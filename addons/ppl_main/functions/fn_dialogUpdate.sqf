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
		_requestedPlayerUid = _control lbData _selectedIndex;
		_text = _control lbText _selectedIndex;
		
		_promoteButton = (findDisplay 24984) displayCtrl 1610;
		
		_playerUid = getPlayerUID player;
		_clientId = clientOwner;
		
		_filterEventsEditBox = (findDisplay 24984) displayCtrl 1401;
		
		_filterEvents = "";
	
		if ((_text find (localize "STR_PPL_Main_Admin")) > -1) then
		{
			_promoteButton ctrlSetText localize "STR_PPL_Main_Dialog_Button_Degrade";
		}
		else
		{
			_promoteButton ctrlSetText localize "STR_PPL_Main_Dialog_Button_Promote";
		};
		
		_request = _playerUid + "-requestEventsFiltered";
		missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedPlayerUid, _filterEvents], false];
		publicVariableServer _request;
	};
}];

/* ================================================================================ */

_eventsListBox = (findDisplay 24984) displayCtrl 1501;
_eventsListBox ctrlAddEventHandler ["LBSelChanged",
{
	params ["_control", "_selectedIndex"];

	if (_selectedIndex != -1) then
	{
		_playersListBox = (findDisplay 24984) displayCtrl 1500;
		_selectedPlayerIndex = lbCurSel _playersListBox;
		_requestedPlayerUid = _playersListBox lbData _selectedPlayerIndex;
		
		_requestedEventId = _control lbData _selectedIndex;
		
		_playerUid = getPlayerUID player;
		_clientId = clientOwner;
		
		_filterLoadoutsEditBox = (findDisplay 24984) displayCtrl 1402;
		
		_filterLoadouts = "";
	
		_request = _playerUid + "-requestLoadoutsFiltered";
		missionNamespace setVariable [_request, [_playerUid, _clientId, _requestedPlayerUid, _requestedEventId, _filterLoadouts], false];
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
	
		_filterEventsEditBox = (findDisplay 24984) displayCtrl 1401;
		_filterEvents = ctrlText _filterEventsEditBox;

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

_filterEventsEditBox = (findDisplay 24984) displayCtrl 1401;
_filterEventsEditBox ctrlAddEventHandler ["KeyUp",
{
	params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

	if ((_key == 28) || (_key == 156)) then
	{
		_playerUid = getPlayerUID player;
		_clientId = clientOwner;

		_filterPlayersEditBox = (findDisplay 24984) displayCtrl 1400;
		_filterPlayers = ctrlText _filterPlayersEditBox;

		_filterEventsEditBox = (findDisplay 24984) displayCtrl 1401;
		_filterEvents = ctrlText _filterEventsEditBox;

		_eventsListBox = (findDisplay 24984) displayCtrl 1501;
		lbClear _eventsListBox;
		_eventsListBox lbSetCurSel -1;
		
		{
			_text = _x select 0;
			_data = _x select 1;
			
			if (((toLower _text) find (toLower _filterEvents)) > -1) then
			{
				_index = _eventsListBox lbAdd _text;
				_eventsListBox lbSetData [_index, _data];
				
				if(PPL_isEvent &&(_dbEventId == PPL_eventId)) then
				{
					_eventsListBox lbSetColor [_index, [1, 0.5, 0.5, 1]];
					_eventsListBox lbSetCurSel _index;
					_eventsListBox lbSetText [_index, format [localize "STR_PPL_Main_Dialog_List_Event_Active", _text]];
				};
			};
		} forEach PPL_lbEventsContent;
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
	_eventsListBox = (findDisplay 24984) displayCtrl 1501;
	_selectedEventIndex = lbCurSel _eventsListBox;
	_requestedEventId = _eventsListBox lbData _selectedEventIndex;
	
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
	_countEventsTotal = _broadcastVariableValue select 8;
	_filteredPlayers = _broadcastVariableValue select 9;

	_activeEventStartTime = +PPL_eventStartTime;
	
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
	_eventsListBox = (findDisplay 24984) displayCtrl 1501;
	lbClear _eventsListBox;
	_eventsListBox lbSetCurSel -1;
	_loadoutsListBox = (findDisplay 24984) displayCtrl 1502;
	lbClear _loadoutsListBox;
	_loadoutsListBox lbSetCurSel -1;
	_adminButton = (findDisplay 24984) displayCtrl 1600;
	_eventStartButton = (findDisplay 24984) displayCtrl 1602;
	_eventStopButton = (findDisplay 24984) displayCtrl 1607;
	_eventContinueButton = (findDisplay 24984) displayCtrl 1606;
	_eventDeleteButton = (findDisplay 24984) displayCtrl 1608;
	_continueButton = (findDisplay 24984) displayCtrl 1606;
	_trackLoadoutsButton = (findDisplay 24984) displayCtrl 1604;
	_promoteButton = (findDisplay 24984) displayCtrl 1610;
	_eventEditBox = (findDisplay 24984) displayCtrl 1603;
	
	_filterPlayersEditBox = (findDisplay 24984) displayCtrl 1400;
	_filterPlayers = ctrlText _filterPlayersEditBox;
	
	if (_statusServer) then {_statusServer = localize "STR_PPL_Main_Online"} else {_statusServer = localize "STR_PPL_Main_Offline"};
	if (_statusDatabase) then {_statusDatabase = localize "STR_PPL_Main_Online"} else {_statusDatabase = localize "STR_PPL_Main_Offline"};
	
	_serverAndDatabaseStatusText ctrlSetText format [localize "STR_PPL_Main_Dialog_Server_Status", format ["%1 [%2]", _statusServer, _versionServer],  format ["%1 [%2]", _statusDatabase, _versionDatabase]];
	_playersAndAdminsCountText ctrlSetText format [localize "STR_PPL_Main_Dialog_Player_Status",_countPlayersTotal , _countPlayersOnline, _countAdminsTotal, _countAdminsOnline, _countEventsTotal];

	if (_isAdminLoggedIn) then
	{
		_adminButton ctrlSetText localize "STR_PPL_Main_Dialog_Button_Logout";
		_eventStartButton ctrlShow true;
		_eventStopButton ctrlShow true;
		_eventContinueButton ctrlShow true;
		_eventDeleteButton ctrlShow true;
		_eventEditBox ctrlShow true;
		_continueButton ctrlShow true;
		_promoteButton ctrlShow true;
	}
	else
	{
		_adminButton ctrlSetText localize "STR_PPL_Main_Dialog_Button_Login";
		_eventStartButton ctrlShow false;
		_eventStopButton ctrlShow false;
		_eventContinueButton ctrlShow false;
		_eventDeleteButton ctrlShow false;
		_eventEditBox ctrlShow false;
		_continueButton ctrlShow false;
		_promoteButton ctrlShow false;
	};

	_noEvent = localize "STR_PPL_Main_Dialog_No_Event";
	
	if (PPL_isEvent) then
	{
		{
			if(_x < 10) then
			{
				_activeEventStartTime set [_forEachIndex, format ["0%1", str _x]];
			}
			else
			{
				_activeEventStartTime set [_forEachIndex, str _x];
			};
		} forEach _activeEventStartTime;
		_year = _activeEventStartTime select 0;
		_month = _activeEventStartTime select 1;
		_day = _activeEventStartTime select 2;
		_hours = _activeEventStartTime select 3;
		_minutes = _activeEventStartTime select 4;
		_seconds = _activeEventStartTime select 5;
		_timeZone = PPL_TimeZone;
		if (PPL_SummerTime) then {_timeZone = _timeZone + 1;};
		_headlineText ctrlSetBackgroundColor [0.5, 0, 0, 1];
		_headlineText ctrlSetText format [localize "STR_PPL_Main_Dialog_Head_Time", PPL_eventName, _hours, _minutes, _seconds, _timeZone];
	}
	else
	{
		_headlineText ctrlSetBackgroundColor [0, 0.5, 0, 1];
		_headlineText ctrlSetText format [localize "STR_PPL_Main_Dialog_Head", _noEvent];
	};		

	PPL_lbPlayersContent = [];

	_filteredPlayers sort true;
	{
		_dbPlayerName = _x select 0;
		_dbPlayerUid = _x select 1;
		_dbPlayerIsAdmin = _x select 2;
		_dbPlayerIsAdminLoggedIn = _x select 3;
		_dbPlayerIsTrackLoadoutsActive = _x select 4;
		_dbPlayerTrackLoadoutsKey = _x select 5;
		_dbPlayerStatus = _x select 6;
		
		if (_dbPlayerIsAdmin) then {_dbPlayerIsAdmin = localize "STR_PPL_Main_Admin";} else {_dbPlayerIsAdmin = localize "STR_PPL_Main_Player";};

		if (_dbPlayerStatus) then {_dbPlayerStatus = " " + (localize "STR_PPL_Main_Online");} else {_dbPlayerStatus = " " + (localize "STR_PPL_Main_Offline");};

		if (_dbPlayerIsAdminLoggedIn) then {_dbPlayerIsAdminLoggedIn = " " + (localize "STR_PPL_Main_Logged_In");} else {_dbPlayerIsAdminLoggedIn = "";};
		
		if ((_dbPlayerUid == _playerUid) && _dbPlayerIsTrackLoadoutsActive) then
		{
			_trackLoadoutsButton ctrlSetText localize "STR_PPL_Main_Dialog_Button_Track_Value_Off";
		};
		if ((_dbPlayerUid == _playerUid) && !_dbPlayerIsTrackLoadoutsActive) then
		{
			_trackLoadoutsButton ctrlSetText localize "STR_PPL_Main_Dialog_Button_Track_Value_On";
		};
		
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

_answer = _playerUid + "-answerEventsFiltered";
_answer addPublicVariableEventHandler
{
	params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];

	_playerUid = _broadcastVariableValue select 0;
	_clientId = _broadcastVariableValue select 1;	
	_isAdmin = _broadcastVariableValue select 2;
	_isAdminLoggedIn = _broadcastVariableValue select 3;
	_filteredEvents = _broadcastVariableValue select 4;
	
	_eventsListBox = (findDisplay 24984) displayCtrl 1501;
	lbClear _eventsListBox;
	_eventsListBox lbSetCurSel -1;
	
	_loadoutsListBox = (findDisplay 24984) displayCtrl 1502;
	lbClear _loadoutsListBox;
	_loadoutsListBox lbSetCurSel -1;
	
	_filterEventsEditBox = (findDisplay 24984) displayCtrl 1401;
	_filterEvents = ctrlText _filterEventsEditBox;

	PPL_lbEventsContent = [];

	_filteredEvents sort false;
	{
		_dbEventId = _x select 0;
		_dbEventName = _x select 1;
		_dbEventStartTime = _x select 2;
		_dbEventDuration = _x select 3;
		
		_year = str (_dbEventStartTime select 0);
		_month = _dbEventStartTime select 1;
		if (_month < 10) then {_month = format ["0%1", _month];} else {_month = str _month};
		_day = _dbEventStartTime select 2;
		if (_day < 10) then {_day = format ["0%1", _day];} else {_day = str _day};
		
		_eventText = format ["%1-%2-%3 %4 (%5 min.)", _year, _month, _day, _dbEventName, _dbEventDuration];
		
		if(PPL_isEvent && (_dbEventId == PPL_eventId)) then
		{
			_eventText = format [localize "STR_PPL_Main_Dialog_List_Event_Active", _eventText];
		};

		if (((toLower _eventText) find (toLower _filterEvents)) > -1) then
		{
			_index = _eventsListBox lbAdd _eventText;	
			_eventsListBox lbSetData [_index, _dbEventId];

			if(PPL_isEvent && (_dbEventId == PPL_eventId)) then
			{
				_eventsListBox lbSetColor [_index, [1, 0.5, 0.5, 1]];
				_eventsListBox lbSetCurSel _index;
			};
		};	
		
		PPL_lbEventsContent = PPL_lbEventsContent + [[_eventText, _dbEventId]];
	
	} forEach _filteredEvents;
	
	ctrlSetFocus _eventsListBox;
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

_filterPlayersEditBox = (findDisplay 24984) displayCtrl 1400;
_filterPlayers = ctrlText _filterPlayersEditBox;

_request = _playerUid + "-requestDialogUpdate";
missionNamespace setVariable [_request, [_playerUid, _clientId, _filterPlayers], false];
publicVariableServer _request;

/* ================================================================================ */
