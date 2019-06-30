/*
 * Author: y0024984
 *
 * Creates the PPL Dialog and adds multiple event handlers to interface elements.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call PPL_fnc_dialogOpen;
 *
 * Public: No
 */

if (hasInterface ) then
{
	if (isMultiplayer) then
	{
		_serverAdminStatus = call BIS_fnc_admin;
		if (_serverAdminStatus == 2) then 
		{
			_playerUid = getPlayerUID player;
			_clientId = clientOwner;
			_request = _playerUid + "-requestSetServerAdminToPplAdmin";
			missionNamespace setVariable [_request, [_playerUid, _clientId], false];
			publicVariableServer _request;
		};
		
		if (!dialog) then {_ok = createDialog "PPL_Main_Dialog";};
		
		_pplDialog = findDisplay 24984;
		
		[_pplDialog] call PPL_fnc_dialogEventHandlerKeyUpAdd;
		
		/* ---------------------------------------- */
		
		_playersFilterEditBox = _pplDialog displayCtrl 1400;
		_playersFilterEditBox ctrlAddEventHandler ["SetFocus",
		{
			params ["_control"];
			
			_pplDialog = (findDisplay 24984);
			_pplDialog displayRemoveAllEventHandlers "KeyUp";
		}];
		_playersFilterEditBox ctrlAddEventHandler ["KillFocus",
		{
			params ["_control"];
			
			_pplDialog = (findDisplay 24984);
			[_pplDialog] call PPL_fnc_dialogEventHandlerKeyUpAdd;
		}];
		
		/* ---------------------------------------- */
		
		_templatesFilterEditBox = _pplDialog displayCtrl 1401;
		_templatesFilterEditBox ctrlAddEventHandler ["SetFocus",
		{
			params ["_control"];
			
			_pplDialog = (findDisplay 24984);
			_pplDialog displayRemoveAllEventHandlers "KeyUp";
		}];
		_templatesFilterEditBox ctrlAddEventHandler ["KillFocus",
		{
			params ["_control"];
			
			_pplDialog = (findDisplay 24984);
			[_pplDialog] call PPL_fnc_dialogEventHandlerKeyUpAdd;
		}];

		/* ---------------------------------------- */
		
		_loadoutsFilterEditBox = _pplDialog displayCtrl 1402;
		_loadoutsFilterEditBox ctrlAddEventHandler ["SetFocus",
		{
			params ["_control"];
			
			_pplDialog = (findDisplay 24984);
			_pplDialog displayRemoveAllEventHandlers "KeyUp";
		}];
		_loadoutsFilterEditBox ctrlAddEventHandler ["KillFocus",
		{
			params ["_control"];
			
			_pplDialog = (findDisplay 24984);
			[_pplDialog] call PPL_fnc_dialogEventHandlerKeyUpAdd;
		}];
		
		/* ---------------------------------------- */
		
		_templateEditBox = _pplDialog displayCtrl 1603;
		_templateEditBox ctrlAddEventHandler ["SetFocus",
		{
			params ["_control"];
			
			_pplDialog = (findDisplay 24984);
			_pplDialog displayRemoveAllEventHandlers "KeyUp";
		}];
		_templateEditBox ctrlAddEventHandler ["KillFocus",
		{
			params ["_control"];
			
			_pplDialog = (findDisplay 24984);
			[_pplDialog] call PPL_fnc_dialogEventHandlerKeyUpAdd;
		}];
		
		/* ---------------------------------------- */
		
		_playersListBox = (findDisplay 24984) displayCtrl 1500;
		_playersListBox ctrlAddEventHandler ["MouseButtonDblClick",
		{
			params ["_control"];

			_playerUid = getPlayerUID player;
			_clientId = clientOwner;
			_dataType = "player";
			
			_playersListBox = (findDisplay 24984) displayCtrl 1500;
			_selectedPlayerIndex = lbCurSel _playersListBox;
			_requestedPlayerUid = _playersListBox lbData _selectedPlayerIndex;
			
			_request = _playerUid + "-requestDetails";
			missionNamespace setVariable [_request, [_playerUid, _clientId, _dataType, _requestedPlayerUid], false];
			publicVariableServer _request;
		}];
		
		/* ---------------------------------------- */
		
		_templatesListBox = (findDisplay 24984) displayCtrl 1501;
		_templatesListBox ctrlAddEventHandler ["MouseButtonDblClick",
		{
			params ["_control"];

			_playerUid = getPlayerUID player;
			_clientId = clientOwner;
			_dataType = "template";
			
			_templatesListBox = (findDisplay 24984) displayCtrl 1501;
			_selectedTemplateIndex = lbCurSel _templatesListBox;
			_requestedTemplateId = _templatesListBox lbData _selectedTemplateIndex;
			
			_request = _playerUid + "-requestDetails";
			missionNamespace setVariable [_request, [_playerUid, _clientId, _dataType, _requestedTemplateId], false];
			publicVariableServer _request;
		}];
		
		/* ---------------------------------------- */

		_loadoutsListBox = (findDisplay 24984) displayCtrl 1502;
		_loadoutsListBox ctrlAddEventHandler ["MouseButtonDblClick",
		{
			params ["_control"];

			_playerUid = getPlayerUID player;
			_clientId = clientOwner;
			_dataType = "loadout";
			
			_loadoutsListBox = (findDisplay 24984) displayCtrl 1502;
			_selectedLoadoutIndex = lbCurSel _loadoutsListBox;
			_requestedLoadoutId = _loadoutsListBox lbData _selectedLoadoutIndex;
			
			_templatesListBox = (findDisplay 24984) displayCtrl 1501;
			_selectedTemplateIndex = lbCurSel _templatesListBox;
			_requestedTemplateId = _templatesListBox lbData _selectedTemplateIndex;
			
			_playersListBox = (findDisplay 24984) displayCtrl 1500;
			_selectedPlayerIndex = lbCurSel _playersListBox;
			_requestedPlayerUid = _playersListBox lbData _selectedPlayerIndex;

			
			
			
			_request = _playerUid + "-requestDetails";
			missionNamespace setVariable [_request, [_playerUid, _clientId, _dataType, [_requestedLoadoutId, _requestedTemplateId, _requestedPlayerUid]], false];
			publicVariableServer _request;
		}];

		/* ---------------------------------------- */

		[] call PPL_fnc_dialogUpdate;
	}
	else
	{
		hint localize "STR_PPL_Main_Notifications_Singleplayer_Not_Supported";
	};
};