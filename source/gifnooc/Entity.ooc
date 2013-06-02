import gifnooc/Errors

Entity: abstract class {
    parent: Entity
    basePath: String = null

    hasParent: func -> Bool { parent != null }

    getOption: abstract func <T> (path: String, T: Class, absolute: Bool) -> T
    getOption: func ~relative <T> (path: String, T: Class) -> T {
        getOption(path, T, false)
    }

    setBasePath: func (=basePath) {}
    _getPath: func (path: String, absolute: Bool) -> String {
        if(absolute) {
            return path
        } else {
            if(basePath) {
                return "%s.%s" format(basePath, path)
            } else {
                return path
            }
        }
    }

    getWriteableEntity: func -> WriteableEntity {
        if(this instanceOf?(WriteableEntity)) {
            return this as WriteableEntity
        } else if(hasParent()) {
            return parent getWriteableEntity()
        } else {
            NoWriteableEntityError new(This, "Couldn't find a writeable entity for you. Developer's fault.") throw()
            return null
        }
    }
}

WriteableEntity: abstract class extends Entity {
    setOption: abstract func <T> (path: String, value: T)
    save: abstract func
}
