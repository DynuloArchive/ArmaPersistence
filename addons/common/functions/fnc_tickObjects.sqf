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

private _vars = [];

if (_obj isKindOf "Car") then {
	_vars pushBack ["engine", isEngineOn _obj];
	_vars pushBack ["light", isLightOn _obj];
};
if (_obj isKindOf "Tank") then {
	_vars pushBack ["engine", isEngineOn _obj];
	_vars pushBack ["light", isLightOn _obj];
};
if (_obj isKindOf "Helicopter") then {
	_vars pushBack ["engine", isEngineOn _obj];
	_vars pushBack ["light", isLightOn _obj];
	_vars pushBack ["collision", isCollisionLightOn _obj];
};

if (missionNamespace getVariable ["ace_cargo", false]) then {
	private _cargo = [];
    {
        _cargo pushBack (if (_x isEqualType "") then {
            [0, _x]
        } else {
            [1, _x getVariable [QGVAR(id), 0]]
        });
    } forEach (_obj getVariable ["ace_cargo_loaded", []]);
	if (_cargo isNotEqualTo []) then {
		_vars pushBack ["cargo", _cargo];
	};
};

if (_obj getVariable ["ace_rearm_magazineClass", ""] isNotEqualTo "") then {
	_vars pushBack ["ace_magazine", _obj getVariable ["ace_rearm_magazineClass", ""]];
};

if !(alive _obj) then {
	_vars pushBack ["alive", false];
} else {
	private _ammoCargo = getAmmoCargo _obj;
	if (_ammoCargo isNotEqualTo -1) then {
		_vars pushBack ["ammoCargo", _ammoCargo];
	};
	private _repairCargo = getRepairCargo _obj;
	if (_repairCargo isNotEqualTo -1) then {
		_vars pushBack ["repairCargo", _ammoCargo];
	};
	private _fuelCargo = getFuelCargo _obj;
	if (_fuelCargo != -1) then {
		_vars pushBack ["fuelCargo", _fuelCargo];
	};
	private _ammo = magazinesAmmo _obj;
	if (_ammo isNotEqualTo []) then {
		_vars pushBack ["ammo", _ammo];
	};
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

private _phases = [];
{
	private _phase = _obj animationSourcePhase _x;
	_phases pushBack [_x, _phase];
} forEach (animationNames _obj);
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

private _tree = [_obj] call FUNC(getInventory);
if (_tree isNotEqualTo [[[[],[]],[],[[],[]]],[]]) then {
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

