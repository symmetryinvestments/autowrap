import autowrap;

enum str = wrapDlang!(
    LibraryName("std_experimental"),
    Modules(
        Yes.alwaysExport,
        "std.experimental.checkedint",
        "std.experimental.typecons",
        // "std.experimental.logger.core", // compilation failure
        // "std.experimental.logger.filelogger", // compilation failure
        // "std.experimental.logger.multilogger", // compilation failure
        // "std.experimental.logger.nulllogger",  // compilation failure
        // "std.experimental.allocator.common", // compilation failure
        "std.experimental.allocator.gc_allocator",
        "std.experimental.allocator.mallocator",
        "std.experimental.allocator.mmap_allocator",
        // "std.experimental.allocator.showcase",
        "std.experimental.allocator.typed",
        "std.experimental.allocator.building_blocks.affix_allocator",
        "std.experimental.allocator.building_blocks.aligned_block_list",
        "std.experimental.allocator.building_blocks.allocator_list",
        "std.experimental.allocator.building_blocks.ascending_page_allocator",
        "std.experimental.allocator.building_blocks.bitmapped_block",
        "std.experimental.allocator.building_blocks.bucketizer",
        "std.experimental.allocator.building_blocks.fallback_allocator",
        "std.experimental.allocator.building_blocks.free_list",
        "std.experimental.allocator.building_blocks.free_tree",
        "std.experimental.allocator.building_blocks.kernighan_ritchie",
        "std.experimental.allocator.building_blocks.null_allocator",
        "std.experimental.allocator.building_blocks.quantizer",
        "std.experimental.allocator.building_blocks.region",
        "std.experimental.allocator.building_blocks.scoped_allocator",
        "std.experimental.allocator.building_blocks.segregator",
        "std.experimental.allocator.building_blocks.stats_collector",
        )
    );

// pragma(msg, str);
mixin(str);
