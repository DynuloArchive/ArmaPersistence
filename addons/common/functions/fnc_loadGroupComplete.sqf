#include "script_component.hpp"

GVAR(groupsReady) = true;

systemChat "all groups loaded";

[{
	EXT callExtension "get_units";
}, [], 0.5] call CBA_fnc_waitAndExecute;
