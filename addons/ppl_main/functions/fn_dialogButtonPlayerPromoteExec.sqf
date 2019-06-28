/*
 * Author: y0014984
 *
 * Handles the PPL Dialog Player Promote Button pressing event.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call PPL_fnc_dialogButtonPlayerPromoteExec;
 *
 * Public: No
 */
 
_playerUid = getPlayerUID player;
_playerName = name player;
_clientId = clientOwner;

_answer = _playerUid + "-answerPromotePlayer";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	//[] call PPL_fnc_dialogUpdate;

	[] call PPL_fnc_triggerServerDialogUpdate;
};

_answer = _playerUid + "-answerDegradePlayer";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	//[] call PPL_fnc_dialogUpdate;

	[] call PPL_fnc_triggerServerDialogUpdate;
};

_playersListBox = (findDisplay 24984) displayCtrl 1500;
_selectedPlayerIndex = lbCurSel _playersListBox;
_requestedPlayerUid = _playersListBox lbData _selectedPlayerIndex;
_promoteButton = (findDisplay 24984) displayCtrl 1610;
_promoteButtonText = ctrlText _promoteButton;

if (_selectedPlayerIndex != -1) then
{
		if ((_promoteButtonText find (localize "STR_PPL_Main_Dialog_Button_Promote")) > -1) then
		{
			_request = _playerUid + "-requestPromotePlayer";
			missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedPlayerUid], false];
			publicVariableServer _request;
		}
		else
		{
			_request = _playerUid + "-requestDegradePlayer";
			missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedPlayerUid], false];
			publicVariableServer _request;
		};	
}
else
{
	hint localize "STR_PPL_Main_Notifications_No_Player_Selected";
};