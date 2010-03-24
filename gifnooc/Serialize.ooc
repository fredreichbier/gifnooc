import structs/HashMap
import io/File

import gifnooc/Errors

SerializationEntry: class {
    serialize, deserialize, validateValue, validateString: Pointer 
    init: func (=serialize, =deserialize, =validateValue, =validateString) {}
}

Registrar: class {
    entries: static HashMap<String, SerializationEntry> = HashMap<String, SerializationEntry> new()

    _addrToString: static func (ptr: Pointer) -> String {
        str := String new(Pointer size + 1)
        for(i: Int in 0..Pointer size) {
            str[i] = ptr& as Char* [i]
        }
        str[Pointer size] = '\0'
        str
    }

    addEntry: static func (cls: Class, serialize, deserialize, validateValue, validateString: Func) {
        This entries put(_addrToString(cls),\
            SerializationEntry new(serialize as Pointer, deserialize as Pointer, validateValue as Pointer, validateString as Pointer))
    }

    getEntry: static func (cls: Class) -> SerializationEntry {
        entry := This entries get(_addrToString(cls))
        if(entry == null) {
            SerializationError new(This, "No serialization This entries found for %s." format(cls name)) throw()
        }
        return entry
    }

    serialize: static func <T> (T: Class, value: T) -> String {
        if(!validateValue(T, value)) {
            SerializationError new(This, "The '%s' object at 0x%x could not be validated." format(T name, value as Pointer)) throw()
        }
        fnc := getEntry(T) serialize as Func(Pointer) -> Pointer
        return fnc(value as Pointer) /* whoa. that is dirty. */
    }

    deserialize: static func <T> (T: Class, value: String) -> T {
        if(!validateString(T, value)) {
            SerializationError new(This, "The string '%s' could not be validated for %s." format(value, T name)) throw()
        }
        fnc := getEntry(T) deserialize as Func(String) -> Pointer
        return fnc(value)
    }

    validateString: static func <T> (T: Class, value: String) -> Bool {
        fnc := getEntry(T) validateString as Func(String) -> Bool
        return fnc(value)
    }

    validateValue: static func <T> (T: Class, value: T) -> Bool {
         fnc := getEntry(T) validateValue as Func(T) -> Bool
         return fnc(value)
    }
}
/* builtin. */
Registrar addEntry(Int, \
    func (value: Int) -> String { value toString() }, \
    func (value: String) -> Int { value toInt() },
    func (value: Int) -> Bool { true },
    func (value: String) -> Bool { true /* TODO. */ })
Registrar addEntry(Bool, \
    func (value: Bool) -> String { value ? "yes" : "no" }, \
    func (value: String) -> Bool { value == "yes" },
    func (value: Bool) -> Bool { true },
    func (value: String) -> Bool { value == "yes" || value == "no" })
Registrar addEntry(String, \
    func (value: String) -> String { value }, \
    func (value: String) -> String { value },
    func (value: String) -> Bool { true },
    func (value: String) -> Bool { true })
Registrar addEntry(File, \
    func (value: File) -> String { value path }, \
    func (value: String) -> File { File new(value) },
    func (value: File) -> Bool { true },
    func (value: String) -> Bool { true })

