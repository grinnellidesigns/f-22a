/*    Grinnelli Designs F-22A Raptor
    Copyright (C) 2025, Branden Hooper
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see https://www.gnu.org/licenses.
    */

#pragma once
#include "stdafx.h"

namespace FM_DATA
{
    //F-22 dimensions
    double wing_area = 78.04;
    double wingspan = 13.56;
    double length = 18.92;
    double height = 5.08;
    double mach_max = 2.4;

    double mach_table[] = { 0.0, 0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.4 };


    //Aerodynamics
    // Zero-lift side-force coefficient. Represents lateral force at zero AoA (small for symmetry)
    double Cy0 = 0.008;  // Baseline lift coefficient 0.01

    // Pitch damping or elevator effectiveness coefficient. Negative value suggests a stabilizing pitch-down moment.
    double Czbe = -0.028; //was -0.28

    //Drag and Lift for external surfaces
    double cx_gear = 0.155;
    double cx_brk = 0.062;
    double cx_flap = 0.051;
    double cy_flap = 0.272;

    // Zero-lift drag coefficient (parasitic drag) as a function of Mach.
    double cx0[] = { 0.013, 0.0135, 0.014, 0.021, 0.0378, 0.0505, 0.0455, 0.04175, 0.038, 0.037, 0.0368, 0.0362, 0.039 };

    // Lift curve slope vs. Mach. Defines how much lift increases per degree of AoA.
       double Cya[] = { 0.08, 0.075, 0.07, 0.065, 0.06, 0.055, 0.05, 0.045, 0.04, 0.0375, 0.035, 0.0325, 0.03 };

    // Maximum roll rate vs. Mach. Indicates roll agility.
   
    double OmxMax[] = { 1.65, 2.45, 3.25, 4.7, 3.98, 3.2, 2.5, 2.25, 2.0, 1.85, 1.7, 1.5, 1.3 };

    // Critical angle of attack (degrees) vs. Mach. Beyond this AoA, the wing stalls (lift drops).
    double Aldop[] = { 60, 57.5, 55, 50, 45, 40, 35, 32.5, 30, 30, 30, 30, 30 };

    // Maximum lift coefficient vs. Mach. Represents peak lift capability before stall
    double CyMax[] = { 1.8, 1.85, 1.9, 1.85, 1.75, 1.6, 1.45, 1.35, 1.25, 1.15, 1.1, 1.05, 1.0 };


    //Reactions

    double AoA_table[] = { 0.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0 };
    double AoA_drag_factor[] = { 0.0, 0.01, 0.024, 0.10, 0.24, 0.375, 0.47, 0.60, 0.71, 1.0 };

    double beta_table[] = { 0.0, 5.0, 10.0, 20.0, 30.0 }; // Sideslip angle (deg)
    double Cy_beta[] = { 0.0, 0.05, 0.1, 0.2, 0.3 }; // Side-force coefficient

    double idle_rpm = 50.0;
    double fuel_consumption = 1.00798;
    double engine_start_time = 60;

    //Thrust - per engine
    double idle_thrust[] = { 
        2000, 
        2075, 
        2150, 
        2200, 
        2250, 
        2300, 
        2500, 
        3000, 
        3500, 
        3850, 
        4200, 
        4600, 
        5000 
    };
    
    double max_thrust[] = { 
        115600, // Mach 0.0 (~26,000 lbf total, real MIL)
        117050, 
        118500, // Mach 0.4 (slight dip, engine efficiency)
        127250, // Mach 0.6 (minimum before ram boost)
        154000, // Mach 0.8 (ram effect kicks in)
        183800, // Mach 1.0 (transonic boost)
        245000, // Mach 1.2 (supersonic rise)
        293000, 
        330000, // Mach 1.6 (supercruise tuned for M1.76)
        230000, // Mach 1.8 (supercruise tuned for M1.76)
        0, // Mach 2.0
        0, // Mach 2.2
        0  // Mach 2.4
    };
    
    double ab_thrust[] = { 
        197000, // Mach 0.0 (~40,000 lbf total, real AB+)
        215300, // Mach 0.2
        232600, // Mach 0.4 (slight dip, engine efficiency)
        256500, // Mach 0.6 (minimum before ram boost)
        275000, // Mach 0.8 (ram effect kicks in)
        298000, // Mach 1.0 (transonic boost)
        325000, // Mach 1.2 (supersonic rise)
        355000, // Mach 1.4
        405000, // Mach 1.6
        470000, // Mach 1.8
        535000, // Mach 2.0
        536500, // Mach 2.2 
        0  // Mach 2.4
    };

    //FBW Limits
    //Elevator
    double elevator_rate_table[] = { 1.396, 1.396, 1.396, 1.256, 1.221, 1.047, 0.922, 0.880, 0.838, 0.8365, 0.835, 0.835, 0.835 };
    double max_elevator_deflection[] = { 30.0, 28.0, 26.0, 15.8, 14.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0 };

    //Thrust Vectoring Nozzles
    double max_thrust_vector_deflection[] = { 20.0, 20.0, 20.0, 17.0, 10.0, 5.0, 2.5, 1.25, 0.0, 0.0, 0.0, 0.0, 0.0 };
    double thrust_vector_rate[] = { 1.396, 1.3905, 1.385, 1.13, 0.892, 0.737, 0.601, 0.5185, 0.436, 0.3635, 0.291, 0.291, 0.291 };

    // Damping tables
    double Kd_pitch[] = { 0.635, 0.662, 0.654, 0.65, 0.78, 1.95, 2.4, 2.8, 2.8, 2.8, 2.8, 2.8, 2.8 };
    double Kd_roll[] = { 0.50, 0.32, 0.3, 0.27, 0.33, 0.37, 0.45, 0.52, 0.62, 0.78, 0.85, 0.88, 0.81 };
    double Kd_yaw[] = { 2.0, 2.0, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3.0 };

    //Other
    double throttle_input_table[] = { 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0 };
    double engine_power_table[] = { 0, 0.01, 0.02, 0.06, 0.08, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0 };
    double engine_power_readout_table[] = { 0.67, 0.70, 0.73, 0.76, 0.79, 0.82, 0.88, 0.94, 1.00, 1.025, 1.1 };
}