/*
 * Author: y0014984
 *
 * Handles the PPL Dialog Template Delete Button pressing event.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call PPL_fnc_dialogButtonTemplateDeleteExec;
 *
 * Public: No
 */
 
_playerUid = getPlayerUID player;
_playerName = name player;
_clientId = clientOwner;

_answer = _playerUid + "-answerTemplateDelete";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	[] call PPL_fnc_triggerServerDialogUpdate;
};

_templatesListBox = (findDisplay 24984) displayCtrl 1501;
_selectedTemplateIndex = lbCurSel _templatesListBox;

if (_selectedTemplateIndex != -1) then
{
	_requestedTemplateId = _templatesListBox lbData _selectedTemplateIndex;

	_request = _playerUid + "-requestTemplateDelete";
	missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedTemplateId], false];
	publicVariableServer _request;	
}
else
{
	hint localize "STR_PPL_Main_Notifications_No_Template_Selected";
};