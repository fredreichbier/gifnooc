Entity: abstract class {
    parent: Entity

    hasParent: func -> Bool { parent != null }

    getOption: abstract func <T> ~errorIfNotFound (path: String, T: Class) -> T
}
