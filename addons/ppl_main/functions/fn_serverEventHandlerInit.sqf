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
			
			if (_requestedTemplateId == "") then
			{
				_dbName = "ppl-templates";
				_dbTemplates = ["new", _dbName] call OO_INIDBI;
				
				_templates = [];
				if ("exists" call _dbTemplates) then
				{
					_templates = "getSections" call _dbTemplates;

					{
						_dbName = "ppl-loadouts-" + _x + "-" + _requestedPlayerUid;
						_dbLoadouts = ["new", _dbName] call OO_INIDBI;
						
						_tmpTemplateId = _x;
						_found = false;
						
						if ("exists" call _dbLoadouts) then
						{
							_loadouts = "getSections" call _dbLoadouts;

							{
								if (_x == _requestedLoadoutId) then {_found = true;};		
							} forEach _loadouts;
						};
						
						if (_found) then {_requestedTemplateId = _tmpTemplateId;};
					} forEach _templates;
				};
			};
			
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
				["write", [_loadoutId, "actualTimeStamp", _setupTimeStamp]] call _dbLoadouts;
				["write", [_loadoutId, "actualLoadoutName", _templateName]] call _dbLoadouts;
				["write", [_loadoutId, "actualLoadout", _templateLoadout]] call _dbLoadouts;
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
	_requestedPlayerUid = _broadcastVariableValue select 2;
	_templateName = _broadcastVariableValue select 3;

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

		_templateLoadout = [];

		_allPlayerObj = allPlayers;
		{
			_tmpPlayerUid = getPlayerUID _x;
							
			if (_tmpPlayerUid == _requestedPlayerUid) then
			{
				_templateLoadout = getUnitLoadout [_x, false];
			};
		} forEach _allPlayerObj;		
		
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
			_players = "getSections" call _dbPlayers;
			
			{
				_dbName = "ppl-loadouts-" + _requestedTemplateId + "-" + _x;
				_dbLoadouts = ["new", _dbName] call OO_INIDBI;
				
				if ("exists" call _dbLoadouts) then
				{
					"delete" call _dbLoadouts;
				};
			} forEach _players;
			
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

(_playerUid + "-requestLoadoutAssign") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_requestedPlayerUid = _broadcastVariableValue select 2;
	_requestedLoadoutId = _broadcastVariableValue select 3;

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	_players = "getSections" call _dbPlayers;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	
	if ((_playerUid == _requestedPlayerUid) || (_isAdmin && _isAdminLoggedIn)) then
	{		
		_dbName = "ppl-templates";
		_dbTemplates = ["new", _dbName] call OO_INIDBI;
		
		_templates = "getSections" call _dbTemplates;
		
		_loadout = [];
		_loadoutName = "";
		{
			_dbName = "ppl-loadouts-" + _x + "-" + _requestedPlayerUid;
			_dbLoadouts = ["new", _dbName] call OO_INIDBI;
			
			if ("exists" call _dbLoadouts) then
			{
				_tmpLoadout = ["read", [_requestedLoadoutId, "actualLoadout", []]] call _dbLoadouts;
				_tmpLoadoutName = ["read", [_requestedLoadoutId, "actualLoadoutName", ""]] call _dbLoadouts;
				if (!(_tmpLoadout isEqualTo [])) then {_loadout = _tmpLoadout;};
				if (_tmpLoadoutName != "") then {_loadoutName = _tmpLoadoutName;};
			};
		} forEach _templates;
		
		if (!(_loadout isEqualTo [])) then
		{
			_allPlayerObj = allPlayers;
			{
				_tmpPlayerUid = getPlayerUID _x;
								
				if (_tmpPlayerUid == _requestedPlayerUid) then
				{
					_x setUnitLoadout [_loadout, false];
					
					["write", [_requestedPlayerUid, "activeLoadout", _requestedLoadoutId]] call _dbPlayers;
				};
			} forEach _allPlayerObj;
		};

		_result = true;
		
		_answer = _playerUid + "-answerLoadoutAssign";
		missionNamespace setVariable [_answer, _result, false];
		_clientId publicVariableClient _answer;
		
		[format ["[%1] PPL Player Request Loadout Assign: %2 - %3 (%4)", serverTime, _loadoutName, _requestedPlayerUid, _playerUid]] call PPL_fnc_log;
	};
};

