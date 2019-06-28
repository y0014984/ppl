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

	[] call PPL_fnc_triggerServerDialogUpdate;
};

_templateEditBox = (findDisplay 24984) displayCtrl 1603;
_templateName = ctrlText _templateEditBox;
_filter = "0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZzÜüÖöÄä[]-_.:#*(){}%$§&<>+-,;'~?= ";
_templateName = [_templateName, _filter] call BIS_fnc_filterString;

_templateLoadout = getUnitLoadout [player, false];

if (_templateName == "") then
{
	hint localize "STR_PPL_Main_Notifications_Missing_Template_Name";
}
else
{
	_request = _playerUid + "-requestTemplateSave";
	missionNamespace setVariable [_request, [_playerUid, _clientId, _templateName, _templateLoadout], false];
	publicVariableServer _request;
};