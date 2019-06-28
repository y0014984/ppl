/*
 * Author: y0024984
 *
 * Updates the content of the PPL Dialog.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call PPL_fnc_dialogUpdate;
 *
 * Public: No
 */

_playerUid = getPlayerUID player;
_clientId = clientOwner;

/* ================================================================================ */

_playersListBox = (findDisplay 24984) displayCtrl 1500;
_playersListBox ctrlAddEventHandler ["LBSelChanged",
{
	params ["_control", "_selectedIndex"];

	if (_selectedIndex != -1) then
	{
		_text = _control lbText _selectedIndex;
		
		_promoteButton = (findDisplay 24984) displayCtrl 1610;

		if ((_text find (localize "STR_PPL_Main_Admin")) > -1) then
		{
			_promoteButton ctrlSetText localize "STR_PPL_Main_Dialog_Button_Degrade";
		}
		else
		{
			_promoteButton ctrlSetText localize "STR_PPL_Main_Dialog_Button_Promote";
		};
	};
}];

/* ================================================================================ */

_templatesListBox = (findDisplay 24984) displayCtrl 1501;
_templatesListBox ctrlAddEventHandler ["LBSelChanged",
{
	params ["_control", "_selectedIndex"];

	if (_selectedIndex != -1) then
	{
		_playersListBox = (findDisplay 24984) displayCtrl 1500;
		_selectedPlayerIndex = lbCurSel _playersListBox;
		_requestedPlayerUid = _playersListBox lbData _selectedPlayerIndex;
		
		_requestedTemplateId = _control lbData _selectedIndex;
		
		_playerUid = getPlayerUID player;
		_clientId = clientOwner;
		
		_filterLoadouts = "";
	
		_request = _playerUid + "-requestLoadoutsFiltered";
		missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedPlayerUid, _requestedTemplateId, _filterLoadouts], false];
		publicVariableServer _request;
	};
}];

/* ================================================================================ */

_loadoutsListBox = (findDisplay 24984) displayCtrl 1502;
_loadoutsListBox ctrlAddEventHandler ["LBSelChanged",
{
	params ["_control", "_selectedIndex"];

	if (PPL_isTrackLoadoutsActive && (_selectedIndex != -1)) then
	{
		_loadoutsListBox = (findDisplay 24984) displayCtrl 1502;
		_loadoutsKey = _loadoutsListBox lbData _selectedIndex;
		_trackLoadoutsButton = (findDisplay 24984) displayCtrl 1604;
		
		if (PPL_trackLoadoutsKey == _loadoutsKey) then
		{
			_trackLoadoutsButton ctrlSetText localize "STR_PPL_Main_Dialog_Button_Track_Value_Off";
		}
		else
		{
			_trackLoadoutsButton ctrlSetText localize "STR_PPL_Main_Dialog_Button_Track_Value_On";
		};
	};
}];

/* ================================================================================ */

_filterPlayersEditBox = (findDisplay 24984) displayCtrl 1400;
_filterPlayersEditBox ctrlAddEventHandler ["KeyUp",
{
	params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

	if ((_key == 28) || (_key == 156)) then
	{
		_playerUid = getPlayerUID player;
		_clientId = clientOwner;
		
		_filterPlayersEditBox = (findDisplay 24984) displayCtrl 1400;
		_filterPlayers = ctrlText _filterPlayersEditBox;
	
		_playersListBox = (findDisplay 24984) displayCtrl 1500;
		lbClear _playersListBox;
		_playersListBox lbSetCurSel -1;
		
		{
			_text = _x select 0;
			_data = _x select 1;
			
			if (((toLower _text) find (toLower _filterPlayers)) > -1) then
			{
				_index = _playersListBox lbAdd _text;
				_playersListBox lbSetData [_index, _data];
				
				if(_data == _playerUid) then
				{
					_playersListBox lbSetColor [_index, [1, 0.5, 0.5, 1]];
					_playersListBox lbSetCurSel _index;
				};
			};
		} forEach PPL_lbPlayersContent;
	};
}];

/* ================================================================================ */