/* ================================================================================ */

(_playerUid + "-requestLoadoutUpdate") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_requestedPlayerUid = _broadcastVariableValue select 2;
	_requestedLoadoutId = _broadcastVariableValue select 3;

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	_players = "getSections" call _dbPlayers;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	
	if ((_playerUid == _requestedPlayerUid) || (_isAdmin && _isAdminLoggedIn)) then
	{		
		_dbName = "ppl-templates";
		_dbTemplates = ["new", _dbName] call OO_INIDBI;
		
		_templates = "getSections" call _dbTemplates;
		
		{
			_dbName = "ppl-loadouts-" + _x + "-" + _requestedPlayerUid;
			_dbLoadouts = ["new", _dbName] call OO_INIDBI;
			
			if ("exists" call _dbLoadouts) then
			{
				_loadouts = "getSections" call _dbLoadouts;
				{
					if (_x == _requestedLoadoutId) then
					{
						_allPlayerObj = allPlayers;
						{
							_tmpPlayerUid = getPlayerUID _x;
											
							if (_tmpPlayerUid == _requestedPlayerUid) then
							{
								_activeLoadout = ["read", [_requestedPlayerUid, "activeLoadout", ""]] call _dbPlayers;
								if ((_activeLoadout != "") && (_activeLoadout == _requestedLoadoutId)) then
								{
									_newLoadout = getUnitLoadout [_x, false];
									
									_newTimeStamp = "getTimeStamp" call _dbLoadouts;

									["write", [_requestedLoadoutId, "actualLoadout", _newLoadout]] call _dbLoadouts;
									["write", [_requestedLoadoutId, "actualTimeStamp", _newTimeStamp]] call _dbLoadouts;
								};
							};
						} forEach _allPlayerObj;
					};
				}forEach _loadouts;
			};
		} forEach _templates;

		_result = true;
		
		_answer = _playerUid + "-answerLoadoutUpdate";
		missionNamespace setVariable [_answer, _result, false];
		_clientId publicVariableClient _answer;
		
		[format ["[%1] PPL Player Request Loadout Update: %2 - %3 (%4)", serverTime, _loadoutName, _requestedPlayerUid, _playerUid]] call PPL_fnc_log;
	};
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

(_playerUid + "-requestLoadouts") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];
	
	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_requestedPlayerUid = _broadcastVariableValue select 2;
	_requestedTemplateId = _broadcastVariableValue select 3;
	
	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;

	_requestedTemplates = [_requestedTemplateId];
	if (_requestedTemplateId == "") then
	{
		_dbName = "ppl-templates";
		_dbTemplates = ["new", _dbName] call OO_INIDBI;

		if ("exists" call _dbTemplates) then {_requestedTemplates = "getSections" call _dbTemplates} else {_requestedTemplates = []};
	};

	if (!(_requestedTemplates isEqualTo [])) then
	{
		if ((_playerUid == _requestedPlayerUid) || (_isAdmin && _isAdminLoggedIn)) then
		{
			_requestedLoadouts = [];	
			{
				_dbName = "ppl-loadouts-" + _x + "-" + _requestedPlayerUid;
				_dbLoadouts = ["new", _dbName] call OO_INIDBI;
				
				if ("exists" call _dbLoadouts) then
				{
					_loadouts = "getSections" call _dbLoadouts;

					{
						_loadoutId = ["read", [_x, "loadoutId", ""]] call _dbLoadouts;
						_setupTimeStamp = ["read", [_x, "setupTimeStamp", [0, 0, 0, 0, 0, 0]]] call _dbLoadouts;
						_setupLoadoutName = ["read", [_x, "setupLoadoutName", []]] call _dbLoadouts;
						_actualTimeStamp = ["read", [_x, "actualTimeStamp", [0, 0, 0, 0, 0, 0]]] call _dbLoadouts;
						_actualLoadoutName = ["read", [_x, "actualLoadoutName", []]] call _dbLoadouts;
						
						_requestedLoadouts = _requestedLoadouts + [[_setupTimeStamp, _actualTimeStamp, _loadoutId, _setupLoadoutName, _actualLoadoutName]];
							
					} forEach _loadouts;
				};
			} forEach _requestedTemplates;

			/* ---------------------------------------- */

			_result = [_playerUid, _clientId, _isAdmin, _isAdminLoggedIn, _requestedLoadouts];
			
			_answer = _playerUid + "-answerLoadouts";
			missionNamespace setVariable [_answer, _result, false];
			_clientId publicVariableClient _answer;
					
			[format ["[%1] PPL Player Request Loadouts: (%2)", serverTime, _requestedPlayerUid]] call PPL_fnc_log;
		};
	};
};

