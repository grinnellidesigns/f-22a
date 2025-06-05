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

self_ID = "F-22A by GrinnelliDesigns"
declare_plugin(self_ID, {
    image        = "FC3.bmp",
    installed    = true,
    dirName      = current_mod_path,
    binaries     = {'F22', },
    developerName = _("GrinnelliDesigns"),
    developerLink = _("https://grinnellidesigns.com/"),
    fileMenuName  = _("F-22A"),
    displayName   = _("F-22A"),
    shortName     = _("F-22A"),
    version       = "MK II - EFM",
    state         = "installed",
    update_id     = "F-22A",
    info          = _("F-22A Raptor 3D Model by GrinnelliDesigns; EFM by BHOOP Studios"),
    encyclopedia_path = current_mod_path .. '/Encyclopedia',
    Skins = {{name = _("F-22A"), dir = "Theme"}},
    Missions = {{name = _("F-22A"), dir = "Missions"}},
    LogBook = {{name = _("F-22A"), type = "F-22A"}},
    InputProfiles = {["F-22A"] = current_mod_path .. '/Input/F-22A'}
})
mount_vfs_model_path(current_mod_path .. "/Shapes")
mount_vfs_model_path(current_mod_path .. "/Cockpit/Shape") 
--mount_vfs_sound_path(current_mod_path .. "/Sounds/")
mount_vfs_liveries_path(current_mod_path .. "/Liveries")
mount_vfs_texture_path(current_mod_path .. "/Textures")
mount_vfs_texture_path(current_mod_path .. "/Textures/F-22A.zip")
mount_vfs_texture_path(current_mod_path .. "/Textures/F-22A_Cockpit.zip")
mount_vfs_texture_path(current_mod_path .. "/Textures/Clipboards")
mount_vfs_texture_path(current_mod_path .. "/Textures/Cockpit Photo")
mount_vfs_texture_path(current_mod_path .. "/Textures/Weapons.zip")

-------------------

mount_vfs_model_path(current_mod_path .. "/Shapes")

dofile(current_mod_path.."/VLO Fuel Tank.lua")
dofile(current_mod_path.."/IRST Sensor.lua")
dofile(current_mod_path.."/IRST Pod.lua")
dofile(current_mod_path .. "/Views.lua")
dofile(current_mod_path .. "/F-22A.lua")
dofile(current_mod_path .. "/Weapons.lua")
make_view_settings('F-22A', ViewSettings, SnapViews)


local cfg_path = current_mod_path .. "/FM/config.lua"
dofile(cfg_path)

local FM = {
[1] = self_ID,
[2] = 'F22.dll',
config_path = cfg_path,
suspension = suspension,
old = 6,
}

--FC4 Avionics
MAC_flyable('F-22A', current_mod_path..'/Cockpit/Scripts/', FM, current_mod_path..'/comm.lua')


plugin_done()
