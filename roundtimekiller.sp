#include <sourcemod>
#define PLUGIN_VERSION "1.0" 
#pragma semicolon 1
#pragma newdecls required
ConVar mp_roundtime, sm_override_roundtime, sm_override_roundtime_resetter;

public  Plugin myinfo = 
{
	name = "[CS:GO] Round Time KiLLER",
	author = "IT-KiLLER",
	description = "Increases the time limit from 60 to 546 minutes per round and support for override mp_roundtime.",
	version = PLUGIN_VERSION,
	url = "https://github.com/it-killer"
}

public void OnPluginStart()
{
	mp_roundtime = FindConVar("mp_roundtime");
	sm_override_roundtime = CreateConVar("sm_override_roundtime", "0", "This override the round time if it changes. 0=Disabled, set a time (1-546 minutes) to enable override.", _, true, 0.0, true, 546.0);
	sm_override_roundtime_resetter = CreateConVar("sm_override_roundtime_resetter", "1", "Automatically disabled override after map change.", _, true, 0.0, true, 1.0);
	CreateConVar("sm_roundtime_killer_version", PLUGIN_VERSION, "Plugin by IT-KiLLER @ github", FCVAR_DONTRECORD|FCVAR_SPONLY);
	mp_roundtime.AddChangeHook(OnConVarChange);
	sm_override_roundtime.AddChangeHook(OnConVarChange);
	mp_roundtime.SetBounds(ConVarBound_Upper, true, 546.0);
}

public void OnMapEnd(){
	if(sm_override_roundtime_resetter.BoolValue)
		SetConVarInt(FindConVar("sm_override_roundtime"), 0, false, false);
}

public void OnConVarChange(Handle hCvar, const char[] oldValue, const char[] newValue)
{
	if (StrEqual(oldValue, newValue)) return;
	SetConVarInt(FindConVar("mp_roundtime_defuse"), 0, false, false);
	SetConVarInt(FindConVar("mp_roundtime_hostage"), 0, false, false);
	if (sm_override_roundtime.BoolValue) {
		PrintToServer("[SM] The round time has been changed to %-.2f by Round Time KiLLER. sm_override_roundtime 0 to disable this.", sm_override_roundtime.FloatValue);
		mp_roundtime.SetFloat(sm_override_roundtime.FloatValue);
	}
}