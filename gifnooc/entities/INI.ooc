use oocini

import text/StringTokenizer
import io/[Reader, FileReader]

import gifnooc/[Entity, Errors, Serialize]

import oocini/INI

INIEntity: class extends Entity {
    ini: INI

    init: func ~withFileName (=parent, filename: String) {
        ini = INI new(filename)
    }

    getOption: func <T> ~errorIfNotFound (path: String, T: Class) -> T {
        tokens := path split('.', 1) toArrayList()
        section := tokens get(0)
        key := tokens get(1)
        if(ini hasOption(section, key)) {
            s := ini getOption(section, key)
            /* valid contents? return, deserialized.
               invalid contents? ask parent. */
            if(Registrar validateString(T, s)) {
                return Registrar deserialize(T, s)
            } else if(hasParent()) {
                return parent getOption(path, T)
            } else {
                NoSuchOptionError new(This, "No valid contents for '%s' found." format(path)) throw()
            }
        } else if(hasParent()) {
            return parent getOption(path, T)
        } else {
            NoSuchOptionError new(This, "No such option: '%s'" format(path)) throw()
        }
    }
}
