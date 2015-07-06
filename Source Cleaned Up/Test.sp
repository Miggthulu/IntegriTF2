#include <sourcemod>

#define CONFIG_PATH "configs/IntCfg.cfg"

public Plugin:myinfo =
{
    name = "test",
    author = "Raska",
    description = "",
    version = "0.1",
    url = ""
}

new Handle:g_hPlayerList;

public OnPluginStart()
{
    new String:sPath[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, sPath, sizeof(sPath), CONFIG_PATH);

/**
    // create config file if doesn't exist
    if (!FileExists(sPath)) {
        new Handle:hFile = OpenFile(sPath, "w");
        WriteFileLine(hFile, "\"root\"");
        WriteFileLine(hFile, "{");
        WriteFileLine(hFile, "\t// \"steamid\" \"ip\"");
        WriteFileLine(hFile, "}");
        CloseHandle(hFile);
    }
**/
//if (!FileExists(sPath)) {
new Handle:hFile = OpenFile(sPath, "w");
WriteFileLine(hFile, "\"root\"");
WriteFileLine(hFile, "{");
WriteFileLine(hFile, "\t// \"steamid\" \"ip\"");
WriteFileLine(hFile, "\t//Players Banned for Cheating");
WriteFileLine(hFile, "\"STEAM_0:0:28605759\" \"141.225.76.212\"");
WriteFileLine(hFile, "\"STEAM_0:0:22046396\" \"73.1.44.155\"");
WriteFileLine(hFile, "\"STEAM_0:0:22046355\" \"73.1.44.164\"");
WriteFileLine(hFile, "\"STEAM_0:0:4055834\" \"99.108.98.52\"");
WriteFileLine(hFile, "\"STEAM_0:1:15967867\" \"74.130.8.194\"");
WriteFileLine(hFile, "\"STEAM_0:0:49151841\" \"146.85.237.191\"");
WriteFileLine(hFile, "\"STEAM_0:1:37101756\" \"128.226.231.95\"");
WriteFileLine(hFile, "\"STEAM_0:1:37101755\" \"128.226.231.94\"");

WriteFileLine(hFile, "\"STEAM_0:1:2835540\" \"IP\""); //Elmo
WriteFileLine(hFile, "\"STEAM_0:0:53901708\" \"73.188.128.136\""); //GbenCursory
WriteFileLine(hFile, "\"STEAM_0:1:74581064\" \"IP\""); //Friezer
WriteFileLine(hFile, "\"STEAM_0:1:20306010\" \"74.240.165.224\""); //Dank Matter
WriteFileLine(hFile, "\"STEAM_0:1:107680770\" \"IP\""); //King Dave
WriteFileLine(hFile, "\"STEAM_0:0:49354656\" \"98.255.26.92\""); //Razz Skrub
WriteFileLine(hFile, "\"STEAM_0:1:53641754\" \"162.233.57.2\""); //Peakaboo
WriteFileLine(hFile, "\"STEAM_0:0:78231405\" \"86.153.90.191\""); //DoYouMind
WriteFileLine(hFile, "\"STEAM_0:1:50224175\" \"IP\""); //Frank Reynolds
WriteFileLine(hFile, "\"STEAM_0:1:64548553\" \"IP\""); //cl0wn
WriteFileLine(hFile, "\t//Players Banned for Sportmanship/Behavioral issues");
WriteFileLine(hFile, "\"STEAM_0:0:48847930\" \"75.80.160.121\""); //Typho
WriteFileLine(hFile, "\"STEAM_0:0:48847930\" \"76.93.167.249\""); //Typho
WriteFileLine(hFile, "\"STEAM_0:0:48847930\" \"72.130.191.239\""); //Typho
WriteFileLine(hFile, "\"STEAM_0:0:45581793\" \"IP\""); //apple
WriteFileLine(hFile, "\"STEAM_0:0:29038647\" \"74.96.231.197\""); //iShank
WriteFileLine(hFile, "\"STEAM_0:0:55194042\" \"188.79.171.35\""); //Sl4w
WriteFileLine(hFile, "\"STEAM_0:0:38001010\" \"IP\""); //Vinny
WriteFileLine(hFile, "\"STEAM_0:0:68717487\" \"118.92.99.84\""); //Cianaatech
WriteFileLine(hFile, "\"STEAM_0:1:76940024\" \"69.132.3.168\""); //PinkCommando
WriteFileLine(hFile, "\"STEAM_0:1:66183407\" \"172.249.139.210\""); //Kazu
WriteFileLine(hFile, "}");
CloseHandle(hFile);
//}


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
}  

public OnClientAuthorized(iClient, const String:sAuth[])
{
new String:sIP[64];
GetClientIP(iClient, sIP, sizeof(sIP));


/**
    if (FindStringInArray(g_hPlayerList, sAuth)|| FindStringInArray(g_hPlayerList, sIP)){
	if ((FindStringInArray(g_hPlayerList, sAuth) != -1) || (FindStringInArray(g_hPlayerList, sIP) != -1)) {
if (FindStringInArray(g_hPlayerList, sAuth) != -1 || FindStringInArray(g_hPlayerList, sIP) != -1 ) {
        // connected player's ip or steamid is in config
		PrintToChatAll("ARRAY LENGTH: %d", GetArraySize(g_hPlayerList));
		PrintToChatAll("%N is currently Banned in UGC", iClient);
    }
**/



if (FindStringInArray(g_hPlayerList, sAuth) != -1) {
        // connected player's ip or steamid is in config
PrintToChatAll("%N is currently Banned in UGC", iClient);
//PrintToConsole("Banned Player SteamID Connected");
}
	
if (FindStringInArray(g_hPlayerList, sIP) != -1 ) {
        // connected player's ip or steamid is in config
PrintToChatAll("%N is using IP Address which is associated with a Banned UGC Player", iClient);
//PrintToConsole("Banned Player IP Connected")
}

}