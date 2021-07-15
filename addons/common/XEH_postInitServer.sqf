#include "script_component.hpp"

REQUIRE_PERSISTENCE;

GVAR(tickObjectsPFH) = [FUNC(tickObjects), 0.1] call CBA_fnc_addPerFrameHandler;
GVAR(tickGroupsPFH) = [FUNC(tickGroups), 0.1] call CBA_fnc_addPerFrameHandler;
GVAR(tickUnitsPFH) = [FUNC(tickUnits), 0.1] call CBA_fnc_addPerFrameHandler;

addMissionEventHandler ["ExtensionCallback", {
	params ["_name", "_function", "_data"];
	if !(_name == "dynulo_persistence") exitWith {};

	switch (_function) do {
		case "object": {
			(parseSimpleArray _data) call FUNC(loadObject);
		};
		case "objects_complete": {
			call FUNC(loadObjectComplete);
		};
		case "group": {
			(parseSimpleArray _data) call FUNC(loadGroup);
		};
		case "groups_complete": {
			call FUNC(loadGroupComplete);
		};
		case "unit": {
			(parseSimpleArray _data) call FUNC(loadUnit);
		};
		case "units_complete": {
			call FUNC(loadUnitComplete);
		};
	};
}];

addMissionEventHandler ["BuildingChanged", { 
	params ["_previousObject", "_newObject", "_isRuin"];
	_newObject setVariable [QGVAR(terrain), netId _previousObject];
}];

EXT callExtension "get_objects";
