#pragma semicolon 1
#include <sourcemod>
#include <geoipcity>
#include <socket>
//#include <smjansson>
#undef REQUIRE_PLUGIN
#include <updater>

#define PLUGIN_VERSION "2.3"

#define CVAR_MAXLEN 64

#define API_BANLIST_HOST "kimonolabs.com"
#define API_BANLIST_DIR "/api/efs80kbe?apikey=mwluOVdQfLoQZ1kkWFujhsJzvFKXgc8n"

#define UPDATE_URL "http://miggthulu.com/integritf2/updatefile.txt"

#define MAX_URL_LENGTH 256
#define API_BANLIST_URL "http://kimonolabs.com/api/efs80kbe?apikey=mwluOVdQfLoQZ1kkWFujhsJzvFKXgc8n"

//#include "helpers/download_socket.sp"
#include "helpers/filesys.sp"

public Plugin myinfo = {
	name        = "IntegriTF2",
	author      = "Miggy, mizx and friends",
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
ConVar g_CvarDroppedWeaponLifetime;

int g_TeleFovStart = 90;
int g_DroppedWeaponLifetime = 0;

float g_CheckClientConVarsMin = 15.0;
float g_CheckClientConVarsMax = 60.0;

void initConVar(ConVar convar)
{
	if (convar == INVALID_HANDLE)
		return;
	convar.AddChangeHook(OnConVarChanged);
	resetConVar(convar);
}

void resetConVar(ConVar convar)
{
	if (convar == g_CvarTeleFovStart)
	{
		// if convar is TeleFovStart, change to 90 from default of 120
		// the exploit allows users to keep 120 after teleporting
		convar.SetInt(g_TeleFovStart, true, true);
	}
	else if (convar == g_CvarDroppedWeaponLifetime)
		convar.SetInt(0, true, true);
	else
		convar.RestoreDefault(true, true);
}

public void OnPluginStart()
{
	/** Starts IP Logging **/
	SetConVarInt(FindConVar("sm_paranoia_ip_verbose"), 1, true);

	/** Hook Round Start event for a tournament mode game **/
	HookEvent("teamplay_round_start", EventRoundStart);
	HookEvent("player_spawn", Event_Player_Spawn);
	
	/** Team Based Exploits **/
	g_CvarDmgMultiBlu = FindConVar("tf_damage_multiplier_blue");
	g_CvarDmgMultiRed = FindConVar("tf_damage_multiplier_red");
	initConVar(g_CvarDmgMultiBlu);
	initConVar(g_CvarDmgMultiRed);
	
	/** Engineer Tele Exploit Fix **/
	g_CvarTeleFovStart = FindConVar("tf_teleporter_fov_start");
	g_CvarTeleFovTime = FindConVar("tf_teleporter_fov_time");
	initConVar(g_CvarTeleFovStart);
	initConVar(g_CvarTeleFovTime);
	
	/** Spy Cloak Exploit Prevention **/
	g_CvarCloakConsumeRate = FindConVar("tf_spy_cloak_consume_rate");
	g_CvarCloakRegenRate = FindConVar("tf_spy_cloak_regen_rate");
	g_CvarCloakAttackTime = FindConVar("tf_spy_cloak_no_attack_time");
	g_CvarCloakInvisTime = FindConVar("tf_spy_invis_time");
	g_CvarCloakUnInvisTime = FindConVar("tf_spy_invis_unstealth_time");
	initConVar(g_CvarCloakConsumeRate);
	initConVar(g_CvarCloakRegenRate);
	initConVar(g_CvarCloakAttackTime);
	initConVar(g_CvarCloakInvisTime);
	initConVar(g_CvarCloakUnInvisTime);
	
	g_CvarDroppedWeaponLifetime = FindConVar("tf_dropped_weapon_lifetime");
	initConVar(g_CvarDroppedWeaponLifetime);
	
	CreateTimer(5.0, Timer_CheckClientConVars);
	
	//CheckBanlistApi();
	/**
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin(UPDATE_URL);
	}
	**/

	PrintToChatAll("[IntegriTF2] has been loaded.");
}

public OnLibraryAdded(const String:name[])
{
	if (StrEqual(name, "updater"))
	{
		Updater_AddPlugin(UPDATE_URL);
	}
}

stock setConVarCheat(ConVar convar)
{
	convar.Flags = convar.Flags |= FCVAR_CHEAT;
}

public void OnConVarChanged(ConVar convar, char[] oldValue, char[] newValue)
{
	char convarDefault[CVAR_MAXLEN];
	char convarName[CVAR_MAXLEN];
	convar.GetDefault(convarDefault, sizeof(convarDefault));
	convar.GetName(convarName, sizeof(convarName));
	
	if (convar == g_CvarTeleFovStart)
	{
		IntToString(g_TeleFovStart, convarDefault, sizeof(convarDefault));
	}
	else if (convar == g_CvarDroppedWeaponLifetime)
	{
		IntToString(g_DroppedWeaponLifetime, convarDefault, sizeof(convarDefault));
	}
	
	if (StringToInt(convarDefault) != StringToInt(newValue))
	{
		PrintToChatAll("[IntegriTF2] Attempt to change cvar %s to %s (looking for %s), reverting changes...", convarName, newValue, convarDefault);
		resetConVar(convar);
	}
}

public void OnClientAuthorized(int client, const char[] sAuth)
{
	char ip[17], city[45], region[45], country_name[45], country_code[3], country_code3[4];
	GetClientIP(client, ip, sizeof(ip));
	GeoipGetRecord(ip, city, region, country_name, country_code, country_code3);
	
	if (StrContains(country_name, "Anonymous", false) != -1 || StrContains(country_name, "Proxy", false) != -1) {
		PrintToChatAll("IntegriTF2: Detecting player %N is using a proxy.", client);
	}
}

public Action EventRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	PrintToChatAll("[IntegriTF2] This Server is running IntegriTF2 version %s", PLUGIN_VERSION);
	return Plugin_Continue;
}

