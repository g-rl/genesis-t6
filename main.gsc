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

    foreach(models in strtok("collision_clip_32x32x10,t6_wpn_supply_drop_ally,collision_clip_32x32x32,t6_wpn_drop_box", ","))
    {
        precachemodel( models );
    }

    level thread on_connect();
    thread loot_crate("hi");
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
        event = self common_scripts\utility::waittill_any_return( "spawned_player", "death" );
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

    // make sure classes load on spawn properly
    thread save_class();
    thread load_class();

    thread spam_loc();
    pprint("Oh, this only runs once..");
}

player_spawn()
{
    self setclientthirdperson(true);

    unfreeze();
    thread smart_third();
    thread track_weapon();
    pprint("Hello, " + self.name);
}

smart_third() // add for snipers only prob and might not use at all who knows
{
    while(true)
    {
        if(self adsbuttonpressed())
        {
            if(!isDefined(self.waiting) && self adsButtonPressed()) 
            {
                self.waiting = true;
                wait 0.3;
                self setclientthirdperson(false);
                self.waiting = undefined;
            }
        } else {
            self setclientthirdperson(true);
        }
        waiting();
    }
}