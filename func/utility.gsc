#include codescripts\struct;
#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\main;
#include scripts\mp\func\functions;

inventory()
{
    return array(self.inventory["primary"], self.inventory["secondary"], self.inventory["lethal"], self.inventory["tactical"], self.inventory["name"]);
}

check_inventory(weap)
{
    if(in_inventory(weap)) 
        dprint("In Inventory: " + weap);
    else
        dprint("Not In Inventory: " + weap);
}

manage_inventory(weap)
{
    if(!IsInArray(inventory(), weap))
    {
        if(weap == "none") return;
        
        self takeweapon(weap);
        self playlocalsound("mpl_crate_enemy_steals");
        self switchToWeapon(inventory()[0]);
    }
}

in_inventory(weap)
{
    if(IsInArray(inventory(), weap)) 
        return true;
    else
        return false;
}

setpers(pers, val)
{
    if(!isDefined(self.pers[pers]))
        self.pers[pers] = val;

    self.pers[pers] = val;
}

getpers(pers)
{
    return self.pers[pers];
}

void()
{
    /*
    level.cratemodelfriendly = "t6_wpn_supply_drop_ally";
    level.cratemodelenemy = "t6_wpn_supply_drop_axis";
    level.cratemodelhacker = "t6_wpn_supply_drop_detect";
    level.cratemodeltank = "t6_wpn_drop_box";
    level.cratemodelboobytrapped = "t6_wpn_supply_drop_trap";
    level.supplydrophelicopterfriendly = "veh_t6_drone_supply";
    level.supplydrophelicopterenemy = "veh_t6_drone_supply_alt";
    level.suppydrophelicoptervehicleinfo = "heli_supplydrop_mp";
    */
}

msg(message, type)
{
    if(isDefined(type)) self iprintlnbold(message);
        else self iprintln(message);
}

unfreeze()
{
    self freezecontrols(0);
}

waiting()
{
    wait 0.03;
}

randomize(array)
{
    arr = strtok(array, ",");
    random = randomint(arr.size);
    shuffle = arr[random];
    return shuffle;
}

load_effects()
{
    level._effect["rcbomb_enemy_light"] = loadfx( "vehicle/light/fx_rcbomb_blinky_light" );
    level._effect["rcbomb_friendly_light"] = loadfx( "vehicle/light/fx_rcbomb_solid_light" );
    level._effect["rcbomb_enemy_light_blink"] = loadfx( "vehicle/light/fx_rcbomb_light_red_os" );
    level._effect["rcbomb_friendly_light_blink"] = loadfx( "vehicle/light/fx_rcbomb_light_green_os" );
    level._effect["rcbomb_stunned"] = loadfx( "weapon/grenade/fx_spark_disabled_rc_car" );
}

most_perks() // cleanup later
{
    self setperk("specialty_additionalprimaryweapon");
    self setperk("specialty_armorpiercing");
    self setperk("specialty_bulletaccuracy");
    self setperk("specialty_bulletdamage");
    self setperk("specialty_bulletflinch");
    self setperk("specialty_bulletpenetration");
    self setperk("specialty_deadshot");
    self setperk("specialty_delayexplosive");
    self setperk("specialty_detectexplosive");
    self setperk("specialty_disarmexplosive");
    self setperk("specialty_earnmoremomentum");
    self setperk("specialty_explosivedamage");
    self setperk("specialty_extraammo");
    self setperk("specialty_fallheight");
    self setperk("specialty_fastads");
    self setperk("specialty_fastequipmentuse");
    self setperk("specialty_fastladderclimb");
    self setperk("specialty_fastmantle");
    self setperk("specialty_fastmeleerecovery");
    self setperk("specialty_fastreload");
    self setperk("specialty_fasttoss");
    self setperk("specialty_fastweaponswitch");
    self setperk("specialty_finalstand");
    self setperk("specialty_fireproof");
    self setperk("specialty_flakjacket");
    self setperk("specialty_flashprotection");
    self setperk("specialty_gpsjammer");
    self setperk("specialty_grenadepulldeath");
    self setperk("specialty_healthregen");
    self setperk("specialty_holdbreath");
    self setperk("specialty_immunecounteruav");
    self setperk("specialty_immuneemp");
    self setperk("specialty_immunemms");
    self setperk("specialty_immunenvthermal");
    self setperk("specialty_immunerangefinder");
    self setperk("specialty_killstreak");
    self setperk("specialty_longersprint");
    self setperk("specialty_loudenemies");
    self setperk("specialty_marksman");
    self setperk("specialty_movefaster");
    self setperk("specialty_nomotionsensor");
    self setperk("specialty_noname");
    self setperk("specialty_nottargetedbyairsupport");
    self setperk("specialty_nokillstreakreticle");
    self setperk("specialty_nottargettedbysentry");
    self setperk("specialty_pin_back");
    self setperk("specialty_pistoldeath");
    self setperk("specialty_proximityprotection");
    self setperk("specialty_quickrevive");
    self setperk("specialty_quieter");
    self setperk("specialty_reconnaissance");
    self setperk("specialty_rof");
    self setperk("specialty_showenemyequipment");
    self setperk("specialty_stunprotection");
    self setperk("specialty_shellshock");
    self setperk("specialty_sprintrecovery");
    self setperk("specialty_showonradar");
    self setperk("specialty_stalker");
    self setperk("specialty_twogrenades");
    self setperk("specialty_twoprimaries");
    self setperk("specialty_unlimitedsprint");
    self unsetperk("specialty_scavenger");
}

