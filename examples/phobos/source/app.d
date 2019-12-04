import autowrap;

version(Have_autowrap_pyd) {
    enum modules = Modules(
        Module("std.socket", Yes.alwaysExport),

        Module("std.algorithm.comparison", Yes.alwaysExport),
        Module("std.algorithm.iteration", Yes.alwaysExport),
        Module("std.algorithm.mutation", Yes.alwaysExport),
        Module("std.algorithm.searching", Yes.alwaysExport),
        Module("std.algorithm.setops", Yes.alwaysExport),
        Module("std.algorithm.sorting", Yes.alwaysExport),
        Module("std.array", Yes.alwaysExport),
        Module("std.ascii", Yes.alwaysExport),
        Module("std.base64", Yes.alwaysExport),
        Module("std.bigint", Yes.alwaysExport),
        // Module("std.bitmanip", Yes.alwaysExport),
        Module("std.compiler", Yes.alwaysExport),
        Module("std.complex", Yes.alwaysExport),
        Module("std.concurrency", Yes.alwaysExport),
    );
} else {
    enum modules = Modules(

        Module("std.algorithm.comparison", Yes.alwaysExport),
        Module("std.algorithm.iteration", Yes.alwaysExport),
        Module("std.algorithm.mutation", Yes.alwaysExport),
        Module("std.algorithm.searching", Yes.alwaysExport),
        Module("std.algorithm.setops", Yes.alwaysExport),
        Module("std.algorithm.sorting", Yes.alwaysExport),
        Module("std.array", Yes.alwaysExport),
        Module("std.ascii", Yes.alwaysExport),
        Module("std.base64", Yes.alwaysExport),
        Module("std.bigint", Yes.alwaysExport),
        Module("std.bitmanip", Yes.alwaysExport),
        Module("std.compiler", Yes.alwaysExport),
        Module("std.complex", Yes.alwaysExport),
        // Module("std.concurrency", Yes.alwaysExport), // compilation failure
        Module("std.container.array", Yes.alwaysExport),
        Module("std.container.binaryheap", Yes.alwaysExport),
        Module("std.container.dlist", Yes.alwaysExport),
        Module("std.container.rbtree", Yes.alwaysExport),
        Module("std.container.slist", Yes.alwaysExport),
        Module("std.container.util", Yes.alwaysExport),
        Module("std.conv", Yes.alwaysExport),
        Module("std.csv", Yes.alwaysExport),
        Module("std.datetime.date", Yes.alwaysExport),
        Module("std.datetime.interval", Yes.alwaysExport),
        Module("std.datetime.stopwatch", Yes.alwaysExport),
        // Module("std.datetime.systime", Yes.alwaysExport),  // linker Timezone propertyGet
        // Module("std.datetime.timezone", Yes.alwaysExport), // compilation failure
        Module("std.demangle", Yes.alwaysExport),
        Module("std.digest.crc", Yes.alwaysExport),
        Module("std.digest.digest", Yes.alwaysExport),
        Module("std.digest.hmac", Yes.alwaysExport),
        Module("std.digest.md", Yes.alwaysExport),
        Module("std.digest.murmurhash", Yes.alwaysExport),
        Module("std.digest.ripemd", Yes.alwaysExport),
        Module("std.digest.sha", Yes.alwaysExport),
        Module("std.encoding", Yes.alwaysExport),
        Module("std.exception", Yes.alwaysExport),
        Module("std.experimental.checkedint", Yes.alwaysExport),
        Module("std.experimental.typecons", Yes.alwaysExport),
        // Module("std.experimental.logger.core", Yes.alwaysExport), // compilation failure
        // Module("std.experimental.logger.filelogger", Yes.alwaysExport), // compilation failure
        // Module("std.experimental.logger.multilogger", Yes.alwaysExport), // compilation failure
        // Module("std.experimental.logger.nulllogger", Yes.alwaysExport),  // compilation failure
        // Module("std.experimental.allocator.common", Yes.alwaysExport), // compilation failure
        Module("std.experimental.allocator.gc_allocator", Yes.alwaysExport),
        Module("std.experimental.allocator.mallocator", Yes.alwaysExport),
        Module("std.experimental.allocator.mmap_allocator", Yes.alwaysExport),
        // Module("std.experimental.allocator.showcase", Yes.alwaysExport), // compilation failure
        Module("std.experimental.allocator.typed", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.affix_allocator", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.aligned_block_list", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.allocator_list", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.ascending_page_allocator", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.bitmapped_block", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.bucketizer", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.fallback_allocator", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.free_list", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.free_tree", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.kernighan_ritchie", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.null_allocator", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.quantizer", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.region", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.scoped_allocator", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.segregator", Yes.alwaysExport),
        Module("std.experimental.allocator.building_blocks.stats_collector", Yes.alwaysExport),
        // // Module("std.file", Yes.alwaysExport),  // compilation failure
        Module("std.format", Yes.alwaysExport),
        Module("std.functional", Yes.alwaysExport),
        Module("std.getopt", Yes.alwaysExport),
        Module("std.json", Yes.alwaysExport),
        // Module("std.math", Yes.alwaysExport), // undefined symbol rndtonl
        Module("std.mathspecial", Yes.alwaysExport),
        Module("std.meta", Yes.alwaysExport),
        // // Module("std.mmfile", Yes.alwaysExport), // compilation failure
        // Module("std.net.curl", Yes.alwaysExport), // compilation failure
        Module("std.net.isemail", Yes.alwaysExport),
        // Module("std.numeric", Yes.alwaysExport),  // compilation failure
        Module("std.outbuffer", Yes.alwaysExport),
        // Module("std.parallelism", Yes.alwaysExport), // compilation failure
        Module("std.path", Yes.alwaysExport),
        // Module("std.process", Yes.alwaysExport), // compilation failure
        // Module("std.random", Yes.alwaysExport), // compilation failure
        Module("std.range.interfaces", Yes.alwaysExport),
        Module("std.range.primitives", Yes.alwaysExport),
        Module("std.regex", Yes.alwaysExport),
        Module("std.signals", Yes.alwaysExport),
        Module("std.socket", Yes.alwaysExport),
        Module("std.stdint", Yes.alwaysExport),
        // Module("std.stdio", Yes.alwaysExport), // compilation failure
        Module("std.string", Yes.alwaysExport),
        Module("std.system", Yes.alwaysExport),
        Module("std.traits", Yes.alwaysExport),
        Module("std.typecons", Yes.alwaysExport),
        Module("std.typetuple", Yes.alwaysExport),
        // Module("std.uni", Yes.alwaysExport), // compilation failure
        Module("std.uri", Yes.alwaysExport),
        Module("std.utf", Yes.alwaysExport),
        Module("std.uuid", Yes.alwaysExport),
        // Module("std.variant", Yes.alwaysExport), // compilation failure
        Module("std.windows.charset", Yes.alwaysExport),
        Module("std.windows.registry", Yes.alwaysExport),
        Module("std.windows.syserror", Yes.alwaysExport),
        // Module("std.xml", Yes.alwaysExport), // compilation failure
        // Module("std.zip", Yes.alwaysExport),  // linker propertyGet TimeZone
        // Module("std.zlib", Yes.alwaysExport), // compilation failure
    );
}


enum str = wrapDlang!(
    LibraryName("phobos"),
    modules,
);

// pragma(msg, str);
mixin(str);
