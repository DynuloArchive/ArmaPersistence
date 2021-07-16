#include "script_component.hpp"

if !(GVAR(unitsReady)) exitWith {};

if (GVAR(unitStack) isEqualTo []) then {
	GVAR(unitStack) = allUnits - allPlayers;
	{
		EXT callExtension ["delete_unit", [_x]];
		GVAR(unitIDStack) = GVAR(unitIDStack) - [_x];
	} forEach GVAR(unitNotSeen);
	GVAR(unitNotSeen) = +GVAR(unitIDStack);
};

if (GVAR(unitStack) isEqualTo []) then {};

private _unit = GVAR(unitStack) deleteAt 0;

private _id = _unit getVariable [QGVAR(id), ""];
if (_id isEqualTo "") then {
	_id = EXT callExtension "uuid";
	_unit setVariable [QGVAR(id), _id];
};
GVAR(unitIDStack) pushBackUnique _id;
GVAR(unitNotSeen) = GVAR(unitNotSeen) - [_id];

if (_unit getVariable [QGVAR(ignore), false]) exitWith {};
if (time < (_unit getVariable [QGVAR(nextUpdate), -1])) exitWith {};

private _vars = [
	["name", name _unit],
	["loadout", getUnitLoadout _unit]
];

if (face _unit isNotEqualTo "Default") then {
	_vars pushBack ["face", face _unit];
};
if (speaker _unit isNotEqualTo "") then {
	_vars pushBack ["speaker", speaker _unit];
};
if (rank _unit isNotEqualTo "PRIVATE") then {
	_vars pushBack ["rank", rank _unit];
};
if (pitch _unit != 1) then {
	_vars pushBack ["pitch", pitch _unit];
};
if !(alive _unit) then {
	_vars pushBack ["alive", false];
};
if (_unit isFlashlightOn (currentWeapon _unit)) then {
	_vars pushBack ["flashlight", true];
};
if (_unit isIRLaserOn (currentWeapon _unit)) then {
	_vars pushBack ["irlaser", true];
};
if (primaryWeapon _unit isNotEqualTo currentWeapon _unit) then {
	_vars pushBack ["weapon", currentWeapon _unit];
};
if (unitPos _unit isNotEqualTo "Auto") then {
	_vars pushBack ["pos", unitPos _unit];
};
if (unitCombatMode _unit isNotEqualTo "YELLOW") then {
	_vars pushBack ["combat", unitCombatMode _unit];
};
if (behaviour _unit isNotEqualTo "NORMAL") then {
	_vars pushBack ["behaviour", behaviour _unit];
};
if (vehicle _unit isNotEqualTo _unit) then {
	_vars pushBack ["vehicle", [
		(vehicle _unit) getVariable [QGVAR(id), ""],
		call {
			if (driver vehicle _unit isEqualTo _unit) exitWith { "driver" };
			if (gunner vehicle _unit isEqualTo _unit) exitWith { "gunner" };
			if (commander vehicle _unit isEqualTo _unit) exitWith { "commander" };
			(vehicle _unit) getCargoIndex _unit
		}
	]];
};

if (missionnamespace getVariable ["ace_main", false]) then {
	if (_unit getVariable ["ace_captives_isSurrendering", false]) then {
		_vars pushBack ["ace_surrender", true];
	};
	if (_unit getVariable ["ace_captives_isHandcuffed", false]) then {
		_vars pushBack ["ace_handcuffed", true];
	};
};

private _info = [
	_id,
	typeOf _unit,
	(group _unit) getVariable [QGVAR(id), ""],
	call {
		private _pos = getPosASL _unit;
		_pos set [0, _pos#0 toFixed 8];
		_pos set [1, _pos#1 toFixed 8];
		_pos set [2, _pos#2 toFixed 8];
		_pos
	},
	str [
		vectorDir _unit,
		vectorUp _unit
	],
	str _vars
];

if (str _info isNotEqualTo (_unit getVariable [QGVAR(lastInfo), ""])) then {
	EXT callExtension ["save_unit", _info];
	_unit setVariable [QGVAR(lastInfo), str _info];
};

_unit setVariable [QGVAR(nextUpdate), time + 2];
