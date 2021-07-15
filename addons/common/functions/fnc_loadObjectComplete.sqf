#include "script_component.hpp"

{
	_x enableSimulationGlobal true;
	if (missionNamespace getVariable ["ace_cargo", false]) then {
		[{
			_this call FUNC(handleAceCargo);
		}, [_x], 1] call CBA_fnc_waitAndExecute;
	};
} forEach GVAR(loadedObjects);

GVAR(objectsReady) = true;

EXT callExtension "get_groups";
