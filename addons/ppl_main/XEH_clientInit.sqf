#include "\a3\editor_f\data\scripts\dikcodes.h"

/*
Reset der Settings, falls vergurkt, in der Debug Console ausführen:
profileNamespace setVariable ["cba_keybinding_registrynew", nil]; saveProfileNamespace;
profileNamespace setVariable ["cba_keybinding_registry", []]; saveProfileNamespace;
*/

[
	localize "STR_PPL_Main_Keybinds_Category",
	"pplDialogOpen",
	[localize "STR_PPL_Main_Keybinds_Open_Dialog", localize "STR_PPL_Main_Keybinds_Open_Dialog_Description"],
	{true;}, 
	{[] call PPL_fnc_dialogOpen;}, 
	[DIK_I, [false, false, true]]
] call CBA_fnc_addKeybind;

/*
_entry = ["PPL", "pplDialogOpen"] call CBA_fnc_getKeybind; -->
["PPL","pplDialogOpen","PPL Menü öffnen",{true;},{_this call PPL_fnc_dialogOpen;},[22,[false,false,false]],false,0,[[22,[false,false,false]]]]

if (!isNil "_entry") then {
    _modName     = _entry select 0; // Name of the registering mod ("your_mod")
    _actionName  = _entry select 1; // Id of the key action ("openMenu")
    _displayName = _entry select 2; // Pretty name for the key action or an array with ["pretty name", "tool tip"]
    _downCode    = _entry select 3; // Code to execute on keyDown
    _upCode      = _entry select 4; // Code to execute on keyUp
    _firstKeybind= _entry select 5; // [DIK code, [shift, ctrl, alt]] (Only the first one)
    _holdKey     = _entry select 6; // Will the key fire every frame while held down? (bool)
    _holdDelay   = _entry select 7; // How long after keydown will the key event fire, in seconds (float)
    _keybinds    = _entry select 8; // All keybinds (array)
};
*/