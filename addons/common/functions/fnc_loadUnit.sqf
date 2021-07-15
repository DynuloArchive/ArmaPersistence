#include "script_component.hpp"

params [
	"_id",
	"_class",
	"_group",
	"_position",
	"_rotation",
	"_variables"
];

_position = parseSimpleArray _position;
_rotation = parseSimpleArray _rotation;
_variables = parseSimpleArray _variables;

_position set [0, parseNumber (_position select 0)];
_position set [1, parseNumber (_position select 1)];
// _position set [2, parseNumber (_position select 2)];
_position deleteAt 2;

systemChat format ["looking for group %1", _group];
private _groups = allGroups;
private _group = _groups select (_groups findIf {(_x getVariable [QGVAR(id), "-"]) isEqualTo _group});
systemChat format ["found group %1", _group];
private _unit = _group createUnit [_class, _position, [], 0, "NONE"];

_unit enableSimulationGlobal false;
_unit setVariable [QGVAR(id), _id];
GVAR(unitIDStack) pushBackUnique _id;

_unit setVectorDirAndUp _rotation;

{
	_x params ["_key", "_value"];
	switch (_key) do {
		case "alive": {
			if !(_value) then {
				_unit setDamage [1, false];
			};
		};
		case "loadout": {
			_unit setUnitLoadout _value;
		};
		case "name": {
			_unit setName _value;
		};
		case "face": {
			_unit setFace _value;
		};
		case "pitch": {
			_unit setPitch _value;
		};
		case "speaker": {
			_unit setSpeaker _value;
		};
		case "rank": {
			_unit setRank _value;
		};
		case "pos": {
			_unit setUnitPos _value;
		};
		case "combat": {
			_unit setUnitCombatMode _value;
		};
		case "behaviour": {
			_unit setBehaviour _value;
		};
		case "vehicle": {
			_value params ["_vid", "_seat"];
			private _objects = allMissionObjects "All";
			private _vehicle = _objects select (_objects findIf { (_x getVariable [QGVAR(id), "-"]) isEqualTo _vid });
			switch (_seat) do {
				case "driver": {
					_unit moveInDriver _vehicle;
				};
				case "gunner": {
					_unit moveInGunner _vehicle;
				};
				case "commander": {
					_unit moveInCommander _vehicle;
				};
				default {
					_unit moveInCargo [_vehicle, _seat];
				};
			}
		}
	};
} forEach _variables;

// TODO save initial state
// _unit setVariable [QGVAR(lastInfo), str _this];
_unit setVariable [QGVAR(nextUpdate), time + 4];

GVAR(loadedUnits) pushBack _unit;
