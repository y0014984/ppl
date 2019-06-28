/*
 * Author: y0014984
 *
 * PPL Server Initialization. Sets global vartiables for the first time.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * None. Is started in postInit.
 *
 * Public: No
 */

if (isServer && isMultiplayer) then
{
	_activatedAddons = activatedAddons;
	_addonInidbi2Activated = false;
	_versionDatabase = "unknown Version";
	if ((_activatedAddons find "inidbi2") > -1) then
	{
		_addonInidbi2Activated = true;
		_dbName = "ppl-temp";
		_db = ["new", _dbName] call OO_INIDBI;
		_versionDatabase = "getVersion" call _db;
		if (_versionDatabase != "Inidbi: 2.06 Dll: 2.06") then {_versionDatabase = _versionDatabase + " (Required Version 2.06)";};
	}
	else
	{
		[format ["[%1] PPL server mod INIDBI2 not activated. Server will not start.", serverTime]] call PPL_fnc_log;
	};

	PPL_statusDatabase = _addonInidbi2Activated;
	publicVariable "PPL_statusDatabase";
	PPL_versionDatabase = _versionDatabase;
	publicVariable "PPL_versionDatabase";

	if (_addonInidbi2Activated) then
	{
		/* ---------------------------------------- */
		
		PPL_statusServer = true;
		publicVariable "PPL_statusServer";
		PPL_versionServer = "v0.4.2";
		publicVariable "PPL_versionServer";
		
		_dbName = "ppl-players";
		_dbPlayers = ["new", _dbName] call OO_INIDBI;
		
		if ("exists" call _dbPlayers) then
		{
			_players = "getSections" call _dbPlayers;
			
			{
				[_x] call PPL_fnc_serverEventHandlerInit;
				_playerUid = ["read", [_x, "playerUid", "<id not set>"]] call _dbPlayers;
				[format ["[%1] DB PPL Player: (%2)", serverTime, _playerUid]] call PPL_fnc_log;
			} forEach _players;
		};	

		/* ---------------------------------------- */

		"pplServerHelo" addPublicVariableEventHandler
		{
			params ["_broadcastVariableName", "_broadcastVariableValue", "_broadcastVariableTarget"];
			
			_playerName = _broadcastVariableValue select 0;
			_playerUid = _broadcastVariableValue select 1;
			
			[format ["[%1] PPL Player send Helo to server: (%2)", serverTime, _playerUid]] call PPL_fnc_log;
				
			_dbName = "ppl-players";
			_dbPlayers = ["new", _dbName] call OO_INIDBI;

			_players = [];
			if ("exists" call _dbPlayers) then
			{
				_players = "getSections" call _dbPlayers;
			};
			
			_result = _players find _playerUid;
			
			if (_result == -1) then
			{
				["write", [_playerUid, "playerName", _playerName]] call _dbPlayers;
				["write", [_playerUid, "playerUid", _playerUid]] call _dbPlayers;
				["write", [_playerUid, "isAdmin", false]] call _dbPlayers;
				["write", [_playerUid, "isAdminLoggedIn", false]] call _dbPlayers;
				
				[_playerUid] call PPL_fnc_serverEventHandlerInit;
				
				[format ["[%1] New PPL Player added to DB: (%2)", serverTime, _playerUid]] call PPL_fnc_log;
			};
		};

		/* ---------------------------------------- */

		_dbName = "ppl-players";
		_dbPlayers = ["new", _dbName] call OO_INIDBI;
		
		_players = "getSections" call _dbPlayers;
		{
			["write", [_x, "isAdminLoggedIn", false]] call _dbPlayers;
		}forEach _players;
		
		/* ---------------------------------------- */
	}
	else
	{
		PPL_statusServer = false;
		publicVariable "PPL_statusServer";
		PPL_versionServer = "unknown Version";
		publicVariable "PPL_versionServer";
	};
};