int main(string[] args) @safe {
    try {
        run(args);
        return 0;
    } catch(Exception e) {
        import std.stdio: stderr;
        () @trusted { stderr.writeln("Error: ", e); }();
        return 1;
    }
}


void run(string[] args) @safe {
    import std.exception: enforce;
    import std.conv: text;
    import std.file: mkdirRecurse, thisExePath;
    import std.path: buildPath, dirName;
    import std.stdio: File;
    import std.format: format;

    enforce(args.length == 2, "Usage: create <phobos module/package (e.g. `file`)>");
    const name = args[1];
    const stdName = "std_" ~ name;
    const projDir = buildPath(thisExePath.dirName, stdName);
    mkdirRecurse(buildPath(projDir, "source"));

    {
        auto dubSdl = File(buildPath(projDir, "dub.sdl"), "w");
        dubSdl.writeln(`
            name "%s"
            targetType "dynamicLibrary"


            configuration "python38" {
                targetPath "lib/pyd"
                lflags "-L$PYTHON_LIB_DIR"
                dependency "autowrap:python" path="../../.."
                subConfiguration "autowrap:python" "python38"
            }

            configuration "python37" {
                targetPath "lib/pyd"
                lflags "-L$PYTHON_LIB_DIR"
                dependency "autowrap:python" path="../../.."
                subConfiguration "autowrap:python" "python37"
            }

            configuration "python36" {
                targetPath "lib/pyd"
                dependency "autowrap:python" path="../../.."
                subConfiguration "autowrap:python" "python36"
            }

            configuration "python33" {
                targetPath "lib/pyd"
                dependency "autowrap:python" path="../../.."
                subConfiguration "autowrap:python" "python33"
            }

            configuration "python27" {
                targetPath "lib/pyd"
                dependency "autowrap:python" path="../../.."
                subConfiguration "autowrap:python" "python27"
            }

            configuration "env" {
                targetPath "lib/pyd"
                dependency "autowrap:python" path="../../.."
                subConfiguration "autowrap:python" "env"
            }

            configuration "pynih" {
                targetPath "lib/pynih"
                lflags "-L$PYTHON_LIB_DIR"
                dependency "autowrap:pynih" path="../../.."
            }
        `.format(stdName).deindent
        );
    }

    {
        auto selections = File(buildPath(projDir, "dub.selections.json"), "w");
        selections.writeln(`
            {
            	"fileVersion": 1,
            	"versions": {
            		"autowrap": {"path":"../../.."},
            		"mirror": "0.3.0",
            		"pyd": "0.14.0",
            		"unit-threaded": "1.0.4"
            	}
            }
        `.deindent);
    }

    {
        auto app = File(buildPath(projDir, "source", "app.d"), "w");
        app.writeln(q{
            import autowrap;

            enum str = wrapDlang!(
                LibraryName("%s"),
                Modules(
                    Yes.alwaysExport,
                    "std.%s",
                    )
                );

            // pragma(msg, str);
            mixin(str);
        }.format(stdName, name).deindent);
    }

    {
        auto makefile = File(buildPath(thisExePath.dirName, "Makefile"), "a");
        makefile.writeln(`$(eval $(call test-package,%s))`.format(name));
    }

    {
        auto tests = File(buildPath(thisExePath.dirName, "tests", "test_" ~ stdName ~ ".py"), "w");
        tests.writeln(
`def test_import():
    import %s
`.format(stdName));
    }
}


private string deindent(in string str) @safe pure {
    import std.string: splitLines;
    import std.algorithm: map;
    import std.array: join;

    enum indent = 12;

    return str
        .splitLines
        [1..$]  // drop first empty line due to newline
        .map!(a => a.length >= indent ? a[indent .. $] : a)
        [0 .. $-1]  // drop empty last line due to newline
        .join("\n")
        ;
}
