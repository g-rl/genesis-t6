#include codescripts\struct;
#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\main;
#include scripts\mp\func\utility;
#include scripts\mp\func\spawners;

spam_loc()
{
    while(true)
    {
        print(self.origin);
        wait 1;
    }
}

custom_class( weap1, weap2, name, eq1, eq2 )
{
    weapons = array(weap1,weap2,eq1,eq2);
    
    self.classnameplayerp = name;
    self.camo = self calcweaponoptions( self.class_num, 0 );

    self takeallweapons();

    foreach(weap in weapons)
    {
        self giveweapon(weap, 0, self.camo, 1, 0, 0, 0);
    }

    if(isDefined(self.lastgun) && self.lastgun != "none")
    {
        if(self.lastgun != weap && self.lastgun != weap2)
        {
            self switchtoweapon( weap1 );
            return;
        }

        self switchtoweapon(self.lastgun);
        return;
    }

    self switchtoweapon( weap1 );
}

save_class(update,primary,secondary,lethal,tactical,name)
{
    // for first spawn pretty much to setup default class
    if(!isDefined(self.inventory))
    {
        self.inventory = [];
        if(!isDefined(primary))
            primary = "knife_mp";
        if(!isDefined(secondary))
            secondary = "none";
        if(!isDefined(lethal))
            lethal = "hatchet_mp";
        if(!isDefined(tactical))
            tactical = "sensor_grenade_mp";
        if(!isDefined(name))
            name = "Starter Class";
    }

    // update weapons without fucking up other guns
    if(isDefined(update))
    {
        primary = isDefined(primary) ? primary : self.inventory["primary"];
        secondary = isDefined(secondary) ? secondary : self.inventory["secondary"];
        lethal = isDefined(lethal) ? lethal : self.inventory["lethal"];
        tactical = isDefined(tactical) ? tactical : self.inventory["tactical"];
        name = isDefined(name) ? name : self.inventory["name"];
        
        self.inventory["primary"] = primary;
        self.inventory["secondary"] = secondary;
        self.inventory["lethal"] = lethal;
        self.inventory["tactical"] = tactical;
        self.inventory["name"] = name;

        return;
    }

    self.inventory["primary"] = primary;
    self.inventory["secondary"] = secondary;
    self.inventory["lethal"] = lethal;
    self.inventory["tactical"] = tactical;
    self.inventory["name"] = name;
}

load_class()
{
    custom_class(self.inventory["primary"], self.inventory["secondary"], self.inventory["name"], self.inventory["lethal"], self.inventory["tactical"]);
}

update_class(weapon)
{
    save_class(1,weapon);
    load_class();
    pprint("Updating class...", 1);
}

track_weapon()
{
    self endon("disconnect");
    self endon("death"); // switchtoweapon fix 
    while(1)
    {
        self.lastgun = self getCurrentWeapon();
        wait 0.05;
    }
}

last_gun()
{
    return self.lastgun;
}
