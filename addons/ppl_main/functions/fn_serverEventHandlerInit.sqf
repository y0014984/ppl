/*
 * Author: y0014984
 *
 * Adds communication event handlers serverside for every player. Main serverside logic.
 *
 * Arguments:
 * 0: _playerUid <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_playerUid] call PPL_fnc_serverEventHandlerInit;
 *
 * Public: No
 */

params ["_playerUid"];

/* ================================================================================ */

(_playerUid + "-requestSwitchAdmin") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	
	if (_isAdmin) then
	{
		_players = "getSections" call _dbPlayers;
		
		_isAnotherAdminLoggedIn = false;
		{
			scopeName "LoopAnotherAdminLoggedIn";
			_tempIsAdminLoggedIn = ["read", [_x, "isAdminLoggedIn", false]] call _dbPlayers;
			_tempPlayerUid = ["read", [_x, "playerUid", 0]] call _dbPlayers;
			if ((_tempIsAdminLoggedIn) && (_tempPlayerUid != _playerUid)) then
			{
				_isAnotherAdminLoggedIn = true;
				breakOut "LoopAnotherAdminLoggedIn";
			};
		} forEach _players;

		if (!_isAnotherAdminLoggedIn) then
		{
			if (_isAdminLoggedIn) then
			{
				["write", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
			}
			else
			{
				["write", [_playerUid, "isAdminLoggedIn", true]] call _dbPlayers;
			};
		}
		else
		{
			["STR_PPL_Main_Notifications_Login_Denied_Too_Many_Admins"] remoteExecCall ["PPL_fnc_hintLocalized", _clientId];
		};
	}
	else
	{
		["STR_PPL_Main_Notifications_Login_Denied_Missing_Permission"] remoteExecCall ["PPL_fnc_hintLocalized", _clientId];
	};
	
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	
	_result = [_isAdmin, _isAdminLoggedIn];
	
	_answer = _playerUid + "-answerSwitchAdmin";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;
	
	[format ["[%1] PPL Player Request Switch Admin Status: set %2 (%3)", serverTime, _isAdminLoggedIn, _playerUid]] call PPL_fnc_log;
};

/* ================================================================================ */

(_playerUid + "-requestDetails") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_dataType = _broadcastVariableValue select 2;
	_section = _broadcastVariableValue select 3;
	
	_dbName = "";
	
	switch (_dataType) do
	{
		case "player":{_dbName = "ppl-players";};
		case "template":{_dbName = "ppl-templates";};
		case "loadout":
		{
			_requestedLoadoutId = _section select 0;
			_requestedTemplateId = _section select 1;
			_requestedPlayerUid = _section select 2;
			
			_section = _requestedLoadoutId;
			
			_dbName = "ppl-loadouts-" + _requestedTemplateId + "-" + _requestedPlayerUid;
		};
	};
	
	_db = ["new", _dbName] call OO_INIDBI;
	_keys = ["getKeys", _section] call _db;
	
	_details = "";
	{
		_key = _x;
		_value = ["read", [_section, _key, ""]] call _db;
		
		_details = _details + _key + ": " + (str _value) + "\n";
	} forEach _keys;

	["STR_PPL_Main_Notifications_Details", _details] remoteExecCall ["PPL_fnc_hintLocalized", _clientId];
	
	[format ["[%1] PPL Player Request Details: %2 - %3 (%4)", serverTime, _dataType, _section, _playerUid]] call PPL_fnc_log;
};

/* ================================================================================ */

