#include codescripts\struct;
#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\main;
#include scripts\mp\func\functions;
#include scripts\mp\func\utility;
#include clientscripts\mp\_utility;
#include clientscripts\mp\_proximity_grenade;

setup_crates()
{
	reward = [];
	reward[0] = "upgrade";
	reward[1] = "class";

	switch(getdvar("mapname"))
	{
		case "mp_nuketown_2020":
			location = array((-237.983, -542.812, -60.6306), (303.939, -511.525, -60.5));
			foreach(crate in location)
			{
				random_reward = reward[randomint(reward.size)];
				thread loot_crate("Nukebox", crate, random_reward);
				print("Spawning a crate @ ^2" + crate + "^7!");
			}
			break;
		default:
			break;
	}
}

loot_crate(id, location, reward, model, phys) 
{
	level endon("game_ended");

	hint = "[{+usereload}] ^7to open!";
	model = "t6_wpn_drop_box";
	phys = "collision_clip_32x32x32";

	box_trigger = spawn( "trigger_radius", (location), 1, 45, 45 );
	box_trigger setHintString(hint);
	box_trigger SetCursorHint("HINT_NOICON");

	box_model = spawn( "script_model", location + (0,3,18)); 
	box_model setmodel(model);

	box_phys = spawn( "script_model", location + (0,3,18)); 
	box_phys setmodel(phys);

	waiting();

	while(1) 
	{

		box_trigger waittill( "trigger", player );
		box_trigger setHintString(hint);
		box_trigger SetCursorHint("HINT_NOICON"); 

		thread slightly_loop_till_usage(box_model);

		if(player UseButtonPressed()) 
		{
			waiting();

			player notify("used");
			level.using = undefined;

			player playsound("fly_equipment_pickup_npc");

			player thread new_reward(reward);
			player thread proximity_shock_fx(box_model);

			box_trigger Delete();
			box_model Delete();
			box_phys Delete();
			waiting();
			wait 4;
		}
	}
}



new_reward(reward)
{
	switch(reward)
	{
		case "class":
			self thread class_reward();
			break;
		case "upgrade":
			self thread weapon_upgrade();
			break;
		default:
			break;
	}
}

class_reward()
{
	c = [];
	c[0] = ::class_doublesniper;

	funct = c[randomint(c.size)]; 
	self thread [[funct]]();
}

weapon_upgrade()
{
	thread update_primary("dsr50_mp");
	thread update_secondary("mp7_mp");
}

class_doublesniper()
{
	sniper = randomize("svu_mp+ir+steadyaim,as50_mp+ir+steadyaim,dsr50_mp+steadyaim,ballista_mp+steadyaim,dsr50_mp+dualclip+steadyaim,as50_mp+steadyaim,as50_mp+dualclip+steadyaim,svu_mp+steadyaim,svu_mp+dualclip+steadyaim");
	sniper2 = randomize("ballista_mp,dsr50_mp,ballista_mp+dualclip,ballista_mp+acog,ballista_mp+is,dsr50_mp+dualclip,dsr50_mp+dualclip+silencer,ballista_mp+dualclip+silencer");
	tactical = randomize("emp_grenade_mp,concussion_grenade_mp,proximity_grenade_mp,sensor_grenade_mp");
	frag = randomize("hatchet_mp,pda_hack_mp,sticky_grenade_mp,frag_grenade_mp,satchel_charge_mp,tactical_insertion_mp,bouncingbetty_mp,claymore_mp");
	streak = randomize("counteruav_mp,inventory_supplydrop_mp,rcbomb_mp,remote_missile_mp,turret_drop_mp,killstreak_qrdrone_mp,inventory_minigun_mp,inventory_m32_mp");

	custom_class(sniper, sniper2, "Double Sniper", frag, tactical);
	save_class(0,sniper,sniper2,frag,tactical,"Double Sniper");
}

sfx(fx, origin)
{
	if(!isDefined(origin)) origin = self.origin;
	if(!isDefined(level._effect[fx])) self iprintln("Invalid FX!"); // ?
	playfx(level._effect[fx], origin);
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

proximity_shock_fx(box_model)
{
	for(e=0;e<20;e++) playfx(level._effect["prox_grenade_player_shock"], self.origin + (0,randomint(100), 0));
}

setup_oom()
{
    switch(level.script)
    {
		case "mp_nuketown_2020":
			thread oom((42.7598, -589.359, -66.8514), (44.4079, -645.641, -66.7719));
			break;
		default:
			break;
    }
}

oom(enter, exit)
{
	level endon("game_ended");
	self endon("disconnect");

	while(1) 
	{
		if(distance(enter, self.origin) <= 15)
		{
			if(!isDefined(self.exiting))
			{
			self setOrigin(exit);
			self thread exit_bind(enter);
			}
		}
		waiting();
	}
}

exit_bind(enter)
{	
	self endon("disconnect");
	self endon("exited");
	self endon("death");

	pprint("Press [{+actionslot 1}] to go back!", 1);

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