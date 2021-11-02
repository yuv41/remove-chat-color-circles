#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#pragma semicolon 1
#pragma newdecls required

enum colours
{
    GREY = -1,
    YELLOW = 0,
    PURPLE = 1,
    GREEN = 2,
    BLUE = 3,
    ORANGE = 4,
}

bool loaded_player_colours = false;
int player_colours[MAXPLAYERS + 1];
public Plugin myinfo =
{
	name = "Remove chat team colors",
	author = "B3none, yuv",
	description = "Removes team colors from chat.",
	version = "1.0.0",
	url = "https://github.com/b3none / https://github.com/yuv41/"
};

public void OnClientPostAdminCheck(int client)
{
	player_colours[client] = -1;
}
public void OnMapStart()
{
	int playerManager = GetPlayerResourceEntity();
	if (playerManager == -1)
	{
		SetFailState("Unable to find cs_player_manager entity");
	}
	
	SDKHook(playerManager, SDKHook_ThinkPost, OnThinkPost);
}

public void OnThinkPost(int entity)
{
	int offset = FindSendPropInfo("CCSPlayerResource", "m_iCompTeammateColor");
	
	if (!loaded_player_colours)
	{
		GetEntDataArray(entity, offset, player_colours, MAXPLAYERS + 1);
		loaded_player_colours = true;
	}
	
	if (offset > 0)
	{
		SetEntDataArray(entity, offset, player_colours, MAXPLAYERS + 1, _, true);
	}
}