#pragma semicolon 1
#include <sourcemod>
#include <clients>
#define CONFIG_PATH "configs/IntCfg.cfg"

public Plugin:myinfo = {
	name        = "IntegriTF2",
	author      = "Miggy and friends",
	url         = "miggthulu.com"
};

/**********************************************************************************************/

//Creates a Static SteamID and IP Banlist. On player connect it checks their SteamID and IPs with those that are on the list//
new Handle:g_hPlayerList;

public OnPluginStart()
{

new String:sPath[PLATFORM_MAX_PATH];
BuildPath(Path_SM, sPath, sizeof(sPath), CONFIG_PATH);

new Handle:hFile = OpenFile(sPath, "w");
WriteFileLine(hFile, "\"root\"");
WriteFileLine(hFile, "{");
WriteFileLine(hFile, "\t// \"steamid\" \"ip\"");

WriteFileLine(hFile, "\t//Players Banned for Cheating");

//Season 15
WriteFileLine(hFile, "\"STEAM_0:1:2835540\" \"IP\""); //Elmo //NO IP
WriteFileLine(hFile, "\"STEAM_0:0:53901708\" \"IP\""); //GbenCursory
WriteFileLine(hFile, "\"STEAM_0:1:74581064\" \"IP\""); //Friezer //NO IP
WriteFileLine(hFile, "\"STEAM_0:1:20306010\" \"IP\""); //Dank Matter
WriteFileLine(hFile, "\"STEAM_0:1:20306010\" \"IP\""); //Dank Matter
WriteFileLine(hFile, "\"STEAM_0:1:107680770\" \"IP\""); //King Dave //Is Dank matter^^
WriteFileLine(hFile, "\"STEAM_0:0:49354656\" \"IP\""); //Razz Skrub
WriteFileLine(hFile, "\"STEAM_0:1:53641754\" \"IP\""); //Peakaboo
WriteFileLine(hFile, "\"STEAM_0:0:78231405\" \"IP\""); //DoYouMind
WriteFileLine(hFile, "\"STEAM_0:0:78231405\" \"IP\""); //DoYouMind
WriteFileLine(hFile, "\"STEAM_0:1:50224175\" \"IP\""); //Frank Reynolds //NO IP
WriteFileLine(hFile, "\"STEAM_0:1:64548553\" \"IP\""); //cl0wn //NO IP
WriteFileLine(hFile, "\"STEAM_0:0:86860480\" \"IP\""); //cl0wn //NO IP

//Season 16
WriteFileLine(hFile, "\"STEAM_0:1:106504484\" \"IP\""); //4g VivaLaVida
WriteFileLine(hFile, "\"STEAM_0:0:91646796\" \"IP\""); //Swordfish, VivaLaVida ALT
WriteFileLine(hFile, "\"STEAM_0:0:99579555\" \"IP\""); //Arani
WriteFileLine(hFile, "\"STEAM_0:1:108351137\" \"IP\""); //Red Medic
WriteFileLine(hFile, "\"STEAM_0:0:59380627\" \"IP\""); //Mr Master
WriteFileLine(hFile, "\"STEAM_0:0:88027879\" \"IP\""); //Luc
WriteFileLine(hFile, "\"STEAM_0:0:110948773\" \"IP\""); //Deliscous, LUC Alt
WriteFileLine(hFile, "\"STEAM_0:0:52214012\" \"IP\""); //Mike
WriteFileLine(hFile, "\"STEAM_0:0:73163035\" \"IP\""); //Dovahkiin NR LFT
WriteFileLine(hFile, "\"STEAM_0:1:21067488\" \"IP\""); //Flawless
WriteFileLine(hFile, "\"STEAM_0:1:89229497\" \"IP\""); //April, Flawless Alt
WriteFileLine(hFile, "\"STEAM_0:0:106865077\" \"IP\""); //FoXXy, Flawless Alt
WriteFileLine(hFile, "\"STEAM_0:1:9546511\" \"IP\""); //Rondego
WriteFileLine(hFile, "\"STEAM_0:0:20304074\" \"IP\""); //Heavy Whuppins Guy
WriteFileLine(hFile, "\"STEAM_0:0:10979589\" \"IP\""); //Heavy Whuppins Alt
WriteFileLine(hFile, "\"STEAM_0:0:83819423\" \"IP\""); //Mr64Bit
WriteFileLine(hFile, "\"STEAM_0:0:68058500\" \"IP\""); //Icoter
WriteFileLine(hFile, "\"STEAM_0:1:28240569\" \"IP\""); //Ari
WriteFileLine(hFile, "\"STEAM_0:1:54433150\" \"IP\""); //Mittens
WriteFileLine(hFile, "\"STEAM_0:0:10384388\" \"IP\""); //KittyKatty, Mittens Alt


WriteFileLine(hFile, "\t//Players Banned for Sportmanship/Behavioral issues");

//Season 15
WriteFileLine(hFile, "\"STEAM_0:0:48847930\" \"75.80.160.121\""); //Typho
WriteFileLine(hFile, "\"STEAM_0:0:48847930\" \"76.93.167.249\""); //Typho
WriteFileLine(hFile, "\"STEAM_0:0:48847930\" \"72.130.191.239\""); //Typho
WriteFileLine(hFile, "\"STEAM_0:0:45581793\" \"IP\""); //apple //NO IP
WriteFileLine(hFile, "\"STEAM_0:0:29038647\" \"74.96.231.197\""); //iShank
WriteFileLine(hFile, "\"STEAM_0:0:55194042\" \"188.79.171.35\""); //Sl4w
WriteFileLine(hFile, "\"STEAM_0:1:76940024\" \"69.132.3.168\""); //PinkCommando

//Season 16
WriteFileLine(hFile, "\"STEAM_0:1:50245576\" \"IP\""); //Discario
WriteFileLine(hFile, "\"STEAM_0:1:40342961\" \"IP\""); //Arbi
WriteFileLine(hFile, "\"STEAM_0:1:82636480\" \"IP\""); //Theta, Arbi Alt
WriteFileLine(hFile, "\"STEAM_0:1:37516202\" \"IP\""); //Lennon

WriteFileLine(hFile, "}");
CloseHandle(hFile);


    // create dynamic array (adt_array) structure
if (g_hPlayerList != INVALID_HANDLE) {
        CloseHandle(g_hPlayerList);
    }
g_hPlayerList = CreateArray(64);

    // open config
new Handle:hKV = CreateKeyValues("root");
if (!FileToKeyValues(hKV, sPath)) {
        CloseHandle(hKV);
        LogError("Cannot load data from file '%s' !", sPath);
        return;
}

    // read condig
if (!KvGotoFirstSubKey(hKV, false)) {
        LogError("Cannot load first key from file '%s' !", sPath);
        CloseHandle(hKV);
        return;
}

new String:sSteamID[64], String:sIP[64];
do
    {
        KvGetSectionName(hKV, sSteamID, sizeof(sSteamID));
        KvGetString(hKV, NULL_STRING, sIP, sizeof(sIP));
        
        //LogMessage("SteamID = '%s', IP = '%s'", sSteamID, sIP);
        
        PushArrayString(g_hPlayerList, sSteamID);
        PushArrayString(g_hPlayerList, sIP);
} while (KvGotoNextKey(hKV, false));

CloseHandle(hKV);
//


//On Round Start PSA part 1//
HookEvent("teamplay_round_start",PSABroadcast);

//Searches Client Cvar for mismatching r_drawothermodels value - part 1//
HookEvent("player_spawn", Event_player_spawn);

//Logs Connecting Players and Searches for Possible Alters//
//HookEvent("player_connect",WhoAreYou);
//HookEvent("player_connect",AlterGTFO);


//informs users that Plugin has been loaded//
PrintToChatAll("IntegriTF2 has been loaded");


//Team Based Damage Multipliers//
SetConVarInt(FindConVar("tf_damage_multiplier_blue"), 1, true);
SetConVarInt(FindConVar("tf_damage_multiplier_red"), 1, true);


//Engineer Tele Exploit Fix//
SetConVarInt(FindConVar("tf_teleporter_fov_start"), 90, true);
SetConVarFloat(FindConVar("tf_teleporter_fov_time"), 0.5, true);


///Spy Cloak CVar lockdown//
SetConVarInt(FindConVar("tf_spy_cloak_consume_rate"), 10, true);
SetConVarFloat(FindConVar("tf_spy_cloak_regen_rate"),  3.3, true);
SetConVarFloat(FindConVar("tf_spy_cloak_no_attack_time"), 2.0, true);
SetConVarFloat(FindConVar("tf_spy_invis_time"), 1.0, true);
SetConVarFloat(FindConVar("tf_spy_invis_unstealth_time"), 2.0, true);
SetConVarInt(FindConVar("tf_backstab_detection_method"), 1, true);


//sv_pure 2 bypass prevention. Servers server to sv_pure 1 and//
//deletes any pre-existing whitelist, replacing it with this one//
ServerCommand("sv_pure 1");  
new Handle:file = OpenFile("cfg/pure_server_whitelist.txt", "w");
WriteFileLine(file,"materials/...           					trusted_source");
WriteFileLine(file,"models/...              					trusted_source");
WriteFileLine(file,"sound/...               					trusted_source");
WriteFileLine(file,"particles/...           					trusted_source");
WriteFileLine(file,"scripts/game_sounds.txt 					trusted_source");
WriteFileLine(file,"scripts/game_sounds_manifest.txt         	trusted_source");
WriteFileLine(file,"scripts/game_sounds_player.txt           	trusted_source");
WriteFileLine(file,"scripts/game_sounds_vo.txt               	trusted_source");
WriteFileLine(file,"scripts/game_sounds_vo_handmade.txt      	trusted_source");
WriteFileLine(file,"scripts/game_sounds_weapons.txt          	trusted_source");
WriteFileLine(file,"scripts/soundmixers.txt                  	trusted_source");
WriteFileLine(file,"sound/ui/hitsound.wav                    	any");
CloseHandle(file);


//Changes flag for tf_backstab_detection_method to require sv_cheats to be enabled//
new flags, Handle:cvar = FindConVar("tf_backstab_detection_method");
flags = GetConVarFlags(cvar);
flags |= FCVAR_NOTIFY;
SetConVarFlags(cvar, flags);
CloseHandle(cvar);


//Pickup of Dropped Items
SetConVarInt(FindConVar("tf_dropped_weapon_lifetime"), 0, true);


}

