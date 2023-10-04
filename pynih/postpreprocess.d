#!/usr/bin/env rdmd

/// Remove system libraries from the preprocessed output

import std.stdio;
import std.string;
import std.array;
import std.algorithm;

void main() {
    bool skip = false;
    foreach (line; stdin.byLine()) {
        line = chomp(line);

        if (!skip)
            writeln(line);

        if (line.startsWith("# "))
        {
            auto toks = line.strip().split(" ");
            auto linenum = toks[1];
            auto filename = toks[2];
            auto flags = toks[3 .. $];

            skip = flags.canFind("3");
        }
    }
}
