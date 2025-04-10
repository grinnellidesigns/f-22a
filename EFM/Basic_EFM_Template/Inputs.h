#pragma once

enum InputCommands
{
	// commands from command_defs.lua, similar to the Su-25T and FC3 aircraft.

	// Pitch
	JoystickPitch = 2001,
	PitchUp = 195,
	PitchUpStop = 196,
	PitchDown = 193,
	PitchDownStop = 194,
	trimUp = 95,
	trimDown = 96,

	// Roll
	JoystickRoll = 2002,
	RollLeft = 197,
	RollLeftStop = 198,
	RollRight = 199,
	RollRightStop = 200,
	trimLeft = 93,
	trimRight = 94,

	// Yaw
	PedalYaw = 2003,
	rudderleft = 201,
	rudderleftstop = 202,
	rudderright = 203,
	rudderrightstop = 204,
	ruddertrimLeft = 98,
	ruddertrimRight = 99,

	// Engine and throttle commands
	EnginesOn = 309,
	LeftEngineOn = 311,
	RightEngineOn = 312,

	EnginesOff = 310,
	LeftEngineOff = 313,
	RightEngineOff = 314,

	ThrottleAxis = 2004, // Both engines
	ThrottleAxisLeft = 2005,
	ThrottleAxisRight = 2006,
	ThrottleLeftUp = 161,
	ThrottleRightUp = 163,
	ThrottleLeftDown = 162,
	ThrottleRightDown = 164,
	ThrottleIncrease = 1032,
	ThrottleDecrease = 1033,
	ThrottleStop = 1034,

	// Gear commands
	gearToggle = 68,
	gearUp = 430,
	gearDown = 431,
	WheelBrakeOn = 74,
	WheelBrakeOff = 75,

	// Air brake commands
	AirBrakes = 73,
	AirBrakesOn = 147,
	AirBrakesOff = 148,

	// Flap commands
	flapsToggle = 72,
	flapsUp = 145,
	flapsDown = 146,

	// Misc controls
	resetTrim = 97,

	//Autopilot
	AltitudeHoldToggle = 10500,
	AttitudeHoldToggle = 10501,
	AutoThrottleToggle = 10502,
	AutopilotDisengage = 10503,

	Reserved // Placeholder
};
