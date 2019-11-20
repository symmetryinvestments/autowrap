/**
   Necessary boilerplate for C#/.NET.

   To wrap all functions/return/parameter types and struct/class definitions from
   a list of modules, write this in a "main" module and generate mylib.{so,dll}:

   ------
   mixin wrapCSharp("mylib", Modules("module1", "module2", ...));
   ------
 */
module autowrap.csharp.boilerplate;


import autowrap.types: Modules, LibraryName;
import autowrap.csharp.common: OutputFileName, RootNamespace;


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

    import std.traits: isDynamicArray;

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
        import std.conv: to;

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
    import std.conv: to;

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

// Used for core.time.Duration
extern(C) export struct Marshalled_Duration {

    import core.time : dur, Duration;

    long hnsecs;

    this(Duration d)
    {
        hnsecs = d.total!"hnsecs";
    }

    Duration opCast() { return dur!"hnsecs"(hnsecs); }
}

// Used for Date, DateTime, and TimeOfDay from std.datetime.date.
// Unfortunately, C# doesn't really have a clean way of representing any of
// them. So, barring the use of a 3rd party library like Noda, the two options
// are to either use C#'s DateTime or create new types. Laeeth wanted the D
// date/time types to marshall to the standard C# date/time types. So, the
// current solution is to convert std.datetime.DateTime to a C# DateTime with
// UTC as its DateTimeKind so that the value doesn't risk changing based on
// time zone issues. std.datetime.Date will be converted to a C# DateTime with
// DateTimeKind.UTC and midnight for the time. std.datetime.TimeOfDay will be
// converted to a C# Datetime with DateTimeKind.Utc and January 1st, 1 A.D. as
// its date. When converting from C# to D, C#'s DateTime's properties will be
// used to get the values out so that the values will match whatever
// DateTimeKind the Datetime is using. std.datetime.Date will then ignore the
// hour, minute, and second values, and std.datetime.TimeOfDay will then ignore
// the year, month, and day values.
// The marshalled type does not need to keep track of whether a DateTime, Date,
// or TimeOfDay is intended, because the generated D code using it knows which
// D date/time type it's working with and will generate the correct conversion
// code.
extern(C) export struct Marshalled_std_datetime_date {

    import std.datetime.date : Date, DateTime, TimeOfDay;
    import std.traits: Unqual;

    // = 1 so that the result is a valid C# DateTime when the D type is Date
    short year = 1;
    ubyte month = 1;
    ubyte day = 1;
    ubyte hour;
    ubyte minute;
    ubyte second;

    this(DateTime dt)
    {
        year = dt.year;
        month = dt.month;
        day = dt.day;
        hour = dt.hour;
        minute = dt.minute;
        second = dt.second;
    }

    this(Date d)
    {
        year = d.year;
        month = d.month;
        day = d.day;
    }

    this(TimeOfDay tod)
    {
        hour = tod.hour;
        minute = tod.minute;
        second = tod.second;
    }

    DateTime opCast(T)()
        if(is(Unqual!T == DateTime))
    {
        return DateTime(year, month, day, hour, minute, second);
    }

    Date opCast(T)()
        if(is(Unqual!T == Date))
    {
        return Date(year, month, day);
    }

    TimeOfDay opCast(T)()
        if(is(Unqual!T == TimeOfDay))
    {
        return TimeOfDay(hour, minute, second);
    }
}

// Used for std.datetime.systime.SysTime. It will be converted to C#'s
// DateTimeOffset. Unfortunately, DateTimeOffset does not have a way to
// uniquely distinguish UTC or local time in the way that SysTime does.
// Essentially, it's the equivalent of a SysTime which always uses a
// SimpleTimeZone for its timezone property. The current solution is to treat
// an offset of 0 as always being UTC (since odds are that that's what it is,
// and it requires less memory allocation that way), but since assuming that
// a UTC offset that matches the local time is intended to be treated as local
// time could cause problems, it unfortunately is treated as just another
// SimpleTimeZone rather than LocalTime.
extern(C) export struct Marshalled_std_datetime_systime {

    import core.time : hnsecs;
    import std.datetime.systime : SysTime;

    long ticks; // SysTime's stdTime is equivalent to C#'s Ticks
    long utcOffset; // in hnsecs

    this(SysTime st)
    {
        ticks = st.stdTime;
        utcOffset = st.utcOffset.total!"hnsecs";
    }

    SysTime opCast() {
        import std.datetime.timezone : SimpleTimeZone, UTC;
        return SysTime(ticks, utcOffset == 0 ? UTC() : new immutable SimpleTimeZone(hnsecs(utcOffset)));
    }
}

public auto mapArray(alias pred, T)(T[] arr)
{
    import std.algorithm.iteration : map;
    import std.array : array;
    return arr.map!pred.array;
}

public void pinPointer(void* ptr) nothrow {
    import core.memory: GC;
    GC.setAttr(ptr, GC.BlkAttr.NO_MOVE);
    GC.addRoot(ptr);
}

extern(C) void rt_moduleTlsCtor();
extern(C) void rt_moduleTlsDtor();

struct AttachThread
{
    static create() nothrow
    {
        import core.thread : Thread, thread_attachThis;

        typeof(this) retval;

        retval.notAttached = Thread.getThis() is null;

        if(retval.notAttached)
        {
            try
            {
                thread_attachThis();
                rt_moduleTlsCtor();
            }
            catch(Exception)
                assert(0, "An Exception shouldn't be possible here, but it happened anyway.");
        }

        return retval;
    }

    ~this() nothrow
    {
        import core.thread : thread_detachThis;

        if(notAttached)
        {
            try
            {
                thread_detachThis();
                rt_moduleTlsDtor();
            }
            catch(Exception)
                assert(0, "An Exception shouldn't be possible here, but it happened anyway.");
        }
    }

    private bool notAttached = false;
}

public string wrapCSharp(
    in Modules modules,
    in OutputFileName outputFile,
    in LibraryName libraryName,
    in RootNamespace rootNamespace)
    @safe pure
{
    import std.format : format;
    import std.algorithm: map;
    import std.array: join;
    import autowrap.common: dllMainMixinStr;
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
            import autowrap.csharp.boilerplate : AttachThread, pinPointer;

            auto attachThread = AttachThread.create();
            string temp = toUTF8(str.fromStringz());
            pinPointer(cast(void*)temp.ptr);
            return temp;
        }

        extern(C) export wstring autowrap_csharp_createWString(wchar* str) nothrow {
            import std.string : fromStringz;
            import std.utf : toUTF16;
            import autowrap.csharp.boilerplate : pinPointer;

            auto attachThread = AttachThread.create();
            wstring temp = toUTF16(str.fromStringz());
            pinPointer(cast(void*)temp.ptr);
            return temp;
        }

        extern(C) export dstring autowrap_csharp_createDString(wchar* str) nothrow {
            import std.string : fromStringz;
            import std.utf : toUTF32;
            import autowrap.csharp.boilerplate : pinPointer;

            auto attachThread = AttachThread.create();
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
            import autowrap.types: LibraryName;
            import autowrap.csharp.common : RootNamespace;
            import autowrap.csharp.csharp : generateCSharp;
            string generated = generateCSharp!(%1$s)(LibraryName("%3$s"), RootNamespace("%4$s"));
            auto f = File("%5$s", "w");
            f.writeln(generated);
        }
    }.format(modulesList, dllMainMixinStr(), libraryName.value, rootNamespace.value, outputFile.value);
}
