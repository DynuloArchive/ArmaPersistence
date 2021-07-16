#include "script_component.hpp"

params [
	"_id",
	"_position",
	"_variables"
];
_position = parseSimpleArray _position;
_variables = parseSimpleArray _variables;

_position set [0, parseNumber (_position select 0)];
_position set [1, parseNumber (_position select 1)];

private _marker = createMarkerLocal [_id, _position];
// use some defaults to save on space
_marker setMarkerTypeLocal "hd_dot";
_marker setMarkerShadowLocal true;
_marker setMarkerColorLocal "ColorBlack";
GVAR(markerIDStack) pushBackUnique _marker;

{
	_x params ["_key", "_value"];
	switch (_key) do {
		case "alpha": {
			_marker setMarkerAlphaLocal _value;
		};
		case "color": {
			_marker setMarkerColorLocal _value;
		};
		case "size": {
			_marker setMarkerSizeLocal _value;
		};
		case "text": {
			_marker setMarkerTextLocal _value;
		};
		case "type": {
			_marker setMarkerTypeLocal _value;
		};
		case "brush": {
			_marker setMarkerBrushLocal _value;
		};
		case "dir": {
			_marker setMarkerDirLocal _value;
		};
		case "polyline": {
			_marker setMarkerPolylineLocal _value;
		};
		case "shadow": {
			_marker setMarkerShadowLocal _value;
		};
		case "shape": {
			_marker setMarkerShapeLocal _value;
		};
	};
} forEach _variables;

// Broadcast the marker globally
_marker setMarkerAlpha (markerAlpha _marker);
