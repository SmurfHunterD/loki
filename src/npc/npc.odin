package npc

import "core:math/rand"
import "core:fmt"
import "core:time"
import "core:encoding/json"
import "core:encoding/cbor"

male_first_name_list: [12]string = {"Ahren", "Borlen", "Jhurin", "Pytr", "Tyril", "Thorin", "Dhurgan", "Khorin", "Korwin", "Garlis", "Tanis", "Gharland"}
female_first_name_list: [12]string = {"Gwen", "Briala", "Calin", "Nora", "Aria", "Elyra", "Fenya", "Halia", "Sehrin", "Telyah", "Khorrina", "Kaara"}
shared_clan_name_list: [10]string = {"Bloodmoon", "Highmoon", "Lightfoot", "Darkbane", "Nightfury", "Skyborne", "Everwinter", "Stonebreak", "Ironborne", "Cloudbreak"}

Age :: int

Level :: int

Race :: enum {
    Astarin,
    Fae,
}

Gender :: enum {
    Male,
    Female,
}

Profession :: enum {
    Mage,
    Bard,
    Priest,
    Spearman,
    Hunter,
    Warrior,
    Assassin,
    Druid,
    Archer,
}

Stats :: struct {
    health: int,
    stamina: int,
    mana: int,
    intelligence: int,
    strength: int,
    agility: int,
}

NPC :: struct {
    first_name: string,
    clan_name: string,
    age: Age,
    level: Level,
    race: Race,
    gender: Gender,
    profession: Profession,
    stats: Stats,
}

pick_first_name_for_npc :: proc(race: Race, gender: Gender) -> string {
    names: []string
    if gender == .Male {
        switch race {
        case .Astarin:
            names = male_first_name_list[0:6]
        case .Fae:
            names = male_first_name_list[6:12]
        }
    } else {
        switch race {
        case .Astarin:
            names = female_first_name_list[0:6]
        case .Fae:
            names = female_first_name_list[6:12]
        }
    }
    return names[rand.int_max(len(names))]
}

pick_clan_name_for_npc :: proc(race: Race) -> string {
    names: []string
    switch race {
    case .Astarin:
        names = shared_clan_name_list[0:5]
    case .Fae:
        names = shared_clan_name_list[5:10]
    }
    return names[rand.int_max(len(names))]
}

generate_age :: proc(race: Race) -> Age {
    age := 0
    if race == .Astarin {
        age = cast(int)rand.float32_range(18, 60)
    } else if race == .Fae {
        age = cast(int)rand.float32_range(40, 150)
    } else {
        age = cast(int)rand.float32_range(18, 80)
    }
    return Age(age)
}

generate_level :: proc(age: Age, race: Race) -> Level {
    level: int
    switch race {
    case .Astarin:
        if age <= 25 {
            level = age - cast(int)rand.float32_range(1, 5) 
        } else if age > 25 &&  age <= 40 {
            level = age - cast(int)rand.float32_range(1, 6)
        } else {
            level = age - cast(int)rand.float32_range(1, 7)
        }
    case .Fae:
        if age <= 75 {
            level = age - cast(int)rand.float32_range(1, 5)
        } else if age > 75 && age <= 125 {
            level = age - cast(int)rand.float32_range(5, 10)
        } else {
            level = age - cast(int)rand.float32_range(20,50)
        }       
    }
    
    level = clamp(level, 1, 100)
    return Level(level)
}

pick_profession_for_npc :: proc(race: Race) -> Profession {
    astarin_professions := []Profession{.Assassin, .Warrior, .Spearman, .Bard, .Archer}
    fae_professions := []Profession{.Priest, .Warrior, .Mage, .Hunter, .Druid}
    professions: []Profession
    switch race {
    case .Astarin:
        professions = astarin_professions
    case .Fae:
        professions = fae_professions
    }
    return professions[rand.int_max(len(professions))]
}

create_base_stats :: proc() -> Stats {
    return Stats{
        health = 40 + cast(int)rand.float32_range(0, 20),
        stamina = 40 + cast(int)rand.float32_range(0, 20),
        mana = 40 + cast(int)rand.float32_range(0, 10),
        intelligence = 25 + cast(int)rand.float32_range(0, 5),
        strength = 25 + cast(int)rand.float32_range(0, 5),
        agility = 25 + cast(int)rand.float32_range(0, 5),
    }
}

