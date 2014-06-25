///////////////////////////////////////////////////
//
// Attract-Mode Frontend - Regen plugin
//
///////////////////////////////////////////////////
//
// Author: cools @ Arcade Otaku
//
// Usage:
//
// 1.  Copy this file to the "plugins" directory of your Attract-Mode
//      configuration.
//
// 2.  Run Attract-Mode and enter configuration mode.  Configure the
//     Regen plugin with the path to the Attract-Mode executable.
//
///////////////////////////////////////////////////

class UserConfig </ help="Regenerates romlists when the screensaver is active." /> {
 </ label="Emulators", help="Comma separated list of emulators." />
 cfg_emulators="mame,mess-snes,video";

 </ label="Romlists", help="Comma separated list of romlists." />
 cfg_romlists="Arcade,Super Nintendo,Videos";
}

local executable=fe.init_name;
local emulators = split(fe.uconfig["cfg_emulators"],",");
local romlists = split(fe.uconfig["cfg_romlists"],",");
local runonce = true;

fe.add_transition_callback("regen_plugin_transition");
function regen_plugin_transition (ttype, var, ttime ) {
 if (ScreenSaverActive && runonce) {
  foreach(idx,val in emulators) {
   runonce = false;
   fe.plugin_command( executable, "--build-romlist " + val + " --output \"" + romlists[idx] + "\"");
  }
  return false;
 }
 return false;
}
