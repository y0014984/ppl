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
		case "loadout":{_dbName = "ppl-loadouts";};
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

(_playerUid + "-requestSwitchTrackLoadouts") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_key = _broadcastVariableValue select 2;
	
	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isTrackLoadoutsActive = ["read", [_playerUid, "isTrackLoadoutsActive", false]] call _dbPlayers;
	_trackLoadoutsKey = ["read", [_playerUid, "trackLoadoutsKey", ""]] call _dbPlayers;

	if (_isTrackLoadoutsActive) then
	{
		if (_key != _trackLoadoutsKey) then
		{
			["write", [_playerUid, "trackLoadoutsKey", _key]] call _dbPlayers;
			
			_value = ["read", [_key, "value", "not set"]] call _dbLoadouts;
			if ((str _value) != (str "not set")) then
			{
				["STR_PPL_Main_Notifications_Tracking", _key, _value] remoteExecCall ["PPL_fnc_hintLocalized", _clientId];
			};
		}
		else
		{
			["write", [_playerUid, "isTrackLoadoutsActive", false]] call _dbPlayers;
			["write", [_playerUid, "trackLoadoutsKey", ""]] call _dbPlayers;
			["write", [_playerUid, "trackLoadoutsClientId", ""]] call _dbPlayers;
		};
	}
	else
	{
		["write", [_playerUid, "isTrackLoadoutsActive", true]] call _dbPlayers;
		["write", [_playerUid, "trackLoadoutsKey", _key]] call _dbPlayers;
		["write", [_playerUid, "trackLoadoutsClientId", _clientId]] call _dbPlayers;

		_value = ["read", [_key, "value", "not set"]] call _dbLoadouts;
		if ((str _value) != (str "not set")) then
		{
			["STR_PPL_Main_Notifications_Tracking", _key, _value] remoteExecCall ["PPL_fnc_hintLocalized", _clientId];
		};
	};

	_isTrackLoadoutsActive = ["read", [_playerUid, "isTrackLoadoutsActive", false]] call _dbPlayers;
	_trackLoadoutsKey = ["read", [_playerUid, "trackLoadoutsKey", ""]] call _dbPlayers;
	_trackLoadoutsClientId = ["read", [_playerUid, "trackLoadoutsClientId", ""]] call _dbPlayers;
	
	missionNamespace setVariable ["PPL_isTrackLoadoutsActive", _isTrackLoadoutsActive, false];
	_clientId publicVariableClient "PPL_isTrackLoadoutsActive";
	missionNamespace setVariable ["PPL_trackLoadoutsKey", _trackLoadoutsKey, false];
	_clientId publicVariableClient "PPL_trackLoadoutsKey";

	_result = [_isTrackLoadoutsActive, _trackLoadoutsKey, _trackLoadoutsClientId];
	
	_answer = _playerUid + "-answerSwitchTrackLoadouts";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;
	
	[format ["[%1] PPL Player Request Switch Track Loadouts: Active: %2 Value: %3 (%4)", serverTime, _isTrackLoadoutsActive, _trackLoadoutsKey, _playerUid]] call PPL_fnc_log;
};

/* ================================================================================ */