adjust_stats_for_job :: proc(stats: ^Stats, profession: Profession) {
    switch profession {
        case .Spearman:
            stats.health += cast(int)rand.float32_range(50, 100)
            stats.stamina += cast(int)rand.float32_range(10, 50)
            stats.mana += cast(int)rand.float32_range(10, 20)
            stats.intelligence += cast(int)rand.float32_range(5, 15)
            stats.strength += cast(int)rand.float32_range(20, 65)
            stats.agility += cast(int)rand.float32_range(20, 65)
        case .Mage:
            stats.health += cast(int)rand.float32_range(10, 50)
            stats.stamina += cast(int)rand.float32_range(10, 50)
            stats.mana += cast(int)rand.float32_range(10, 170)
            stats.intelligence += cast(int)rand.float32_range(15, 45)
            stats.strength += cast(int)rand.float32_range(5, 15)
            stats.agility += cast(int)rand.float32_range(5, 15) 
        case .Hunter:
            stats.health += cast(int)rand.float32_range(50, 100)
            stats.stamina += cast(int)rand.float32_range(10, 50)
            stats.mana += cast(int)rand.float32_range(10, 20)
            stats.intelligence += cast(int)rand.float32_range(5, 15)
            stats.strength += cast(int)rand.float32_range(10, 45)
            stats.agility += cast(int)rand.float32_range(30, 85)
        case .Bard:
            stats.health += cast(int)rand.float32_range(10, 50)
            stats.stamina += cast(int)rand.float32_range(10, 50)
            stats.mana += cast(int)rand.float32_range(10, 170)
            stats.intelligence += cast(int)rand.float32_range(15, 45)
            stats.strength += cast(int)rand.float32_range(5, 15)
            stats.agility += cast(int)rand.float32_range(5, 15) 
        case .Warrior:
            stats.health += cast(int)rand.float32_range(50, 100)
            stats.stamina += cast(int)rand.float32_range(10, 50)
            stats.mana += cast(int)rand.float32_range(10, 20)
            stats.intelligence += cast(int)rand.float32_range(5, 15)
            stats.strength += cast(int)rand.float32_range(20, 65)
            stats.agility += cast(int)rand.float32_range(20, 65)
        case .Priest:
            stats.health += cast(int)rand.float32_range(10, 50)
            stats.stamina += cast(int)rand.float32_range(10, 50)
            stats.mana += cast(int)rand.float32_range(10, 170)
            stats.intelligence += cast(int)rand.float32_range(15, 45)
            stats.strength += cast(int)rand.float32_range(5, 15)
            stats.agility += cast(int)rand.float32_range(5, 15) 
        case .Assassin:
            stats.health += cast(int)rand.float32_range(50, 100)
            stats.stamina += cast(int)rand.float32_range(10, 50)
            stats.mana += cast(int)rand.float32_range(10, 20)
            stats.intelligence += cast(int)rand.float32_range(5, 15)
            stats.strength += cast(int)rand.float32_range(10, 45)
            stats.agility += cast(int)rand.float32_range(30, 85)
        case .Druid:
            stats.health += cast(int)rand.float32_range(20, 65)
            stats.stamina += cast(int)rand.float32_range(10, 50)
            stats.mana += cast(int)rand.float32_range(50, 100)
            stats.intelligence += cast(int)rand.float32_range(15, 45)
            stats.strength += cast(int)rand.float32_range(10, 20)
            stats.agility += cast(int)rand.float32_range(20, 65)
        case .Archer:
            stats.health += cast(int)rand.float32_range(50, 100)
            stats.stamina += cast(int)rand.float32_range(10, 50)
            stats.mana += cast(int)rand.float32_range(10, 20)
            stats.intelligence += cast(int)rand.float32_range(5, 15)
            stats.strength += cast(int)rand.float32_range(10, 45)
            stats.agility += cast(int)rand.float32_range(30, 85)
        }
}

generate_npc :: proc() -> NPC {
    race := Race(rand.int_max(len(Race)))
    gender := Gender(rand.int_max(len(Gender)))
    age := generate_age(race)
    level := generate_level(age, race)
    profession := pick_profession_for_npc(race)
    stats := create_base_stats()
    adjust_stats_for_job(&stats, profession)
    return NPC{
        first_name = pick_first_name_for_npc(race, gender),
        clan_name = pick_clan_name_for_npc(race),
        age = age,
        level = level,
        race = race,
        gender = gender,
        profession = profession,
        stats = stats,
    }
}

print_npc :: proc(n: NPC) {
    race_names := []string{"Astarin", "Fae"}
    gender_names := []string{"Male", "Female"}
    profession_names := []string{
            "Mage",
            "Bard",
            "Priest",
            "Spearman",
            "Hunter",
            "Warrior",
            "Assassin",
            "Druid",
            "Archer",
        }
    fmt.println("  NPC Info:")
    fmt.printf("       Name:     %s %s\n", n.first_name, n.clan_name)
    fmt.printf("       Race:     %s\n", race_names[n.race])
    fmt.printf("     Gender:     %s\n", gender_names[n.gender])
    fmt.printf("        Age:     %d\n", n.age)
    fmt.printf("      Level:     %d\n", n.level)
    fmt.printf(" Profession:     %s\n", profession_names[n.profession])
    fmt.printf("     Stats:\n")
    fmt.printf("         Health:      %d\n", n.stats.health)
    fmt.printf("        Stamina:      %d\n", n.stats.stamina)
    fmt.printf("   Intelligence:      %d\n", n.stats.stamina)
    fmt.printf("           Mana:      %d\n", n.stats.mana)
    fmt.printf("       Strength:      %d\n", n.stats.strength)
    fmt.printf("        Agility:      %d\n", n.stats.agility)
}

marshal_npcs_json :: proc(count: int) -> (json_data: []byte, err: json.Marshal_Error) {
    npcs := make([dynamic]NPC, 0, count, context.allocator)
    defer delete(npcs)

    for i in 0..<count {
        append(&npcs, generate_npc())
    }
    return json.marshal(npcs[:], json.Marshal_Options{pretty = true, use_enum_names = true})
}

marshal_npcs_cbor :: proc(count: int) -> (cbor_data: []byte, err: cbor.Marshal_Error) {
    npcs := make([dynamic]NPC, 0, count, context.allocator)
    defer delete(npcs)

    for i in 0..<count {
        append(&npcs, generate_npc())
    }

    return cbor.marshal(npcs[:])
}
