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

    self switchtoweapon( weap1 );
}

save_class(update,primary,secondary,lethal,tactical,name)
{
    // for first spawn pretty much to setup default class
    if(!isDefined(self.new_class))
    {
        self.new_class = [];
        if(!isDefined(primary))
            primary = "dsr50_mp+dualclip+steadyaim";
        if(!isDefined(secondary))
            secondary = "ballista_mp+dualclip+steadyaim";
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
        primary = isDefined(primary) ? primary : self.new_class["primary"];
        secondary = isDefined(secondary) ? secondary : self.new_class["secondary"];
        lethal = isDefined(lethal) ? lethal : self.new_class["lethal"];
        tactical = isDefined(tactical) ? tactical : self.new_class["tactical"];
        name = isDefined(name) ? name : self.new_class["name"];
        
        self.new_class["primary"] = primary;
        self.new_class["secondary"] = secondary;
        self.new_class["lethal"] = lethal;
        self.new_class["tactical"] = tactical;
        self.new_class["name"] = name;

        return;
    }

	self.new_class["primary"] = primary;
	self.new_class["secondary"] = secondary;
	self.new_class["lethal"] = lethal;
	self.new_class["tactical"] = tactical;
	self.new_class["name"] = name;
}

load_class()
{
    custom_class(self.new_class["primary"], self.new_class["secondary"], self.new_class["name"], self.new_class["lethal"], self.new_class["tactical"]);
}

update_class()
{
    save_class(1,"mp7_mp");
    load_class();
    pprint("Updating class...", 1);
}