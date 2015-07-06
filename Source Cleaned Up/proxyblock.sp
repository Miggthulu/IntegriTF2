#pragma semicolon 1
#include <sourcemod>
#include <geoipcity>
#pragma newdecls required

public Plugin myinfo = {
        name            = "[ANY] Proxy Blocker",
        author          = "Dr. McKay",
        description     = "Blocks connections from some proxies",
        version         = "2.0.0",
        url                     = "http://www.doctormckay.com"
};


public void OnClientConnected(int client) {
        char ip[17], city[45], region[45], country_name[45], country_code[3], country_code3[4];
        GetClientIP(client, ip, sizeof(ip));
        GeoipGetRecord(ip, city, region, country_name, country_code, country_code3);
		PrintToChatAll("Player %s is connecting from %s  %s  %s", client, country_name, country_code, country_code3);
        if(StrContains(country_name, "Anonymous", false) != -1 || StrContains(country_name, "Proxy", false) != -1) {
                PrintToChatAll("intgreTF2: detecting %N is using a proxy.", client);
        }
       // player is not using a proxy
}