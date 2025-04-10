// Basic_EFM_Template.cpp : Defines the exported functions for the DLL application.
// This is essentially the main file.
#include "stdafx.h"
#include "Basic_EFM_Template.h"
#include "Utility.h"
#include <Math.h>
#include <stdio.h>
#include <string>
#include "Inputs.h"
#include "include/Cockpit/CockpitAPI_Declare.h" // Provides param handle interfacing for use in lua
#include "include/FM/API_Declare.h"
#include "FM_data.h"

namespace FM 
{
Vec3	common_force;
Vec3	common_moment;
Vec3    center_of_mass;
Vec3	wind;
Vec3	velocity_world;
Vec3	airspeed;

double	const	pi = 3.1415926535897932384626433832795;
double	const	rad_to_deg = 180.0 / pi;

// Defining aircraft stats here so we don't have to keep calling the FM_DATA namespace.
double S = FM_DATA::wing_area; // Wing area
double wingspan = FM_DATA::wingspan; // Wing span
double length = FM_DATA::length; // Overall length
double height = FM_DATA::height; // Overall height, not counting landing gear
double idle_rpm = FM_DATA::idle_rpm / 100; // RPM % at idle throttle

// Initializing force positions
// The positions are relative to the object's 3d model origin point.
Vec3 left_wing_pos(center_of_mass.x - 0.7, center_of_mass.y + 0.5, -wingspan / 2);
Vec3 right_wing_pos(center_of_mass.x - 0.7, center_of_mass.y + 0.5, wingspan / 2);
Vec3 tail_pos(center_of_mass.x - 0.5, center_of_mass.y, 0);

Vec3 elevator_pos(-length / 2, center_of_mass.y, 0);
Vec3 left_aileron_pos(center_of_mass.x, center_of_mass.y, -wingspan * 0.5);
Vec3 right_aileron_pos(center_of_mass.x, center_of_mass.y, wingspan * 0.5);
Vec3 rudder_pos(-length / 2, height / 2, 0);

// Greater Y and Z offsets create moments from the thrust force.
Vec3 left_engine_pos(-3.793, -0.391, -0.716); // Position (forward/back, up/down, left/right) of the first engine, usually left.
Vec3 right_engine_pos(-3.793, -0.391, 0.716); // Position of the second engine, usually right.

// Pitch variables
double  pitch_input = 0;
int		pitch_discrete = 0;
bool	pitch_analog = true;
double	pitch_trim = 0;
double	elevator_command = 0;

// Roll variables
double  roll_input = 0;
int		roll_discrete = 0;
bool	roll_analog = true;
double  roll_trim = 0;
double	aileron_command = 0;

// Yaw variables
double  yaw_input = 0;
int	yaw_discrete = 0;
bool	yaw_analog = true;
double	yaw_trim = 0;
double	rudder_command = 0;

// Left engine (# 1) variables
bool	left_engine_switch = false;
double  left_throttle_input = 0;
double	left_throttle_output = 0;
double	left_engine_power_readout = 0;
double	left_thrust_force = 0;

// Left engine (# 2) variables
bool	right_engine_switch = false;
double  right_throttle_input = 0;
double	right_throttle_output = 0;
double	right_engine_power_readout = 0;
double	right_thrust_force = 0;

// Lift and drag devices
bool	airbrake_switch = false;
double	airbrake_pos = 0;
double	flaps_pos = 0;
bool	flaps_switch = false;
double	slats_pos = 0;

// Landing gear
bool	gear_switch = false;
double	gear_pos = 0;
double	wheel_brake = 0; 
int	carrier_pos = 0;

double  internal_fuel = 0; // Amount of fuel in the aircraft (Kg)
double	external_fuel = 0; // Amount of fuel in external stations (Kg)
double	total_fuel = internal_fuel + external_fuel; // Total fuel amount (Kg)
double  fuel_consumption_since_last_time = 0;

double  atmosphere_density = 101000.0; // Atmosphere/air density (Pascals)
double	altitude_ASL = 0; // Altitude above sea level
double	altitude_AGL = 0; // Altitude above gound/surface leveldouble 
double	V_scalar = 0; // Velocity scalar
double  speed_of_sound = 320; // Speed of sound (m/s)
double	mach = 0; // Air speed as a multiple of the speed of sound
double	engine_alt_effect = 1; // Multiplier of maximum thrust based on altitude

double  aoa = 0; // Angle of attack in radians
double  alpha = 0; // Angle of attack in degrees

double  aos = 0; // Angle of slide in radians
double  beta = 0; // Angle of slide in degrees

double  g = 0; // G force

double	atmosphere_temperature = 273; // Current temperature in Kelvin

bool	on_ground = false; // Is the aircraft currently on the ground?

// Pitch
double	pitch = 0; // Pitch angle in radians
double	pitch_rate = 0;

// Roll
double	roll = 0; // Roll/bank angle in radians
double	roll_rate = 0;

// Yaw/heading
double	heading = 0;
double	yaw_rate = 0;

// Damage stuff
int element_integrity[111]; 
double left_wing_integrity = 1.0;
double right_wing_integrity = 1.0;
double tail_integrity = 1.0;
double left_engine_integrity = 1.0;
double right_engine_integrity = 1.0;
double total_damage = 1 - (left_wing_integrity + right_wing_integrity + tail_integrity + 
						left_engine_integrity + right_engine_integrity) / 5;

// Optional parameters set in the options menu
bool invincible = true; // No damage received if true
bool infinite_fuel = false; // No fuel drained if true
bool easy_flight = false; // Easier and more stable flight characteristics if true

// Cockpit/head shaking intensity
double shake_amplitude = 0; 

// Basic timer
double fm_clock = 0; 

// Has the simulation passed frame 1?
bool sim_inititalised = false;

// DLL-Lua interface
EDPARAM interface; 
}

using namespace FM;

// An example of how to interface with the Lua environment.
// Conventionally, parameter names are in all-caps.
void* fm_export_temperature = interface.getParamHandle("FM_TEMPERATURE_C");

