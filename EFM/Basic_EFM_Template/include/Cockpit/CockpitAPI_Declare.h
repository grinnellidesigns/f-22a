#pragma once
#include "ccParametersAPI.h"

class EDPARAM
{
public:
		EDPARAM()
		{
			ed_param_api = ed_get_cockpit_param_api();
		}
		cockpit_param_api ed_param_api;

		void* getParamHandle(const char* name)
		{
			return ed_param_api.pfn_ed_cockpit_get_parameter_handle(name);
		}

		void setParamNumber(void* handle, double value)
		{
			ed_param_api.pfn_ed_cockpit_update_parameter_with_number(handle, value);
		}

		void setParamString(void* handle, const char* string)
		{
			ed_param_api.pfn_ed_cockpit_update_parameter_with_string(handle, string);
		}

		double getParamNumber(void* handle)
		{
			double res = 0;
			ed_param_api.pfn_ed_cockpit_parameter_value_to_number(handle, res, false);
			return res;
		}

		/*
		const char* getParamString(void* handle, unsigned buffer_size)
		{
			char buffer[256];
			ed_param_api.parameter_value_to_string(handle, buffer, 256);
			return &buffer[0];
		}
		*/

		inline void getParamString(void* ptr, char* buffer, unsigned int bufferSize) const
		{
			ed_param_api.pfn_ed_cockpit_parameter_value_to_string(ptr, buffer, bufferSize);
		}

		int compareParams(void* handle1, void* handle2)
		{
			return ed_param_api.pfn_ed_cockpit_compare_parameters(handle1, handle2);
		}
};