public Action Event_Player_Spawn(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	QueryClientConVar(client, "r_drawothermodels", ConVarQueryFinished:ClientConVar);
	return Plugin_Continue;
}

public void ClientConVar(QueryCookie cookie, int client, ConVarQueryResult result, const char[] cvarName, const char[] cvarValue, any value) 
{ 
	if (client == 0 || !IsClientInGame(client)) 
		return; 
	
	if (result != ConVarQuery_Okay) 
		PrintToChatAll("[IntegriTF2] Unable to check CVar %s on player %N.", cvarName, client);
	else if (StringToInt(cvarValue) == 2)
		PrintToChatAll("[IntegriTF2] Player %N is using CVar %s = %s, potentially exploiting.", client, cvarName, cvarValue); 
}

public Action:Timer_CheckClientConVars(Handle:timer)
{
	for (new client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerAlive(client))
		{
			QueryClientConVar(client, "r_drawothermodels", ConVarQueryFinished:ClientConVar, client);
		}
	}
	
	CreateTimer(GetRandomFloat(g_CheckClientConVarsMin, g_CheckClientConVarsMax), Timer_CheckClientConVars);
}

public void OnPluginEnd()
{
	PrintToChatAll("[IntegriTF2] has been unloaded.");
}

/**
void CheckBanlistApi()
{
	Download_Socket(API_BANLIST_URL, "ugc_banlist.json");
	//new Handle:hSocket = SocketCreate(SOCKET_TCP, OnSocketError);
	
	//SocketSetArg(hSocket, hFile);
	//SocketConnect(hSocket, OnSocketConnected, OnSocketReceive, OnSocketDisconnected, "kimonolabs.com", 80);
}
**/

void DownloadEnded(bool successful, char error[]="")
{
	if ( ! successful) {
		LogError("Download attempt failed: %s", error);
		return;
	}
	
}