// Add force
void add_local_force(const Vec3 & Force, const Vec3 & Force_pos)
{
	common_force.x += Force.x;
	common_force.y += Force.y;
	common_force.z += Force.z;

	Vec3 delta_pos(Force_pos.x - center_of_mass.x,
				   Force_pos.y - center_of_mass.y,
				   Force_pos.z - center_of_mass.z);

	Vec3 delta_moment = cross(delta_pos, Force);

	common_moment.x += delta_moment.x;
	common_moment.y += delta_moment.y;
	common_moment.z += delta_moment.z;
}

// Add moment
void add_local_moment(const Vec3& Moment)
{
	common_moment.x += Moment.x;
	common_moment.y += Moment.y;
	common_moment.z += Moment.z;
}

void ed_fm_add_local_force(double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z)
{
	x = common_force.x;
	y = common_force.y;
	z = common_force.z;
	pos_x = center_of_mass.x;
	pos_y = center_of_mass.y;
	pos_z = center_of_mass.z;
}

void ed_fm_add_local_moment(double& x, double& y, double& z)
{
	x = common_moment.x;
	y = common_moment.y;
	z = common_moment.z;
}

/*
// Unused, doesn't seem to work.
void ed_fm_add_global_force(double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z)
{

}

void ed_fm_add_global_moment(double & x,double &y,double &z)
{

}
*/

// Fuel consumption
void simulate_fuel_consumption(double dt)
{
	// Fuel drain at full throttle in Kg/s. 
	fuel_consumption_since_last_time = FM_DATA::fuel_consumption * ((left_throttle_output + right_throttle_output + 1) / 3) * dt;

	if (external_fuel >= 0) // Drain external fuel first
	{
		if (fuel_consumption_since_last_time > external_fuel)
			fuel_consumption_since_last_time = external_fuel;
		external_fuel -= fuel_consumption_since_last_time;
	}
	else // Drain internal fuel
	{
		if (fuel_consumption_since_last_time > internal_fuel)
			fuel_consumption_since_last_time = internal_fuel;
		internal_fuel -= fuel_consumption_since_last_time;
	};
}

