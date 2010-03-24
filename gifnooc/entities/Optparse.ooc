use optparse

import structs/[HashBag, HashMap]

import optparse/Parser

import gifnooc/[Entity, Serialize, Errors]

OptparseEntity: class extends Entity {
    parser: Parser
    key: String

    init: func ~withParser (=parent, =parser, =key) {
    }
    
    getOption: func <T> (path: String, T: Class, absolute: Bool) -> T {
        path = _getPath(path, absolute)
        if(!parser values contains(key)) {
           NoSuchOptionError new(This, "Parser didn't parse anything. Stab your developer!") throw()
        } else {
            map := parser values get(key, HashMap<String, String>)
            if(map contains(path)) {
                s := map[path]
                if(Registrar validateString(T, s)) {
                    return Registrar deserialize(T, s)
                } else if(hasParent()) {
                    return parent getOption(path, T, true)
                } else {
                    NoSuchOptionError new(This, "No valid contents for '%s' found." format(path)) throw()
                }
            } else if(hasParent()) {
                return parent getOption(path, T, true)
            } else {
                NoSuchOptionError new(This, "No such option: '%s'." format(path)) throw()
            }
        }
    }
}
