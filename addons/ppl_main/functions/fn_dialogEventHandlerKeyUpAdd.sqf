/*
 * Author: y0014984
 *
 * Adds KeyUp Event Handler to given Dialog
 *
 * Arguments:
 * 1: _pplDialog <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_pplDialog] call PPL_fnc_dialogEventHandlerKeyUpAdd;
 *
 * Public: No
 */

params ["_pplDialog"];	

_pplDialog displayAddEventHandler ["KeyUp", 
{
	params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];	

	_entry = ["PPL", "pplDialogOpen"] call CBA_fnc_getKeybind;

	_keybinds = _entry select 8;
	
	_pplDialog = (findDisplay 24984);
	
	{
		_pplKey = _x select 0;
		_pplModifiers = _x select 1;
		
		_pplShift = _pplModifiers select 0;
		_pplCtrl = _pplModifiers select 1;
		_pplAlt = _pplModifiers select 2;

		if ((_key == _pplKey) && (_shift isEqualTo _pplShift) && (_ctrl isEqualTo _pplCtrl) && (_alt isEqualTo _pplAlt)) then	
		{
			//_pplDialog closeDisplay 1;
			closeDialog 1;
		};
	} forEach _keybinds;
}];