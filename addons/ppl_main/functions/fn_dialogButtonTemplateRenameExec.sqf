/*
 * Author: y0014984
 *
 * Handles the PPL Dialog Template Rename Button pressing event.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call PPL_fnc_dialogButtonTemplateRenameExec;
 *
 * Public: No
 */
 
_playerUid = getPlayerUID player;
_playerName = name player;
_clientId = clientOwner;

_answer = _playerUid + "-answerTemplateRename";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	[] call PPL_fnc_triggerServerDialogUpdate;
};

_templatesListBox = (findDisplay 24984) displayCtrl 1501;
_selectedTemplateIndex = lbCurSel _templatesListBox;

_templateEditBox = (findDisplay 24984) displayCtrl 1603;
_requestedTemplateName = ctrlText _templateEditBox;

if (_selectedTemplateIndex != -1) then
{
	_requestedTemplateId = _templatesListBox lbData _selectedTemplateIndex;
	
	if (_requestedTemplateName != "") then
	{
		_request = _playerUid + "-requestTemplateRename";
		missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedTemplateId, _requestedTemplateName], false];
		publicVariableServer _request;
	}
	else
	{
		hint localize "STR_PPL_Main_Notifications_Missing_Template_Name";
	};
}
else
{
	hint localize "STR_PPL_Main_Notifications_No_Template_Selected";
};