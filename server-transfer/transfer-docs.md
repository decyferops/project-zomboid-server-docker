# Instructions to migrate local multiplayer server as a dedicated one on another host

Here we will cover how to move a local server that you hosted from the in-game option, to play with your friends, as a dedicated server on another host (in the cloud, or self-hosted).

---

= Get to -> C:\Users\Decyfer\Zomboid\Server
- List all servers present and allow user to specify server name to be transferred
$ - User Input - Give local zomboid server name
$ - User Input - Destination Server IP
$ - User Input - Destination Server user that has SSH access configured
$ - User Input - Destination Server PZ Template path (Fresh server files)




# TODO: Optionally list mods n stuff

= In the local repo
- List all present ini server config
(Allow user to select one of the present configurations)
$ - User Input - Give server config name ini
- List all present lua game config
(Allow user to select one of the present configurations)
$ - User Input - Give game config name lua

---

First of all, locate your local Zomboid folder.

Windows: 
`C:\Users\<username>\Zomboid\`
Linux: 
`~/Zomboid/`

## Transfer data

1/
In the "Server" subfolder, you will find configuration files for each server or hosted game that you’ve set up. They will be named `<servername>.ini`, `<servername>_SandboxVars.lua`, `<servername>_spawnregions.lua` and so on. 
Copy or upload these files into the same location on the server.

2/
In the `Saves/Multiplayer/<servername>` you will find all the world save information, which includes items, zombies, players, vehicles etc. Also copy or upload this folder to the server’s `Multiplayer` folder.

## IMPORTANT
```
I do not recommend to change the server name in these files and folders.
I have not tested what happens when you do. 
Certain database files refer to the server name so changing it could have adverse effects.
```

## Transferring Player data
Located in `<servername>.db`

When you move from an in-game hosted server to a dedicated one, the account system the game uses is slightly different. In essence this means that those who’ve been playing in your world before might not be able to log into the same characters they've played as before, and instead have to create a new character altogether.

Actually, when you join a hosted game, the game will create an account for you locked to your Steam ID, and uses your current Steam profile name for the account name. When you log into a dedicated server, you have to specify a name and password yourself.

When you create a character, it will be bound to a specific username. Your Steam profile name on a hosted server or the account name on a dedicated server. When switching to a dedicated server, you have two options:

    * Create accounts with the same account names as your Steam profile names. Due to the character being bound to the same name, everything matches up. This won’t work if you had special symbols in your Steam name, which you can’t type in-game.

    * Fix up the names the characters are bound to, so the person logging into an account with a certain name will get a certain character assigned. This works even when creating new accounts after renaming the character’s username.

If every player from the old hosted server can create accounts with the Steam name they used... gg. If not sadge.

## Transfer Map information
After your server owner has successfully transferred your characters and you can once again log in with your desired account name into the newly set-up dedicated server, you might find one little thing being wrong: Your map data is missing. No explored areas are visible, and all your custom markers are gone.

This is because this information is actually stored on your computer, and not the server. And there’s currently no way for the game to realize that, after a server has been moved, the old and new server are actually the same.

To fix this, we need to transfer the map data from the hosted server over to the dedicated server. (Make sure you’ve logged into the new server at least once.)

From the Zomboid folder `Zomboid\` go to `Saves` and then `Multiplayer`. There is one folder for each server you've joined. Format is `<steamid>_<servername>_player` (using the steam id of the player who hosted the game). Dedicated servers have the format `<address>_<port>_...`

Once you’ve found the right folders, delete the files inside the dedicated server folder (destination) to which you want to copy the map information. Then copy the files from the hosted game folder into the dedicated server folder.

## Transferring Mods
Locally you can find them at `<steamdir>\steamapps\workshop\content\108600\<mod_id>\mods\<mod_name>`

They are put into the server config `<servername>.ini` file like
```
Mods=autotsartrailers;tsarslib;ATA_Bus;BetterSortCC;Brita_2;
...
WorkshopItems=2282429356;2392709985;2592358528;2313387159;2460154811;
```

For transferring we can read the local file structure and populate the config file.
Use the script `get-local-mods.ps1` as most people play on windows made sense to write it in poweshell.
It will output the workshop IDs and the Mod IDs that you can paste into the config.