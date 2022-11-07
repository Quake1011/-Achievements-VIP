#pragma semicolon 1
#pragma tabsize 0

#include <vip_core>
#include <achievements>

public Plugin myinfo = 
{
	name = "[Achievements] VIP",
	author = "Quake1011",
	description = "Achievements module for VIP",
	version = "0.0.1",
	url = "https://github.com/Quake1011/"
}

public void OnPluginStart()
{
    if(Achievements_CoreIsLoad()) Achievements_OnCoreLoaded();
}

public void Achievements_OnCoreLoaded()
{
    Achievements_RegisterTrigger("vip_group", GetGroup);
}

void GetGroup(int iClient, const char[] outcome)
{
    char exp[2][64];
    //exp[0] - группа
    //exp[1] - время
    ExplodeString(outcome, "|", exp, sizeof(exp), sizeof(exp[]));
    if(VIP_IsClientVIP(iClient)) CreateChangeVIPMenu(iClient, exp[0], exp[1]);
    else VIP_GiveClientVIP(_, iClient, StringToInt(exp[1]), exp[0], true);
}

void CreateChangeVIPMenu(iClient, const char[] newGroup, const char[] time)
{
	char oldGroup[256], buffer[256], info[256];
    VIP_GetClientVIPGroup(iClient, oldGroup, sizeof(oldGroup));
	Menu hMenu = CreateMenu(Selector);
	hMenu.ExitButton = false;
    Format(buffer, sizeof(buffer), "Выберите один из вариантов");
	hMenu.SetTitle(buffer);
    Format(info, sizeof(info), "Оставить текущую: %s", oldGroup);
    hMenu.AddItem("", info);
    Format(info, sizeof(info), "Установить новую: %s", newGroup);
    hMenu.AddItem(time, info);
    Format(info, sizeof(info), "Выход");
    hMenu.AddItem("", info);
    hMenu.Display(iClient, 1);
}

public int Selector(Menu menu, MenuAction action, int client, int item)
{
    switch(action)
    {
        case MenuAction_Select:
        {
            if(item == 0) delete menu;
            else if(item == 1) 
            {
				char sTime[32], group[256];
				menu.GetItem(item, sTime, sizeof(sTime), _, group, sizeof(group));
                VIP_RemoveClientVIP2(0, client, true, false);
                VIP_GiveClientVIP(0, client, StringToInt(sTime), group, true);
            }
			else if(item == 2) delete menu;
        }
        case MenuAction_End: delete menu;
    }
    return 0;
}