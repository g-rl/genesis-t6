#include codescripts\struct;
#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\main;
#include scripts\mp\func\functions;
#include scripts\mp\func\utility;
#include clientscripts\mp\_utility;
#include clientscripts\mp\_proximity_grenade;
#include scripts\mp\func\spawners\spawners;

on_strip() 
{
    level endon( "game_ended" );
    self endon( "disconnect" );
	
    for( ;; ) 
    {
        event = self common_scripts\utility::waittill_any_return( "stripped", "unstripped" );
        switch( event ) 
        {
            case "stripped":
                break;
            case "unstripped":
				break;
            default:
                break;
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
		case "strip":
			self thread strip();
			break;
		default:
            self thread weapon_upgrade();
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

	self notify("stripped");

	foreach(weapon in list)
	{
		self takeweapon(weapon);
	}

	event(&"Stripped!", self);
	custom_class("knife_mp", "none", "Stripped", "hatchet_mp", "willy_pete_mp");
	save_class(1,"knife_mp","none","hatchet_mp","willy_pete_mp","Stripped");
}

weapon_upgrade()
{
	random_gun = randomize("mk48_mp+rf,mk48_mp+rf+silencer,qbb95_mp,qbb95_mp+rf+silencer,qbb95_mp+rf,lsat_mp+rf,lsat_mp+rf+silencer,hamr_mp,hamr_mp+rf,hamr_mp+rf+silencer,mp7_mp,mp7_mp,mp7_mp+dualclip+rf,mp7_mp+rf,pdw57_mp,pdw57_mp,pdw57_mp+rf,pdw57_mp+rf+dualclip,pdw57_mp+dualclip,pdw57_mp+dualclip+rf,vector_mp,vector_mp+dualclip+silencer,vector_mp+dualclip+silencer,vector_mp+rangefinder+dualclip,insas_mp+rf+dualclip,insas_mp,insas_mp+dualclip,insas_mp,qcw05_mp+rf+dualclip,qcw05_mp+rf,qcw05_mp+dualclip,qcw05_mp,qcw05_mp,evoskorpion_mp+dualclip,evoskorpion_mp+dualclip,evoskorpion_mp+dualclip+rangefinder,peacekeeper_mp+dualclip+silencer,peacekeeper_mp+rf+dualclip+silencer,tar21_mp+dualclip,tar21_mp+dualclip,tar21_mp+dualclip+gl,type95_mp,type95_mp+dualclip,type95_mp+dualclip+mms,type95_mp+dualclip,type95_mp,sig556_mp+dualclip,sig556_mp+silencer,sig556_mp+dualclip+silencer,sa58_mp+dualclip,sa58_mp+dualclip,hk416_mp+dualoptic,hk416_mp+dualclip+silencer,scar_mp,scar_mp,saritch_mp,saritch_mp+dualclip,saritch_mp,xm8_mp,xm8_mp,an94_mp+silencer+dualclip,srm1216_mp+mms+dualclip,870mcs_mp,870mcs_mp+silencer,ksg_mp,srm1216_mp,srm1216_mp+mms,ksg_mp+mms,ksg_mp+silencer,ksg_mp+silencer+dualclip,saiga12_mp+dualclip,crossbow_mp+stackfire,crossbow_mp+stackfire+ir,riotshield_mp,knife_ballistic_mp,smaw_mp,fhj18_mp,usrpg_mp,fhj18_mp,smaw_mp,tar21_mp+dualclip+rangefinder,tar21_mp+dualclip+rangefinder,ballista_mp+is,kard_dw_mp,beretta93r_dw_mp,judge_dw_mp,fnp45_dw_mp,fnp45_mp+tacknife,beretta93r_mp+tacknife,riotshield_mp,srm1216_mp,870mcs_mp,ksg_mp,saiga12_mp+dualclip,saiga12_mp,knife_ballistic_mp,dsr50_mp,ballista_mp,hk416_mp+dualoptic+dualclip,mp7_mp+dualclip+rf,mp7_mp+dualclip+rf,mp7_mp,mp7_mp,pdw57_mp+dualclip,pdw57_mp+dualclip,pdw57_mp,vector_mp+rf+dualclip,vector_mp+dualclip,vector_mp+rf,vector_mp+rf+dualclip,vector_mp+rf+dualclip+silencer,vector_mp+silencer+dualclip,evoskorpion_mp+dualclip,evoskorpion_mp+silencer+dualclip,peacekeeper_mp+dualclip,peacekeeper_mp+rf+dualclip,qbb95_mp,tar21_mp+dualclip,type95_mp+mms,sig556_mp+dualclip+silencer,sig556_mp+dualclip,sa58_mp,sa58_mp+dualclip,hk416_mp+dualclip,hk416_mp,scar_mp,saritch_mp,xm8_mp,an94_mp,an94_mp+dualclip,kard_mp,judge_mp,beretta93r_mp,fnp45_mp,fiveseven_mp,fiveseven_mp+dualclip,kard_mp+dualclip,beretta93r_mp+dualclip,fnp45_mp+dualclip,insas_mp+rf,insas_mp+rf+dualclip,insas_mp+dualclip+silencer,insas_mp,qcw05_mp+rf+dualclip,qcw05_mp+rf,qcw05_mp+dualclip,qcw05_mp,evoskorpion_mp+rf+dualclip,evoskorpion_mp+rf+silencer,evoskorpion_mp+rf+silencer+dualclip,peacekeeper_mp+dualclip+silencer,peacekeeper_mp+dualclip+rf,tar21_mp+gl+silencer,tar21_mp+gl+dualclip+silencer,mk48_mp+rf,mk48_mp+rf+silencer,qbb95_mp,qbb95_mp+rf+silencer,qbb95_mp+rf,lsat_mp+rf,lsat_mp+rf+silencer,hamr_mp,hamr_mp+rf,hamr_mp+rf+silencer,svu_mp+ir+steadyaim,as50_mp+ir+steadyaim,dsr50_mp+steadyaim,ballista_mp+steadyaim,dsr50_mp+dualclip+steadyaim,as50_mp+steadyaim,as50_mp+dualclip+steadyaim,svu_mp+steadyaim,svu_mp+dualclip+steadyaim");
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
	save_class(1,sniper,sniper2,frag,tactical,"Double Sniper");
}