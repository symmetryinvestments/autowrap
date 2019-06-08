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
import std.traits : Unqual;
import std.string;
import std.traits;
import std.utf;

private void pinInternalPointers(T)(ref T value) @trusted nothrow
    if(is(T == struct))
{
    import std.traits : Fields, isPointer, isDynamicArray, isStaticArray;

    static foreach(i, Field; Fields!T)
    {
        static assert(!isPointer!T, "If we're now supporting pointers, this code needs to be updated");
        static assert(!isStaticArray!T, "If we're now supporting static arrays, this code needs to be updated");

        static if(is(Field == struct))
            pinInternalPointers(value.tupleof[i]);
        else static if(isDynamicArray!Field)
        {
            if(value.tupleof[i] !is null)
                pinPointer(cast(void*)value.tupleof[i].ptr);
        }
        else static if(is(Field == class) || is(Field == interface))
        {
            if(value.tupleof[i] !is null)
                pinPointer(cast(void*)value.tupleof[i]);
        }
    }
}

extern(C) export struct returnValue(T) {
    T value;
    wstring error;

    this(T value) nothrow {
        this.value = value;
        static if (isDynamicArray!T)
        {
            if (this.value !is null)
                pinPointer(cast(void*)this.value.ptr);
        }
        else static if (is(T == class) || is(T == interface))
        {
            if (this.value !is null)
                pinPointer(cast(void*)this.value);
        }
        else static if (is(T == struct))
            pinInternalPointers(value);
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
        extern(C) export void autowrap_csharp_release(void* ptr) nothrow {
            import core.memory : GC;
            GC.clrAttr(ptr, GC.BlkAttr.NO_MOVE);
            GC.removeRoot(ptr);
        }

        extern(C) export string autowrap_csharp_createString(wchar* str) nothrow {
            import std.string : fromStringz;
            import std.utf : toUTF8;
            import autowrap.csharp.boilerplate : pinPointer;
            string temp = toUTF8(str.fromStringz());
            pinPointer(cast(void*)temp.ptr);
            return temp;
        }

        extern(C) export wstring autowrap_csharp_createWString(wchar* str) nothrow {
            import std.string : fromStringz;
            import std.utf : toUTF16;
            import autowrap.csharp.boilerplate : pinPointer;
            wstring temp = toUTF16(str.fromStringz());
            pinPointer(cast(void*)temp.ptr);
            return temp;
        }

        extern(C) export dstring autowrap_csharp_createDString(wchar* str) nothrow {
            import std.string : fromStringz;
            import std.utf : toUTF32;
            import autowrap.csharp.boilerplate : pinPointer;
            dstring temp = toUTF32(str.fromStringz());
            pinPointer(cast(void*)temp.ptr);
            return temp;
        }

        static import autowrap.csharp.dlang;
        mixin(autowrap.csharp.dlang.wrapDLang!(%1$s));

        //Insert DllMain for Windows only.
        version(Windows) {
            %2$s
        }

        void main() {
            import std.stdio : File;
            import autowrap.csharp.common : LibraryName, RootNamespace;
            import autowrap.csharp.csharp : generateCSharp;
            string generated = generateCSharp!(%1$s)(LibraryName("%3$s"), RootNamespace("%4$s"));
            auto f = File("%5$s", "w");
            f.writeln(generated);
        }
    }.format(modulesList, dllMainMixinStr(), libraryName.value, rootNamespace.value, outputFile.value);
}
