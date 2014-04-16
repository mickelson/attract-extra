///////////////////////////////////////////////////
//
// Attract-Mode Frontend - Shutdown plugin 1.0
//
///////////////////////////////////////////////////
//
// Author: cools @ Arcade Otaku
//
// History: V1.0 - Windows only initial release
//
class UserConfig </ help="Switches off the PC when quitting the frontend. Set the command executable to c:\\windows\\system32\\cmd.exe (or wherever your cmd.exe is held)" /> {
	</ label="Type", help="Select Shutdown Type", options="Normal, Forced, Reboot, Forced_Reboot" />
	s_type="Normal";
  
	</ label="Timeout", help="Seconds to timeout. Set to 0 for immediate shutdown when quitting the frontend." />
	s_time="60";
}

local shutdown=fe.init_name;
local config = fe.get_config();
local timeout = config["s_time"];

local s_map = {
	Normal="/c shutdown -s -t "
	Forced="/c shutdown -s -f -t "
	Reboot="/c shutdown -r -t "
	Forced_Reboot="/c shutdown -r -f -t "
};

local options;
if ( s_map.rawin( config["s_type"] ) )
	options = s_map[ config["s_type"] ];

fe.add_transition_callback( "shutdown_plugin_transition" );

function shutdown_plugin_transition( ttype, var, ttime ) {

	switch ( ttype )
	{
	case Transition.EndLayout:
		if (( var == FromTo.Frontend ))
			fe.plugin_command_bg( shutdown, options + timeout );
		break;
	}

	return false; // must return false
}
