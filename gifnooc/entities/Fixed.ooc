import structs/HashMap

import gifnooc/[Entity, Errors, Serialize]

FixedEntity: class extends Entity {
    values: HashMap<String>

    init: func (=parent) {
        values = HashMap<String> new()
    }

    addValue: func <T> (path: String, value: T) {
        values put(path, Registrar serialize(T, value))
    }

    setValue: func <T> (path: String, value: T) {
        addValue(path, value)
    }

    removeValue: func (path: String) {
        values remove(path)
    }

    getValue: func <T> (path: String, T: Class) -> T {
        Registrar deserialize(T, values get(path))
    }

    getOption: func <T> (path: String, T: Class, absolute: Bool) -> T {
        path = _getPath(path, absolute)
        if(!values contains(path)) {
            if(hasParent()) {
                return parent getOption(path, T, true)
            } else {
                NoSuchOptionError new(This, "No such option: '%s'" format(path)) throw()
            }
        } else {
            return getValue(path, T)
        }
    }
}
