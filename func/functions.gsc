#include codescripts\struct;
#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\main;
#include scripts\mp\func\utility;
#include scripts\mp\func\spawners\spawners;
#include scripts\mp\func\spawners\rewards;

track_position()
{
    while(true)
    {
        dprint(get_cross());
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

    if(isDefined(last_gun()) && last_gun() != "none")
    {
        if(last_gun() == weap2) // make sure weapon orders are correct
        {
        weapons = array(weap2,weap1,eq1,eq2);
        self takeallweapons();
        }

        foreach(weap in weapons)
        {
            self giveweapon(weap, 0, self.camo, 1, 0, 0, 0);
        }

        if(last_gun() != weap && last_gun() != weap2)
        {
            self switchtoweapon( weap1 );
            return;
        }

        self switchtoweapon(last_gun());
        dprint(last_gun());
        return;
    }
    self switchtoweapon( weap1 );
    // reload_ammo();
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
    most_perks();
}

update_primary(weapon)
{
    save_class(1,weapon);
    load_class();
    self switchToWeapon(inventory()[0]);
    msg("Updating primary...");
}

update_secondary(weapon)
{
    save_class(1,undefined,weapon);
    load_class();
    self switchToWeapon(inventory()[1]);
    msg("Updating secondary...");
}

update_lethal(weapon)
{
    save_class(1,undefined,undefined,weapon,undefined);
    load_class();
    msg("Updating lethal...");
}

update_tactical(weapon)
{
    save_class(1,undefined,undefined,undefined,weapon);
    load_class();
    msg("Updating tactical...");
}

track_ammo()
{
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");

    self.pers["new_clip"] = [];
    self.pers["new_stock"] = [];

    while(true)
    {
        self.pers["new_clip"][0]  = self getWeaponAmmoClip(self.inventory["primary"]);
        self.pers["new_clip"][1]  = self getWeaponAmmoClip(self.inventory["secondary"]);
        self.pers["new_stock"][0] = self getWeaponAmmoStock(self.inventory["primary"]);
        self.pers["new_stock"][1] = self getWeaponAmmoStock(self.inventory["secondary"]);
        wait 0.05;
    }
}

reload_ammo()
{
    self setWeaponAmmoClip(self.inventory["primary"], self.pers["new_clip"][0]);
    self setWeaponAmmoStock(self.inventory["primary"], self.pers["new_stock"][0]); 
    self setWeaponAmmoClip(self.inventory["secondary"], self.pers["new_clip"][1]);
    self setWeaponAmmoStock(self.inventory["secondary"], self.pers["new_stock"][1]); 
}

track_last_weapon()
{
    self endon("disconnect");
    self endon("death"); // switchtoweapon fix 
    level endon("game_ended");

    while(true)
    {
        self.lastgun = self getCurrentWeapon();
        waiting();
    }
}

last_gun()
{
    return self.lastgun;
}

smart_third() // add for snipers only prob and might not use at all who knows
{
    while(true)
    {
        if(self adsbuttonpressed())
        {
            self setclientthirdperson(false);
        } else {
            self setclientthirdperson(true);
        }
        waiting();
    }
}

spawn_animation()
{
    self endon("death");
    self endon("disconnect");
    self setclientuivisibilityflag( "hud_visible", 0 );
    self enableInvulnerability();
    self disableWeapons();
    self hide();
    self freezecontrols(1);

    // ensure random spawn animations
    height = randomintrange(0,9999);
    back = randomintrange(0,4400);
    yaw = randomintrange(2,100);

    origin = self.origin;
    self.origin = origin+vector_scale(anglestoforward(self.angles+(randomintrange(-180,180),randomintrange(-180,180),randomintrange(-180,180))),back)+(randomint(7500),0,height);

    ent = spawn("script_model",(0,0,0));
    ent.angles = self.angles + ( yaw, 0, 0 );
    ent.origin = self.origin;
    ent setmodel("tag_origin");

    self PlayerLinkToAbsolute(ent);

    ent moveto (origin + (0,0,0), 4, 2, 2);
    wait (1);
    ent rotateto((ent.angles[0] - yaw, ent.angles[1], 0), 3, 1, 1);
    wait (0.5);
    self playlocalsound("ui_camera_whoosh_in"); 
    wait (2.5);
    self unlink();
    wait (0.2);
    ent delete();
    
    self Show();
    self freezecontrols(0);
    self disableInvulnerability();
    self enableWeapons();
    self setclientuivisibilityflag( "hud_visible", 1 );
}

instant_frag()
{
    // im either retarded or death & disconnect r the same thing
    self endon("disconnect");
    self endon("death");

    for(;;)
    {
        self waittill("grenade_fire", grenade, weapname);
        grenade thread instant_explode();
    }
}

instant_explode()
{
	self waittill("grenade_bounce");
	self resetmissiledetonationtime(0);
}

shock_bullets()
{
	self endon("disconnect");
	self endon("bloodGunOff");
	for(;;)
	{
        self waittill("weapon_fired");
        playfx(level._effect["prox_grenade_player_shock"], get_cross());
        waiting();
	}
	waiting();
}

give_ammo( amount )
{
    currentweapon = self getcurrentweapon();
    clipammo = self getweaponammoclip( currentweapon );
    self setweaponammoclip( currentweapon, clipammo + amount );
}

regen_crate(id,location,reward,model,phys,player)
{
	if(!isDefined(level.first_claimed))
		level notify("first_claimed", player);

	// event(&"Claimed a crate!", player);
	wait (randomfloatrange(10,185));
	thread loot_crate(id, location, random_reward(), random_model(), phys); // rewrite phys later
}

first_claimed()
{
	level waittill("first_claimed", player);
	level.first_claimed = 1;
	event(&"Claimed the first crate!", player);
}

exit_bind(enter)
{	
	self endon("disconnect");
	self endon("exited");
	self endon("death");

	msg("Press [{+actionslot 1}] to go back!", 1);

	while(1)
	{
		if(self ActionSlotOneButtonPressed())
		{
			self.exiting = true;
			self setOrigin(enter);
			wait 3;
			self.exiting = undefined;
			self notify("exited");
		}
		waiting();
	}
}

mines_fx(box_model)
{
	level endon("game_ended");

	while(1)
	{
		playfx(level._effect["prox_grenade_player_shock"], box_model.origin);
		wait 1;
	}
}

slightly_loop_till_usage(box_trigger)
{
	level endon("disconnect");
	level endon("used");

	if(isDefined(level.using))
		return;

	while(1)
	{
		playfx(level._effect["qrdrone_prop"], box_trigger.origin);
		playfx(level._effect["heli_comlink_light"]["friendly"], box_trigger.origin - (85,0,25));
		playfx(level._effect["rcbomb_enemy_light"], box_trigger.origin);
		playfx(level._effect["rcbomb_friendly_light"], box_trigger.origin);
		wait 6;
	}
}