(_playerUid + "-requestTemplateLoad") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_requestedPlayerUid = _broadcastVariableValue select 2;
	_requestedTemplateId = _broadcastVariableValue select 3;

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	_players = "getSections" call _dbPlayers;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	
	if ((_playerUid == _requestedPlayerUid) || (_isAdmin && _isAdminLoggedIn)) then
	{		
		_dbName = "ppl-templates";
		_dbTemplates = ["new", _dbName] call OO_INIDBI;
		
		_templateLoadout = ["read", [_requestedTemplateId, "templateLoadout", []]] call _dbTemplates;
		_templateName = ["read", [_requestedTemplateId, "templateName", ""]] call _dbTemplates;
		
		_allPlayerObj = allPlayers;
		{
			_tmpPlayerUid = getPlayerUID _x;
			
			//hint format ["%1\n\n%2\n\n%3\n\n%4\n\n%5\n\n%6", _requestedTemplateId, _templateLoadout, _templateName, _playerUid, _requestedPlayerUid, _tmpPlayerUid];
			
			if ((_tmpPlayerUid == _requestedPlayerUid) && (!(_templateLoadout isEqualTo []))) then
			{
				_x setUnitLoadout [_templateLoadout, false];
				
				["write", [_requestedPlayerUid, "activeTemplate", _requestedTemplateId]] call _dbPlayers;
				
				_dbName = "ppl-loadouts-" + _requestedTemplateId + "-" + _requestedPlayerUid;
				_dbLoadouts = ["new", _dbName] call OO_INIDBI;
				
				_players = [];
				if ("exists" call _dbLoadouts) then {_loadouts = "getSections" call _dbLoadouts;};
				
				_loadoutId = [10] call PPL_fnc_generateId;	
				while {(_loadouts find _loadoutId) > -1} do {_loadoutId = [10] call PPL_fnc_generateId;};
				
				_setupTimeStamp = "getTimeStamp" call _dbLoadouts;
				
				["write", [_loadoutId, "loadoutId", _loadoutId]] call _dbLoadouts;
				["write", [_loadoutId, "templateId", _requestedTemplateId]] call _dbLoadouts;
				["write", [_loadoutId, "playerId", _requestedPlayerUid]] call _dbLoadouts;
				["write", [_loadoutId, "setupTimeStamp", _setupTimeStamp]] call _dbLoadouts;
				["write", [_loadoutId, "setupLoadoutName", _templateName]] call _dbLoadouts;
				["write", [_loadoutId, "setupLoadout", _templateLoadout]] call _dbLoadouts;
			};
		} forEach _allPlayerObj;

		_result = true;
		
		_answer = _playerUid + "-answerTemplateLoad";
		missionNamespace setVariable [_answer, _result, false];
		_clientId publicVariableClient _answer;
		
		[format ["[%1] PPL Player Request Template Load: %2 - %3 (%4)", serverTime, _templateName, _requestedPlayerUid, _playerUid]] call PPL_fnc_log;
	};
};

/* ================================================================================ */

(_playerUid + "-requestTemplateSave") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_templateName = _broadcastVariableValue select 2;
	_templateLoadout = _broadcastVariableValue select 3;

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	_players = "getSections" call _dbPlayers;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	
	if (_isAdmin && _isAdminLoggedIn) then
	{		
		_dbName = "ppl-templates";
		_dbTemplates = ["new", _dbName] call OO_INIDBI;
		
		_templates = "getSections" call _dbTemplates;
		
		_templateId = [10] call PPL_fnc_generateId;	
		while {(_templates find _templateId) > -1} do {_templateId = [10] call PPL_fnc_generateId;};
				
		["write", [_templateId, "templateId", _templateId]] call _dbTemplates;
		["write", [_templateId, "templateName", _templateName]] call _dbTemplates;
		["write", [_templateId, "templateLoadout", _templateLoadout]] call _dbTemplates;

		["STR_PPL_Main_Notifications_Template_Saved", _templateName] remoteExecCall ["PPL_fnc_hintLocalized"];
			
		_result = true;
		
		_answer = _playerUid + "-answerTemplateSave";
		missionNamespace setVariable [_answer, _result, false];
		_clientId publicVariableClient _answer;
		
		[format ["[%1] PPL Player Request Template Save: %2 (%3)", serverTime, _templateName, _playerUid]] call PPL_fnc_log;
	};
};

/* ================================================================================ */

(_playerUid + "-requestTemplateRename") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_requestedTemplateId = _broadcastVariableValue select 2;
	_requestedTemplateName = _broadcastVariableValue select 3;
	
	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	
	if (_isAdmin && _isAdminLoggedIn) then
	{		
		_dbName = "ppl-templates";
		_dbTemplates = ["new", _dbName] call OO_INIDBI;
		
		if ("exists" call _dbTemplates) then
		{
			["write", [_requestedTemplateId, "templateName", _requestedTemplateName]] call _dbTemplates;
			
			["STR_PPL_Main_Notifications_Template_Renamed", _requestedTemplateName] remoteExecCall ["PPL_fnc_hintLocalized"];
		};
			
		_result = true;
		
		_answer = _playerUid + "-answerTemplateRename";
		missionNamespace setVariable [_answer, _result, false];
		_clientId publicVariableClient _answer;
		
		[format ["[%1] PPL Player Request Template Rename: %2 (%3)", serverTime, _requestedTemplateName, _playerUid]] call PPL_fnc_log;
	};
};

