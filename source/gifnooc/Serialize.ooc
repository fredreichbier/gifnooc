import structs/HashMap
import io/File

import gifnooc/Errors

SerializationEntry: abstract class <T> {
    serialize, deserialize, validateValue, validateString: Pointer
    init: func {}

    serialize: abstract func <T> (value: T) -> String
    deserialize: abstract func <T> (data: String, T: Class) -> T
    validateValue: abstract func <T> (value: T) -> Bool
    validateString: abstract func (value: String) -> Bool
}

Registrar: class {
    entries := static HashMap<Class, SerializationEntry> new()

    addEntry: static func <T> (cls: Class, entry: SerializationEntry<T>) {
        This entries put(cls, entry)
    }

    getEntry: static func <T> (cls: Class) -> SerializationEntry<T> {
        entry := This entries get(cls)
        if(entry == null) {
            SerializationError new(This, "No serialization This entries found for %s." format(cls name)) throw()
        }
        return entry
    }

    serialize: static func <T> (T: Class, value: T) -> String {
        if(!validateValue(T, value)) {
            SerializationError new(This, "The '%s' object at 0x%x could not be validated." format(T name, value as Pointer)) throw()
        }
        getEntry(T) serialize(value)
    }

    deserialize: static func <T> (T: Class, value: String) -> T {
        if(!validateString(T, value)) {
            SerializationError new(This, "The string '%s' could not be validated for %s." format(value, T name)) throw()
        }
        getEntry(T) deserialize(value, T)
    }

    validateString: static func <T> (T: Class, value: String) -> Bool {
        getEntry(T) validateString(value)
    }

    validateValue: static func <T> (T: Class, value: T) -> Bool {
         getEntry(T) validateValue(value)
    }
}

SerializeSSizeT: class extends SerializationEntry<SSizeT> {
    serialize: func <T> (value: T) -> String {
        value as SSizeT toString()
    }

    deserialize: func <T> (data: String, T: Class) -> T {
        data toInt()
    }

    validateValue: func <T> (value: T) -> Bool {
        true
    }

    validateString: func (value: String) -> Bool {
        true // TODO
    }
}

SerializeInt: class extends SerializationEntry<Int> {
    serialize: func <T> (value: T) -> String {
        value as Int toString()
    }

    deserialize: func <T> (data: String, T: Class) -> T {
        data toInt()
    }

    validateValue: func <T> (value: T) -> Bool {
        true
    }

    validateString: func (value: String) -> Bool {
        true // TODO
    }
}

SerializeString: class extends SerializationEntry<String> {
    serialize: func <T> (value: T) -> String {
        value as String
    }

    deserialize: func <T> (data: String, T: Class) -> T {
        data
    }

    validateValue: func <T> (value: T) -> Bool {
        true
    }

    validateString: func (value: String) -> Bool {
        true // TODO
    }
}

SerializeBool: class extends SerializationEntry<Bool> {
    serialize: func <T> (value: T) -> String {
        (value as Bool) ? "yes" : "no"
    }

    deserialize: func <T> (data: String, T: Class) -> T {
        data == "yes"
    }

    validateValue: func <T> (value: T) -> Bool {
        T == Bool
    }

    validateString: func (value: String) -> Bool {
        value == "yes" || value == "no"
    }
}

SerializeFile: class extends SerializationEntry<File> {
    serialize: func <T> (value: T) -> String {
        value as File getPath()
    }

    deserialize: func <T> (data: String, T: Class) -> T {
        File new(data)
    }

    validateValue: func <T> (value: T) -> Bool {
        true
    }

    validateString: func (value: String) -> Bool {
        true
    }
}

Registrar addEntry(SSizeT, SerializeSSizeT new()) \
         .addEntry(Int, SerializeInt new()) \
         .addEntry(String, SerializeString new()) \
         .addEntry(Bool, SerializeBool new()) \
         .addEntry(File, SerializeFile new())
