use gifnooc
import gifnooc/Entity
import gifnooc/entities/[INI, Fixed]

setupConfig: func -> Entity {
    defaults := FixedEntity new(null)
    defaults addValue("Data.address", "RIGHT BEHIND YOU!")

    system := INIEntity new(defaults, "system.ini")
    user := INIEntity new(system, "user.ini")
    return user
}

main: func {
    entity := setupConfig()
    "verbose: %d" format(entity getOption("Options.verbose", Bool)) println()
    "outfile: %s" format(entity getOption("Options.out", String)) println()
    "name: %s" format(entity getOption("Data.name", String)) println()
    "address: %s" format(entity getOption("Data.address", String)) println()
}
