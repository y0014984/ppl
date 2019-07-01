/*
 * Author: y0014984
 *
 * Handles the PPL Dialog Template Load Button pressing event.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call PPL_fnc_dialogButtonTemplateLoadExec;
 *
 * Public: No
 */

_playerUid = getPlayerUID player;
_playerName = name player;
_clientId = clientOwner;

_answer = _playerUid + "-answerTemplateLoad";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	[] call PPL_fnc_triggerServerDialogUpdate;
};

_pplDialog = findDisplay 24984;

_playersListBox = _pplDialog displayCtrl 1500;
_selectedPlayerIndex = lbCurSel _playersListBox;
_requestedPlayerUid = _playersListBox lbData _selectedPlayerIndex;

_templatesListBox = _pplDialog displayCtrl 1501;
_selectedTemplateIndex = lbCurSel _templatesListBox;

if (_selectedTemplateIndex != -1) then
{
	_requestedTemplateId = _templatesListBox lbData _selectedTemplateIndex;

	_request = _playerUid + "-requestTemplateLoad";
	missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedPlayerUid, _requestedTemplateId], false];
	publicVariableServer _request;
}
else
{
	hint localize "STR_PPL_Main_Notifications_No_Template_Selected";
};