(_playerUid + "-requestStopEvent") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	_players = "getSections" call _dbPlayers;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	
	if (_isAdmin && _isAdminLoggedIn) then
	{		
		_dbName = "ppl-events";
		_dbEvents = ["new", _dbName] call OO_INIDBI;
		
		if (PPL_isEvent) then
		{
			_eventStopTime = "getTimeStamp" call _dbEvents;

			PPL_eventStopTime = +_eventStopTime;
			publicVariable "PPL_eventStopTime";
			PPL_isEvent = false;
			publicVariable "PPL_isEvent";
			
			["write", [PPL_eventId, "eventStopTime", PPL_eventStopTime]] call _dbEvents;
			
			if ((PPL_eventStopTime select 0) == (PPL_eventStartTime select 0)) then
			{
				_tmpEventStartTime = +PPL_eventStartTime;
				_tmpEventStartTime set [5, "delete"];
				_tmpEventStartTime = _tmpEventStartTime - ["delete"];
				_tmpEventStopTime = +PPL_eventStopTime;
				_tmpEventStopTime set [5, "delete"];
				_tmpEventStopTime = _tmpEventStopTime - ["delete"];
				_eventDuration = (dateToNumber _tmpEventStopTime) - (dateToNumber _tmpEventStartTime);
				_eventDuration = numberToDate [_tmpEventStopTime select 0, _eventDuration];
				if (((_eventDuration select 1) == 1) && ((_eventDuration select 2) == 1)) then
				{
					_eventDurationOld = ["read", [PPL_eventId, "eventDuration", 0]] call _dbEvents;
					_eventDuration = _eventDurationOld + (((_eventDuration select 3) * 60) + (_eventDuration select 4));
					["write", [PPL_eventId, "eventDuration", _eventDuration]] call _dbEvents;
				};
			};
			
			["STR_PPL_Main_Notifications_Event_Stopped", PPL_eventName] remoteExecCall ["PPL_fnc_hintLocalized"];
		};
			
		_result = true;
		
		_answer = _playerUid + "-answerStopEvent";
		missionNamespace setVariable [_answer, _result, false];
		_clientId publicVariableClient _answer;
		
		[format ["[%1] PPL Player Request Stop Event: %2 (%3)", serverTime, PPL_eventName, _playerUid]] call PPL_fnc_log;
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

(_playerUid + "-requestDeletePlayer") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_requestedPlayerUid = _broadcastVariableValue select 2;

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	_playerName = ["read", [_requestedPlayerUid, "playerName", false]] call _dbPlayers;
	
	if ((_playerUid == _requestedPlayerUid) || (_isAdmin && _isAdminLoggedIn)) then
	{
		_dbName = "ppl-events";
		_dbEvents = ["new", _dbName] call OO_INIDBI;
		
		if ("exists" call _dbEvents) then
		{
			_events = "getSections" call _dbEvents;	
			{
				_dbName = "ppl-loadouts-" + _requestedPlayerUid + "-" + _x;
				_dbLoadouts = ["new", _dbName] call OO_INIDBI;	

				if ("exists" call _dbLoadouts) then {"delete" call _dbLoadouts;};
				
				_eventPlayerUids = ["read", [_x, "eventPlayerUids", ""]] call _dbEvents;
				_eventPlayerUidsWithoutPlayer = [];
				{
					if (_x != _requestedPlayerUid) then {_eventPlayerUidsWithoutPlayer = _eventPlayerUidsWithoutPlayer + [_x]};
				} forEach _eventPlayerUids;
				["write", [_x, "eventPlayerUids", _eventPlayerUidsWithoutPlayer]] call _dbEvents;
			} forEach _events;
		};
		
		["deleteSection", _requestedPlayerUid] call _dbPlayers;
		
		["STR_PPL_Main_Notifications_Player_Deleted", _playerName] remoteExecCall ["PPL_fnc_hintLocalized"];
	};

	_result = true;
	
	_answer = _playerUid + "-answerDeletePlayer";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;
	
	[format ["[%1] PPL Player Request Delete Player: %2 (%3)", serverTime, _requestedPlayerUid, _playerUid]] call PPL_fnc_log;
};

/* ================================================================================ */

