#pragma once
//#include "stdafx.h"
#include <math.h>
#include <stdio.h>
#include <string>
// This file contains useful functions, mostly math.

// Convert number from degrees to radians
inline double rad(double x)
{
	return x / 57.295779513082320876798154814105;
};

// Convert number from radians to degrees
inline double deg(double x)
{
	return x * 57.295779513082320876798154814105;
};

// Simple actuator
inline double actuator(double value, double target, double down_speed, double up_speed)
{
	if ((value + up_speed) < target)
	{
		return value += up_speed;
	}

	else if ((value + down_speed) > target)
	{
		return value += down_speed;
	}

	else
	{
		return target;
	}
};

// Simple upper and lower limiter
inline double limit(double input, double lower_limit, double upper_limit)
{
	if (input > upper_limit)
	{
		return upper_limit;
	}
	else if (input < lower_limit)
	{
		return lower_limit;
	}
	else
	{
		return input;
	}
};

// Rescales a -1 to +1 scale to different minima/maxima. Example: -1 to +1 -> -10 to +15
// inline double rescale(double input, double min, double max)
//{
//	if (input >= 0.0)
//		return input * fabs(max);
//	if (input < 0.0)
//		return input * fabs(min);
//};

inline double rescale(double input, double min_in, double max_in, double min_out = -1.0, double max_out = 1.0)
{
	if (max_in - min_in == 0) return min_out; // Avoid divide-by-zero
	return min_out + (max_out - min_out) * (input - min_in) / (max_in - min_in);
}






// 3D vector structure,
// In DCS coordinates linear: x = forward/back, y = up/down, z = left/right
// Angular: x = roll, y = yaw, z = pitch
struct Vec3
{
	inline Vec3(double x_ = 0,double y_ = 0,double z_ = 0) :x(x_),y(y_),z(z_){}
	double x;
	double y;
	double z;
};

// Vector cross product
inline Vec3 cross(const Vec3 & a, const Vec3 & b)
{
	return Vec3 (a.y * b.z - a.z * b.y,
				 a.z * b.x - a.x * b.z,
				 a.x * b.y - a.y * b.x);
}

/* 
Unused structs.
May be useful for more advanced projects with multi-dimensional data tables.

struct Matrix33
{
	Vec3 x;
	Vec3 y;
	Vec3 z;
};

struct Quaternion
{
	double x;
	double y;
	double z;
	double w;
};


Matrix33 quaternion_to_matrix(const Quaternion & v)
{
	Matrix33 mtrx;
	double wx, wy, wz, xx, yy, yz, xy, xz, zz, x2, y2, z2;
	x2 = v.x + v.x;
	y2 = v.y + v.y;
	z2 = v.z + v.z;
	xx = v.x * x2;   xy = v.x * y2;   xz = v.x * z2;
	yy = v.y * y2;   yz = v.y * z2;   zz = v.z * z2;
	wx = v.w * x2;   wy = v.w * y2;   wz = v.w * z2;


	mtrx.x.x  = 1.0 - (yy + zz);
	mtrx.x.y  = xy+wz;
	mtrx.x.z  = xz-wy;

	mtrx.y.x = xy-wz;
	mtrx.y.y = 1.0 - (xx + zz);
	mtrx.y.z = yz + wx;

	mtrx.z.x = xz+wy;
	mtrx.z.y = yz-wx;
	mtrx.z.z = 1.0 - (xx+yy);

	return mtrx;
}
*/

// Linear interpolation
inline double lerp(const double* x, const double* f, size_t sz, double t)
{
	if (sz == 0) return 0.0;
	if (sz == 1) return f[0];

	for (size_t i = 0; i < sz; i++)
	{
		if (t <= x[i])
		{
			if (i > 0)
			{
				double dx = x[i] - x[i - 1];
				if (dx == 0.0) return f[i - 1];
				return ((f[i] - f[i - 1]) / dx * t +
					(x[i] * f[i - 1] - x[i - 1] * f[i]) / dx);
			}
			return f[0];
		}
	}
	return f[sz - 1];
}

/*	
	This takes two tables and makes a sort of "virtual graph".
	The x value makes the x axis, the f value makes the y axis.
	It's important that the number of entries (size) in both tables are exactly the same.
	The t value is the "driver" that determines the output value.
	In most cases here, the x table is mach values, f table is aerodynamics coefficients, 
	and t is the aircraft's current mach number.

	This can be used for other stuff, like the throttle response curve.
*/

// Linear interpolation smoothing function
double smooth_lerp(double current, double target, double t)
{
	return current + (target - current) * t;
};

//Slew Rate Limiter
inline double slew_rate_limit(double current, double target, double rate, double dt) {
	double delta = target - current;
	double max_change = rate * dt;
	return current + std::clamp(delta, -max_change, max_change);
}