_templatesFilterEditBox = (findDisplay 24984) displayCtrl 1401;
_templatesFilterEditBox ctrlAddEventHandler ["KeyUp",
{
	params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

	if ((_key == 28) || (_key == 156)) then
	{
		_playerUid = getPlayerUID player;
		_clientId = clientOwner;

		_templatesFilterEditBox = (findDisplay 24984) displayCtrl 1401;
		_filterTemplates = ctrlText _templatesFilterEditBox;

		_templatesListBox = (findDisplay 24984) displayCtrl 1501;
		lbClear _templatesListBox;
		_templatesListBox lbSetCurSel -1;
		
		{
			_text = _x select 0;
			_data = _x select 1;
			
			if (((toLower _text) find (toLower _filterTemplates)) > -1) then
			{
				_index = _templatesListBox lbAdd _text;
				_templatesListBox lbSetData [_index, _data];
			};
		} forEach PPL_lbTemplatesContent;
	};
}];

/* ================================================================================ */

_filterLoadoutsEditBox = (findDisplay 24984) displayCtrl 1402;
_filterLoadoutsEditBox ctrlAddEventHandler ["KeyUp",
{
	params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

	_filterLoadoutsEditBox = (findDisplay 24984) displayCtrl 1402;

	_playersListBox = (findDisplay 24984) displayCtrl 1500;
	_selectedPlayerIndex = lbCurSel _playersListBox;
	_requestedPlayerUid = _playersListBox lbData _selectedPlayerIndex;
	_templatesListBox = (findDisplay 24984) displayCtrl 1501;
	_selectedTemplateIndex = lbCurSel _templatesListBox;
	_requestedTemplateId = _templatesListBox lbData _selectedTemplateIndex;
	
	if ((_key == 28) || (_key == 156)) then
	{
		_playerUid = getPlayerUID player;
		_clientId = clientOwner;
		_filterLoadouts = ctrlText _filterLoadoutsEditBox;
		
		_loadoutsListBox = (findDisplay 24984) displayCtrl 1502;
		lbClear _loadoutsListBox;
		_loadoutsListBox lbSetCurSel -1;
		
		{
			_text = _x select 0;
			_data = _x select 1;
			
			if (((toLower _text) find (toLower _filterLoadouts)) > -1) then
			{
				_index = _loadoutsListBox lbAdd _text;
				_loadoutsListBox lbSetData [_index, _data];
				
				if ((PPL_isTrackLoadoutsActive) && (PPL_trackLoadoutsKey == _data)) then
				{
					_loadoutsListBox lbSetColor [_index, [1, 0.5, 0.5, 1]];
					_loadoutsListBox lbSetCurSel _index;
				};
			};
		} forEach PPL_lbLoadoutsContent;
	};
}];

/* ================================================================================ */

