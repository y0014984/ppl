/*
 * Author: y0014984
 *
 * Initializes player objects and communicates with server.
 * Runs in infinite loop.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call PPL_fnc_playerInit;
 *
 * Public: No
 */

_playerUid = getPlayerUID player;
_playerName = name player;

/* ================================================================================ */

_filter = "0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZzÜüÖöÄä[]-_.:#*(){}%$§&<>+-,;'~?= ";
_playerName = [_playerName, _filter] call BIS_fnc_filterString;

pplServerHelo = [_playerName, _playerUid];
publicVariableServer "pplServerHelo";

/* ================================================================================ */

while {true} do
{
	// Do we something here?
};

/* ================================================================================ */