// The most important part of this whole thing.
// dt is apparently fixed to 0.006 seconds.
void ed_fm_simulate(double dt)
{
	fm_clock += dt;

	common_force = Vec3();
	common_moment = Vec3();

	// Update the force positions to be relative to the center of mass.
	// Somewhat unrealistic, but if this isn't done it usually leads to really weird flight behaviour.
	if (sim_inititalised == false)
	{
	left_wing_pos.x = center_of_mass.x - 0.7;
	left_wing_pos.y = center_of_mass.y + 0.5;

	right_wing_pos.x = center_of_mass.x - 0.7;
	right_wing_pos.y = center_of_mass.y + 0.5;

	tail_pos.x = center_of_mass.x - 0.5;
	tail_pos.y = center_of_mass.y;

	elevator_pos.y = center_of_mass.y;

	left_aileron_pos.x = center_of_mass.x;
	left_aileron_pos.y = center_of_mass.y;

	right_aileron_pos.x = center_of_mass.x;
	right_aileron_pos.y = center_of_mass.y;
	}

	// Actuator animation function for the moving parts
	gear_pos = limit(actuator(gear_pos, gear_switch, -0.001, 0.001), 0, 1); // Landing gear (all 3)
	airbrake_pos = limit(actuator(airbrake_pos, airbrake_switch, -0.003, 0.004), 0, 1); // Air brakes
	flaps_pos = limit(actuator(flaps_pos, flaps_switch, -0.002, 0.002), 0, 1); // Flaps
	slats_pos = limit(actuator(slats_pos, (alpha - 6.0) / 12.0, -0.003, 0.003), 0, 1); // Slats, starts moving at 6 degrees alpha

#pragma region AERODYNAMICS
	airspeed.x = velocity_world.x - wind.x;
	airspeed.y = velocity_world.y - wind.y;
	airspeed.z = velocity_world.z - wind.z;

	V_scalar = sqrt(airspeed.x * airspeed.x + airspeed.y * airspeed.y + airspeed.z * airspeed.z);

	mach = V_scalar / speed_of_sound;

	// Many coefficients are not static, they change with mach.
	// Here, we use a linear interpolation (lerp for short) function for these coefficients.
	// See the definition of the lerp function in ED_FM_Utility.h for more info on how it works.

	double CyAlpha_ = lerp(FM_DATA::mach_table, FM_DATA::Cya, sizeof(FM_DATA::mach_table) / sizeof(double), mach); // Lift
	double Cx0_ = lerp(FM_DATA::mach_table, FM_DATA::cx0, sizeof(FM_DATA::mach_table) / sizeof(double), mach); // Drag
	double CyMax_ = lerp(FM_DATA::mach_table, FM_DATA::CyMax, sizeof(FM_DATA::mach_table) / sizeof(double), mach); // Max lift
	double AlphaMax_ = lerp(FM_DATA::mach_table, FM_DATA::Aldop, sizeof(FM_DATA::mach_table) / sizeof(double), mach); // Max alpha
	double OmxMax_ = lerp(FM_DATA::mach_table, FM_DATA::OmxMax, sizeof(FM_DATA::mach_table) / sizeof(double), mach); // Max roll rate

	CyMax_ += (FM_DATA::cy_flap * 0.4 * slats_pos);	// Slats increase max lift coefficient.

	// Lift coefficient
	double Cy = CyAlpha_ * alpha;
	if (Cy > CyMax_)
		Cy = CyMax_;
	if (Cy < -CyMax_)
		Cy = -CyMax_;

	// Tail lift coefficient, defined as a guess
	double Cy_tail = (0.5 * CyAlpha_ + FM_DATA::Czbe) * beta;
	if (Cy_tail > CyMax_)
		Cy_tail = CyMax_;
	if (Cy_tail < -CyMax_)
		Cy_tail = -CyMax_;

	// Dynamic pressure (0.5 * rho * v^2)
	double q = 0.5 * atmosphere_density * V_scalar * V_scalar;

	// Lift/normal force, acts upwards
	double Lift = Cy + FM_DATA::Cy0 + (FM_DATA::cy_flap * flaps_pos);

	// Drag force, acts backwards
	double Drag = Cx0_ + (FM_DATA::cx_brk * airbrake_pos) + (FM_DATA::cx_flap * flaps_pos) + (FM_DATA::cx_gear * gear_pos);

	// Cheap, unrealistic, but effective aoa limiter
	if ((fabs(alpha) / AlphaMax_) >= 0.75)
	{
		left_wing_pos.x = center_of_mass.x - 0.7 - ( limit(pow((fabs(alpha) / (AlphaMax_ * 1.1)), 3) / 2000.0, 0, length / 3) + limit(-aos * 10, 0, 1) );
		right_wing_pos.x = center_of_mass.x - 0.7 - ( limit(pow((fabs(alpha) / (AlphaMax_ * 1.1)), 3) / 2000.0, 0, length / 3) + limit(aos * 10, 0, 1) );
	}
	else
	{
		left_wing_pos.x = center_of_mass.x - 0.7;
		right_wing_pos.x = center_of_mass.x - 0.7;
	};

	// Left wing forces
	Vec3 left_wing_forces(-Drag * (sin(-aos / 2) + 1) * q * (S / 2) * left_wing_integrity, Lift * (sin(-aos / 2) / 2 + 1) * q * (S / 2) * left_wing_integrity, 0);
	add_local_force(left_wing_forces, left_wing_pos);

	// Right wing forces
	Vec3 right_wing_forces(-Drag * (sin(aos / 2) + 1) * q * (S / 2) * right_wing_integrity, Lift * (sin(aos / 2) / 2 + 1) * q * (S / 2) * right_wing_integrity, 0);
	add_local_force(right_wing_forces, right_wing_pos);

	// Tail forces
	Vec3 tail_force(pow(-Cy_tail, 3) * sin(aoa) * (S / 2) * q * tail_integrity, 0, -Cy_tail * cos(aoa) * q * (S / 2) * tail_integrity);
	add_local_force(tail_force, tail_pos);
#pragma endregion

	// PITCH //
#pragma region PITCH

	// Pitch control
	if (pitch_analog == true)
	{
		pitch_input = limit(pitch_input, -1, 1);
	}
	else	// Discrete pitch input //
	{
		//POSITIVE
		if (pitch_discrete > 0.1)
		{
			pitch_input += 0.0035;

			if (pitch_input > 1.0)
				pitch_input = 1;
		};
		// back down to 0.7
		if (pitch_discrete == 0 && pitch_input > 0.5)
		{
			if (pitch_input > 0.7)
				pitch_input *= 0.98;
		};

		//NEGATIVE
		if (pitch_discrete < -0.1)
		{
			pitch_input -= 0.0035;

			if (pitch_input < -1)
				pitch_input = -1;
		};

		// back down to half
		if (pitch_discrete == 0 && pitch_input < -0.5)
		{
			if (pitch_input < -0.5)
				pitch_input *= 0.98;
		};
	};

	pitch_trim = limit(pitch_trim, -0.3, 0.3);

	elevator_command = limit(actuator(elevator_command, pitch_input + pitch_trim, -0.0125, 0.0125), -1, 1);

	// Elevator deflection plus default angle
	double elevator_deflection = (-(rescale(elevator_command + 0.15, rad(-25), rad(35))) * 14) * cos(aoa / 2);

	double pitch_stability = (aoa + sin(aoa / 2) / 2) + (pitch_rate * 2);

	add_local_force(Vec3(0, ((elevator_deflection * limit(1 - sqrt((mach + FM_DATA::mach_max * 0.4) / 3), 0.001, 1)) + (pitch_stability * (mach / 2 + 1))) * q, 0), elevator_pos);

#pragma endregion

	// ROLL //
#pragma region ROLL

	// Roll control
	if (roll_analog == true)
	{
		roll_input = limit(roll_input, -1, 1);
	}
	else	// Discrete roll input //
	{
		//POSITIVE
		if (roll_discrete > 0.1)
		{
			roll_input += 0.004;

			if (roll_input > 1)
				roll_input = 1;
		}

		//NEGATIVE
		if (roll_discrete < -0.1)
		{
			roll_input -= 0.004;

			if (roll_input < -1)
				roll_input = -1;
		}

		// back down to 0
		if (roll_discrete == 0)
			roll_input *= 0.9;
	};

	roll_trim = limit(roll_trim, -0.3, 0.3);

	aileron_command = limit(actuator(aileron_command, roll_input + roll_trim, -0.02, 0.02), -1, 1);

	// Aileron deflection
	double aileron_deflection = rescale(aileron_command, rad(-30), rad(30)) * 4;

	double roll_stabilty = -roll_rate * (((fabs(aoa + 0.5) * fabs(aos + 0.5)) + 1) * (5 / wingspan)) +
		(sin(roll) / 2 * fabs(aoa / 2)); // Stability and correcting some of the rolling moment whhen in a turn.

	add_local_force(Vec3(0, (aileron_deflection + roll_stabilty) * q, 0), left_aileron_pos);
	add_local_force(Vec3(0, -(aileron_deflection + roll_stabilty) * q, 0), right_aileron_pos);

#pragma endregion

	// YAW //
#pragma region YAW

	// Yaw control
	if (yaw_analog == true)
	{
		yaw_input = limit(yaw_input, -1, 1);
	}
	else	// Discrete yaw input //
	{
		//POSITIVE
		if (yaw_discrete > 0.1)
		{
			yaw_input += 0.0035;

			if (yaw_input > 1)
				yaw_input = 1;
		}

		//NEGATIVE
		if (yaw_discrete < -0.1)
		{
			yaw_input -= 0.0035;

			if (yaw_input < -1)
				yaw_input = -1;
		}

		// back down to 0
		if (yaw_discrete == 0)
			yaw_input *= 0.9;
	};

	yaw_trim = limit(yaw_trim, -0.2, 0.2);

	rudder_command = limit(actuator(rudder_command, yaw_input + yaw_trim, -0.012, 0.012), -1, 1);

	// Rudder deflection
	double rudder_deflection = rescale(rudder_command, rad(-30), rad(30)) * 1.5;

	double yaw_stability = -((aos * 2) + yaw_rate);

	add_local_force(Vec3(0, 0, (rudder_deflection + yaw_stability) * q), rudder_pos);

#pragma endregion

	// ENGINE(S) AND THRUST //
#pragma region THRUST

	double max_dry_thrust = lerp(FM_DATA::engine_mach_table, FM_DATA::max_thrust, sizeof(FM_DATA::engine_mach_table) / sizeof(double), mach);

	left_throttle_input = limit(left_throttle_input, 0, 1);
	right_throttle_input = limit(right_throttle_input, 0, 1);

	// Left engine
	if (left_engine_switch == false)
	{
		left_throttle_output = actuator(left_throttle_output, 0, -0.01, 0.01);
		left_engine_power_readout = actuator(left_engine_power_readout, 0.0, -dt / (FM_DATA::engine_start_time / 2), dt / (FM_DATA::engine_start_time / 2));
		left_throttle_input = limit(left_throttle_input, 0, 0);
	};

	if (left_engine_switch == true && left_engine_power_readout < 0.5)
	{
		left_engine_power_readout = actuator(left_engine_power_readout, 0.5, -dt / (FM_DATA::engine_start_time / 2), dt / (FM_DATA::engine_start_time / 2));
		left_throttle_input = limit(left_throttle_input, 0, 0.1);
	};

	if (left_engine_switch == true && left_engine_power_readout >= 0.5)
	{
		left_throttle_output = limit(lerp(FM_DATA::throttle_input_table, FM_DATA::engine_power_table, sizeof(FM_DATA::throttle_input_table) / sizeof(float), left_throttle_input), 0.1, 1);
		left_engine_power_readout = limit(lerp(FM_DATA::throttle_input_table, FM_DATA::engine_power_readout_table, sizeof(FM_DATA::throttle_input_table) / sizeof(float), left_throttle_input), 0, 1);
	};

	// Right engine
	if (right_engine_switch == false)
	{
		right_throttle_output = actuator(right_throttle_output, 0, -0.01, 0.01);
		right_engine_power_readout = actuator(right_engine_power_readout, 0.0, -dt / (FM_DATA::engine_start_time / 2), dt / (FM_DATA::engine_start_time / 2));
		right_throttle_input = limit(right_throttle_input, 0, 0);
	};

	if (right_engine_switch == true && right_engine_power_readout < 0.5)
	{
		right_engine_power_readout = actuator(right_engine_power_readout, 0.5, -dt / (FM_DATA::engine_start_time / 2), dt / (FM_DATA::engine_start_time / 2));
		right_throttle_input = limit(right_throttle_input, 0, 0.1);
	};

	if (right_engine_switch == true && right_engine_power_readout >= 0.5)
	{
		right_throttle_output = limit(lerp(FM_DATA::throttle_input_table, FM_DATA::engine_power_table, sizeof(FM_DATA::throttle_input_table) / sizeof(float), right_throttle_input), 0.1, 1);
		right_engine_power_readout = limit(lerp(FM_DATA::throttle_input_table, FM_DATA::engine_power_readout_table, sizeof(FM_DATA::throttle_input_table) / sizeof(float), right_throttle_input), 0, 1);
	};

	left_thrust_force = left_throttle_output * max_dry_thrust * engine_alt_effect * left_engine_integrity * 0.5;
	right_thrust_force = right_throttle_output * max_dry_thrust * engine_alt_effect * right_engine_integrity * 0.5;

	left_engine_power_readout *= left_engine_integrity;
	right_engine_power_readout *= right_engine_integrity;

	// Engine shutdown
	if (internal_fuel <= 0 || altitude_ASL > 20000)
	{
		left_thrust_force = 0;
		right_thrust_force = 0;
		left_engine_switch = false;
		right_engine_switch = false;
		left_engine_power_readout = actuator(right_engine_power_readout, 0.0, -dt / 10, dt / 10);
		right_engine_power_readout = actuator(left_engine_power_readout, 0.0, -dt / 10, dt / 10);
	};

	//add_local_force(thrust, thrust_pos);
	add_local_force(Vec3(left_thrust_force, 0, 0), left_engine_pos);
	add_local_force(Vec3(right_thrust_force, 0, 0), right_engine_pos);

	if (infinite_fuel == false)
	{
		simulate_fuel_consumption(dt);
	};

#pragma endregion

	// MISC //
#pragma region MISC
	// Artificial limiters and other forces and moments.
	// Not exactly realistic, but added for convenience.

	double roll_yaw_moment = -(roll_rate / 2) * (q + 1e5 * 0.5); // Subtle yaw moment to keep stable in sharp turns
	add_local_moment(Vec3(0, roll_yaw_moment, 0));

	double roll_rate_limiter = -roll_rate * limit(pow((limit(fabs(roll_rate) / (OmxMax_ + 0.1), 0.0001, 2)), 6) * (q + q + 1e5 * 0.3), -1e7, 1e7);
	add_local_moment(Vec3(roll_rate_limiter, 0, 0));

	double yaw_rate_limiter = -(yaw_rate + aos) * (q + 1e5 * 0.5);
	add_local_moment(Vec3(0, yaw_rate_limiter, 0));

	double speed_limiter = limit(pow(fabs(mach) / FM_DATA::mach_max, 5) * (q + 1e5 * 0.5), -1e7, 1e7);
	add_local_force(-speed_limiter, center_of_mass);

	// Note about speed:
	// In DCS, if a plane goes faster than around 3100 Km/h (860 m/s) ground speed, it explodes. Even with invincibility on.

	// Additional optional artificial stuff for easier and more stable flight.
	if (easy_flight == true)
	{
		// Attitude stability.
		add_local_moment(Vec3(-(roll_rate / 4) * (1 - sqrt(fabs(aileron_command))) * (1e5 + q * 0.5),
			-(yaw_rate + (sin(aos) / 2)) * (1 - sqrt(fabs(rudder_command))) * (1e5 + q * 0.5),
			-(pitch_rate + (sin(aoa) / 2)) * (1 - sqrt(fabs(elevator_command))) * (1e5 + q * 0.5)));

		// Additional side (yaw) force.
		add_local_force(Vec3(0, 0, -rudder_command * (1e5 + q * 0.1)), Vec3(center_of_mass.x - 0.2, center_of_mass.y, 0));
	};

	// Logic for determining if the aircraft is on the ground.
	if (gear_pos > 0.5 && altitude_AGL < 50.0 && mach < 0.3)
	{
		on_ground = true;
	}
	else
	{
		on_ground = false;
	};

	// Cockpit shaking intensity
	shake_amplitude = 0; // Starts at zero every frame

	shake_amplitude += limit((FM_DATA::cx_brk + 1) * airbrake_pos * mach, 0, 2) / 6; // Air brakes

	if (on_ground == false)
	{
		if (fabs(alpha) > 10) // High angle of attack
			shake_amplitude += (fabs(alpha) - 10) / 100;

		if (fabs(beta) > 10) // High angle of slide
			shake_amplitude += (fabs(beta) - 10) / 100;

		if (fabs(g) > 5) // High g
			shake_amplitude += (fabs(g) - 5) / 100;

		if (mach > FM_DATA::mach_max * 0.8) // Approaching maximum speed
			shake_amplitude += (mach - (FM_DATA::mach_max * 0.8)) / 2;
	};
#pragma endregion

	sim_inititalised = true; // The first step is complete
}