/**********************************************************************************************/

//Second half of the SteamID/IP Checker. When a matching player connects it announces it in chat//
public OnClientAuthorized(iClient, const String:sAuth[])
{
new String:sIP[64];
GetClientIP(iClient, sIP, sizeof(sIP));

if (FindStringInArray(g_hPlayerList, sAuth) != -1) {
        // connected player's ip or steamid is in config
PrintToChatAll("%N is currently Banned in UGC", iClient);
}
	
if (FindStringInArray(g_hPlayerList, sIP) != -1 ) {
        // connected player's ip or steamid is in config
PrintToChatAll("%N is using IP Address which is associated with a Banned UGC Player", iClient);
}

}

/**********************************************************************************************/

//On Round Start PSA execution//
public Action:PSABroadcast(Handle:event,const String:name[],bool:dontBroadcast)
{
PrintToChatAll("This Server is running IntegriTF2 version 1.3");
return Plugin_Continue;
}

/**********************************************************************************************/

//r_drawothermodels 2 check part 2. Checks client CVar//
public Action:Event_player_spawn(Handle:event, const String:name[], bool:dontBroadcast)
{
new client = GetClientOfUserId(GetEventInt(event, "userid"));
QueryClientConVar(client, "r_drawothermodels", ConVarQueryFinished:ClientConVar, client);
return Plugin_Continue;
}

public void ClientConVar(QueryCookie cookie, int client, ConVarQueryResult result, const char[] cvarName, const char[] cvarValue, any value) 
{ 
decl String:ClientName[64];
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

/**********************************************************************************************/


//Alerts when plugin is unloaded before map end//
public OnPluginEnd()
{
PrintToChatAll("IntegriTF2 has been unloaded");

//Deletes Static SteamID/IP list//
new String:sPath[PLATFORM_MAX_PATH];
BuildPath(Path_SM, sPath, sizeof(sPath), CONFIG_PATH);

new Handle:hFile = OpenFile(sPath, "w");
WriteFileLine(hFile, "\"root\"");
WriteFileLine(hFile, "{");
WriteFileLine(hFile, "\t// \"steamid\" \"ip\"");
WriteFileLine(hFile, "}");
CloseHandle(hFile);

}


/**********************************************************************************************/
