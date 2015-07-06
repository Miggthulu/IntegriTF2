#pragma semicolon 1

#include <sourcemod>
//#include <connect>
#include <geoipcity>
//#include <firepowered_core>

#pragma newdecls required

public Plugin myinfo = {
        name            = "[ANY] Proxy Blocker",
        author          = "Dr. McKay",
        description     = "Blocks connections from some proxies",
        version         = "2.0.0",
        url                     = "http://www.doctormckay.com"
};

//public bool OnClientPreConnectEx(const char[] name, char password[255], const char[] ip, const char[] steamID, char rejectReason[255]) {
public bool OnClientConnect(const char[] name, char password[255], const char[] ip, const char[] steamID, char rejectReason[255]) {
        char city[45], region[45], country_name[45], country_code[3], country_code3[4];
        GeoipGetRecord(ip, city, region, country_name, country_code, country_code3);
        if(StrContains(country_name, "Anonymous", false) != -1 || StrContains(country_name, "Proxy", false) != -1) {
                strcopy(rejectReason, sizeof(rejectReason), "Connections from proxies and VPNs are not allowed. Please disconnect your proxy/VPN and then rejoin the game.");
                //FP_SendAdminNotice("Rejected proxy connection from %s [%s] [%s] (%s)", name, steamID, ip, country_name);
                return false;
        }
        
        return true;
}