// Atmosphere data
void ed_fm_set_atmosphere(double h, //altitude above sea level
							double t, // current atmosphere temperature in Kelvin
							double a, // speed of sound
							double ro, // atmosphere density
							double p, // atmosphere pressure
							double wind_vx, double wind_vy, double wind_vz // components of velocity vector, including turbulence in world coordinate system
						)

{
	wind.x = wind_vx;
	wind.y = wind_vy;
	wind.z = wind_vz;

	atmosphere_density = ro;
	speed_of_sound     = a;

	altitude_ASL = h;

	engine_alt_effect = limit(pow(1 - (h / 30000), 0.3), 0.1, 1); 

	atmosphere_temperature = t;

	// FM interface example: exporting the current outside temperature in degrees Celsius.
	interface.setParamNumber(fm_export_temperature, t + 273);
}

void ed_fm_set_surface(double h, // distance between sea level and the surface/ground
	double h_obj, // h but with objects
	unsigned surface_type, // type of surface under the aircraft?
	double normal_x, double normal_y, double normal_z // components of normal vector to surface
)
{
	altitude_AGL = altitude_ASL - (h + h_obj * 0.5);
}

// Called before simulation to set up your environment for the next step
void ed_fm_set_current_mass_state (double mass,
									double center_of_mass_x, double center_of_mass_y, double center_of_mass_z,
									double moment_of_inertia_x, double moment_of_inertia_y, double moment_of_inertia_z
									)
{
	center_of_mass.x  = center_of_mass_x;
	center_of_mass.y  = center_of_mass_y;
	center_of_mass.z  = center_of_mass_z;
}

