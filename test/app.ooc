use gifnooc
import gifnooc/Entity
import gifnooc/entities/INI

setupConfig: func -> Entity {
    system := INIEntity new(null, "system.ini")
    user := INIEntity new(system, "user.ini")
    return user
}

main: func {
    entity := setupConfig()
    "verbose: %d" format(entity getOption("Options.verbose", Bool)) println()
    "outfile: %s" format(entity getOption("Options.out", String)) println()
    "name: %s" format(entity getOption("Data.name", String)) println()
}
