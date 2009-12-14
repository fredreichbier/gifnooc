use gifnooc
import gifnooc/Entity
import gifnooc/entities/[INI, Fixed]

setupConfig: func -> Entity {
    defaults := FixedEntity new(null)
    defaults addValue("Data.address", "RIGHT BEHIND YOU!")
    defaults addValue("Fun.counter", 0)

    system := INIEntity new(defaults, "system.ini")
    user := INIEntity new(system, "user.ini")
    return user
}

main: func {
    entity := setupConfig() as WriteableEntity
    
    entity setBasePath("Options")
    "verbose: %d" format(entity getOption("verbose", Bool)) println()
    "outfile: %s" format(entity getOption("out", String)) println()

    entity setBasePath("Data")
    "name: %s" format(entity getOption("name", String)) println()
    "address: %s" format(entity getOption("address", String)) println()

    entity setBasePath(null)
    counter := entity getOption("Fun.counter", Int)
    "counter: %d" format(counter) println()
    entity setOption("Fun.counter", counter + 1)
    entity save()
}
