#include "script_component.hpp"

INFO_1("Creating command globally with %1", QFUNC(init));
remoteExec [QFUNC(init), REMOTE_CLIENTS, true];
