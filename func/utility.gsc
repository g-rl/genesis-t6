#include codescripts\struct;
#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\main;
#include scripts\mp\func\functions;

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

pprint(message, type)
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
    level._effect["heli_guard_light"]["friendly"] = loadfx( "light/fx_vlight_mp_escort_eye_grn" );
    level._effect["heli_guard_light"]["enemy"] = loadfx( "light/fx_vlight_mp_escort_eye_red" );
    level._effect["heli_comlink_light"]["friendly"] = loadfx( "light/fx_vlight_mp_attack_heli_grn" );
    level._effect["heli_comlink_light"]["enemy"] = loadfx( "light/fx_vlight_mp_attack_heli_red" );
    level._effect["heli_gunner_light"]["friendly"] = loadfx( "light/fx_vlight_mp_vtol_grn" );
    level._effect["heli_gunner_light"]["enemy"] = loadfx( "light/fx_vlight_mp_vtol_red" );
    level._effect["heli_gunner"]["vtol_fx"] = loadfx( "vehicle/exhaust/fx_exhaust_vtol_mp" );
    level._effect["heli_gunner"]["vtol_fx_ft"] = loadfx( "vehicle/exhaust/fx_exhaust_vtol_rt_mp" );
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

spam_print()
{
    while(1)
    {
    weap = self getWeaponsListPrimaries();
    print("inv primary: " + self.inventory["primary"]);
    print("inv secondary: " + self.inventory["secondary"]);
    print("actual primary: " + weap[0]);
    print("actual secondary: " + weap[1]);
    print("new clip [1]: " + self.pers["new_clip"][0]);
    print("new stock [1]: " + self.pers["new_stock"][0]);
    print("new clip [2]: " + self.pers["new_clip"][1]);
    print("new stock [2]: " + self.pers["new_stock"][1]);
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
        print("structuring");
    }
}