/* ================================================================================ */

(_playerUid + "-requestTemplateDelete") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_requestedTemplateId = _broadcastVariableValue select 2;

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
		
	_dbName = "ppl-templates";
	_dbTemplates = ["new", _dbName] call OO_INIDBI;
	
	_templateName = "";
	
	if ("exists" call _dbTemplates) then
	{
		if (_isAdmin && _isAdminLoggedIn) then
		{
			_templateName = ["read", [_requestedTemplateId, "templateName", ""]] call _dbTemplates;
			
			["deleteSection", _requestedTemplateId] call _dbTemplates;
			
			["STR_PPL_Main_Notifications_Template_Deleted", _templateName] remoteExecCall ["PPL_fnc_hintLocalized"];
		};
	};
		
	_result = true;
	
	_answer = _playerUid + "-answerTemplateDelete";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;
	
	[format ["[%1] PPL Player Request Template Delete : %2 (%3)", serverTime, _templateName, _playerUid]] call PPL_fnc_log;
};

/* ================================================================================ */

(_playerUid + "-requestPromotePlayer") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_requestedPlayerUid = _broadcastVariableValue select 2;

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	
	if (_isAdmin && _isAdminLoggedIn) then
	{
		_isAdmin = ["read", [_requestedPlayerUid, "isAdmin", false]] call _dbPlayers;
		if (!_isAdmin) then
		{
			["write", [_requestedPlayerUid, "isAdmin", true]] call _dbPlayers;
			_playerName = ["read", [_requestedPlayerUid, "playerName", false]] call _dbPlayers;
			["STR_PPL_Main_Notifications_Player_Promoted", _playerName] remoteExecCall ["PPL_fnc_hintLocalized"];
		};
	};

	_result = true;
	
	_answer = _playerUid + "-answerPromotePlayer";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;
	
	[format ["[%1] PPL Player Request Promote Player: %2 (%3)", serverTime, _requestedPlayerUid, _playerUid]] call PPL_fnc_log;
};

/* ================================================================================ */

(_playerUid + "-requestDegradePlayer") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_requestedPlayerUid = _broadcastVariableValue select 2;

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	
	if (_isAdmin && _isAdminLoggedIn) then
	{
		_isAdmin = ["read", [_requestedPlayerUid, "isAdmin", false]] call _dbPlayers;
		if (_isAdmin) then
		{
			["write", [_requestedPlayerUid, "isAdmin", false]] call _dbPlayers;
			_playerName = ["read", [_requestedPlayerUid, "playerName", false]] call _dbPlayers;
			["STR_PPL_Main_Notifications_Player_Degraded", _playerName] remoteExecCall ["PPL_fnc_hintLocalized"];
		};
	};

	_result = true;
	
	_answer = _playerUid + "-answerDegradePlayer";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;
	
	[format ["[%1] PPL Player Request Degrade Player: %2 (%3)", serverTime, _requestedPlayerUid, _playerUid]] call PPL_fnc_log;
};
/* ================================================================================ */

(_playerUid + "-requestExportLoadouts") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];
	
	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;

	_tab = "	";
	_crlf = "
