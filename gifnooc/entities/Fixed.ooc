import structs/HashMap

import gifnooc/[Entity, Errors, Serialize]

FixedEntity: class extends Entity {
    values: HashMap<Pointer>

    init: func (=parent) {
        values = HashMap<Pointer> new()
    }

    addValue: func <T> (path: String, value: T) {
        values put(path, value as Pointer)
    }

    setValue: func <T> (path: String, value: T) {
        addValue(path, value)
    }

    removeValue: func (path: String) {
        values remove(path)
    }

    getValue: func <T> (path: String, T: Class) -> T {
        values get(path) as T
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
            return values get(path) as T
        }
    }
}
