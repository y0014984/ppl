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

_request = _playerUid + "-requestDialogUpdate";
missionNamespace setVariable [_request, [_playerUid, _clientId], false];
publicVariableServer _request;

_request = _playerUid + "-requestTemplates";
missionNamespace setVariable [_request, [_playerUid, _clientId], false];
publicVariableServer _request;
