/*
 * Author: y0014984
 *
 * Generates a random digit string for id purposes
 *
 * Arguments:
 * 0: _idLength <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * _id = [10] call PPL_fnc_generateId;
 *
 * Public: No
 */

params ["_idLength"];

_id = "";

for "_i" from 1 to _idLength do
{
	_id = _id + ((random 9) toFixed 0);
};

_id;