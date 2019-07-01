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
		_templatesListBox = (findDisplay 24984) displayCtrl 1501;
		_selectedTemplateIndex = lbCurSel _templatesListBox;
		_requestedPlayerUid = _control lbData _selectedIndex;
		
		_requestedTemplateId = "";
		if (_selectedTemplateIndex != -1) then {_requestedTemplateId = _templatesListBox lbData _selectedTemplateIndex;};
		
		_playerUid = getPlayerUID player;
		_clientId = clientOwner;
		
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
	
		_request = _playerUid + "-requestLoadouts";
		missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedPlayerUid, _requestedTemplateId], false];
		publicVariableServer _request;
	};
}];

/* ================================================================================ */

_templatesListBox = (findDisplay 24984) displayCtrl 1501;
_templatesListBox ctrlAddEventHandler ["LBSelChanged",
{
	params ["_control", "_selectedIndex"];

	_playersListBox = (findDisplay 24984) displayCtrl 1500;
	_selectedPlayerIndex = lbCurSel _playersListBox;
	
	if (_selectedPlayerIndex != -1) then
	{
		_requestedPlayerUid = _playersListBox lbData _selectedPlayerIndex;
		
		_requestedTemplateId = _control lbData _selectedIndex;
		
		_playerUid = getPlayerUID player;
		_clientId = clientOwner;
	
		_request = _playerUid + "-requestLoadouts";
		missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedPlayerUid, _requestedTemplateId], false];
		publicVariableServer _request;
	};
}];

/* ================================================================================ */

_loadoutsListBox = (findDisplay 24984) displayCtrl 1502;
_loadoutsListBox ctrlAddEventHandler ["LBSelChanged",
{
	params ["_control", "_selectedIndex"];

	if (_selectedIndex != -1) then
	{
		// ???
	};
}];

/* ================================================================================ */