(_playerUid + "-requestDeleteEvent") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_eventId = _broadcastVariableValue select 2;

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
		
	_dbName = "ppl-events";
	_dbEvents = ["new", _dbName] call OO_INIDBI;
	
	if ("exists" call _dbEvents) then
	{
		_eventName = ["read", [_eventId, "eventName", ""]] call _dbEvents;
		_eventPlayerUids = ["read", [_eventId, "eventPlayerUids", ""]] call _dbEvents;
		
		if (_isAdmin && _isAdminLoggedIn) then
		{
			{
				_dbName = "ppl-loadouts-" + _x + "-" + _eventId;
				_dbLoadouts = ["new", _dbName] call OO_INIDBI;
				
				if ("exists" call _dbLoadouts) then {"delete" call _dbLoadouts;};
			} forEach _eventPlayerUids;
			
			["deleteSection", _eventId] call _dbEvents;
		} 
		else 
		{
			/*this code can't be reached because the delete button is invisible for non admin players*/
			_dbName = "ppl-loadouts-" + _playerUid + "-" + _eventId;
			_dbLoadouts = ["new", _dbName] call OO_INIDBI;
			
			if ("exists" call _dbLoadouts) then {"delete" call _dbLoadouts;};
			
			_eventPlayerUidsWithoutPlayer = [];
			{
				if (_x != _playerUid) then {_eventPlayerUidsWithoutPlayer = _eventPlayerUidsWithoutPlayer + [_x]};
			} forEach _eventPlayerUids;
			["write", [_eventId, "eventPlayerUids", _eventPlayerUidsWithoutPlayer]] call _dbEvents;
		};
		
		["STR_PPL_Main_Notifications_Event_Deleted", _eventName] remoteExecCall ["PPL_fnc_hintLocalized"];
	};
		
	_result = true;
	
	_answer = _playerUid + "-answerDeleteEvent";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;
	
	[format ["[%1] PPL Player Request Delete Event: %2 (%3)", serverTime, PPL_eventName, _playerUid]] call PPL_fnc_log;
};

/* ================================================================================ */