";
	_result = "Player" + _tab + "Event" + _tab + "Loadouts Key" + _tab + "Loadouts Value" + _crlf;;
	
	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;

	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	
	_players = [_playerUid];
	if (_isAdmin && _isAdminLoggedIn) then {_players = "getSections" call _dbPlayers;};
	{
		_currentPlayer = _x;
		
		_playerName = ["read", [_currentPlayer, "playerName", 0]] call _dbPlayers;
		
		_dbName = "ppl-events";
		_dbEvents = ["new", _dbName] call OO_INIDBI;
		
		if ("exists" call _dbEvents) then
		{
			_events = "getSections" call _dbEvents;
			{
				_currentEvent = _x;
				
				_eventPlayerUids = ["read", [_x, "eventPlayerUids", 0]] call _dbEvents;
				
				_eventId = ["read", [_currentEvent, "eventId", 0]] call _dbEvents;
				_eventName = ["read", [_currentEvent, "eventName", ""]] call _dbEvents;
				_eventDuration = ["read", [_currentEvent, "eventDuration", 0]] call _dbEvents;
				_eventStartTime = ["read", [_currentEvent, "eventStartTime", [0, 0, 0, 0, 0, 0]]] call _dbEvents;
				
				if ((_eventPlayerUids find _currentPlayer) > -1) then
				{
					_dbName = "ppl-loadouts-" + _currentPlayer + "-" + _eventId;
					_dbLoadouts = ["new", _dbName] call OO_INIDBI;
					
					if ("exists" call _dbLoadouts) then
					{
						_loadouts = "getSections" call _dbLoadouts;
						{
							_currentLoadouts = _x;
							
							_key = ["read", [_currentLoadouts, "key", ""]] call _dbLoadouts;
							_value = ["read", [_currentLoadouts, "value", ""]] call _dbLoadouts;
							
							_result = _result + _playerName + _tab + _eventName + _tab + _key + _tab + (str _value) + _crlf;
								
						} forEach _loadouts;
					};
				};
			} forEach _events;
		};
	} forEach _players;

	/* ---------------------------------------- */

	_answer = _playerUid + "-answerExportLoadouts";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;
			
	[format ["[%1] PPL Player Request Export Loadouts: (%2)", serverTime, _playerUid]] call PPL_fnc_log;
};

/* ================================================================================ */

(_playerUid + "-requestLoadoutsFiltered") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];
	
	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_requestedPlayerUid = _broadcastVariableValue select 2;
	_requestedTemplateId = _broadcastVariableValue select 3;
	_filterLoadouts = _broadcastVariableValue select 4;
	
	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	
	if ((_playerUid == _requestedPlayerUid) || (_isAdmin && _isAdminLoggedIn)) then
	{
		_dbName = "ppl-loadouts-" + _requestedTemplateId + "-" + _requestedPlayerUid;
		_dbLoadouts = ["new", _dbName] call OO_INIDBI;

		_filteredLoadouts = [];	
		if ("exists" call _dbLoadouts) then
		{
			_loadouts = "getSections" call _dbLoadouts;

			{
				_loadoutId = ["read", [_x, "loadoutId", ""]] call _dbLoadouts;
				//_requestedTemplateId = ["read", [_x, "templateId", ""]] call _dbLoadouts;
				//_requestedPlayerUid = ["read", [_x, "playerId", ""]] call _dbLoadouts;
				_setupTimeStamp = ["read", [_x, "setupTimeStamp", [0, 0, 0, 0, 0, 0]]] call _dbLoadouts;
				_setupLoadoutName = ["read", [_x, "setupLoadoutName", []]] call _dbLoadouts;
				_setupLoadout = ["read", [_x, "setupLoadout", []]] call _dbLoadouts;
				
				_filteredLoadouts = _filteredLoadouts + [[_setupTimeStamp, _loadoutId, _setupLoadoutName]];
					
			} forEach _loadouts;
		};

		/* ---------------------------------------- */

		_result = [_playerUid, _clientId, _isAdmin, _isAdminLoggedIn, _filteredLoadouts];
		
		_answer = _playerUid + "-answerLoadoutsFiltered";
		missionNamespace setVariable [_answer, _result, false];
		_clientId publicVariableClient _answer;
				
		[format ["[%1] PPL Player Request Loadouts Filtered: (%2)", serverTime, _requestedPlayerUid]] call PPL_fnc_log;
	};
};

/* ================================================================================ */

(_playerUid + "-requestTemplatesFiltered") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];
	
	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_filterTemplates = _broadcastVariableValue select 2;

	/* ---------------------------------------- */

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;

	/* ---------------------------------------- */

	_dbName = "ppl-templates";
	_dbTemplates = ["new", _dbName] call OO_INIDBI;
	
	_filteredTemplates = [];
	if ("exists" call _dbTemplates) then
	{
		_templates = "getSections" call _dbTemplates;
		{	
			_templateId = ["read", [_x, "templateId", 0]] call _dbTemplates;
			_templateName = ["read", [_x, "templateName", ""]] call _dbTemplates;
			
			_filteredTemplates = _filteredTemplates + [[_templateId, _templateName]];
			
		} forEach _templates;
	};

	/* ---------------------------------------- */

	_result = [_playerUid, _clientId, _isAdmin, _isAdminLoggedIn, _filteredTemplates];
	
	_answer = _playerUid + "-answerTemplatesFiltered";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;

	[format ["[%1] PPL Player Request Templates Filtered: (%2)", serverTime, _playerUid]] call PPL_fnc_log;
};

