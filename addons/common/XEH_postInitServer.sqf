#include "script_component.hpp"

REQUIRE_PERSISTENCE;

GVAR(tickObjectsPFH) = [FUNC(tickObjects), 0.1] call CBA_fnc_addPerFrameHandler;
GVAR(tickGroupsPFH) = [FUNC(tickGroups), 0.1] call CBA_fnc_addPerFrameHandler;
GVAR(tickUnitsPFH) = [FUNC(tickUnits), 0.1] call CBA_fnc_addPerFrameHandler;
GVAR(tickMarkersPFH) = [FUNC(tickMarkers), 1] call CBA_fnc_addPerFrameHandler;

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
		case "marker": {
			(parseSimpleArray _data) call FUNC(loadMarker);
		};
		case "markers_complete": {
			call FUNC(loadMarkerComplete);
		};
	};
}];

addMissionEventHandler ["BuildingChanged", { 
	params ["_previousObject", "_newObject", "_isRuin"];
	_newObject setVariable [QGVAR(terrain), netId _previousObject];
}];

if (missionNamespace getVariable ["ace_tagging", false]) then {
	["ace_tagCreated", {
		params ["_tag", "_texture", "_object", "_unit"];
		private _info = [
			EXT callExtension "uuid",
			typeOf _tag,
			call {
				private _pos = getPosASL _tag;
				_pos set [0, _pos#0 toFixed 8];
				_pos set [1, _pos#1 toFixed 8];
				_pos set [2, _pos#2 toFixed 8];
				_pos
			},
			str [
				vectorDir _tag,
				vectorUp _tag
			],
			str [
				["tex", [_texture]]
			]
		];
		EXT callExtension ["save_object", _info];
	}] call CBA_fnc_addEventHandler;
};

EXT callExtension "get_markers";
EXT callExtension "get_objects";
