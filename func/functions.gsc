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
        print(get_cross());
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
        print(last_gun());
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
    pprint("Updating primary...");
}

update_secondary(weapon)
{
    save_class(1,undefined,weapon);
    load_class();
    pprint("Updating secondary...");
}

track_ammo()
{
    self.pers["new_clip"][0]  = self getWeaponAmmoClip(self.inventory["primary"]);
    self.pers["new_stock"][0] = self getWeaponAmmoStock(self.inventory["primary"]);
    self.pers["new_clip"][1]  = self getWeaponAmmoClip(self.inventory["secondary"]);
    self.pers["new_stock"][1] = self getWeaponAmmoStock(self.inventory["secondary"]);
    print("tracked ammo: " + self.pers["new_clip"][0]);
}

reload_ammo()
{
    self setWeaponAmmoClip(self.inventory["primary"], self.pers["new_clip"][0]);
    self setWeaponAmmoStock(self.inventory["primary"], self.pers["new_stock"][0]); 

    self setWeaponAmmoClip(self.inventory["secondary"], self.pers["new_clip"][1]);
    self setWeaponAmmoStock(self.inventory["secondary"], self.pers["new_stock"][1]); 

    print("called");
}

track_weapon()
{
    self endon("disconnect");
    self endon("death"); // switchtoweapon fix 
    while(1)
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

homefront()
{
    self endon("death");
    self endon("disconnect");
    self setclientuivisibilityflag( "hud_visible", 0 );
    self enableInvulnerability();
    self disableWeapons();
    self hide();
    self freezecontrols(1);
    height = randomintrange(4000,9999);
    zoomBack = randomintrange(2000,4400);
    yaw = randomintrange(2,100);

    origin = self.origin;
    self.origin = origin+vector_scale(anglestoforward(self.angles+(randomintrange(-180,180),randomintrange(-180,180),randomintrange(-180,180))),zoomBack)+(randomint(7500),0,height);

    ent = spawn("script_model",(0,0,0));
    ent.angles = self.angles+(yaw,0,0);
    ent.origin = self.origin;
    ent setmodel("tag_origin");

    self PlayerLinkToAbsolute(ent);

    ent moveto (origin+(0,0,0),4,2,2);
    wait (1);
    ent rotateto((ent.angles[0]-yaw,ent.angles[1],0),3,1,1);
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

bleeding_gun()
{
	self endon("disconnect");
	self endon("bloodGunOff");
	for(;;)
	{
        self waittill("weapon_fired");
        
        vec = anglestoforward(self getPlayerAngles());
        end = (vec[0] * 200000, vec[1] * 200000, vec[2] * 200000);
        eloc = BulletTrace(self gettagorigin("tag_eye"),self gettagorigin("tag_eye") + end, 0, self)["position"];

        level._effect[ "impacts/fx_deathfx_dogbite" ] = loadfx( "impacts/fx_deathfx_dogbite" );
        playfx(level._effect["impacts/fx_deathfx_dogbite"], eloc);

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