#include "script_component.hpp"

{
	_x enableSimulationGlobal true;
} forEach GVAR(loadedObjects);

GVAR(objectsReady) = true;

systemChat "all objects loaded";
EXT callExtension "get_groups";
