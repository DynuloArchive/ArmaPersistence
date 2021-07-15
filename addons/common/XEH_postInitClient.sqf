#include "script_component.hpp"

REQUIRE_PMC;
NO_HC;

// Don't save information about Zeus
if (typeOf player isEqualto "VirtualCurator_F") exitWith {
	player setVariable [QGVAR(ignore), true, true];
};
