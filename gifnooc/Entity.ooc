Entity: abstract class {
    parent: Entity
    basePath: String = null

    hasParent: func -> Bool { parent != null }

    getOption: abstract func <T> ~errorIfNotFound (path: String, T: Class) -> T

    setBasePath: func (=basePath) {}
    _getPath: func (path: String) -> String {
        if(basePath) {
            return "%s.%s" format(basePath, path)
        } else {
            return path
        }
    }
}

WriteableEntity: abstract class extends Entity {
    setOption: abstract func <T> (path: String, value: T)
    save: abstract func
}
