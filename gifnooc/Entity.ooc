Entity: abstract class {
    parent: Entity

    init: func ~withParent (=parent) {}
    
    init: func ~withoutParent {
        parent = null
    }

    hasParent: func -> Bool { parent != null }

    getOption: abstract func <T> ~errorIfNotFound (path: String, T: Class) -> T
}
