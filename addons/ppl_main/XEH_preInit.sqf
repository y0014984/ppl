[
	"PPL_TimeZone",
	"LIST",
	[localize "STR_PPL_Main_Settings_Timezone", localize "STR_PPL_Main_Settings_Timezone_Description"],
	localize "STR_PPL_Main_Settings_Category_Client_Settings",
	[
		[0, 1, 2],
		[["UTC+0", "Großbritannien"], ["UTC+1", "Deutschland"], ["UTC+2", "Ukraine"]], 
		1
	],
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
        params ["_value"];
    } // function that will be executed once on mission start and every time the setting is changed.
] call cba_settings_fnc_init;

[
	"PPL_SummerTime",
	"Checkbox",
	[localize "STR_PPL_Main_Settings_Daylight_Saving_Time", localize "STR_PPL_Main_Settings_Daylight_Saving_Time_Description"],
	localize "STR_PPL_Main_Settings_Category_Client_Settings",
	true,
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
        params ["_value"];
    } // function that will be executed once on mission start and every time the setting is changed.
] call cba_settings_fnc_init;

[
	"PPL_ClientLogging",
	"Checkbox",
	[localize "STR_PPL_Main_Settings_Client_Logging", "STR_PPL_Main_Settings_Client_Logging_Description"],
	localize "STR_PPL_Main_Settings_Category_Client_Settings",
	false,
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
        params ["_value"];
    } // function that will be executed once on mission start and every time the setting is changed.
] call cba_settings_fnc_init;

[
	"PPL_ServerLogging",
	"Checkbox",
	[localize "STR_PPL_Main_Settings_Server_Logging", "STR_PPL_Main_Settings_Server_Logging_Description"],
	localize "STR_PPL_Main_Settings_Category_Server_Settings",
	false,
    nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
        params ["_value"];
    } // function that will be executed once on mission start and every time the setting is changed.
] call cba_settings_fnc_init;
