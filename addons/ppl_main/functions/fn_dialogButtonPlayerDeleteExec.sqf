/*
 * Author: y0014984
 *
 * Handles the PPL Dialog Player Delete Button pressing event.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call PPL_fnc_dialogButtonPlayerDeleteExec;
 *
 * Public: No
 */
 
_playerUid = getPlayerUID player;
_playerName = name player;
_clientId = clientOwner;

_answer = _playerUid + "-answerDeletePlayer";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	//[] call PPL_fnc_dialogUpdate;

	[] call PPL_fnc_triggerServerDialogUpdate;
};

_playersListBox = (findDisplay 24984) displayCtrl 1500;
_selectedPlayerIndex = lbCurSel _playersListBox;
_requestedPlayerUid = _playersListBox lbData _selectedPlayerIndex;

if (_selectedPlayerIndex != -1) then
{
	_request = _playerUid + "-requestDeletePlayer";
	missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedPlayerUid], false];
	publicVariableServer _request;	
}
else
{
	hint localize "STR_PPL_Main_Notifications_No_Player_Selected";
};