/* ================================================================================ */

(_playerUid + "-requestSetServerAdminToPplAdmin") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];
	
	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;

	/* ---------------------------------------- */

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	
	_serverAdminStatus = admin _clientId;

	/* ---------------------------------------- */

	if (!_isAdmin && (_serverAdminStatus == 2)) then
	{
		["write", [_playerUid, "isAdmin", true]] call _dbPlayers;
	};

	/* ---------------------------------------- */

	_result = true;
	
	_answer = _playerUid + "-answerSetServerAdminToPplAdmin";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;

	[format ["[%1] PPL Player Request Server Admin to PPL Admin: (%2)", serverTime, _playerUid]] call PPL_fnc_log;
};

/* ================================================================================ */

(_playerUid + "-requestDialogUpdate") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];
	
	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_filterPlayers = _broadcastVariableValue select 2;

	/* ---------------------------------------- */

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;

	/* ---------------------------------------- */

	_countPlayersTotal = 0;
	_countPlayersOnline = 0;
	_countAdminsTotal = 0;
	_countAdminsOnline = 0;
	_countEventsTotal = 0;
	
	_allActivePlayers = allPlayers - entities "HeadlessClient_F";
	_countPlayersOnline = count _allActivePlayers;
	
	_allActivePlayersIds = [];
	{
		_tmpPlayerUid = getPlayerUID _x;
		_tmpIsAdmin = ["read", [_tmpPlayerUid, "isAdmin", false]] call _dbPlayers;
		if (_tmpIsAdmin) then {_countAdminsOnline = _countAdminsOnline + 1};
		_allActivePlayersIds = _allActivePlayersIds + [_tmpPlayerUid];
	} forEach _allActivePlayers;
	
	/* ---------------------------------------- */

	_dbName = "ppl-templates";
	_dbTemplates = ["new", _dbName] call OO_INIDBI;
	_templates = "getSections" call _dbTemplates;
	_countTemplatesTotal = count _templates;

	/* ---------------------------------------- */

	_players = [];
	
	_players = "getSections" call _dbPlayers;
	_countPlayersTotal = count _players;
	
	_filteredPlayers = [];
	_playerOnly = [];
	{
		_tmpPlayerName = ["read", [_x, "playerName", ""]] call _dbPlayers;
		_tmpPlayerUid = ["read", [_x, "playerUid", ""]] call _dbPlayers;
		_tmpIsAdmin = ["read", [_x, "isAdmin", false]] call _dbPlayers;
		if (_tmpIsAdmin) then {_countAdminsTotal = _countAdminsTotal + 1};
		_tmpIsAdminLoggedIn = ["read", [_x, "isAdminLoggedIn", false]] call _dbPlayers;
		
		_tmpPlayerStatus = false;
		if ((_allActivePlayersIds find _tmpPlayerUid) > -1) then {_tmpPlayerStatus = true;};
		
		_filteredPlayers = _filteredPlayers + [[_tmpPlayerName, _tmpPlayerUid, _tmpIsAdmin, _tmpIsAdminLoggedIn, _tmpPlayerStatus]];
		if (_tmpPlayerUid == _playerUid) then
		{
			_playerOnly = [[_tmpPlayerName, _tmpPlayerUid, _tmpIsAdmin, _tmpIsAdminLoggedIn, _tmpPlayerStatus]];
		};
	} forEach _players;
	
	if (!_isAdminLoggedIn) then {_filteredPlayers = _playerOnly;};

	/* ---------------------------------------- */

	_result =
	[
		_playerUid, _clientId, _isAdmin, _isAdminLoggedIn,  
		_countPlayersTotal, _countPlayersOnline, _countAdminsTotal, _countAdminsOnline, _countTemplatesTotal, 
		_filteredPlayers
	];
	
	_answer = _playerUid + "-answerDialogUpdate";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;

	[format ["[%1] PPL Player Request Dialog Update: (%2)", serverTime, _playerUid]] call PPL_fnc_log;
};

/* ================================================================================ */