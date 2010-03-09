use gifnooc
use optparse

import structs/[HashBag, ArrayList]

import optparse/[Option, Parser]

import gifnooc/Entity
import gifnooc/entities/[INI, Fixed, Optparse]

setupConfig: func (parser: Parser) -> Entity {
    defaults := FixedEntity new(null)
    defaults addValue("Data.address", "RIGHT BEHIND YOU!")
    defaults addValue("Fun.counter", 0)

    system := INIEntity new(defaults, "system.ini")
    user := INIEntity new(system, "user.ini")

    cmdline := OptparseEntity new(user, parser, "cfg")

    return cmdline
}

main: func (args: ArrayList<String>) {
    // setup cmdline parser
    parser := Parser new()
    cfg := MapOption new("cfg") .longName("cfg") .shortName("c") .help("Add the KEY/VALUE pair to the configuration.") .metaVar("KEY VALUE")
    parser addOption(cfg)
    parser parse(args)

    entity := setupConfig(parser)
    writeable := entity getWriteableEntity()
    
    entity setBasePath("Options")
    "verbose: %d" format(entity getOption("verbose", Bool)) println()
    "outfile: %s" format(entity getOption("out", String)) println()

    entity setBasePath("Data")
    "name: %s" format(entity getOption("name", String)) println()
    "address: %s" format(entity getOption("address", String)) println()

    entity setBasePath(null)
    counter := entity getOption("Fun.counter", Int)
    "counter: %d" format(counter) println()
    writeable setOption("Fun.counter", counter + 1)
    writeable save()
}
