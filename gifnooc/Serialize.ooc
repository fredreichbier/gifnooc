import structs/HashMap

SerializationEntry: class {
    serialize, deserialize: Pointer 
    init: func (=serialize, =deserialize) {}
}

Registrar: class {
    entries: static HashMap<SerializationEntry> = HashMap<SerializationEntry> new()

    _addrToString: static func (ptr: Pointer) -> String {
        str := String new(Pointer size + 1)
        for(i: Int in 0..Pointer size) {
            str[i] = ptr& as Char* [i]
        }
        str[Pointer size] = '\0'
        str
    }

    addEntry: static func (cls: Class, serialize, deserialize: Func) {
        entries put(_addrToString(cls), SerializationEntry new(serialize, deserialize))
    }

    getEntry: static func (cls: Class) -> SerializationEntry {
        entries get(_addrToString(cls))
    }

    serialize: static func <T> (T: Class, value: T) -> String {
        fnc := getEntry(T) serialize as Func(Int) -> Pointer
        return fnc(value) /* whoa. that is dirty. */
    }

    deserialize: static func <T> (T: Class, value: String) -> T {
        fnc := getEntry(T) deserialize as Func(String) -> Pointer
        return fnc(value)
    }
}
/* builtin. */
Registrar addEntry(Int, \
    func (value: Int) -> String { value toString() }, \
    func (value: String) -> Int { value toInt() })
Registrar addEntry(Bool, \
    func (value: Bool) -> String { value ? "yes" : "no" }, \
    func (value: String) -> Bool { value == "yes" })
