use oocini

import text/StringTokenizer
import io/[Reader, FileReader]

import gifnooc/[Entity, Errors, Serialize]

import oocini/INI

INIEntity: class extends WriteableEntity {
    ini: INI

    init: func ~withFileName (=parent, filename: String) {
        ini = INI new(filename)
    }

    _getOptionName: func (path: String, section, key: String*) {
        tokens := path split('.', 1) toArrayList()
        if(tokens size() == 2) {
            section@ = tokens get(0)
            key@ = tokens get(1)
        } else {
            section@ = ""
            key@ = tokens get(0)
        }
    }

    getOption: func <T> (path: String, T: Class, absolute: Bool) -> T {
        section, key: String
        path = _getPath(path, absolute)
        _getOptionName(path, section&, key&)
        if(ini hasOption(section, key)) {
            s := ini getOption(section, key)
            /* valid contents? return, deserialized.
               invalid contents? ask parent. */
            if(Registrar validateString(T, s)) {
                return Registrar deserialize(T, s)
            } else if(hasParent()) {
                return parent getOption(path, T, true)
            } else {
                NoSuchOptionError new(This, "No valid contents for '%s' found." format(path)) throw()
            }
        } else if(hasParent()) {
            return parent getOption(path, T)
        } else {
            NoSuchOptionError new(This, "No such option: '%s'." format(path)) throw()
        }
    }

    setOption: func <T> (path: String, value: T) {
        section, key: String
        path = _getPath(path, false)
        _getOptionName(path, section&, key&)
        if(Registrar validateValue(T, value)) {
            ini setOption(section, key, Registrar serialize(T, value))
        } else {
            NoSuchOptionError new(This, "Invalid value to save at '%s'." format(path)) throw()
        }
    }

    save: func {
        ini dump()
    }
}
