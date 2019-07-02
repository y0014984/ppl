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
_clientId = clientOwner;

/* ================================================================================ */

_filter = "0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZzÜüÖöÄä[]-_.:#*(){}%$§&<>+-,;'~?= ";
_playerName = [_playerName, _filter] call BIS_fnc_filterString;

pplServerHelo = [_playerName, _playerUid];
publicVariableServer "pplServerHelo";

/* ================================================================================ */

_requestedPlayerUid = _playerUid;
_requestedLoadoutId = "activeLoadout";

_request = _playerUid + "-requestLoadoutAssign";
missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedPlayerUid, _requestedLoadoutId], false];
publicVariableServer _request;

/* ================================================================================ */

addMissionEventHandler ["Ended",
{
	params ["_endType"];
	
	_playerUid = getPlayerUID player;
	_clientId = clientOwner;
	
	_requestedPlayerUid = _playerUid;
	
	_requestedLoadoutId = "activeLoadout";
	
	_request = _playerUid + "-requestLoadoutUpdate";
	missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedPlayerUid, _requestedLoadoutId], false];
	publicVariableServer _request;
}];