// Called before simulation to set up your environment for the next step
void ed_fm_set_current_state (double ax, double ay, double az,//linear acceleration component in world coordinate system
							double vx, double vy, double vz,//linear velocity component in world coordinate system
							double px, double py, double pz,//center of the body position in world coordinate system
							double omegadotx, double omegadoty, double omegadotz,//angular accelearation components in world coordinate system
							double omegax, double omegay, double omegaz, //angular velocity components in world coordinate system 
							double quaternion_x, double quaternion_y, double quaternion_z, double quaternion_w //orientation quaternion components in world coordinate system
							)
{
	velocity_world.x = vx;
	velocity_world.y = vy;
	velocity_world.z = vz;
}


// Called before simulation to set up your environment for the next step
void ed_fm_set_current_state_body_axis(double ax, double ay, double az,//linear acceleration components in body coordinate system
	double vx, double vy, double vz,//linear velocity components in body coordinate system
	double wind_vx, double wind_vy, double wind_vz,//wind linear velocity components in body coordinate system
	double omegadotx, double omegadoty, double omegadotz,//angular accelearation components in body coordinate system
	double omegax, double omegay, double omegaz,//angular velocity components in body coordinate system
	double yaw,  //radians
	double pitch,//radians
	double roll, //radians
	double common_angle_of_attack, //AoA radians
	double common_angle_of_slide   //AoS radians
	)
{
	aoa = common_angle_of_attack;
	alpha = common_angle_of_attack * rad_to_deg;

	aos = common_angle_of_slide;
	beta = common_angle_of_slide * rad_to_deg; 
	// Positive aos is yaw left, negative is right.
	// Positive aos means more wind on the right wing, negative on the left wing.

	g = (ay / 9.81) + 1; // 1 g is -9.81 m/s², Earth's gravity. 

	FM::pitch = pitch;
	FM::roll = roll;
	FM::heading = yaw;

	roll_rate = omegax;
	yaw_rate = omegay;
	pitch_rate = omegaz;
}

