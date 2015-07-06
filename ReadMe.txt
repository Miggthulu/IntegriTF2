IntegriTF2
A SourceMod plugin that verifies the integrity of the Server and Player settings.

Why I made the Plugin:
So during the week I was toying around with the idea of a full anticheat plugin and realized that although admirable it's not the least bit feasible.
There were 2 main issues preventing me from doing so:
1) Group Sourcing such a project would reveal all the tidbits of how it worked and could possibly show people how to get around the stuff or even edit it to their liking
2) Something so in depth would require configuring on the Server Owners end which may end up being too complicated.

With this in mind I changed my goal (Sort of) to make things a lot simpler for server owners to do to set up this server with this plugin:
Drag and Drop
Yes, that simple.
If you're a UGC server owner you have FTP access to your server; This is what allows you to update your UGC Configs and add maps.
A vast majority of TF2 servers that are rented for the many various hosting providers either come with SourceMod PreInstalled or have a 1 click button that installs it for you. It's super simple.

But why install it? Knowing that some of these exploits exist I'm sure people on both the home and away teams would feel a lot better knowing that they are being completely blocked.
It rules out a bunch of potential 'bs' and accusations-without-merit from our matches. There really is no reason NOT to have this installed unless you are purposely avoiding it since it
has 0 effect on gameplay other than prevent these exploits from being executed.
And you guys aren't running exploits on purpose, right?


Currently Patched Exploits:
-Teleporter 120FOV exploit (Allows players to keep a 120FOV setting until player death) 
-Server command that can be toggled(Without notifying players) that can prevent a spy from being able to backstab
-Settings related to Spy Cloak Times
-Alters players when a player attempts to run r_drawothermodels 2 (read: player model wireframes)
-Alerts players if the plugin is unloaded during a match
-Settings that would allow one team to have a higher damage multiplier than the other
-Texture Based Wallhacks(ie: GameBanana Wallhacks) working despite the sv_pure 2 setting(REQUIRES SV_PURE 1!! See below)
-Disables the setting to allow players to pick up dropped weapons (Gun Mettal Update)
-Alerts players when protect server variables are changed
-Alerts Players in Server when a UGC Banned Player joins the game.*
*For now I've only added players who were banned for cheating and players who were banned at any point in 2015. It's a really long list so one of my next steps is to upgrade my plugin so
 updating that list will be relatively easy.

**If you guys are aware of any further in-game exploits please let me know and I'll try my best to add them in. Contact info can be found at the bottom of the ReadMe**


This plugin is 100% compliant with UGCs rules and regulations as stated here:

3.5.  Mods - Manimod, Sourcemod, AMX Mod and AMXX Mod and the like are allowed as long as they do not interfere with the match. A csay command here and there will be tolerated, as long as it
      was in the admin mod config and is not insulting to anybody. Admin mods may only be used for setting the config, checking the amount of time left, and changing maps.
	  Please disable all plugins that could affect any aspect of the match, including Donator plugins. If any player from the opposing team (the Visiting team) is kicked, banned or moved to
	  Spectator during a match for any reason due to any installed mod, the hosting team will forfeit all points earned during the round, unless the Visiting team agrees otherwise.
	  Let this be an incentive to either not run admin mods or to disable the plugins.



Installation Instructions:
All you have to do to install this plugin is to place it in your tf/addons/sourcemod/plugins/ directory as illustrated in the image below
http://i.imgur.com/WtXKguL.jpg
You can do this either through your native Windows, FileZilla, or any other FTP client.

**Note: In order for the Texture Based Wallhack patch to work your server must use sv_pure 1 settings.
The plugin will delete any existing sv_pure_whitelist.txt file that exist and create it's own that copies ALL the settings of sv_pure 2. Because of this, even if you type sv_pure
in console it will still show you that it's set to 2.
I have copied two varients of the ugc configs for both the sv_pure 1 and sv_pure 2 settings. Place the sv_pure 1 configs in your servers /tf/cfg folder as shown below
http://i.imgur.com/UWPEgNd.jpg


If you have any questions please feel free to Contact Myself or Mizx
http://steamcommunity.com/id/migeto
http://steamcommunity.com/id/mizx/