/* ================================================================================ */

(_playerUid + "-requestTemplates") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];
	
	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;

	/* ---------------------------------------- */

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;

	/* ---------------------------------------- */

	_dbName = "ppl-templates";
	_dbTemplates = ["new", _dbName] call OO_INIDBI;
	
	_requestedTemplates = [];
	if ("exists" call _dbTemplates) then
	{
		_templates = "getSections" call _dbTemplates;
		{	
			_templateId = ["read", [_x, "templateId", 0]] call _dbTemplates;
			_templateName = ["read", [_x, "templateName", ""]] call _dbTemplates;
			
			_requestedTemplates = _requestedTemplates + [[_templateName, _templateId]];
			
		} forEach _templates;
	};

	/* ---------------------------------------- */

	_result = [_playerUid, _clientId, _isAdmin, _isAdminLoggedIn, _requestedTemplates];
	
	_answer = _playerUid + "-answerTemplates";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;

	[format ["[%1] PPL Player Request Templates: (%2)", serverTime, _playerUid]] call PPL_fnc_log;
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
	
	_requestedPlayers = [];
	_playerOnly = [];
	{
		_tmpPlayerName = ["read", [_x, "playerName", ""]] call _dbPlayers;
		_tmpPlayerUid = ["read", [_x, "playerUid", ""]] call _dbPlayers;
		_tmpIsAdmin = ["read", [_x, "isAdmin", false]] call _dbPlayers;
		if (_tmpIsAdmin) then {_countAdminsTotal = _countAdminsTotal + 1};
		_tmpIsAdminLoggedIn = ["read", [_x, "isAdminLoggedIn", false]] call _dbPlayers;
		
		_tmpPlayerStatus = false;
		if ((_allActivePlayersIds find _tmpPlayerUid) > -1) then {_tmpPlayerStatus = true;};
		
		_requestedPlayers = _requestedPlayers + [[_tmpPlayerName, _tmpPlayerUid, _tmpIsAdmin, _tmpIsAdminLoggedIn, _tmpPlayerStatus]];
		if (_tmpPlayerUid == _playerUid) then
		{
			_playerOnly = [[_tmpPlayerName, _tmpPlayerUid, _tmpIsAdmin, _tmpIsAdminLoggedIn, _tmpPlayerStatus]];
		};
	} forEach _players;
	
	if (!_isAdminLoggedIn) then {_requestedPlayers = _playerOnly;};

	/* ---------------------------------------- */

	_result =
	[
		_playerUid, _clientId, _isAdmin, _isAdminLoggedIn,  
		_countPlayersTotal, _countPlayersOnline, _countAdminsTotal, _countAdminsOnline, _countTemplatesTotal, 
		_requestedPlayers
	];
	
	_answer = _playerUid + "-answerDialogUpdate";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;

	[format ["[%1] PPL Player Request Dialog Update: (%2)", serverTime, _playerUid]] call PPL_fnc_log;
};

/* ================================================================================ */