// Input handling
void ed_fm_set_command (int command, float value)
{
	// See Inputs.h
	switch (command)
	{

	// Flight controls

	// Pitch

	case JoystickPitch: //iCommandPlanePitch
		pitch_input = limit(value, -1, 1);
		pitch_analog = true;
		pitch_discrete = 0;
		break;

	case PitchUp:
		pitch_discrete = 1;
		pitch_analog = false;
		//pitch_acc = 1;
		break;
	case PitchUpStop:
		pitch_discrete = 0;
		pitch_analog = false;
		break;

	case PitchDown:
		pitch_discrete = -1;
		pitch_analog = false;
		break;
	case PitchDownStop:
		pitch_discrete = 0;
		pitch_analog = false;
		break;

	case trimUp:
		pitch_trim += 0.0015;
		break;
	case trimDown:
		pitch_trim -= 0.0015;
		break;

	// Roll

	case JoystickRoll: //iCommandPlaneRoll
		roll_input = limit(value, -1, 1);
		roll_analog = true;
		roll_discrete = 0;
		break;

	case RollLeft:
		roll_discrete = -1;
		roll_analog = false;
		break;
	case RollLeftStop:
		roll_discrete = 0;
		roll_analog = false;
		break;

	case RollRight:
		roll_discrete = 1;
		roll_analog = false;
		break;
	case RollRightStop:
		roll_discrete = 0;
		roll_analog = false;
		break;

	case trimLeft:
		roll_trim -= 0.001;
		break;
	case trimRight:
		roll_trim += 0.001;
		break;

	// Yaw

	case PedalYaw: //Yaw
		yaw_input = limit(-value, -1, 1);
		yaw_discrete = 0;
		yaw_analog = true;
		break;

	case rudderleft:
		yaw_discrete = 1;
		yaw_analog = false;
		break;
	case rudderleftstop:
		yaw_discrete = 0;
		yaw_analog = false;
		break;

	case rudderright:
		yaw_discrete = -1;
		yaw_analog = false;
		break;
	case rudderrightstop:
		yaw_discrete = 0;
		yaw_analog = false;
		break;

	case ruddertrimLeft:
		yaw_trim += 0.001;
		break;
	case ruddertrimRight:
		yaw_trim -= 0.001;
		break;

	case resetTrim:
		pitch_trim = 0;
		roll_trim = 0;
		yaw_trim = 0;
		break;

	//	Engine and throttle commands

	case EnginesOn: // Both engines
		left_engine_switch = true;
		right_engine_switch = true;
		break;
	case LeftEngineOn:
		left_engine_switch = true;
		break;
	case RightEngineOn:
		right_engine_switch = true;
		break;

	case EnginesOff: // Both engines
		left_engine_switch = false;
		right_engine_switch = false;
		break;
	case LeftEngineOff:
		left_engine_switch = false;
		break;
	case RightEngineOff:
		right_engine_switch = false;
		break;

	case ThrottleAxis://iCommandPlaneThrustCommon
		//throttle_input = ((0.5 * value + 0.5) / 2) + 0.5;
		left_throttle_input = limit(-value, 0.0, 1.0);
		right_throttle_input = limit(-value, 0.0, 1.0);
		break;
	case ThrottleAxisLeft:
		left_throttle_input = limit(-value, 0.0, 1.0);
		break;
	case ThrottleAxisRight:
		right_throttle_input = limit(-value, 0.0, 1.0);
		break;

	case ThrottleIncrease: // Both engines
		left_throttle_input += 0.0075;
		right_throttle_input += 0.0075;
		break;
	case ThrottleLeftUp:
		left_throttle_input += 0.0075;
		break;
	case ThrottleRightUp:
		right_throttle_input += 0.0075;
		break;

	case ThrottleDecrease: // Both engines
		left_throttle_input -= 0.0075;
		right_throttle_input -= 0.0075;
		break;
	case ThrottleLeftDown:
		left_throttle_input -= 0.0075;
		break;
	case ThrottleRightDown:
		right_throttle_input -= 0.0075;
		break;

	// Other commands

	case AirBrakes: //toggle
		if (airbrake_switch == false)
			airbrake_switch = true;
		else if (airbrake_switch == true)
			airbrake_switch = false;
		break;
	case AirBrakesOff:
		airbrake_switch = false;
	case AirBrakesOn:
		airbrake_switch = true;
		break;

	case flapsToggle: //toggle
		if (flaps_switch == false)
			flaps_switch = true;
		else if (flaps_switch == true)
			flaps_switch = false;
		break;
	case flapsDown:
		flaps_switch = false;
	case flapsUp:
		flaps_switch = true;
		break;

	case gearToggle:
		if (gear_switch == true)
			gear_switch = false;
		else if (gear_switch == false)
			gear_switch = true;
		break;
	case gearDown:
		gear_switch = true;
		break;
	case gearUp:
		gear_switch = false;
		break;

	case WheelBrakeOn:
		wheel_brake = 1;
		break;
	case WheelBrakeOff:
		wheel_brake = 0;
		break;

	}

}

/*
	Mass handling 

	will be called  after ed_fm_simulate :
	you should collect mass changes in ed_fm_simulate 

	double delta_mass = 0;
	double x = 0;
	double y = 0; 
	double z = 0;
	double piece_of_mass_MOI_x = 0;
	double piece_of_mass_MOI_y = 0; 
	double piece_of_mass_MOI_z = 0;
 
	//
	while (ed_fm_change_mass(delta_mass,x,y,z,piece_of_mass_MOI_x,piece_of_mass_MOI_y,piece_of_mass_MOI_z))
	{
	//internal DCS calculations for changing mass, center of gravity,  and moments of inertia
	}
*/

bool ed_fm_change_mass  (double & delta_mass,
						double & delta_mass_pos_x,
						double & delta_mass_pos_y,
						double & delta_mass_pos_z,
						double & delta_mass_moment_of_inertia_x,
						double & delta_mass_moment_of_inertia_y,
						double & delta_mass_moment_of_inertia_z
						)
{
	if (fuel_consumption_since_last_time > 0)
	{
		delta_mass		 = fuel_consumption_since_last_time;
		delta_mass_pos_x = -1.0;
		delta_mass_pos_y =  1.0;
		delta_mass_pos_z =  0;

		delta_mass_moment_of_inertia_x	= 0;
		delta_mass_moment_of_inertia_y	= 0;
		delta_mass_moment_of_inertia_z	= 0;

		fuel_consumption_since_last_time = 0; // set it 0 to avoid infinite loop, because it called in cycle 
		// better to use stack like structure for mass changing 
		return true;
	}
	else 
	{
		return false;
	}
}

// Set internal fuel volume , init function, called on object creation and for refueling
void   ed_fm_set_internal_fuel(double fuel)
{
	internal_fuel = fuel;
}

// Get internal fuel volume 
double ed_fm_get_internal_fuel()
{
	return internal_fuel;
}

// Set external fuel volume for each payload station, called for weapon init and on reload.
void  ed_fm_set_external_fuel (int	 station,
								double fuel,
								double x, double y, double z)
{
	// Not sure how to work with this.
}

// Get external fuel volume
double ed_fm_get_external_fuel ()
{
	return 0;
}

