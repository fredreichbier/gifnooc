import gifnooc/Entity
import gifnooc/entities/INI

main: func {
    entity := INIEntity new(null, "test.ini")
    s := entity getOption("Options.verbose", Bool)
    (s ? "yay" : "nay") println()
}
