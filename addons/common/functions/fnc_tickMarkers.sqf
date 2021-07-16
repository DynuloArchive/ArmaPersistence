#include "script_component.hpp"

if !(GVAR(markersReady)) exitWith {};

if (GVAR(markerStack) isEqualTo []) then {
	GVAR(markerStack) = allMapMarkers;
	{
		EXT callExtension ["delete_marker", [_x]];
		GVAR(markerIDStack) = GVAR(markerIDStack) - [_x];
	} forEach GVAR(markerNotSeen);
	GVAR(markerNotSeen) = +GVAR(markerIDStack);
};

if (GVAR(markerStack) isEqualTo []) exitWith {};

private _marker = GVAR(markerStack) deleteAt 0;
GVAR(markerIDStack) pushBackUnique _marker;

if (markerShape _marker isEqualTo "ERROR") exitWith {};

GVAR(markerNotSeen) = GVAR(markerNotSeen) - [_marker];

private _vars = [];

if (markerAlpha _marker != 1) then {
	_vars pushBack ["alpha", markerAlpha _marker];
};
if (markerColor _marker != "ColorBlack") then {
	_vars pushBack ["color", markerColor _marker];
};
if (markerSize _marker isNotEqualTo [1,1]) then {
	_vars pushBack ["size", markerSize _marker];
};
if (markerText _marker != "") then {
	_vars pushBack ["text", markerText _marker];
};
if (markerType _marker != "") then {
	_vars pushBack ["type", markerType _marker];
};
if (markerBrush _marker != "Solid") then {
	_vars pushBack ["brush", markerBrush _marker];
};
if (markerDir _marker != 0) then {
	_vars pushBack ["dir", markerDir _marker];
};
if (markerPolyline _marker isNotEqualTo []) then {
	_vars pushBack ["polyline", markerPolyline _marker];
};
if !(markerShadow _marker) then {
	_vars pushBack ["shadow", false];
};
if (markerShape _marker != "ICON") then {
	_vars pushBack ["shape", markerShape _marker];
};

private _info = [
	_marker,
	call {
		private _pos = getMarkerPos _marker;
		_pos set [0, _pos#0 toFixed 8];
		_pos set [1, _pos#1 toFixed 8];
		_pos
	},
	str _vars
];

// TODO caching of some kind
EXT callExtension ["save_marker", _info];
