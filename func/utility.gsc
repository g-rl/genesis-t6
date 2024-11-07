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