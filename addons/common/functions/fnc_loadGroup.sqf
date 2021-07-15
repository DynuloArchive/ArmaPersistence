#include "script_component.hpp"

params [
	"_id",
	"_side",
	"_variables"
];
_variables = parseSimpleArray _variables;

private _group = createGroup call {
	switch (toLower _side) do {
		case "blufor";
		case "west": { west };
		case "opfor";
		case "east": { east };
		case "guer";
		case "resistence";
		case "independent": { independent };
		case "civilian": { civilian };
	}
};
_group setVariable [QGVAR(id), _id];
GVAR(groupIDStack) pushBackUnique _id;

{
	_x params ["_key", "_value"];
	switch (_key) do {
		case "id": {
			_group setGroupIdGlobal [_value];
		};
		case "combat": {
			_group setCombatMode _value;
		};
		case "formation": {
			_group setFormation _value;
		};
		case "speed": {
			_group setSpeedMode _value;
		};
		case "behaviour": {
			_group setBehaviour _value;
		};
		case "waypoints": {
			{
				_x params ["_position", "_vars"];
				private _wp = _group addWaypoint [_position, 0];
				{
					_x params ["_key", "_value"];
					switch (_key) do {
						case "description": {
							_wp setWaypointDescription _value;
						};
						case "speed": {
							_wp setWaypointSpeed _value;
						};
						case "formation": {
							_wp setWaypointFormation _value;
						};
						case "combat": {
							_wp setWaypointCombatMode _value;
						};
						case "type": {
							systemChat format ["waypoint type %1", _value];
							_wp setWaypointType _value;
						};
						case "script": {
							_wp setWaypointScript _value;
						};
						case "statements": {
							_wp setWaypointStatements _value;
						};
						case "timeout": {
							_wp setWaypointTimeout _value;
						};
						case "house"; {
							_wp setWaypointHousePosition _value;
						};
						case "loiterRadius": {
							_wp setWaypointLoiterRadius _value;
						};
						case "loiterAltitude": {
							_wp setWaypointLoiterAltitude _value;
						};
						case "loiterType": {
							_wp setWaypointLoiterType _value;
						};
					};
				} forEach _vars
			} forEach _value;
		};
		case "currentWaypoint": {
			_group setCurrentWaypoint [_group, _value];
		};
	};
} forEach _variables;

// TODO save initial state
// _group setVariable [QGVAR(lastInfo), str _this];
_group setVariable [QGVAR(nextUpdate), time + 4];

GVAR(loadedgroups) pushBack _group;
