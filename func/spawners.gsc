#include codescripts\struct;
#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\main;
#include scripts\mp\func\functions;
#include scripts\mp\func\utility;

loot_crate(id, location, reward, model, phys) 
{
	level endon("game_ended");

	location = (-6252.36, 113.963, 44.125);

	print("Spawned a crate at " + location.origin);

	hint = "[{+usereload}] ^7to open!";
    model = "t6_wpn_drop_box";
	phys = "collision_clip_32x32x32";
	reward = "class";

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

		if(player UseButtonPressed()) 
		{
			waiting();
			player thread new_reward(reward);
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