/**
   Necessary boilerplate for C#/.NET.

   To wrap all functions/return/parameter types and struct/class definitions from
   a list of modules, write this in a "main" module and generate mylib.{so,dll}:

   ------
   mixin wrapCSharp("mylib", Modules("module1", "module2", ...));
   ------
 */
module autowrap.csharp.boilerplate;

import autowrap.common;
import autowrap.reflection;
import autowrap.csharp;

import core.time;
import core.memory;
import std.conv;
import std.datetime : DateTime, SysTime, Date, TimeOfDay, SimpleTimeZone, LocalTime;
import std.meta : Unqual;
import std.string;
import std.traits;
import std.utf;

extern(C) export struct returnValue(T) {
    T value;
    wstring error;

    this(T value) nothrow {
        this.value = value;
        static if (isArray!(T) || is(T == class) || is(T == interface)) {
            if (this.value !is null) {
                pinPointer(cast(void*)this.error.ptr);
            }
        }
        this.error = null;
    }

    this(Exception error) nothrow {
        this.value = T.init;
        try {
            this.error = to!wstring(error.toString());
        } catch(Exception ex) {
            this.error = "Unhandled Exception while marshalling exception data. You should never see this error.";
        }
        pinPointer(cast(void*)this.error.ptr);
    }
}

extern(C) export struct returnVoid {
    wstring error = null;

    this(Exception error) nothrow {
        try {
            this.error = to!wstring(error.toString());
        } catch(Exception ex) {
            this.error = "Unhandled Exception while marshalling exception data. You should never see this error.";
        }
        pinPointer(cast(void*)this.error.ptr);
    }
}

extern(C) export struct datetime {
    long ticks;
    long offset;

    public this(Duration value) {
        this.ticks = value.total!"hnsecs";
        this.offset = 0;
    }

    public this(DateTime value) {
        this.ticks = SysTime(value).stdTime;
        this.offset = 0;
    }

    public this(Date value) {
        this.ticks = SysTime(value).stdTime;
        this.offset = 0;
    }

    public this(TimeOfDay value) {
        import core.time : Duration, hours, minutes, seconds;
        Duration t = hours(value.hour) + minutes(value.minute) + seconds(value.second);
        this.ticks = t.total!"hnsecs";
        this.offset = 0;
    }

    public this(SysTime value) {
        this.ticks = value.stdTime;
        this.offset = value.utcOffset.total!"hnsecs";
    }
}

public void pinPointer(void* ptr) nothrow {
    GC.setAttr(ptr, GC.BlkAttr.NO_MOVE);
    GC.addRoot(ptr);
}

public datetime toDatetime(T)(T value)
if (isDateTimeType!T) {
    return datetime(value);
}

public datetime[] toDatetime1DArray(T)(T[] value)
if (isDateTimeType!T) {
    import std.algorithm : map;
    import std.array : array;
    return value.map!datetime.array;
}

public T fromDatetime(T)(datetime value) if (is(Unqual!T == SysTime)) {
    return SysTime(value.ticks, cast(immutable)new SimpleTimeZone(hnsecs(value.offset)));
}

public T fromDatetime(T)(datetime value) if (is(Unqual!T == DateTime)) {
    return cast(T)SysTime(value.ticks, LocalTime());
}

public T fromDatetime(T)(datetime value) if (is(Unqual!T == Date) || is(Unqual!T == TimeOfDay)) {
    return cast(T)SysTime(value.ticks, cast(immutable)new SimpleTimeZone(hnsecs(0)));
}

public T fromDatetime(T)(datetime value) if (is(Unqual!T == Duration)) {
    return hnsecs(value.ticks);
}

public T[] fromDatetime1DArray(T)(datetime[] value)
if (isDateTimeType!T) {
    import std.algorithm : map;
    import std.array : array;
    return value.map!(fromDatetime!T).array;
}

public string wrapCSharp(in Modules modules, OutputFileName outputFile, LibraryName libraryName, RootNamespace rootNamespace) @safe pure {
    import std.format : format;
    import std.algorithm: map;
    import std.array: join;
    import autowrap.common;
    import autowrap.csharp.boilerplate;

    if(!__ctfe) return null;

    const modulesList = modules.value.map!(a => a.toString).join(", ");

    return q{
        import core.memory : GC;
        import std.conv : to;
        import std.utf : toUTF8, toUTF16, toUTF32;
        import std.typecons;
        import std.string : fromStringz;
        import autowrap.csharp.boilerplate;
        import autowrap.csharp.dlang : wrapDLang;

        extern(C) export void autowrap_csharp_release(void* ptr) nothrow {
            GC.clrAttr(ptr, GC.BlkAttr.NO_MOVE);
            GC.removeRoot(ptr);
        }

        extern(C) export string autowrap_csharp_createString(wchar* str) nothrow {
            string temp = toUTF8(to!wstring(str.fromStringz()));
            pinPointer(cast(void*)temp.ptr);
            return temp;
        }

        extern(C) export wstring autowrap_csharp_createWString(wchar* str) nothrow {
            wstring temp = toUTF16(to!wstring(str.fromStringz()));
            pinPointer(cast(void*)temp.ptr);
            return temp;
        }

        extern(C) export dstring autowrap_csharp_createDString(wchar* str) nothrow {
            dstring temp = toUTF32(to!wstring(str.fromStringz()));
            pinPointer(cast(void*)temp.ptr);
            return temp;
        }

        mixin(wrapDLang!(%1$s));

        //Insert DllMain for Windows only.
        version(Windows) {
            %2$s
        }

        void main() {
            import std.stdio;
            string generated = generateCSharp!(%1$s)(LibraryName("%3$s"), RootNamespace("%4$s"));
            auto f = File("%5$s", "w");
            f.writeln(generated);
        }
    }.format(modulesList, dllMainMixinStr(), libraryName.value, rootNamespace.value, outputFile.value);
}
