#include codescripts\struct;
#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\main;
#include scripts\mp\func\functions;
#include scripts\mp\func\utility;
#include clientscripts\mp\_utility;
#include clientscripts\mp\_proximity_grenade;

setup_mines()
{
    switch(level.script)
    {
		case "mp_drone":
			mines = array((-1866.43, -991.17, 96.125), (-1392.99, -1110.64, 96.125), (-1684.41, -1977.96, 120.642), (-1305.24, -2110.6, 120.642), (-65.1644, -1305.27, -19.875));
			foreach(mine in mines)
			{
				thread mines(mine);
				print("Spawned a mine @ ^1" + mine);
			}
			break;
		default:
			break;
    }
}

mines(location)
{
	level endon("game_ended");
	self endon("disconnect");

	box_model = spawn( "script_model", location);
	box_model setmodel(getweaponmodel("bouncingbetty_mp"));
	
	while(1) 
	{
		foreach(player in level.players)
		{
			if(distance(location, player.origin) <= randomintrange(18,25))
			{
				player suicide();
			}
		}
		waiting();
	}
}

setup_crates()
{
	reward = [];
	reward[0] = "upgrade";
	reward[1] = "class";
	reward[2] = "strip";

	model = [];
	model[0] = "mp_flag_green";
	model[1] = "t6_wpn_supply_drop_trap";
	model[2] = "mp_flag_red";
	
	switch(getdvar("mapname"))
	{
		case "mp_nuketown_2020":
			location = array((-237.983, -542.812, -60.6306), (303.939, -511.525, -60.5));
			foreach(crate in location)
			{
				random_reward = reward[randomint(reward.size)];
				random_model = model[randomint(model.size)];
				thread loot_crate(undefined, crate, random_reward, random_model);
				print("Spawning a crate @ ^2" + crate + "^7! - Reward: ^5" + random_reward);
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

		if(player UseButtonPressed() && isAlive(player)) 
		{
			waiting();

			player notify("used");
			level.using = undefined;

			player playsound("fly_equipment_pickup_npc");

			player thread new_reward(reward);
			player thread proximity_shock_fx(box_model);

			box_trigger delete();
			box_model delete();
			box_phys delete();
			waiting();
			thread regen_crate(id, location, reward, model, phys, player);
			wait 4;
		}
	}
}

regen_crate(id,location,reward,model,phys,player)
{
    event(&"Claimed a crate!", player);
	wait (randomfloatrange(10,185));
	thread loot_crate(id,location,reward,model,phys);
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
		case "strip":
			self thread strip();
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

strip()
{
	list = self getWeaponsListPrimaries();
	foreach(weapon in list)
	{
		self takeweapon(weapon);
	}

	custom_class("knife_mp", "none", "Double Sniper", "none", "none");
	save_class(0,"knife_mp","none","none","none","Stripped");
}

weapon_upgrade()
{
	random_gun = randomize("mk48_mp+rf,mk48_mp+rf+silencer,qbb95_mp,qbb95_mp+rf+silencer,qbb95_mp+rf,lsat_mp+rf,lsat_mp+rf+silencer,hamr_mp,hamr_mp+rf,hamr_mp+rf+silencer,mp7_mp,mp7_mp+sf,mp7_mp+sf+dualclip+rf,mp7_mp+rf,pdw57_mp,pdw57_mp+sf,pdw57_mp+sf+rf,pdw57_mp+sf+rf+dualclip,pdw57_mp+dualclip,pdw57_mp+dualclip+rf,vector_mp,vector_mp+dualclip+sf+silencer,vector_mp+dualclip+silencer,vector_mp+rangefinder+sf+dualclip,insas_mp+rf+dualclip+sf,insas_mp+sf,insas_mp+sf+dualclip,insas_mp,qcw05_mp+rf+sf+dualclip,qcw05_mp+rf+sf,qcw05_mp+dualclip,qcw05_mp+sf,qcw05_mp,evoskorpion_mp+dualclip,evoskorpion_mp+dualclip+sf,evoskorpion_mp+dualclip+sf+rangefinder,peacekeeper_mp+dualclip+sf+silencer,peacekeeper_mp+rf+dualclip+silencer,tar21_mp+dualclip,tar21_mp+dualclip+sf,tar21_mp+dualclip+gl,type95_mp,type95_mp+dualclip,type95_mp+dualclip+mms,type95_mp+dualclip+sf,type95_mp+sf,sig556_mp+dualclip+sf,sig556_mp+sf+silencer,sig556_mp+sf+dualclip+silencer,sa58_mp+dualclip,sa58_mp+dualclip+sf,hk416_mp+dualoptic,hk416_mp+dualclip+silencer,scar_mp+sf,scar_mp,saritch_mp,saritch_mp+dualclip,saritch_mp+sf,xm8_mp+sf,xm8_mp,an94_mp+silencer+dualclip,srm1216_mp+mms+dualclip,870mcs_mp,870mcs_mp+silencer,ksg_mp,srm1216_mp,srm1216_mp+mms,ksg_mp+mms,ksg_mp+silencer,ksg_mp+silencer+dualclip,saiga12_mp+dualclip,crossbow_mp+stackfire,crossbow_mp+stackfire+ir,riotshield_mp,knife_ballistic_mp,smaw_mp,fhj18_mp,usrpg_mp,fhj18_mp,smaw_mp,tar21_mp+dualclip+rangefinder,tar21_mp+dualclip+rangefinder+sf,ballista_mp+is,kard_dw_mp,beretta93r_dw_mp,judge_dw_mp,fnp45_dw_mp,fnp45_mp+tacknife,beretta93r_mp+tacknife,riotshield_mp,srm1216_mp,870mcs_mp,ksg_mp,saiga12_mp+dualclip,saiga12_mp,knife_ballistic_mp,dsr50_mp,ballista_mp,hk416_mp+dualoptic+dualclip,mp7_mp+dualclip+rf,mp7_mp+dualclip+rf+sf,mp7_mp,mp7_mp+sf,pdw57_mp+dualclip,pdw57_mp+dualclip+sf,pdw57_mp+sf,vector_mp+rf+dualclip,vector_mp+dualclip,vector_mp+rf+sf,vector_mp+rf+sf+dualclip,vector_mp+rf+dualclip+silencer,vector_mp+silencer+sf+dualclip,evoskorpion_mp+dualclip,evoskorpion_mp+silencer+dualclip,peacekeeper_mp+dualclip,peacekeeper_mp+rf+dualclip,qbb95_mp,tar21_mp+dualclip,type95_mp+mms,sig556_mp+dualclip+silencer,sig556_mp+dualclip,sa58_mp,sa58_mp+dualclip,hk416_mp+dualclip,hk416_mp,scar_mp,saritch_mp,xm8_mp,an94_mp,an94_mp+dualclip,kard_mp,judge_mp,beretta93r_mp,fnp45_mp,fiveseven_mp,fiveseven_mp+dualclip,kard_mp+dualclip,beretta93r_mp+dualclip,fnp45_mp+dualclip,insas_mp+rf+sf,insas_mp+rf+sf+dualclip,insas_mp+dualclip+silencer,insas_mp+sf,qcw05_mp+rf+sf+dualclip,qcw05_mp+rf+sf,qcw05_mp+dualclip,qcw05_mp+sf,evoskorpion_mp+rf+sf+dualclip,evoskorpion_mp+rf+sf+silencer,evoskorpion_mp+rf+silencer+dualclip,peacekeeper_mp+dualclip+sf+silencer,peacekeeper_mp+dualclip+sf+rf,tar21_mp+gl+silencer,tar21_mp+gl+dualclip+silencer,mk48_mp+rf,mk48_mp+rf+silencer,qbb95_mp,qbb95_mp+rf+silencer,qbb95_mp+rf,lsat_mp+rf,lsat_mp+rf+silencer,hamr_mp,hamr_mp+rf,hamr_mp+rf+silencer,svu_mp+ir+steadyaim,as50_mp+ir+steadyaim,dsr50_mp+steadyaim,ballista_mp+steadyaim,dsr50_mp+dualclip+steadyaim,as50_mp+steadyaim,as50_mp+dualclip+steadyaim,svu_mp+steadyaim,svu_mp+dualclip+steadyaim");
	chance = randomint(10);

	if(chance > 5) thread update_primary(random_gun);
		else thread update_secondary(random_gun);
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