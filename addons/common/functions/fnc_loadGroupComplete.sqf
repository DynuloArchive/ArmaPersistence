#include "script_component.hpp"

GVAR(groupsReady) = true;

[{
	EXT callExtension "get_units";
}, [], 0.5] call CBA_fnc_waitAndExecute;
