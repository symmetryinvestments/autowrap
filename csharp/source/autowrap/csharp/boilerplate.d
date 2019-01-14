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

public struct OutputFileName {
    string value;
}

public string wrapCSharp(in Modules modules, OutputFileName outputFile, LibraryName libraryName, RootNamespace rootNamespace) @safe pure {
    import std.format : format;
    import std.algorithm: map;
    import std.array: join;

    if(!__ctfe) return null;

    const modulesList = modules.value.map!(a => a.toString).join(", ");

    return q{
        //Insert shared boilerplate code
        %1$s

        import std.typecons;
        import autowrap.csharp.boilerplate;
        import autowrap.csharp.dlang : wrapDLang;

        immutable string t = wrapDLang!(%2$s);
        mixin(t);
        //pragma(msg, t); //Uncomment to see generated D interface code, useful for debugging.

        //Insert DllMain for Windows only.
        version(Windows) {
            %3$s
        }

        void main() {
            import std.stdio;
            string generated = generateCSharp!(%2$s)(LibraryName("%4$s"), RootNamespace("%5$s"));
            auto f = File("%6$s", "w");
            f.writeln(generated);
        }
    }.format(commonBoilerplate(), modulesList, dllMainMixinStr(), libraryName.value, rootNamespace.value, outputFile.value);
}

/**
   Returns a string to be mixed in that defines the boilerplate code needed by all C# interfaces.
 */
private string commonBoilerplate() @safe pure {
    return q{
        import std.datetime : DateTime, SysTime, Date, TimeOfDay, SimpleTimeZone, LocalTime;
        import core.time;
        import core.memory;
        import std.conv;
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

        mixin(generateSharedTypes());

        public void pinPointer(void* ptr) nothrow {
            GC.setAttr(ptr, GC.BlkAttr.NO_MOVE);
            GC.addRoot(ptr);
        }

        public datetime toDatetime(T)(T value)
        if (is(T == SysTime) || is(T == DateTime) || is(T == Date) || is(T == TimeOfDay) || is(T == Duration)) {
            return datetime(value);
        }

        public datetime[] toDatetimeArray(T)(T value)
        if (is(T == SysTime[]) || is(T == DateTime[]) || is(T == Date[]) || is(T == TimeOfDay[]) || is(T == Duration[])) {
            datetime[] array = datetime[].init;
            array.reserve(value.length);
            foreach(t; value) {
                array ~= datetime(t);
            }
            return array;
        }

        public T fromDatetime(T)(datetime value)
        if (is(T == SysTime) || is(T == DateTime) || is(T == Date) || is(T == TimeOfDay) || is(T == Duration)) {
            static if (is(T == SysTime)) {
                return SysTime(value.ticks, cast(immutable)new SimpleTimeZone(hnsecs(value.offset)));
            } else static if (is(T == DateTime)) {
                return cast(DateTime)SysTime(value.ticks, LocalTime());
            } else static if (is(T == Date)) {
                return cast(Date)SysTime(value.ticks, cast(immutable)new SimpleTimeZone(hnsecs(0)));
            } else static if (is(T == TimeOfDay)) {
                return cast(TimeOfDay)SysTime(value.ticks, cast(immutable)new SimpleTimeZone(hnsecs(0)));
            } else static if (is(T == Duration)) {
                return hnsecs(value.ticks);
            }
        }

        public T fromDatetimeArray(T)(datetime[] value)
        if (is(T == SysTime[]) || is(T == DateTime[]) || is(T == Date[]) || is(T == TimeOfDay[]) || is(T == Duration[])) {
            T array = T.init;
            array.reserve(value.length);
            foreach(t; value) {
                static if (is(T == SysTime[])) {
                    array ~= SysTime(t.ticks, cast(immutable)new SimpleTimeZone(hnsecs(t.offset)));
                } else static if (is(T == DateTime[])) {
                    array ~= cast(DateTime)SysTime(t.ticks, LocalTime());
                } else static if (is(T == Date[])) {
                    array ~= cast(Date)SysTime(t.ticks, cast(immutable)new SimpleTimeZone(hnsecs(0)));
                } else static if (is(T == TimeOfDay[])) {
                    array ~= cast(TimeOfDay)SysTime(t.ticks, cast(immutable)new SimpleTimeZone(hnsecs(0)));
                } else static if (is(T == Duration[])) {
                    array ~= hnsecs(t.ticks);
                }
            }
            return array;
        }

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
    };
}
