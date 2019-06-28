/*
 * Author: y0014984
 *
 * Handles the PPL Dialog Continue Event Button pressing event.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call PPL_fnc_dialogButtonEvent ContinueExec;
 *
 * Public: No
 */
 
_playerUid = getPlayerUID player;
_playerName = name player;
_clientId = clientOwner;

_answer = _playerUid + "-answerContinueEvent";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	//[] call PPL_fnc_dialogUpdate;

	[] call PPL_fnc_triggerServerDialogUpdate;
};

_eventsListBox = (findDisplay 24984) displayCtrl 1501;
_selectedEventIndex = lbCurSel _eventsListBox;
_requestedEventId = _eventsListBox lbData _selectedEventIndex;

if (_selectedEventIndex != -1) then
{
	if (!PPL_isEvent) then
	{
		_request = _playerUid + "-requestContinueEvent";
		missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedEventId], false];
		publicVariableServer _request;
	}
	else
	{
		hint localize "STR_PPL_Main_Notifications_Event_In_Progress";
	};
	
}
else
{
	hint localize "STR_PPL_Main_Notifications_No_Event_Selected";
};