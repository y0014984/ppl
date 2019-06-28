/*
 * Author: y0014984
 *
 * Triggers Dialog Update on serverside.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call PPL_fnc_triggerServerDialogUpdate;
 *
 * Public: No
 */

_playerUid = getPlayerUID player;
_clientId = clientOwner;

_filterPlayers = "";

_request = _playerUid + "-requestDialogUpdate";
missionNamespace setVariable [_request, [_playerUid, _clientId, _filterPlayers], false];
publicVariableServer _request;

_filterTemplates = "";

_request = _playerUid + "-requestTemplatesFiltered";
missionNamespace setVariable [_request, [_playerUid, _clientId, _filterTemplates], false];
publicVariableServer _request;
