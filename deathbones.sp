/*  SM death bones
 *
 *  Copyright (C) 2017 Francisco 'Franc1sco' García
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>


#pragma semicolon 1

#define VERSION "v1.2"



public Plugin:myinfo = 
{
	name = "SM death bones",
	author = "Franc1sco Steam: franug",
	description = "Convert dead player to skeleton",
	version = VERSION,
	url = "http://steamcommunity.com/id/franug"
};

public OnPluginStart()
{

	CreateConVar("sm_deathbones_version", VERSION, "version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);

        RegConsoleCmd("kill", MatarseEsq);
}


public OnMapStart()
{
        AddFileToDownloadsTable("models/player/slow/bones/bones.dx80.vtx");
        AddFileToDownloadsTable("models/player/slow/bones/bones.dx90.vtx");
        AddFileToDownloadsTable("models/player/slow/bones/bones.mdl");
        AddFileToDownloadsTable("models/player/slow/bones/bones.phy");
        AddFileToDownloadsTable("models/player/slow/bones/bones.sw.vtx");
        AddFileToDownloadsTable("models/player/slow/bones/bones.vvd");
        AddFileToDownloadsTable("models/player/slow/bones/bones.xbox.vtx");
        AddFileToDownloadsTable("materials/models/player/slow/bones/slow_bones.vmt");
        AddFileToDownloadsTable("materials/models/player/slow/bones/slow_bones.vtf");
        AddFileToDownloadsTable("materials/models/player/slow/bones/slow_bones_bump.vtf");

	PrecacheModel("models/player/slow/bones/bones.mdl");
}

//public Action:Esqueleto(Handle:event, const String:name[], bool:dontBroadcast)
//{
//    new client = GetClientOfUserId(GetEventInt(event, "userid"));

    //new ClientHealth = GetClientHealth(client);
    //new Damage_Recibido = GetEventInt(event, "dmg_health");

    //new Vida = GetClientHealth(client) - GetEventInt(event, "dmg_health");

    //if (Vida <= 0)
    //{
//    SetEntityModel(client, "models/player/slow/bones/bones.mdl");
    //}

//    return Plugin_Continue;
//}

public OnClientPutInServer(client)
{
   SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamageEsq);
}

public Action:MatarseEsq(client,args)
{
                 if (GetClientTeam(client) > 1)
                 {
                   if (IsPlayerAlive(client))
                   {
                       SetEntityModel(client, "models/player/slow/bones/bones.mdl");
                   }
                 }
}

public Action:OnTakeDamageEsq(client, &attacker, &inflictor, &Float:damage, &damagetype)
{
   if (!IsValidClient(attacker))
   {
       if(damage >= GetClientHealth(client))
       {
            SetEntityModel(client, "models/player/slow/bones/bones.mdl");
       }
   }

   else if (GetClientTeam(attacker) != GetClientTeam(client))
   {
       if(damage >= GetClientHealth(client))
       {
            SetEntityModel(client, "models/player/slow/bones/bones.mdl");
       }
   }

   return Plugin_Continue;
}

public IsValidClient( client ) 
{ 
    if ( !( 1 <= client <= MaxClients ) || !IsClientInGame(client) ) 
        return false; 
     
    return true; 
}