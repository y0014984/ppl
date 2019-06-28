/*
 * Author: y0014984
 *
 * Adds class event handler to every unit.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * None. Is executed on postInit.
 *
 * Public: No
 */

["CAManBase", "Init", {params ['_entity']; [_entity] spawn PPL_fnc_unitInit;}, nil, nil, true] call CBA_fnc_addClassEventHandler;