// This stuff controls "arguments", which are mostly moving parts, pylons, lights, etc on the aircraft's model.
void ed_fm_set_draw_args (EdDrawArgument * drawargs,size_t size)
{
	//See the model viewer on your aircraft model for arguments on the aircraft.

	// Landing gear
	drawargs[0].f = (float)limit(gear_pos, 0, 1); // Nose
	drawargs[3].f = (float)limit(gear_pos, 0, 1); // Right
	drawargs[5].f = (float)limit(gear_pos, 0, 1); // Left

	// Elevators/stabilators
	drawargs[15].f = (float)limit(elevator_command, -1, 1);
	drawargs[16].f = (float)limit(elevator_command, -1, 1);

	// Ailerons
	drawargs[11].f = (float)limit(aileron_command, -1, 1);
	drawargs[12].f = (float)limit(-aileron_command, -1, 1);

	// Rudder(s)
	drawargs[17].f = (float)limit(rudder_command, -1, 1);
	drawargs[18].f = (float)limit(rudder_command, -1, 1);

	// Airbrake(s)
	drawargs[21].f = (float)limit(airbrake_pos, 0, 1);
	drawargs[182].f = (float)limit(airbrake_pos, 0, 1);
	drawargs[184].f = (float)limit(airbrake_pos, 0, 1);

	// Flaps
	drawargs[9].f = (float)limit(flaps_pos, 0, 1);
	drawargs[10].f = (float)limit(flaps_pos, 0, 1);
	drawargs[126].f = (float)limit(flaps_pos, 0, 1); // Right inner
	drawargs[127].f = (float)limit(flaps_pos, 0, 1); // Right outer
	drawargs[128].f = (float)limit(flaps_pos, 0, 1); // Left inner
	drawargs[129].f = (float)limit(flaps_pos, 0, 1); // Left outer

	// Slats
	drawargs[13].f = (float)limit(slats_pos, 0, 1);
	drawargs[14].f = (float)limit(slats_pos, 0, 1);

	/*
	Hints on some aircraft args where applicable

	25 is the tail hook or weapons bay on some aircraft

	115 to 117 are gear doors

	7 is wing sweep

	28 and 29 are left and right afterburners

	89 and 90 are left and right engine nozzle apertures

	40 and 41 are helicopter rotors

	407 to 410 are propellers
	*/
}

void ed_fm_configure(const char * cfg_path)
{
	// Not sure what this does.
}

// Interface with default parameters like gear and engines
double ed_fm_get_param(unsigned index)
{
	switch (index)
	{
		case ED_FM_SUSPENSION_0_WHEEL_YAW: // Nose wheel steering
			return limit(yaw_input, -1.0, 1.0) * 0.75;

		case ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT:
			return 1e-4;
		case ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT:
		case ED_FM_SUSPENSION_2_RELATIVE_BRAKE_MOMENT:
			return 1e-4 + (5 * wheel_brake);

		case ED_FM_ANTI_SKID_ENABLE:
			return true;

		case ED_FM_FC3_STICK_PITCH:
			return limit(pitch_input/2, -1.0, 1.0);

		case ED_FM_FC3_STICK_ROLL:
			return limit(roll_input, -1.0, 1.0);

		case ED_FM_FC3_RUDDER_PEDALS:
			return limit(-yaw_input, -1.0, 1.0);

		case ED_FM_FC3_THROTTLE_LEFT:
			if (left_engine_switch == false)
				return limit(left_throttle_input, 0.0, 0.1);
			else
				return limit(left_throttle_input, 0.1, 1.0);

		case ED_FM_FC3_THROTTLE_RIGHT:
			if (right_engine_switch == false)
				return limit(right_throttle_input, 0.0, 0.1);
			else
				return limit(right_throttle_input, 0.1, 1.0);

		case ED_FM_FUEL_INTERNAL_FUEL:
			return internal_fuel;
		case ED_FM_FUEL_TOTAL_FUEL:
			return total_fuel;

		case ED_FM_OXYGEN_SUPPLY:
			return 101000.0;

		case ED_FM_FLOW_VELOCITY:
			return 10.0;

		case ED_FM_SUSPENSION_0_GEAR_POST_STATE:
		case ED_FM_SUSPENSION_1_GEAR_POST_STATE:
		case ED_FM_SUSPENSION_2_GEAR_POST_STATE:
			return gear_pos;	// Landing gear states, combined

		if (index <= ED_FM_END_ENGINE_BLOCK)
		{

			// APU, doesn't make sounds.
		case ED_FM_ENGINE_0_RPM:
		case ED_FM_ENGINE_0_RELATED_RPM:
			return 1;
		case ED_FM_ENGINE_0_THRUST:
		case ED_FM_ENGINE_0_RELATED_THRUST:
			return 0;

			// Engine 1, left
		case ED_FM_ENGINE_1_CORE_RPM:
		case ED_FM_ENGINE_1_RPM:
		case ED_FM_ENGINE_1_COMBUSTION:
			return left_throttle_output;

		case ED_FM_ENGINE_1_RELATED_THRUST: // low frequency rumble
			return left_throttle_output;
		case ED_FM_ENGINE_1_CORE_RELATED_THRUST:
		case ED_FM_ENGINE_1_RELATED_RPM:
			return left_throttle_output;
		case ED_FM_ENGINE_1_CORE_RELATED_RPM: // RPM readout and core sound
			return left_engine_power_readout;

		case ED_FM_ENGINE_1_CORE_THRUST:
		case ED_FM_ENGINE_1_THRUST:
			return left_throttle_output;
		case ED_FM_ENGINE_1_TEMPERATURE:
			return (pow(left_engine_power_readout, 3) * 500) + atmosphere_temperature;

			// Engine 2, right
		case ED_FM_ENGINE_2_CORE_RPM:
		case ED_FM_ENGINE_2_RPM:
		case ED_FM_ENGINE_2_COMBUSTION:
			return right_throttle_output;

		case ED_FM_ENGINE_2_RELATED_THRUST: // low frequency rumble
			return right_throttle_output;
		case ED_FM_ENGINE_2_CORE_RELATED_THRUST:
		case ED_FM_ENGINE_2_RELATED_RPM:
			return right_throttle_output;
		case ED_FM_ENGINE_2_CORE_RELATED_RPM: // RPM readout and core sound
			return right_engine_power_readout;

		case ED_FM_ENGINE_2_CORE_THRUST:
		case ED_FM_ENGINE_2_THRUST:
			return right_throttle_output;
		case ED_FM_ENGINE_2_TEMPERATURE:
			return (pow(right_engine_power_readout, 3) * 500) + atmosphere_temperature;
		}
	}
	return 0;
}

void ed_fm_refueling_add_fuel(double fuel)
{
	// Doesn't seem to do anything, maybe it's for mid-air refueling?
}

