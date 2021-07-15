#include "script_component.hpp"

params ["_code", ["_player", objNull]];

if (count _code != 36) exitWith { 
	if !(_player isEqualTo objNull) then {
		MSG("That code does not look valid");
	};
};

profileNamespace setVariable [QEGVAR(main,token), _code];
saveProfileNamespace;

if !(_player isEqualTo objNull) then {
	MSG("Code Registered! You must restart the mission to enable Persistence features");
};
