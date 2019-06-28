/*
 * Author: y0014984
 *
 * Handles the PPL Dialog Stop Event Button pressing event.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call PPL_fnc_dialogButtonEventStopExec;
 *
 * Public: No
 */

_playerUid = getPlayerUID player;
_playerName = name player;
_clientId = clientOwner;

_answer = _playerUid + "-answerStopEvent";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	//[] call PPL_fnc_dialogUpdate;
	
	[] call PPL_fnc_triggerServerDialogUpdate;
};

_request = _playerUid + "-requestStopEvent";
missionNamespace setVariable [_request, [_playerUid, _clientId], false];
publicVariableServer _request;
