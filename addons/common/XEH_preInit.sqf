#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

GVAR(groupsReady) = false;
GVAR(objectsReady) = false;
GVAR(unitsReady) = false;

GVAR(objectStack) = [];
GVAR(objectNotSeen) = [];
GVAR(objectIDStack) = [];
GVAR(loadedObjects) = [];

GVAR(groupStack) = [];
GVAR(groupNotSeen) = [];
GVAR(groupIDStack) = [];

GVAR(unitStack) = [];
GVAR(unitNotSeen) = [];
GVAR(unitIDStack) = [];
GVAR(loadedUnits) = [];

EGVAR(main,enabled) = false;

[
    QEGVAR(main,enabled),
    "CHECKBOX",
    ["Enabled", "Use the Persistence feautres"],
    "Dynulo - Persistence",
    false,
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QEGVAR(main,key),
    "EDITBOX",
    ["Enabled", "Use the Persistence feautres"],
    "Dynulo - Persistence",
    "",
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QEGVAR(main,readOnly),
    "CHECKBOX",
    ["Read Only", "Load values from the database, but do not make changes"],
    "Dynulo - Persistence",
    false,
    true,
    {},
    true
] call CBA_fnc_addSetting;

if (isServer) then {
    private _token = profileNamespace getVariable [QEGVAR(main,token), ""];
	if (_token isEqualTo "") exitWith {
		INFO("token empty, not running setup");
	};
    if ((missionNamespace getVariable [QEGVAR(main,key), ""]) isNotEqualTo "") then {
        private _result = EXT callExtension ["setup", [_token, EGVAR(main,key)]];
        INFO_1("token submitted with result %1", _result);
    };
};

ADDON = true;
