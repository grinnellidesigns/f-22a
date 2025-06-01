--[[
    Grinnelli Designs F-22A Raptor
    Copyright (C) 2024, Joseph Grinnelli
    
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
--]]


Presets = 
{
	F22A =
	{
		{
			Type = "overwingVapor",
			ShadingFX = "ParticleSystem2/overwingVapor.fx",
			UpdateFX  = "ParticleSystem2/overwingVaporComp.fx",
			Technique = "techOverwingVapor",

			Texture = "overwingVapor.dds",
			TextureDetailNoise = "puffNoise.png",
			LODdistance = 1500,

			SpawnLocationsFile = "F-22A_Vapor.owv",

			ParticlesCount = 786,
			ParticleSize = 3.7,
			ScaleOverAgeFactor = 1.8, -- scale = ParticleSize * (1 + (normalized age) * ScaleOverAgeFactor)
			
			VaporLengthMax = 12.0, -- meters
			
			AlbedoSRGB = 0.86,
			
			OpacityMax = 0.5,
			OpacityOverPower = {-- vapor power -> normalized opacity. In this case opacity = sqrt(vapor power)
				{0.0,	0.0},
				{0.125,	0.35355339059327376220042218105242},
				{0.25,	0.5},
				{0.5,	0.70710678118654752440084436210485},
				{1.0,	1.0},
			},
		}
	}
}