_answer = _playerUid + "-answerDialogUpdate";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;	
	_isAdmin = _broadcastVariableValue select 2;
	_isAdminLoggedIn = _broadcastVariableValue select 3;
	_countPlayersTotal = _broadcastVariableValue select 4;
	_countPlayersOnline = _broadcastVariableValue select 5;
	_countAdminsTotal = _broadcastVariableValue select 6;
	_countAdminsOnline = _broadcastVariableValue select 7;
	_countTemplatesTotal = _broadcastVariableValue select 8;
	_filteredPlayers = _broadcastVariableValue select 9;

	_statusServer = false;
	if (!isNil "PPL_statusServer") then {_statusServer =  PPL_statusServer;};
	_versionServer = localize "STR_PPL_Main_Unknown";
	if (!isNil "PPL_versionServer") then {_versionServer = PPL_versionServer;};
	_statusDatabase = false;
	if (!isNil "PPL_statusDatabase") then {_statusDatabase =  PPL_statusDatabase;};
	_versionDatabase = localize "STR_PPL_Main_Unknown";
	if (!isNil "PPL_versionDatabase") then {_versionDatabase = PPL_versionDatabase;};

	_headlineText = (findDisplay 24984) displayCtrl 1000;
	_serverAndDatabaseStatusText = (findDisplay 24984) displayCtrl 1001;
	_playersAndAdminsCountText = (findDisplay 24984) displayCtrl 1002;
	_playersListBox = (findDisplay 24984) displayCtrl 1500;
	lbClear _playersListBox;
	_playersListBox lbSetCurSel -1;
	_adminButton = (findDisplay 24984) displayCtrl 1600;
	_templatesText = (findDisplay 24984) displayCtrl 1007;
	_templatesFilterEditBox = (findDisplay 24984) displayCtrl 1401;
	_templatesListBox = (findDisplay 24984) displayCtrl 1501;
	_templateEditBox = (findDisplay 24984) displayCtrl 1603;
	_templateSaveButton = (findDisplay 24984) displayCtrl 1602;
	_templateLoadButton = (findDisplay 24984) displayCtrl 1607;
	_eventContinueButton = (findDisplay 24984) displayCtrl 1606;
	_eventDeleteButton = (findDisplay 24984) displayCtrl 1608;
	_continueButton = (findDisplay 24984) displayCtrl 1606;
	_trackLoadoutsButton = (findDisplay 24984) displayCtrl 1604;
	_promoteButton = (findDisplay 24984) displayCtrl 1610;
	
	_filterPlayersEditBox = (findDisplay 24984) displayCtrl 1400;
	_filterPlayers = ctrlText _filterPlayersEditBox;
	
	if (_statusServer) then {_statusServer = localize "STR_PPL_Main_Online"} else {_statusServer = localize "STR_PPL_Main_Offline"};
	if (_statusDatabase) then {_statusDatabase = localize "STR_PPL_Main_Online"} else {_statusDatabase = localize "STR_PPL_Main_Offline"};
	
	_serverAndDatabaseStatusText ctrlSetText format [localize "STR_PPL_Main_Dialog_Server_Status", format ["%1 [%2]", _statusServer, _versionServer],  format ["%1 [%2]", _statusDatabase, _versionDatabase]];
	_playersAndAdminsCountText ctrlSetText format [localize "STR_PPL_Main_Dialog_Player_Status",_countPlayersTotal , _countPlayersOnline, _countAdminsTotal, _countAdminsOnline, _countTemplatesTotal];

	if (_isAdminLoggedIn) then
	{
		_adminButton ctrlSetText localize "STR_PPL_Main_Dialog_Button_Logout";
		_templatesText ctrlShow true;
		_templatesFilterEditBox ctrlShow true;
		_templatesListBox ctrlShow true;
		_templateEditBox ctrlShow true;
		_templateSaveButton ctrlShow true;
		_templateLoadButton ctrlShow true;
		_eventContinueButton ctrlShow true;
		_eventDeleteButton ctrlShow true;
		_continueButton ctrlShow true;
		_promoteButton ctrlShow true;
	}
	else
	{
		_adminButton ctrlSetText localize "STR_PPL_Main_Dialog_Button_Login";
		_templatesText ctrlShow false;
		_templatesFilterEditBox ctrlShow false;
		_templatesListBox ctrlShow false;
		_templateEditBox ctrlShow false;
		_templateSaveButton ctrlShow false;
		_templateLoadButton ctrlShow false;
		_eventContinueButton ctrlShow false;
		_eventDeleteButton ctrlShow false;
		_continueButton ctrlShow false;
		_promoteButton ctrlShow false;
	};

	PPL_lbPlayersContent = [];

	_filteredPlayers sort true;
	{
		_dbPlayerName = _x select 0;
		_dbPlayerUid = _x select 1;
		_dbPlayerIsAdmin = _x select 2;
		_dbPlayerIsAdminLoggedIn = _x select 3;
		_dbPlayerStatus = _x select 4;
		
		if (_dbPlayerIsAdmin) then {_dbPlayerIsAdmin = localize "STR_PPL_Main_Admin";} else {_dbPlayerIsAdmin = localize "STR_PPL_Main_Player";};

		if (_dbPlayerStatus) then {_dbPlayerStatus = " " + (localize "STR_PPL_Main_Online");} else {_dbPlayerStatus = " " + (localize "STR_PPL_Main_Offline");};

		if (_dbPlayerIsAdminLoggedIn) then {_dbPlayerIsAdminLoggedIn = " " + (localize "STR_PPL_Main_Logged_In");} else {_dbPlayerIsAdminLoggedIn = "";};
		
		_playerText = format ["%1 (%2%3%4)",_dbPlayerName, _dbPlayerIsAdmin, _dbPlayerStatus, _dbPlayerIsAdminLoggedIn];

		if (((toLower _playerText) find (toLower _filterPlayers)) > -1) then
		{
			_index = _playersListBox lbAdd _playerText;	
			_playersListBox lbSetData [_index, _dbPlayerUid];
			
			if(_dbPlayerUid == _playerUid) then
			{
				_playersListBox lbSetColor [_index, [1, 0.5, 0.5, 1]];
				_playersListBox lbSetCurSel _index;
			};
		};
		
		PPL_lbPlayersContent = PPL_lbPlayersContent + [[_playerText, _dbPlayerUid]];
		
	} forEach _filteredPlayers;
	
	ctrlSetFocus _playersListBox;
};

