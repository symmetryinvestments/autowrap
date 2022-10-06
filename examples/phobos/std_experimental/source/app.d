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
        "std.experimental.allocator.common",
        "std.experimental.allocator.gc_allocator",
        "std.experimental.allocator.mallocator",
        "std.experimental.allocator.mmap_allocator",
        "std.experimental.allocator.showcase",
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


/**
   Without this there is a linker error (only pyd) about an undefined
   symbol corrensponding to the .init value for the TypeInfo object.
*/
void hack0() {
    import std.experimental.allocator.building_blocks.region: Region;
    import std.experimental.allocator.mmap_allocator: MmapAllocator;
    import std.typecons: Flag;
    auto id = typeid(Region!(MmapAllocator));
}


// FIXME - The linker error comes from `toStructImpl` but causing it
// to not compile causes problems for other structs.
pragma(mangle, "_D6python4conv11python_to_d__T2toTS3std12experimental9allocator15building_blocks14allocator_list__T13AllocatorListTSQDdQDcQCr8showcase14mmapRegionListFmZ7FactoryTSQEyQExQEmQEf14null_allocator13NullAllocatorZQEe4NodeZQHeFNePSQIo3raw7_objectZPQHz")
extern(C) void hack1() {

    import std.experimental.allocator.building_blocks.region: Region;
    import std.experimental.allocator.mmap_allocator: MmapAllocator;
    import std.typecons: Flag;
    auto id = typeid(Region!(MmapAllocator));
}


pragma(mangle, "_D6python4conv11d_to_python__T8toPythonTS3std12experimental9allocator15building_blocks14allocator_list__T13AllocatorListTSQDdQDcQCr8showcase14mmapRegionListFmZ7FactoryTSQEyQExQEmQEf14null_allocator13NullAllocatorZQEe4NodeZQHkFKQHfZPSQIx3raw7_object")
extern(C) void hack2() { assert(0); }

pragma(mangle, "_D6python4conv11python_to_d__T2toTxS3std12experimental9allocator15building_blocks14allocator_list__T13AllocatorListTSQDdQDcQCr8showcase14mmapRegionListFmZ7FactoryTSQEyQExQEmQEf14null_allocator13NullAllocatorZQEe4NodeZQHfFNePSQIp3raw7_objectZPxQIa")
extern(C) void hack3() { assert(0); }

pragma(mangle, "_D6python4type__T13PythonCompareTS3std12experimental9allocator15building_blocks14allocator_list__T13AllocatorListTSQDdQDcQCr8showcase14mmapRegionListFmZ7FactoryTSQEyQExQEmQEf14null_allocator13NullAllocatorZQEe4NodeZ7_py_cmpUNbPSQIs3raw7_objectQriZQv")
private void hack4() { assert(0); }

pragma(mangle, "_D6python4type__T10PythonTypeTS3std12experimental9allocator15building_blocks14allocator_list__T13AllocatorListTSQDdQDcQCr8showcase14mmapRegionListFmZ7FactoryTSQEyQExQEmQEf14null_allocator13NullAllocatorZQEe4NodeZQHn__T10methodDefsZQnFNbNiZPSQJf3raw11PyMethodDef")
private void hack5() { assert(0); }
