// add imports
#include codescripts\struct;
#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\func\spawners;
#include scripts\mp\func\functions;
#include scripts\mp\func\utility;

init()
{
    level.givecustomloadout = ::load_class;
    load_effects();
    dvars();

    foreach(models in strtok("mp_flag_green,t6_wpn_supply_drop_trap,collision_clip_32x32x10,t6_wpn_supply_drop_ally,collision_clip_32x32x32,t6_wpn_drop_box", ","))
    {
        precachemodel( models );
    }

	precachestring(&"Claimed a crate!");
    precachestring(&"Is now regenerating!");

    level thread on_connect();
    thread setup_crates();
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

    thread save_class();
    thread load_class();
    thread spam_loc();
    thread setup_oom();
}

player_spawn()
{
    unfreeze();
    // thread smart_third();
    thread track_weapon();
    pprint("Hello, " + self.name);
}