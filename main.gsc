// add imports
#include codescripts\struct;
#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\func\spawners\spawners;
#include scripts\mp\func\spawners\rewards;
#include scripts\mp\func\functions;
#include scripts\mp\func\utility;

init()
{
    level.givecustomloadout = ::load_class;
    load_effects();
    dvars();

    level.first_claimed = undefined;

    foreach(models in strtok("mp_flag_green,t6_wpn_supply_drop_trap,collision_clip_32x32x10,t6_wpn_supply_drop_ally,collision_clip_32x32x32,t6_wpn_drop_box,heli_supplydrop_mp,t6_wpn_supply_drop_detect", ","))
    {
        precachemodel( models );
    }

	precachestring(&"Claimed a crate!");
	precachestring(&"Claimed the first crate!");
    precachestring(&"Is now regenerating!");
    precachestring(&"Stripped!");
    
    thread on_connect();
    thread first_claimed();
    thread setup_boxes();
    thread setup_mines();
}

on_connect()
{
    level endon("game_ended");

    for(;;)
    {
    level waittill("connected", player);
    player thread on_event();
    }
}

on_event() 
{
    level endon( "game_ended" );
    self endon( "disconnect" );

    for( ;; ) 
    {
        event = self common_scripts\utility::waittill_any_return( "spawned_player", "death", "disconnect", "weapon_change" );
        switch( event ) 
        {
            case "spawned_player":
                thread first_spawn();
                thread player_spawn();
                break;
            case "weapon_change":
                thread manage_inventory(self getCurrentWeapon());
            default:
                break;
        }
    }
}

first_spawn()
{
    if(isDefined(self.pers["init"]))
        return;
    if(!isDefined(self.pers["init"]))
        setpers("init", true);

    self.unboxed = 0;

    thread save_class();
    thread load_class();
    thread spam_loc();
    thread setup_oom();
}

player_spawn()
{
    // unfreeze();
    // thread smart_third();
    //thread homefront();

    // set new ammo data before we track ammo again
    if (isdefined(self.pers["new_clip"]) && isdefined(self.pers["new_stock"]))
    {
        reload_ammo();
    }

    thread track_ammo();
    thread track_weapon();
    thread instant_frag();
    thread shock_bullets();

    unfreeze();
    //pprint("Hello, " + self.name);
}