(_playerUid + "-requestContinueEvent") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_eventId = _broadcastVariableValue select 2;

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	
	if (_isAdmin && _isAdminLoggedIn && !PPL_isEvent) then
	{		
		_dbName = "ppl-events";
		_dbEvents = ["new", _dbName] call OO_INIDBI;
		
		if ("exists" call _dbEvents) then
		{
			_eventName = ["read", [_eventId, "eventName", ""]] call _dbEvents;
			
			_eventStartTime = "getTimeStamp" call _dbEvents;
			_eventStopTime = [0, 0, 0, 0, 0, 0];
			["write", [_eventId, "eventStartTime", _eventStartTime]] call _dbEvents;
			["write", [_eventId, "eventStopTime", _eventStopTime]] call _dbEvents;
			
			PPL_isEvent = true;
			publicVariable "PPL_isEvent";
			PPL_eventName = _eventName;
			publicVariable "PPL_eventName";
			PPL_eventId = _eventId;
			publicVariable "PPL_eventId";
			PPL_eventStartTime = +_eventStartTime;
			publicVariable "PPL_eventStartTime";
			PPL_eventStopTime = +_eventStopTime;
			publicVariable "PPL_eventStopTime";
			
			["STR_PPL_Main_Notifications_Event_Continued", _eventName] remoteExecCall ["PPL_fnc_hintLocalized"];
		};
			
		_result = true;
		
		_answer = _playerUid + "-answerContinueEvent";
		missionNamespace setVariable [_answer, _result, false];
		_clientId publicVariableClient _answer;
		
		[format ["[%1] PPL Player Request Continue Event: %2 (%3)", serverTime, PPL_eventName, _playerUid]] call PPL_fnc_log;
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

(_playerUid + "-requestLoadoutsFiltered") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];
	
	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_requestedPlayerUid = _broadcastVariableValue select 2;
	_requestedEventId = _broadcastVariableValue select 3;
	_filterLoadouts = _broadcastVariableValue select 4;
	
	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
	_isTrackLoadoutsActive = ["read", [_playerUid, "isTrackLoadoutsActive", false]] call _dbPlayers;
	_trackLoadoutsKey = ["read", [_playerUid, "trackLoadoutsKey", ""]] call _dbPlayers;
	
	missionNamespace setVariable ["PPL_isTrackLoadoutsActive", _isTrackLoadoutsActive, false];
	_clientId publicVariableClient "PPL_isTrackLoadoutsActive";
	missionNamespace setVariable ["PPL_trackLoadoutsKey", _trackLoadoutsKey, false];
	_clientId publicVariableClient "PPL_trackLoadoutsKey";
		
	if ((_playerUid == _requestedPlayerUid) || _isAdmin) then
	{
		if (_playerUid != _requestedPlayerUid) then {_isTrackLoadoutsActive = false; _trackLoadoutsKey = "";};
		
		_dbName = "ppl-loadouts-" + _requestedPlayerUid + "-" + _requestedEventId;
		_dbLoadouts = ["new", _dbName] call OO_INIDBI;

		_tmpResult = [];
		if ("exists" call _dbLoadouts) then
		{
			_loadouts = "getSections" call _dbLoadouts;
			
			_timeInEvent = ["read", ["timeInEvent", "value", 0]] call _dbLoadouts;
			_countProjectilesFired = ["read", ["countProjectilesFired", "value", 0]] call _dbLoadouts;
			_countGrenadesThrown = ["read", ["countGrenadesThrown", "value", 0]] call _dbLoadouts;
			
			{
				_value = ["read", [_x, "value", ""]] call _dbLoadouts;
				_type = ["read", [_x, "type", ""]] call _dbLoadouts;
				_formatType = ["read", [_x, "formatType", -1]] call _dbLoadouts;
				_formatString = ["read", [_x, "formatString", ""]] call _dbLoadouts;
				_source = ["read", [_x, "source", ""]] call _dbLoadouts;
				
					switch (_formatType) do
					{
						case 0:
						{
							_tmpResult = _tmpResult + [[_x, _formatString, _source, _value, "", ""]];
						};
						case 1:
						{
							_roundValue = parseNumber ((_value / 3600) toFixed 2);
							_roundValuePercent = parseNumber ((100 / _timeInEvent * _value) toFixed 2);
							_tmpResult = _tmpResult + [[_x, _formatString, _source, "%", str _roundValue, str _roundValuePercent]];
						};
						case 2:
						{
							_roundValuePercent = 100;
							if (_countProjectilesFired > 0) then 
							{
								_roundValuePercent = parseNumber ((100 / _countProjectilesFired * _value) toFixed 2);
							};
							_tmpResult = _tmpResult + [[_x, _formatString, _source, "%", _value, _roundValuePercent]];

						};
						case 3:
						{
							_roundValue = parseNumber ((_value / 3600) toFixed 2);
							_tmpResult = _tmpResult + [[_x, _formatString, _source, str _roundValue, "", ""]];
						};
						case 4:
						{
							_roundValuePercent = 100;
							if (_countGrenadesThrown > 0) then 
							{
								_roundValuePercent = parseNumber ((100 / _countGrenadesThrown * _value) toFixed 2);
							};
							_tmpResult = _tmpResult + [[_x, _formatString, _source, "%", _value, _roundValuePercent]];

						};
						case -1:
						{
							_tmpResult = _tmpResult + [[_x, localize "STR_PPL_Main_Dialog_List_Value_Not_Recorded", _source, _value, "", ""]];
						};
					};
					
			} forEach _loadouts;
		};
		
		_resultLoadouts = [];	
		if(_filterLoadouts != "") then
		{
			{
				if (((toLower (_x select 0)) find (toLower _filterLoadouts)) > -1) then
				{
					_resultLoadouts = _resultLoadouts + [_x];
				};
			} forEach _tmpResult;
		}
		else
		{
			_resultLoadouts = _tmpResult;
		};

		/* ---------------------------------------- */

		_answer = _playerUid + "-answerLoadoutsFiltered";
		missionNamespace setVariable [_answer, [_resultLoadouts, _isTrackLoadoutsActive, _trackLoadoutsKey], false];
		_clientId publicVariableClient _answer;
				
		[format ["[%1] PPL Player Request Loadouts Filtered: (%2)", serverTime, _requestedPlayerUid]] call PPL_fnc_log;
	};
};

