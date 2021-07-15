#define COMPONENT commands
#include "\dynulo\persistence\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define CBA_DEBUG_SYNCHRONOUS
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_COMMANDS
  #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_COMMANDS
  #define DEBUG_SETTINGS DEBUG_SETTINGS_COMMANDS
#endif

#include "\dynulo\persistence\addons\main\script_macros.hpp"

#define MSG(TEXT) TEXT remoteExec ["systemChat", _player]

#define USAGE(COUNT, MESSAGE) \
if (count _args != COUNT + 2) exitWith { \
  private _text = format ["Usage: #dynulo persistence %1", MESSAGE]; \
	MSG(_text); \
}
