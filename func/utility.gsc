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