/* ================================================================================ */

_answer = _playerUid + "-answerTemplatesFiltered";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;	
	_isAdmin = _broadcastVariableValue select 2;
	_isAdminLoggedIn = _broadcastVariableValue select 3;
	_filteredTemplates = _broadcastVariableValue select 4;
	
	_templatesListBox = (findDisplay 24984) displayCtrl 1501;
	lbClear _templatesListBox;
	_templatesListBox lbSetCurSel -1;
	
	_loadoutsListBox = (findDisplay 24984) displayCtrl 1502;
	lbClear _loadoutsListBox;
	_loadoutsListBox lbSetCurSel -1;
	
	_templatesFilterEditBox = (findDisplay 24984) displayCtrl 1401;
	_filterTemplates = ctrlText _templatesFilterEditBox;

	PPL_lbTemplatesContent = [];

	_filteredTemplates sort false;
	{
		_dbTemplateId = _x select 0;
		_dbTemplateName = _x select 1;
		
		_templateText = format ["%1", _dbTemplateName];

		if (((toLower _templateText) find (toLower _filterTemplates)) > -1) then
		{
			_index = _templatesListBox lbAdd _templateText;	
			_templatesListBox lbSetData [_index, _dbTemplateId];
		};	
		
		PPL_lbTemplatesContent = PPL_lbTemplatesContent + [[_templateText, _dbTemplateId]];
	
	} forEach _filteredTemplates;
	
	ctrlSetFocus _templatesListBox;
};

/* ================================================================================ */

_answer = _playerUid + "-answerLoadoutsFiltered";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];
	
	_playerLoadouts = _broadcastVariableValue select 0;
	_isTrackLoadoutsActive = _broadcastVariableValue select 1;
	_trackLoadoutsKey = _broadcastVariableValue select 2;

	_loadoutsListBox = (findDisplay 24984) displayCtrl 1502;
	lbClear _loadoutsListBox;
	_loadoutsListBox lbSetCurSel -1;
	
	_filterLoadoutsEditBox = (findDisplay 24984) displayCtrl 1402;
	_filterLoadouts = ctrlText _filterLoadoutsEditBox;
	
	PPL_lbLoadoutsContent = [];
	
	_playerLoadouts sort true;
	{
		_key = _x select 0;
		_formatString = _x select 1;
		_source = _x select 2;
		_valueOne = _x select 3;
		_valueTwo = _x select 4;
		_valueThree = _x select 5;
		
		_loadoutsText = (format ["[%1]", _source]) + " " + (format [(localize _formatString), _valueOne, _valueTwo, _valueThree]);
		
		if ((PPL_isTrackLoadoutsActive) && (PPL_trackLoadoutsKey == _key)) then
		{
			_loadoutsText = format [localize "STR_PPL_Main_Dialog_List_Tracking_Active", _loadoutsText];
		};
		
		if (((toLower _loadoutsText) find (toLower _filterLoadouts)) > -1) then
		{
			_index = _loadoutsListBox lbAdd _loadoutsText;
			_loadoutsListBox lbSetData [_index, _key];
			
			if ((PPL_isTrackLoadoutsActive) && (PPL_trackLoadoutsKey == _key)) then
			{		
				_loadoutsListBox lbSetColor [_index, [1, 0.5, 0.5, 1]];
				_loadoutsListBox lbSetCurSel _index;
			};
		};
		
		PPL_lbLoadoutsContent = PPL_lbLoadoutsContent + [[_loadoutsText, _key]];
		
	} forEach _playerLoadouts;
};

/* ================================================================================ */

[] call PPL_fnc_triggerServerDialogUpdate;

/* ================================================================================ */
