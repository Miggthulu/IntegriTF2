#pragma semicolon 1
#pragma newdecls required
#include <sourcemod>
#include <clients>

#define PLUGIN_VERSION "2.0"

public Plugin myinfo = {
	name        = "IntegriTF2",
	author      = "Miggy and friends",
	description = "Plugin that verifies the integrity of the Server and Player settings.",
	version		= PLUGIN_VERSION,
	url         = "miggthulu.com"
};

// Global Variables
ConVar g_CvarDmgMultiBlu;
ConVar g_CvarDmgMultiRed;
ConVar g_CvarTeleFovStart;
ConVar g_CvarTeleFovTime;
ConVar g_CvarCloakConsumeRate;
ConVar g_CvarCloakRegenRate;
ConVar g_CvarCloakAttackTime;
ConVar g_CvarCloakInvisTime;
ConVar g_CvarCloakUnInvisTime;
ConVar g_CvarBackstabMethod;
ConVar g_CvarDroppedWeaponLifetime;

void SetConVars()
{
	g_CvarDmgMultiBlu.RestoreDefault(true, true);
	g_CvarDmgMultiRed.RestoreDefault(true, true);
	
	g_CvarTeleFovStart.SetInt(90, true, true); // default is 120, change to 90 - exploit allows users to keep 120
	g_CvarTeleFovTime.RestoreDefault(true, true);
	
	g_CvarCloakConsumeRate.RestoreDefault(true, true);
	g_CvarCloakRegenRate.RestoreDefault(true, true);
	g_CvarCloakAttackTime.RestoreDefault(true, true);
	g_CvarCloakInvisTime.RestoreDefault(true, true);
	g_CvarBackstabMethod.RestoreDefault(true, true);
	setConVarCheat(g_CvarBackstabMethod);
	
	g_CvarDroppedWeaponLifetime.RestoreDefault(true, true);
}

public void OnPluginStart()
{
	/* Hook Round Start event for a tournament mode game */
	HookEvent("teamplay_round_start", EventRoundStart);
	HookEvent("player_spawn", Event_player_spawn);
	
	/** Team Based Exploits **/
	g_CvarDmgMultiBlu = FindConVar("tf_damage_multiplier_blue");
	g_CvarDmgMultiRed = FindConVar("tf_damage_multiplier_red");
	
	
	/** Engineer Tele Exploit Fix **/
	g_CvarTeleFovStart = FindConVar("tf_teleporter_fov_start");
	g_CvarTeleFovTime = FindConVar("tf_teleporter_fov_time");
	
	/** Spy Cloak Exploit Prevention **/
	g_CvarCloakConsumeRate = FindConVar("tf_spy_cloak_consume_rate");
	g_CvarCloakRegenRate = FindConVar("tf_spy_cloak_regen_rate");
	g_CvarCloakAttackTime = FindConVar("tf_spy_cloak_no_attack_time");
	g_CvarCloakInvisTime = FindConVar("tf_spy_invis_time");
	g_CvarCloakUnInvisTime = FindConVar("tf_spy_invis_unstealth_time");
	g_CvarBackstabMethod = FindConVar("tf_backstab_detection_method");
	
	g_CvarBackstabMethod = FindConVar("tf_backstab_detection_method");
	setConVarCheat(g_CvarBackstabMethod);
	
	g_CvarDroppedWeaponLifetime = FindConVar("tf_dropped_weapon_lifetime");
    
	SetConVars();

	PrintToChatAll("IntegriTF2 has been loaded.");
}

void setConVarCheat(ConVar convar)
{
	convar.Flags = convar.Flags |= FCVAR_CHEAT;
}

public void OnConVarChange(ConVar convar, char[] oldValue, char[] newValue)
{
	char convarVal[PLATFORM_MAX_PATH];
	char convarName[PLATFORM_MAX_PATH];
	convar.GetDefault(convarVal, strlen(convarVal));
	convar.GetName(convarName, strlen(convarName));
	
	if ( ! StrCompare(newValue, convarVal, false))
	{
		PrintToChatAll("IntegriTF2: Attempt to change cvar %s to %s (default %s), reverting changes...", convarName, newValue, convarVal);
	}
	// TODO: Revert changes
}
 

public void OnClientAuthorized(int iClient, const char[] sAuth)
{

}

public Action EventRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	PrintToChatAll("This Server is running IntegriTF2 version 1.2");
	return Plugin_Continue;
}
/**		     	   **/

/**********************************************************************************************/

/**r_drawothermodels 2 check part 2**/
public Action Event_player_spawn(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	QueryClientConVar(client, "r_drawothermodels", ConVarQueryFinished:ClientConVar, client);
	return Plugin_Continue;
}

public void ClientConVar(QueryCookie cookie, int client, ConVarQueryResult result, const char[] cvarName, const char[] cvarValue, any value) 
{ 
	char ClientName[64];
	GetClientName(client, ClientName, 64);
	
	if (client == 0 || !IsClientInGame(client)) 
	return; 
	if (result != ConVarQuery_Okay) 
	KickClient(client, "Unable to query %s", cvarName); 
	else if (StringToInt(cvarValue) == 2)
	{
	PrintToChatAll("Player %N is using CVar %s = %s", client, cvarName, cvarValue);
	} 
}  

/**Informs players if someone with RCON access disables plugin**/
public void OnPluginEnd()
{
	PrintToChatAll("IntegriTF2 has been unloaded");
}
