#include "script_component.hpp"

{
	_x enableSimulationGlobal true;
} forEach GVAR(loadedUnits);

GVAR(unitsReady) = true;

systemChat "all unit loaded";
