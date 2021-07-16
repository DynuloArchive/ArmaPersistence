#include "script_component.hpp"

params [
	"_id",
	"_class",
	"_position",
	"_rotation",
	"_variables"
];

private _addCargoForContainer = {
	params ["_container", "_cargo"];

	private _standard = _cargo select 0;
	private _nested = _cargo select 1;

	//Magazine cargo
	clearMagazineCargoGlobal _container;
	{
		_container addMagazineCargoGlobal [_x, _standard select 0 select 1 select _forEachIndex];
	} forEach ((_standard select 0) select 0);

	//Weapon Cargo
	clearWeaponCargoGlobal _container;
	{
		_container addWeaponWithAttachmentsCargoGlobal [_x, 1];
	} forEach (_standard select 1);

	//Item Cargo
	clearitemCargoGlobal _container;
	{
		_container addItemCargoGlobal [_x, _standard select 2 select 1 select _forEachIndex];
	} forEach ((_standard select 2) select 0);

	//Nested Cargo
	{
		_x params ["_class", "_items"];
		_container addBackpackCargoGlobal [_class, 1];
		//Thanks Bohemia, the only way to find the container I just added is to loop over every container...
		{
			private _found = false;
			if (_x select 0 == _class) then {
				//More Elegant code
				if (
					!_found &&
					{ (_x select 1) getVariable [QGVAR(NOEDIT), true] }
				) then {
					[_x select 1, (_items)] call _addCargoForContainer;
					(_x select 1) setVariable [QGVAR(NOEDIT), false];
					_found = true;
				};
			};
		} forEach everyContainer _container;
	} forEach _nested;
};

_position = parseSimpleArray _position;
_rotation = parseSimpleArray _rotation;
_variables = parseSimpleArray _variables;

private _obj = _class createVehicle [0,0,0];
_obj enableSimulationGlobal false;
_obj setVariable [QGVAR(id), _id];
GVAR(objectIDStack) pushBackUnique _id;

_position set [0, parseNumber (_position select 0)];
_position set [1, parseNumber (_position select 1)];
_position set [2, parseNumber (_position select 2)];

_obj setVectorDirAndUp _rotation;
_obj setPosASL _position;

{
	_x params ["_key", "_value"];
	switch (_key) do {
		case "alive": {
			if !(_value) then {
				_obj setDamage [1, false];
			};
		};
		case "tex": {
			{
				_obj setObjectTextureGlobal [_forEachIndex, _x];
			} forEach _value;
		};
		case "hits": {
			if (_value isNotEqualTo []) then {
				{
					_obj setHitPointDamage [_x select 0, _x select 1, false];
				} forEach _value;
			};
		};
		case "fuel": {
			_obj setFuel _value;
		};
		case "fuelCargo": {
			_obj setFuelCargo _value;
		};
		case "plate": {
			_obj setPlateNumber _value;
		};
		case "inflamed": {
			_obj inflame _value;
		};
		case "engine": {
			_obj engineOn _value;
		};
		case "light": {
			_obj setPilotLight _value;
		};
		case "collision": {
			_obj setCollisionLight _value;
		};
		case "phases": {
			{
				_obj animateSource [_x#0, _x#1, true];
			} forEach _value;
		};
		case "terrain": {
			hideObjectGlobal  (objectFromNetId _value);
			_obj setVariable [QGVAR(terrain), _value];
		};
		case "locked": {
			_obj lock _value;
		};
		case "inventory": {
			[_obj, _value] call _addCargoForContainer;
		};
		case "ace_magazine": {
			_obj setVariable ["ace_rearm_magazineClass", _vale];
		};
		case "cargo": {
			_obj setVariable [QGVAR(toLoad), _value];
		};
		case "ammo": {
			_obj setVehicleAmmo 0;
			reverse _value;
			{
				_obj addMagazine _x;
			} forEach _value;
			reload _obj;
		};
		case "ammoCargo": {
			_obj setAmmoCargo _value;
		};
		case "repairCargo": {
			_obj setRepairCargo _value;
		};
	};
} forEach _variables;

// TODO save initial state
// _obj setVariable [QGVAR(lastInfo), str _this];
_obj setVariable [QGVAR(nextUpdate), time + 4];

GVAR(loadedObjects) pushBack _obj;
