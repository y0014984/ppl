/*
 * Author: y0014984
 *
 * Initializes units and adds several event handlers.
 *
 * Arguments:
 * 0: _unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit] spawn PPL_fnc_unitInit;
 *
 * Public: No
 */

params ["_unit"];

/* ================================================================================ */

_player = _unit;
_playerUid = getPlayerUID _unit;

if ((local _player) && _playerUid != "" && hasInterface && isMultiplayer) then
{
	[] call PPL_fnc_playerInit;
};

/* ================================================================================ */
