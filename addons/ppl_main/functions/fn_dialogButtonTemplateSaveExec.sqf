/*
 * Author: y0014984
 *
 * Handles the PPL Dialog Template Save Button pressing event.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call PPL_fnc_dialogButtonTemplateSaveExec;
 *
 * Public: No
 */

_playerUid = getPlayerUID player;
_playerName = name player;
_clientId = clientOwner;

_answer = _playerUid + "-answerTemplateSave";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_templateEditBox = (findDisplay 24984) displayCtrl 1603;
	_templateEditBox ctrlSetText "";

	[] call PPL_fnc_triggerServerDialogUpdate;
};

_pplDialog = findDisplay 24984;

_playersListBox = _pplDialog displayCtrl 1500;
_selectedPlayerIndex = lbCurSel _playersListBox;
		
if (_selectedPlayerIndex != -1) then
{
	_requestedPlayerUid = _playersListBox lbData _selectedPlayerIndex;

	_templateEditBox = (findDisplay 24984) displayCtrl 1603;
	_templateName = ctrlText _templateEditBox;
	_filter = "0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZzÜüÖöÄä[]-_.:#*(){}%$§&<>+-,;'~?= ";
	_templateName = [_templateName, _filter] call BIS_fnc_filterString;
	
	if (_templateName != "") then
	{
		_request = _playerUid + "-requestTemplateSave";
		missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedPlayerUid, _templateName], false];
		publicVariableServer _request;
	}
	else
	{
		hint localize "STR_PPL_Main_Notifications_Missing_Template_Name";
	};
}
else
{
	hint localize "STR_PPL_Main_Notifications_No_Player_Selected";
};