dvars() // cleanup later
{
    ex = randomintrange(8,12);
    self setClientDvar("cg_fov_default", 78);
    self setClientDvar("cg_fov_default_thirdperson", 115);
    self setClientDvar("ai_disableSpawn", 0);
    self setClientDvar("player_strafeSpeedScale", 1.5);
    self setClientDvar("player_sprintStrafeSpeedScale", 2.3);
    self setClientDvar("player_backSpeedscale", 1.9);
    self setClientDvar("player_meleeRange", 300);
    self setClientDvar("player_meleeinterruptfrac", 0);
    self setClientDvar("player_standingViewHeight", 60);
    self setClientDvar("cg_drawBreathHint", 0);
    self setClientDvar("cg_friendlyNameFadeIn", 0);
    self setClientDvar("cg_friendlyNameFadeOut", 0);
    self setClientDvar("cg_enemyNameFadeIn", 0);
    self setClientDvar("cg_enemyNameFadeOut", 0);

    setDvar("perk_fastLadderClimbMultiplier", ex);
    
    // setDvar("mantle_adjustment_tu", 0); // break mantling completely ; won't watch for collision updates
    setDvar("mantle_view_yawcap", 180);
    setDvar("mantle_check_angle", 180);
    setDvar("mantle_check_angle", 180);

    setDvar("g_speed", 235);
    setDvar("g_mantleblocktimebuffer", 0);
    setDvar("perk_mantleReduction", 0.01);
    setDvar("bg_aimspreadmovespeedthreshold", 0);
    setDvar("bg_weaponbobamplitudesprinting", 0);
    setDvar("bg_weaponboblag", 3);
    setDvar("bg_weaponbobmax", 3);
    setDvar("lowammowarningnoammocolor1", 1);
    setDvar("lowammowarningnoammocolor2", 0);
    setDvar("sv_enablebounces", 1);
}

spam_dprint()
{
    while(1)
    {
    weap = self getWeaponsListPrimaries();
    dprint("inv primary: " + self.inventory["primary"]);
    dprint("inv secondary: " + self.inventory["secondary"]);
    dprint("actual primary: " + weap[0]);
    dprint("actual secondary: " + weap[1]);
    dprint("new clip [1]: " + self.pers["new_clip"][0]);
    dprint("new stock [1]: " + self.pers["new_stock"][0]);
    dprint("new clip [2]: " + self.pers["new_clip"][1]);
    dprint("new stock [2]: " + self.pers["new_stock"][1]);
    wait 1;
    }
}

class_struct()
{
    if(!isDefined(self.class_structs))
    {
        // me trying to figure out why pers ammo wasnt working
        self.class_structs = true;
        self.pers["new_clip"] = [];
        self.pers["new_stock"] = [];
        dprint("structuring");
    }
}

event(string, origin)
{
	foreach(player in level.players)
    {
        if(!isDefined(level.is_notifying))
        {
            level.is_notifying = 2;
            player luinotifyevent(&"player_callout", 2, string, origin.entnum);
            return;
        } else {
            wait (level.is_notifying);
            player luinotifyevent(&"player_callout", 2, string, origin.entnum);
            level.is_notifying = undefined;
            return;
        }
	}
}

vector_scale(vec,scale)
{
    vec=(vec[0]*scale,vec[1]*scale,vec[2]*scale);
        return vec;
} 

get_cross() 
{
	cross = bullettrace(self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 1000000, 0, self )["position"];
	return cross;
}


// from zm_utility cause its not in mp
is_player_looking_at( origin, dot, do_trace, ignore_ent )
{
    assert( isplayer( self ), "player_looking_at must be called on a player." );

    if ( !isdefined( dot ) )
        dot = 0.7;

    if ( !isdefined( do_trace ) )
        do_trace = 1;

    eye = self geteye();
    delta_vec = anglestoforward( vectortoangles( origin - eye ) );
    view_vec = anglestoforward( self getplayerangles() );
    new_dot = vectordot( delta_vec, view_vec );

    if ( new_dot >= dot )
    {
        if ( do_trace )
            return bullettracepassed( origin, eye, 0, ignore_ent );
        else
            return 1;
    }

    return 0;
}

sfx(fx, origin)
{
	if(!isDefined(origin)) origin = self.origin;
	if(!isDefined(level._effect[fx])) self iprintln("Invalid FX!"); // ?
	playfx(level._effect[fx], origin);
}

proximity_shock_fx(box_model)
{
	for(e=0;e<20;e++) playfx(level._effect["prox_grenade_player_shock"], self.origin + (0,randomint(100), 0));
}

dprint(message) // so i can keep debug prints ngl
{
    if(!isDefined(level.debug)) return;
    print(message);
}