/* ================================================================================ */

(_playerUid + "-requestEventsFiltered") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];
	
	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;
	_requestedPlayerUid = _broadcastVariableValue select 2;
	_filterEvents = _broadcastVariableValue select 3;

	/* ---------------------------------------- */

	_dbName = "ppl-players";
	_dbPlayers = ["new", _dbName] call OO_INIDBI;
	
	_isAdmin = ["read", [_playerUid, "isAdmin", false]] call _dbPlayers;
	_isAdminLoggedIn = ["read", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;

	/* ---------------------------------------- */

	if (_requestedPlayerUid != _playerUid && !_isAdmin) exitWith {};
	
	_dbName = "ppl-events";
	_dbEvents = ["new", _dbName] call OO_INIDBI;
	
	_filteredEvents = [];
	if ("exists" call _dbEvents) then
	{
		_events = "getSections" call _dbEvents;
		{	
			_eventPlayerUids = ["read", [_x, "eventPlayerUids", 0]] call _dbEvents;
			
			_eventId = ["read", [_x, "eventId", 0]] call _dbEvents;
			_eventName = ["read", [_x, "eventName", ""]] call _dbEvents;
			_eventDuration = ["read", [_x, "eventDuration", 0]] call _dbEvents;
			_eventStartTime = ["read", [_x, "eventStartTime", [0, 0, 0, 0, 0, 0]]] call _dbEvents;
			
			if (((_eventPlayerUids find _requestedPlayerUid) > -1) && ((((toLower _eventName) find (toLower _filterEvents)) > -1) || (_filterEvents == ""))) then
			{
				_filteredEvents = _filteredEvents + [[_eventId, _eventName, _eventStartTime, _eventDuration]];
			};
		} forEach _events;
	};

	/* ---------------------------------------- */

	_result = [_playerUid, _clientId, _isAdmin, _isAdminLoggedIn, _filteredEvents];
	
	_answer = _playerUid + "-answerEventsFiltered";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;

	[format ["[%1] PPL Player Request Events Filtered: (%2)", serverTime, _playerUid]] call PPL_fnc_log;
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

	_dbName = "ppl-events";
	_dbEvents = ["new", _dbName] call OO_INIDBI;
	_events = "getSections" call _dbEvents;
	_countEventsTotal = count _events;

	/* ---------------------------------------- */

	_players = [];
	
	_players = "getSections" call _dbPlayers;
	_countPlayersTotal = count _players;
	
	_tmpResult = [];
	_playerOnly = [];
	{
		_tmpPlayerName = ["read", [_x, "playerName", ""]] call _dbPlayers;
		_tmpPlayerUid = ["read", [_x, "playerUid", ""]] call _dbPlayers;
		_tmpIsAdmin = ["read", [_x, "isAdmin", false]] call _dbPlayers;
		if (_tmpIsAdmin) then {_countAdminsTotal = _countAdminsTotal + 1};
		_tmpIsAdminLoggedIn = ["read", [_x, "isAdminLoggedIn", false]] call _dbPlayers;
		
		_tmpPlayerIsTrackLoadoutsActive = ["read", [_x, "isTrackLoadoutsActive", false]] call _dbPlayers;
		_tmpPlayerTrackLoadoutsKey = ["read", [_x, "trackLoadoutsKey", ""]] call _dbPlayers;

		_tmpPlayerStatus = false;
		if ((_allActivePlayersIds find _tmpPlayerUid) > -1) then {_tmpPlayerStatus = true;};
		
		_tmpResult = _tmpResult + [[_tmpPlayerName, _tmpPlayerUid, _tmpIsAdmin, _tmpIsAdminLoggedIn, _tmpPlayerIsTrackLoadoutsActive, _tmpPlayerTrackLoadoutsKey, _tmpPlayerStatus]];
		if (_tmpPlayerUid == _playerUid) then
		{
			_playerOnly = [[_tmpPlayerName, _tmpPlayerUid, _tmpIsAdmin, _tmpIsAdminLoggedIn, _tmpPlayerIsTrackLoadoutsActive, _tmpPlayerTrackLoadoutsKey, _tmpPlayerStatus]];
		};
	} forEach _players;
	
	if (!_isAdminLoggedIn) then {_tmpResult = _playerOnly;};
	
	_filteredPlayers = [];
	if(_filterPlayers != "") then
	{
		{
			if (((toLower (_x select 0)) find (toLower _filterPlayers)) > -1) then
			{
				_filteredPlayers = _filteredPlayers + [_x];
			};
		} forEach _tmpResult;
	}
	else
	{
		_filteredPlayers = _tmpResult;
	};

	/* ---------------------------------------- */

	_result =
	[
		_playerUid, _clientId, _isAdmin, _isAdminLoggedIn,  
		_countPlayersTotal, _countPlayersOnline, _countAdminsTotal, _countAdminsOnline, _countEventsTotal, 
		_filteredPlayers
	];
	
	_answer = _playerUid + "-answerDialogUpdate";
	missionNamespace setVariable [_answer, _result, false];
	_clientId publicVariableClient _answer;

	[format ["[%1] PPL Player Request Dialog Update: (%2)", serverTime, _playerUid]] call PPL_fnc_log;
};

