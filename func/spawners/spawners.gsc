#include codescripts\struct;
#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\main;
#include scripts\mp\func\functions;
#include scripts\mp\func\utility;
#include scripts\mp\func\spawners\rewards;
#include clientscripts\mp\_utility;
#include clientscripts\mp\_proximity_grenade;

setup_boxes()
{
	reward = [];
	reward[0] = "upgrade";
	reward[1] = "strip";

	model = [];
	model[0] = "t6_wpn_supply_drop_trap";
	model[1] = "t6_wpn_drop_box";
	model[2] = "t6_wpn_supply_drop_detect";

	nuke_boxes = array((-1742.4, 864.073, -61.9404), (1556.59, 1133.85, -57.9496), (-837.497, 43.0865, -56.875), (-938.661, 706.467, 79.125), (-237.983, -542.812, -60.6306), (303.939, -511.525, -60.5),(-47.0096, 1092.19, -47.875), (473.588, 1008.81, -63.6191), (718.81, 650.331, -59));

	switch(getdvar("mapname"))
	{
		case "mp_nuketown_2020":
			foreach(crate in nuke_boxes)
			{
				random_reward = reward[randomint(reward.size)];
				random_model = model[randomint(model.size)];
				thread loot_crate(undefined, crate, random_reward, random_model);
				thread mines(crate);
			}
			break;
		default:
			break;
	}
}

setup_mines()
{
	drone_mines = array((-1866.43, -991.17, 96.125), (-1392.99, -1110.64, 96.125), (-1684.41, -1977.96, 120.642), (-1305.24, -2110.6, 120.642), (-65.1644, -1305.27, -19.875));
	nuke_mines = array((531.709, 984.58, -62.303), (641.09, -217.193, -61.3677), (-583.47, 612.627, 79.6036));

    switch(level.script)
    {
		case "mp_drone":
			foreach(mine in drone_mines)
			{
				thread mines(mine);
				print("Spawned a mine @ ^1" + mine);
			}
			break;
		case "mp_nuketown_2020":
			foreach(mine in nuke_mines)
			{
				thread mines(mine);
				print("Spawned a mine @ ^1" + mine);
			}
			break;
		default:
			break;
    }
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

mines(location)
{
	level endon("game_ended");
	self endon("disconnect");

	box_model = spawn( "script_model", location);
	box_model setmodel(getweaponmodel("bouncingbetty_mp"));

	thread mines_fx(box_model);

	while(1) 
	{
		foreach(player in level.players)
		{
			if(distance(location, player.origin) <= randomintrange(27,50) && isAlive(player))
			{
				if(player getStance() == "prone") continue; // prone safety

				playfx(level.chopper_fx["fire"]["trail"]["large"], player.origin);
				
				// tick before damaging
				tick = randomintrange(1,6);
				for(i=0;i<tick;i++)
				{
					player playsound("uin_alert_lockon");
					wait 0.25;
				}

				player playsound("mpl_rc_exp");
				playfx(level.chopper_fx["explode"]["guard"], player.origin);

				// real random damage instead of suicide
				player thread [[level.callbackPlayerDamage]] ( self, self, randomintrange(35,150), 8, "MOD_EXPLOSIVE", "bouncingbetty_mp", ( 0, 0, 0 ), ( 0, 0, 0 ), "pelvis", 0, 0);
				wait 2;
			}
		}
		waiting();
	}
}

loot_crate(id, location, reward, model, phys) 
{
	level endon("game_ended");

	hint = "[{+usereload}] ^7to open!";
	phys = "collision_clip_32x32x32";

	box_trigger = spawn("trigger_radius", (location), 1, 45, 45);
	box_trigger setHintString(hint);
	box_trigger SetCursorHint("HINT_NOICON");

	box_model = spawn("script_model", location + (0,3,18)); 
	box_model setmodel(model);

	box_phys = spawn("script_model", location + (0,3,18)); 
	box_phys setmodel(phys);
	
	waiting();

	while(1) 
	{

		box_trigger waittill( "trigger", player );
		box_trigger setHintString(hint);
		box_trigger SetCursorHint("HINT_NOICON"); 

		// thread slightly_loop_till_usage(box_model);

		if(player UseButtonPressed() && isAlive(player)) 
		{
			waiting();

			player notify("used");
			level.using = undefined;

			player playlocalsound("fly_equipment_pickup_npc");

			player thread new_reward(reward);
			// player thread proximity_shock_fx(box_model);

			playfx(level.chopper_fx["explode"]["death"], box_model.origin);

			box_trigger delete();
			box_model delete();
			box_phys delete();

			waiting();
			
			thread regen_crate(id, location, reward, model, phys, player);

			player.unboxed++;

			wait 4;
		}
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