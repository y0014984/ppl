/*
 * Author: y0014984
 *
 * Handles the PPL Dialog Loadout Update Button pressing event.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call PPL_fnc_dialogButtonLoadoutUpdateExec;
 *
 * Public: No
 */

_playerUid = getPlayerUID player;
_playerName = name player;
_clientId = clientOwner;

_answer = _playerUid + "-answerLoadoutUpdate";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	[] call PPL_fnc_triggerServerDialogUpdate;
};

_pplDialog = findDisplay 24984;

_playersListBox = _pplDialog displayCtrl 1500;
_selectedPlayerIndex = lbCurSel _playersListBox;

if (_selectedPlayerIndex != -1) then
{
	_requestedPlayerUid = _playersListBox lbData _selectedPlayerIndex;

	_loadoutsListBox = _pplDialog displayCtrl 1502;
	_selectedLoadoutIndex = lbCurSel _loadoutsListBox;

	if (_selectedLoadoutIndex != -1) then
	{
		_requestedLoadoutId = _loadoutsListBox lbData _selectedLoadoutIndex;

		_request = _playerUid + "-requestLoadoutUpdate";
		missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedPlayerUid, _requestedLoadoutId], false];
		publicVariableServer _request;
	}
	else
	{
		hint localize "STR_PPL_Main_Notifications_No_Loadout_Selected";
	};
}
else
{
	hint localize "STR_PPL_Main_Notifications_No_Player_Selected";
};
