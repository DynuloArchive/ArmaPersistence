#include "script_component.hpp"

params ["_obj"];

private _loaded = _obj getVariable ["ace_cargo_loaded", []];
if (_loaded isNotEqualTo []) then {
	{
		if (_x isEqualType objNull) then {
			detach _x;
			deleteVehicle _x;
		};
	} forEach _loaded;
};
_obj setVariable ["ace_cargo_loaded", [], true];
[_obj] call ace_cargo_fnc_validateCargoSpace;
private _toLoad = _obj getVariable [QGVAR(toLoad), []];
if (_toLoad isNotEqualTo []) then {
	{
		_x params ["_type", "_id"];
		if (_type == 0) then {
			[_id, _obj] call ace_cargo_fnc_addCargoItem;
		} else {
			private _allObjects = allMissionObjects "All";
			private _object = _allObjects select (_allObjects findIf { _x getVariable [QGVAR(id), ""] isEqualTo _id });
			[_object, _obj, false] call ace_cargo_fnc_loadItem;
		};
	} forEach _toLoad;
};
