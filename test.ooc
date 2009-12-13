import gifnooc/Entity
import gifnooc/Serialize
import gifnooc/entities/INI

main: func {
    entity := INIEntity new(null, "test.ini")
    (entity getOption("Options.verbose", Bool) ? "yay" : "noez") println() 
}