// Infinite fuel setting
void ed_fm_unlimited_fuel(bool value)
{
	infinite_fuel = value;

	/*
	This setting doesn't do anything on its own.
	In this FM, it simply disables fuel consumption when set to true.
	*/
}

// Easy/"game" flight mode setting
void ed_fm_set_easy_flight(bool value)
{
	easy_flight = value;

	/*
	This setting doesn't do anything on its own.
	The expectation is that the aircraft is a lot more stable and easy to fly when set to true.
	Such is the case with this FM.
	*/
}

// Invincibility setting
void ed_fm_set_immortal(bool value)
{
	invincible = value;

	/*
	When enabled, the aircraft does not register damage.
	When disabled, you have to code what would happen when certain parts are damaged.
	See the function below.
	*/
}

// What happens when certain parts of the aircraft are hit?
void ed_fm_on_damage(int Element, double element_integrity_factor)
{
	if (Element >= 0 && Element < 111)
	{
		element_integrity[Element] = element_integrity_factor;
		// Element integrity is a scale from 0 to 1, 0 is completely broken and 1 is fully intact.
	}

	// See DCSWorld/scripts/Aircrafts/_Common/Damage.lua for a full list of elements.
	if (invincible == false)
	{
		// Left wing
		left_wing_integrity = element_integrity[23] * element_integrity[29] * element_integrity[35];

		// Right wing
		right_wing_integrity = element_integrity[24] * element_integrity[30] * element_integrity[36];

		// Tail
		tail_integrity = element_integrity[53] * element_integrity[54] * element_integrity[55] * element_integrity[56] * element_integrity[57];

		// Left engine
		left_engine_integrity = element_integrity[13] * element_integrity[17] * element_integrity[103];

		// Right engine
		right_engine_integrity = element_integrity[14] * element_integrity[18] * element_integrity[104];
	}
}

// What should be reset when the aircraft is repaired?
void ed_fm_repair()
{
	for (int i = 0; i < 111; i++)
	{
		element_integrity[i] = 1.0; // Resets all elements to full integrity.
	}
}

bool ed_fm_pop_simulation_event(ed_fm_simulation_event& out)
{
	// Catapult launch sequence
	if (carrier_pos == 1)
	{
		if (left_throttle_output > 0.99) // Automatic launch at full throttle
		{
			out.event_type = ED_FM_EVENT_CARRIER_CATAPULT;
			out.event_params[0] = 1;
			out.event_params[1] = 2.0; // Start delay (s)
			out.event_params[2] = 80.0; // Added velocity after takeoff (m/s)
			out.event_params[3] = FM_DATA::max_thrust[1] * 0.5 * 2; // Engine thrust during takeoff (N)? Doesn't seem to work.
			carrier_pos = 2;
			return true;
		}
	}
	return false;
}

// bool ed_fm_push_simulation_event. DCS will call it for your FM when ingame event occurs
bool ed_fm_push_simulation_event(const ed_fm_simulation_event& in)
{
	if (in.event_type == ED_FM_EVENT_CARRIER_CATAPULT)
	{
		if (in.event_params[0] == 1)
		{
			carrier_pos = 1;
		}
		else if (in.event_params[0] == 2) // start launch
		{
			carrier_pos = 3;
		}
		else if (in.event_params[0] == 3) // launch finished
		{
			carrier_pos = 0;
		}
	}
	return false;
	// TO DO: Failure events
}


// What should be set on a cold start on the ground?
void ed_fm_cold_start()
{
	// Landing gear down
	gear_switch = true;
	gear_pos = 1;
	carrier_pos = 0;

	// Engines off
	left_engine_switch = false;
	left_throttle_input = 0.0;
	left_throttle_output = 0.0;
	left_engine_power_readout = 0.0;

	right_engine_switch = false;
	right_throttle_input = 0.0;
	right_throttle_output = 0.0;
	right_engine_power_readout = 0.0;
}

// What should be set on a hot start on the ground?
void ed_fm_hot_start()
{	
	// Landing gear down
	gear_switch = true;
	gear_pos = 1;
	carrier_pos = 0;

	// Flaps down
	flaps_switch = true;
	flaps_pos = 1;

	// Engines on at idle/minimum throttle
	left_engine_switch = true;
	left_throttle_input = 0.0;
	left_throttle_output = 0.5;
	left_engine_power_readout = 0.5;

	right_engine_switch = true;
	right_throttle_input = 0.0;
	right_throttle_output = 0.5;
	right_engine_power_readout = 0.5; 
}

// What should be set on a hot start in the air?
void ed_fm_hot_start_in_air()
{
	// Landing gear up
	gear_switch = false;
	gear_pos = 0;
	carrier_pos = 0;

	//Engines on at 50% throttle
	left_engine_switch = true;
	left_throttle_input = 0.5;
	left_throttle_output = 0.5;
	left_engine_power_readout = 0.5;

	right_engine_switch = true;
	right_throttle_input = 0.5;
	right_throttle_output = 0.5;
	right_engine_power_readout = 0.5;
}

// What should be reset on mission exit?
void ed_fm_release()
{
	fm_clock = 0;

	// Reset user inputs
	pitch_input = 0; 
	pitch_trim = 0;
	elevator_command = 0;

	roll_input = 0;
	roll_trim = 0;
	aileron_command = 0;

	yaw_input = 0;
	yaw_trim = 0;
	rudder_command = 0;

	// Repair
	ed_fm_repair();
}

// Cockpit view shaking
double ed_fm_get_shake_amplitude()
{
	return shake_amplitude;

	//This can be used to give a visual indication of stress on the airframe.
}

// Unused
bool ed_fm_add_local_force_component( double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z )
{
	return false;
}

// Unused
bool ed_fm_add_global_force_component( double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z )
{
	return false;
}

// Unused
bool ed_fm_add_local_moment_component( double & x,double &y,double &z )
{
	return false;
}

// Unused
bool ed_fm_add_global_moment_component( double & x,double &y,double &z )
{
	return false;
}

// Debug force vector and center of mass visualisation
bool ed_fm_enable_debug_info()
{
	return false;

	/*
	When set to true, DCS draws lines on the aircraft.
	The blue box is the center of mass, green line is net force vector, pink line is the velocity vector.
	*/
}