/* ================================================================================ */

(_playerUid + "-updateLoadouts") addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];
	
	if (PPL_isEvent) then
	{
		_playerUid = _broadcastVariableValue select 0;
		_intervalLoadouts = _broadcastVariableValue select 1;
		
		_dbName = "ppl-loadouts-" + _playerUid + "-" + PPL_eventId;
		_dbLoadouts = ["new", _dbName] call OO_INIDBI;
		
		{
			_key = _x select 0;
			_value = _x select 1;
			_type = _x select 2;
			_formatType = _x select 3;
			_formatString = _x select 4;
			_source = _x select 5;
			
			if (_value > 0) then
			{
				_valueOld = ["read", [_key, "value", -1]] call _dbLoadouts;
				if (_valueOld == -1) then
				{
					_valueOld = 0;
					_value = _valueOld + _value;
					["write", [_key, "key", _key]] call _dbLoadouts;
					["write", [_key, "key", _key]] call _dbLoadouts;
					["write", [_key, "value", _value]] call _dbLoadouts;
					["write", [_key, "type", _type]] call _dbLoadouts;
					["write", [_key, "formatType", _formatType]] call _dbLoadouts;
					["write", [_key, "formatString", _formatString]] call _dbLoadouts;
					["write", [_key, "source", _source]] call _dbLoadouts;
				}
				else
				{
					_value = _valueOld + _value;
					["write", [_key, "value", _value]] call _dbLoadouts;
				};
			};
		} forEach _intervalLoadouts;
		
		_dbName = "ppl-players";
		_dbPlayers = ["new", _dbName] call OO_INIDBI;
		
		_isTrackLoadoutsActive = ["read", [_playerUid, "isTrackLoadoutsActive", false]] call _dbPlayers;
		_trackLoadoutsKey = ["read", [_playerUid, "trackLoadoutsKey", ""]] call _dbPlayers;
		_trackLoadoutsClientId = ["read", [_playerUid, "trackLoadoutsClientId", ""]] call _dbPlayers;
		
		if (_isTrackLoadoutsActive) then
		{
			_trackLoadoutsValue = ["read", [_trackLoadoutsKey, "value", "not set"]] call _dbLoadouts;

			if ((str _trackLoadoutsValue) != (str "not set")) then
			{
				["STR_PPL_Main_Notifications_Tracking", _trackLoadoutsKey, _trackLoadoutsValue] remoteExecCall ["PPL_fnc_hintLocalized", _trackLoadoutsClientId];
			};
		};
	
		[format ["[%1] PPL Player Updated Loadouts: (%2)", serverTime, _playerUid]] call PPL_fnc_log;
	};
};

/* ================================================================================ */