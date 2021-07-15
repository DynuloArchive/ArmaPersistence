#include "script_component.hpp"

params ["_args", "_player"];

_args = (_args select 0) splitString " ";

INFO_2("dynulo command ran for %1 mod: %2", _args select 0, _args select 1);

if !(isServer) exitWith {};
if !((_args select 0) isEqualTo "persistence") exitWith {};

switch (_args select 1) do {
	case "version": {
		MSG("0.2.0");
	};
	case "register": {
		USAGE(1, "register [code]");
		[_args select 2, _player] call FUNC(register);
	};
	case "status": {
		MSG("Unimplemented");
	};
	case "help": {
		MSG("version | register | status");
	};
};
