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
