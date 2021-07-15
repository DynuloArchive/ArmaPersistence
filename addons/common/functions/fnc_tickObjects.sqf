#include "script_component.hpp";

if !(GVAR(objectsReady)) exitWith {};

if (GVAR(objectStack) isEqualTo []) then {
	GVAR(objectStack) = (allMissionObjects "All") - allUnits;
	{
		EXT callExtension ["delete_object", [_x]];
		GVAR(objectIDStack) = GVAR(objectIDStack) - [_x];
	} forEach GVAR(objectNotSeen);
	GVAR(objectNotSeen) = +GVAR(objectIDStack);
};

private _obj = GVAR(objectStack) deleteAt 0;
if (_obj isKindOf "Logic") exitWith {};

private _id = _obj getVariable [QGVAR(id), ""];
if (_id isEqualTo "") then {
	_id = EXT callExtension "uuid";
	_obj setVariable [QGVAR(id), _id];
};
GVAR(objectIDStack) pushBackUnique _id;
GVAR(objectNotSeen) = GVAR(objectNotSeen) - [_id];

if (_obj getVariable [QGVAR(ignore), false]) exitWith {};
if (time < (_obj getVariable [QGVAR(nextUpdate), -1])) exitWith {};

private _vars = [
	["engine", isEngineOn _obj],
	["light", isLightOn _obj],
	["collision", isCollisionLightOn _obj]
];

if !(alive _obj) then {
	_vars pushBack ["alive", false];
};
if (fuel _obj != 1) then {
	_vars pushBack ["fuel", fuel _obj];
};
if (inflamed _obj) then {
	_vars pushBack ["inflamed", true];
};
if (getPlateNumber _obj isNotEqualTo "") then {
	_vars pushBack ["plate", getPlateNumber _obj];
};

private _tex = getObjectTextures _obj;
if (_tex isNotEqualTo []) then {
	_vars pushBack ["tex", _tex];
};

private _hits = [];
private _data = (getAllHitPointsDamage _obj);
{
	private _damage = _data select 2 select _forEachIndex;
	if (_damage != 0) then {
		_hits pushBack [_x, _damage];
	};
} forEach (_data select 0);
if (_hits isNotEqualTo []) then {
	_vars pushBack ["hits", _hits];
};


private _names = animationNames _obj;
private _phases = [];
{
	private _phase = _obj animationPhase _x;
	if (_phase != 0) then {
		_phases pushBack [_x, _phase];
	};
} forEach _names;
if (_phases isNotEqualTo []) then {
	_vars pushBack ["phases", _phases];
};

if (_obj getVariable [QGVAR(terrain), ""] isNotEqualTo "") then {
	_vars pushBack ["terrain", _obj getVariable [QGVAR(terrain), ""]];
};

private _locked = locked _obj;
if !(_locked in [-1, 0]) then {
	_vars pushBack ["locked", _locked];
};

private _fuelCargo = getFuelCargo _obj;
if (_fuelCargo != -1) then {
	_vars pushBack ["fuelCargo", _fuelCargo];
};

private _tree = [_obj] call FUNC(getInventory);
if (_tree isNotEqualTo []) then {
	_vars pushBack ["inventory", _tree];
};

private _info = [
	_id,
	typeOf _obj,
	call {
		private _pos = getPosASL _obj;
		_pos set [0, _pos#0 toFixed 8];
		_pos set [1, _pos#1 toFixed 8];
		_pos set [2, _pos#2 toFixed 8];
		_pos
	},
	str [
		vectorDir _obj,
		vectorUp _obj
	],
	str _vars
];

if (str _info isNotEqualTo (_obj getVariable [QGVAR(lastInfo), ""])) then {
	EXT callExtension ["save_object", _info];
	_obj setVariable [QGVAR(lastInfo), str _info];
};

_obj setVariable [QGVAR(nextUpdate), time + 2];

