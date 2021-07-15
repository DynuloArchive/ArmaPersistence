#include "script_component.hpp"

if !(GVAR(groupsReady)) exitWith {};

if (GVAR(groupStack) isEqualTo []) then {
	GVAR(groupStack) = allGroups;
	{
		EXT callExtension ["delete_group", [_x]];
		GVAR(groupIDStack) = GVAR(groupIDStack) - [_x];
	} forEach GVAR(groupNotSeen);
	GVAR(groupNotSeen) = +GVAR(groupIDStack);
};

private _group = GVAR(groupStack) deleteAt 0;
if (count units _group == 0 && { time > 30 }) exitWith {};

// groupId is not unique across all side
private _id = _group getVariable [QGVAR(id), ""];
if (_id isEqualTo "") then {
	_id = EXT callExtension "uuid";
	_group setVariable [QGVAR(id), _id];
};
GVAR(groupIDStack) pushBackUnique _id;
GVAR(groupNotSeen) = GVAR(groupNotSeen) - [_id];

if (_group getVariable [QGVAR(ignore), false]) exitWith {};
if (time < (_group getVariable [QGVAR(nextUpdate), -1])) exitWith {};

private _vars = [
	["id", groupId _group],
	["leader", (leader _group) getVariable [QGVAR(id), ""]],
	["behaviour", combatBehaviour _group]
];

private _speedMode = speedMode _group;
if !(_speedMode isEqualTo "NORMAL") then {
	_vars pushBack ["speed", _speedMode];
};

private _combatMode = combatMode _group;
if !(_combatMode isEqualTo "YELLOW") then {
	_vars pushBack ["combat", _combatMode];
};

private _formation = formation _group;
if !(_formation isEqualTo "WEDGE") then {
	_vars pushBack ["formation", _formation];
};

private _waypoints = waypoints _group;
if (count _waypoints > 1) then {
	private _points = [];
	{
		if (_forEachIndex != 0) then {
			private _waypointVars = [];
			if !(wayPointVisible _x) then {
				_waypointVars pushBack ["visible", false];
			};
			if (waypointDescription _x isNotEqualTo "") then {
				_waypointVars pushBack ["description", waypointDescription _x];
			};
			if (waypointSpeed _x isNotEqualTo "UNCHANGED") then {
				_waypointVars pushBack ["speed", waypointSpeed _x];
			};
			if (waypointBehaviour _x isNotEqualTo "UNCHANGED") then {
				_waypointVars pushBack ["behaviour", waypointBehaviour _x];
			};
			if (waypointFormation _x isNotEqualTo "NO CHANGE") then {
				_waypointVars pushBack ["formation", waypointFormation _x];
			};
			if (waypointCombatMode _x isNotEqualTo "NO CHANGE") then {
				_waypointVars pushBack ["combat", waypointCombatMode _x];
			};
			if (waypointType _x isNotEqualTo "MOVE") then {
				_waypointVars pushBack ["type", waypointType _x];
			};
			if (waypointScript _x isNotEqualTo "") then {
				_waypointVars pushBack ["script", waypointScript _x];
			};
			if (waypointStatements _x isNotEqualTo ["true",""]) then {
				_waypointVars pushBack ["statements", waypointStatements _x];
			};
			if (waypointTimeout _x isNotEqualTo [0,0,0]) then {
				_waypointVars pushBack ["timeout", waypointTimeout _x];
			};
			if (waypointHousePosition _x isNotEqualTo -1) then {
				_waypointVars pushBack ["house", waypointHousePosition _x];
			};
			if (waypointLoiterRadius _x isNotEqualTo -1) then {
				_waypointVars pushBack ["loiterRadius", waypointLoiterRadius _x];
			};
			if (waypointLoiterAltitude _x isNotEqualTo -1) then {
				_waypointVars pushBack ["loiterAltitude", waypointLoiterAltitude _x];
			};
			if (waypointLoiterType _x isNotEqualTo "CIRCLE") then {
				_waypointVars pushBack ["loiterType", waypointLoiterType _x];
			};
			_points pushBack [
				waypointPosition _x,
				_waypointVars
			];
		};
	} forEach _waypoints;
	if (_points isNotEqualTo []) then {
		_vars pushBack ["waypoints", _points];
		_vars pushBack ["currentWaypoint", currentWaypoint _group];
	};
};

private _info = [
	_id,
	side _group,
	str _vars
];

if (str _info isNotEqualTo (_group getVariable [QGVAR(lastInfo), ""])) then {
	EXT callExtension ["save_group", _info];
	_group setVariable [QGVAR(lastInfo), str _info];
};

_group setVariable [QGVAR(nextUpdate), time + 2];