_playersFilterEditBox = (findDisplay 24984) displayCtrl 1400;
_playersFilterEditBox ctrlAddEventHandler ["KeyUp",
{
	params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

	if ((_key == 28) || (_key == 156)) then
	{
		_playerUid = getPlayerUID player;
		_clientId = clientOwner;
		
		_playersFilterEditBox = (findDisplay 24984) displayCtrl 1400;
		_playersFilter = ctrlText _playersFilterEditBox;
	
		_playersListBox = (findDisplay 24984) displayCtrl 1500;
		lbClear _playersListBox;
		_playersListBox lbSetCurSel -1;
		
		{
			_text = _x select 0;
			_data = _x select 1;
			
			if (((toLower _text) find (toLower _playersFilter)) > -1) then
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
		_templatesFilter = ctrlText _templatesFilterEditBox;

		_templatesListBox = (findDisplay 24984) displayCtrl 1501;
		lbClear _templatesListBox;
		_templatesListBox lbSetCurSel -1;
		
		{
			_text = _x select 0;
			_data = _x select 1;
			
			if (((toLower _text) find (toLower _templatesFilter)) > -1) then
			{
				_index = _templatesListBox lbAdd _text;
				_templatesListBox lbSetData [_index, _data];
			};
		} forEach PPL_lbTemplatesContent;
	};
}];

/* ================================================================================ */

_loadoutsFilterEditBox = (findDisplay 24984) displayCtrl 1402;
_loadoutsFilterEditBox ctrlAddEventHandler ["KeyUp",
{
	params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

	_loadoutsFilterEditBox = (findDisplay 24984) displayCtrl 1402;

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
		_loadoutsFilter = ctrlText _loadoutsFilterEditBox;
		
		_loadoutsListBox = (findDisplay 24984) displayCtrl 1502;
		lbClear _loadoutsListBox;
		_loadoutsListBox lbSetCurSel -1;
		
		{
			_text = _x select 0;
			_data = _x select 1;
			
			if (((toLower _text) find (toLower _loadoutsFilter)) > -1) then
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
	_players = _broadcastVariableValue select 9;

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
	//_templatesText = (findDisplay 24984) displayCtrl 1007;
	//_templatesFilterEditBox = (findDisplay 24984) displayCtrl 1401;
	//_templatesListBox = (findDisplay 24984) displayCtrl 1501;
	_templateEditBox = (findDisplay 24984) displayCtrl 1603;
	_templateSaveButton = (findDisplay 24984) displayCtrl 1602;
	_templateLoadButton = (findDisplay 24984) displayCtrl 1607;
	_templateRenameButton = (findDisplay 24984) displayCtrl 1606;
	_templateDeleteButton = (findDisplay 24984) displayCtrl 1608;
	_loadoutAssignButton = (findDisplay 24984) displayCtrl 1604;
	_loadoutsExportButton = (findDisplay 24984) displayCtrl 1605;
	_promoteButton = (findDisplay 24984) displayCtrl 1610;
	
	_playersFilterEditBox = (findDisplay 24984) displayCtrl 1400;
	_playersFilter = ctrlText _playersFilterEditBox;
	
	if (_statusServer) then {_statusServer = localize "STR_PPL_Main_Online"} else {_statusServer = localize "STR_PPL_Main_Offline"};
	if (_statusDatabase) then {_statusDatabase = localize "STR_PPL_Main_Online"} else {_statusDatabase = localize "STR_PPL_Main_Offline"};
	
	_serverAndDatabaseStatusText ctrlSetText format [localize "STR_PPL_Main_Dialog_Server_Status", format ["%1 [%2]", _statusServer, _versionServer],  format ["%1 [%2]", _statusDatabase, _versionDatabase]];
	_playersAndAdminsCountText ctrlSetText format [localize "STR_PPL_Main_Dialog_Player_Status",_countPlayersTotal , _countPlayersOnline, _countAdminsTotal, _countAdminsOnline, _countTemplatesTotal];

	if (_isAdminLoggedIn) then
	{
		_adminButton ctrlSetText localize "STR_PPL_Main_Dialog_Button_Logout";
		//_templatesText ctrlShow true;
		//_templatesFilterEditBox ctrlShow true;
		//_templatesListBox ctrlShow true;
		_templateEditBox ctrlShow true;
		_templateSaveButton ctrlShow true;
		_templateLoadButton ctrlShow true;
		_templateRenameButton ctrlShow true;
		_templateDeleteButton ctrlShow true;
		_loadoutAssignButton ctrlShow true;
		_loadoutsExportButton ctrlShow true;
		_promoteButton ctrlShow true;
	}
	else
	{
		_adminButton ctrlSetText localize "STR_PPL_Main_Dialog_Button_Login";
		//_templatesText ctrlShow false;
		//_templatesFilterEditBox ctrlShow false;
		//_templatesListBox ctrlShow false;
		_templateEditBox ctrlShow false;
		_templateSaveButton ctrlShow false;
		_templateLoadButton ctrlShow false;
		_templateRenameButton ctrlShow false;
		_templateDeleteButton ctrlShow false;
		_loadoutAssignButton ctrlShow false;
		_loadoutsExportButton ctrlShow false;
		_promoteButton ctrlShow false;
	};

	PPL_lbPlayersContent = [];

	_players sort true;
	{
		_dbPlayerName = _x select 0;
		_dbPlayerUid = _x select 1;
		_dbPlayerIsAdmin = _x select 2;
		_dbPlayerIsAdminLoggedIn = _x select 3;
		_dbPlayerStatus = _x select 4;
		_dbActiveLoadout = _x select 5;
		
		if (_dbPlayerIsAdmin) then {_dbPlayerIsAdmin = localize "STR_PPL_Main_Admin";} else {_dbPlayerIsAdmin = localize "STR_PPL_Main_Player";};

		if (_dbPlayerStatus) then {_dbPlayerStatus = " " + (localize "STR_PPL_Main_Online");} else {_dbPlayerStatus = " " + (localize "STR_PPL_Main_Offline");};

		if (_dbPlayerIsAdminLoggedIn) then {_dbPlayerIsAdminLoggedIn = " " + (localize "STR_PPL_Main_Logged_In");} else {_dbPlayerIsAdminLoggedIn = "";};
		
		if (_dbActiveLoadout == "") then {_dbActiveLoadout = " " + (localize "STR_PPL_Main_No_Loadout");} else {_dbActiveLoadout = "";};;
		
		_playerText = format ["%1 (%2%3%4)%5",_dbPlayerName, _dbPlayerIsAdmin, _dbPlayerStatus, _dbPlayerIsAdminLoggedIn, _dbActiveLoadout];

		if ((((toLower _playerText) find (toLower _playersFilter)) > -1) || (_playersFilter == "")) then
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
		
	} forEach _players;
	
	ctrlSetFocus _playersListBox;
};

/* ================================================================================ */

_answer = _playerUid + "-answerTemplates";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;	
	_isAdmin = _broadcastVariableValue select 2;
	_isAdminLoggedIn = _broadcastVariableValue select 3;
	_templates = _broadcastVariableValue select 4;
	
	_templatesListBox = (findDisplay 24984) displayCtrl 1501;
	lbClear _templatesListBox;
	_templatesListBox lbSetCurSel -1;
	
	_templatesFilterEditBox = (findDisplay 24984) displayCtrl 1401;
	_templatesFilter = ctrlText _templatesFilterEditBox;

	PPL_lbTemplatesContent = [];

	_templates sort true;
	{
		_dbTemplateName = _x select 0;
		_dbTemplateId = _x select 1;
		
		_templateText = format ["%1", _dbTemplateName];

		if ((((toLower _templateText) find (toLower _templatesFilter)) > -1) || (_templatesFilter == "")) then
		{
			_index = _templatesListBox lbAdd _templateText;	
			_templatesListBox lbSetData [_index, _dbTemplateId];
		};	
		
		PPL_lbTemplatesContent = PPL_lbTemplatesContent + [[_templateText, _dbTemplateId]];
	
	} forEach _templates;
	
	ctrlSetFocus _templatesListBox;
};

/* ================================================================================ */

_answer = _playerUid + "-answerLoadouts";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];
	
	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;	
	_isAdmin = _broadcastVariableValue select 2;
	_isAdminLoggedIn = _broadcastVariableValue select 3;
	_activeLoadout = _broadcastVariableValue select 4;
	_loadouts = _broadcastVariableValue select 5;

	_loadoutsListBox = (findDisplay 24984) displayCtrl 1502;
	lbClear _loadoutsListBox;
	_loadoutsListBox lbSetCurSel -1;
	
	_loadoutsFilterEditBox = (findDisplay 24984) displayCtrl 1402;
	_loadoutsFilter = ctrlText _loadoutsFilterEditBox;
	
	PPL_lbLoadoutsContent = [];
	
	_loadouts sort false;
	{
		_dbSetupTimeStamp = _x select 0;
		_dbActualTimeStamp = _x select 1;
		_dbLoadoutId = _x select 2;
		_dbSetupLoadoutName = _x select 3;
		_dbActualLoadoutName = _x select 4;
		
		_year = _dbSetupTimeStamp select 0;
		if (_year < 10) then {_year = format ["0%1", str _year];} else {_year = str _year;};
		_month = _dbSetupTimeStamp select 1;
		if (_month < 10) then {_month = format ["0%1", str _month];} else {_month = str _month;};
		_day = _dbSetupTimeStamp select 2;
		if (_day < 10) then {_day = format ["0%1", str _day];} else {_day = str _day;};
		
		_dateStringSetup = format ["%1-%2-%3", _year, _month, _day];
		
		_year = _dbActualTimeStamp select 0;
		if (_year < 10) then {_year = format ["0%1", str _year];} else {_year = str _year;};
		_month = _dbActualTimeStamp select 1;
		if (_month < 10) then {_month = format ["0%1", str _month];} else {_month = str _month;};
		_day = _dbActualTimeStamp select 2;
		if (_day < 10) then {_day = format ["0%1", str _day];} else {_day = str _day;};
		
		_dateStringActual = format ["%1-%2-%3", _year, _month, _day];
		
		_isActiveString = "";
		if (_activeLoadout == _dbLoadoutId) then {_isActiveString = " " + (localize "STR_PPL_Main_Active");};
		
		_loadoutText = _dateStringSetup + " " + _dbSetupLoadoutName + " (" + _dateStringActual + _isActiveString + ")";
		
		if ((((toLower _loadoutText) find (toLower _loadoutsFilter)) > -1) || (_loadoutsFilter == "")) then
		{
			_index = _loadoutsListBox lbAdd _loadoutText;
			_loadoutsListBox lbSetData [_index, _dbLoadoutId];
			
			if (_isActiveString != "") then
			{
				_loadoutsListBox lbSetColor [_index, [1, 0.5, 0.5, 1]];
				_loadoutsListBox lbSetCurSel _index;
			};
		};
		
		PPL_lbLoadoutsContent = PPL_lbLoadoutsContent + [[_loadoutText, _dbLoadoutId]];
		
	} forEach _loadouts;
};

/* ================================================================================ */

[] call PPL_fnc_triggerServerDialogUpdate;

/* ================================================================================ */
