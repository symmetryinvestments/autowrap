module python.raw;


        import core.stdc.config;
        import core.stdc.stdarg: va_list;
        static import core.simd;
        static import std.conv;

        struct Int128 { long lower; long upper; }
        struct UInt128 { ulong lower; ulong upper; }

        struct __locale_data { int dummy; }


alias _Bool = bool;
struct dpp {

    static bool isEmpty(T)() {
        return T.tupleof.length == 0;
    }
    static struct Move(T) {
        T* ptr;
    }

    static auto move(T)(ref T value) {
        return Move!T(&value);
    }
    mixin template EnumD(string name, T, string prefix) if(is(T == enum)) {
        private static string _memberMixinStr(string member) {
            import std.conv: text;
            import std.array: replace;
            return text(` `, member.replace(prefix, ""), ` = `, T.stringof, `.`, member, `,`);
        }
        private static string _enumMixinStr() {
            import std.array: join;
            string[] ret;
            ret ~= "enum " ~ name ~ "{";
            static foreach(member; __traits(allMembers, T)) {
                ret ~= _memberMixinStr(member);
            }
            ret ~= "}";
            return ret.join("\n");
        }
        mixin(_enumMixinStr());
    }
}

extern(C)
{
    alias wchar_t = int;
    alias size_t = c_ulong;
    alias ptrdiff_t = c_long;
    struct max_align_t
    {
        long __clang_max_align_nonce1;
        real __clang_max_align_nonce2;
    }
    c_ulong wcsftime_l(int*, c_ulong, const(int)*, const(tm)*, __locale_struct*) @nogc nothrow;
    c_ulong wcsftime(int*, c_ulong, const(int)*, const(tm)*) @nogc nothrow;
    int fputws_unlocked(const(int)*, _IO_FILE*) @nogc nothrow;
    int* fgetws_unlocked(int*, int, _IO_FILE*) @nogc nothrow;
    uint putwchar_unlocked(int) @nogc nothrow;
    uint putwc_unlocked(int, _IO_FILE*) @nogc nothrow;
    uint fputwc_unlocked(int, _IO_FILE*) @nogc nothrow;
    uint fgetwc_unlocked(_IO_FILE*) @nogc nothrow;
    uint getwchar_unlocked() @nogc nothrow;
    uint getwc_unlocked(_IO_FILE*) @nogc nothrow;
    uint ungetwc(uint, _IO_FILE*) @nogc nothrow;
    int fputws(const(int)*, _IO_FILE*) @nogc nothrow;
    int* fgetws(int*, int, _IO_FILE*) @nogc nothrow;
    uint putwchar(int) @nogc nothrow;
    uint putwc(int, _IO_FILE*) @nogc nothrow;
    uint fputwc(int, _IO_FILE*) @nogc nothrow;
    uint getwchar() @nogc nothrow;
    uint getwc(_IO_FILE*) @nogc nothrow;
    uint fgetwc(_IO_FILE*) @nogc nothrow;
    int vswscanf(const(int)*, const(int)*, va_list*) @nogc nothrow;
    int vwscanf(const(int)*, va_list*) @nogc nothrow;
    int vfwscanf(_IO_FILE*, const(int)*, va_list*) @nogc nothrow;
    int swscanf(const(int)*, const(int)*, ...) @nogc nothrow;
    int wscanf(const(int)*, ...) @nogc nothrow;
    int fwscanf(_IO_FILE*, const(int)*, ...) @nogc nothrow;
    int vswprintf(int*, c_ulong, const(int)*, va_list*) @nogc nothrow;
    int vwprintf(const(int)*, va_list*) @nogc nothrow;
    int vfwprintf(_IO_FILE*, const(int)*, va_list*) @nogc nothrow;
    int swprintf(int*, c_ulong, const(int)*, ...) @nogc nothrow;
    int wprintf(const(int)*, ...) @nogc nothrow;
    int fwprintf(_IO_FILE*, const(int)*, ...) @nogc nothrow;
    int fwide(_IO_FILE*, int) @nogc nothrow;
    _IO_FILE* open_wmemstream(int**, c_ulong*) @nogc nothrow;
    int* wcpncpy(int*, const(int)*, c_ulong) @nogc nothrow;
    int* wcpcpy(int*, const(int)*) @nogc nothrow;
    real wcstof64x_l(const(int)*, int**, __locale_struct*) @nogc nothrow;
    double wcstof32x_l(const(int)*, int**, __locale_struct*) @nogc nothrow;
    double wcstof64_l(const(int)*, int**, __locale_struct*) @nogc nothrow;
    float wcstof32_l(const(int)*, int**, __locale_struct*) @nogc nothrow;
    real wcstold_l(const(int)*, int**, __locale_struct*) @nogc nothrow;
    float wcstof_l(const(int)*, int**, __locale_struct*) @nogc nothrow;
    double wcstod_l(const(int)*, int**, __locale_struct*) @nogc nothrow;
    ulong wcstoull_l(const(int)*, int**, int, __locale_struct*) @nogc nothrow;
    long wcstoll_l(const(int)*, int**, int, __locale_struct*) @nogc nothrow;
    c_ulong wcstoul_l(const(int)*, int**, int, __locale_struct*) @nogc nothrow;
    c_long wcstol_l(const(int)*, int**, int, __locale_struct*) @nogc nothrow;
    ulong wcstouq(const(int)*, int**, int) @nogc nothrow;
    long wcstoq(const(int)*, int**, int) @nogc nothrow;
    ulong wcstoull(const(int)*, int**, int) @nogc nothrow;
    long wcstoll(const(int)*, int**, int) @nogc nothrow;
    c_ulong wcstoul(const(int)*, int**, int) @nogc nothrow;
    c_long wcstol(const(int)*, int**, int) @nogc nothrow;
    real wcstof64x(const(int)*, int**) @nogc nothrow;
    double wcstof32x(const(int)*, int**) @nogc nothrow;
    double wcstof64(const(int)*, int**) @nogc nothrow;
    float wcstof32(const(int)*, int**) @nogc nothrow;
    real wcstold(const(int)*, int**) @nogc nothrow;
    float wcstof(const(int)*, int**) @nogc nothrow;
    double wcstod(const(int)*, int**) @nogc nothrow;
    int wcswidth(const(int)*, c_ulong) @nogc nothrow;
    int wcwidth(int) @nogc nothrow;
    c_ulong wcsnrtombs(char*, const(int)**, c_ulong, c_ulong, __mbstate_t*) @nogc nothrow;
    c_ulong mbsnrtowcs(int*, const(char)**, c_ulong, c_ulong, __mbstate_t*) @nogc nothrow;
    c_ulong wcsrtombs(char*, const(int)**, c_ulong, __mbstate_t*) @nogc nothrow;
    c_ulong mbsrtowcs(int*, const(char)**, c_ulong, __mbstate_t*) @nogc nothrow;
    c_ulong mbrlen(const(char)*, c_ulong, __mbstate_t*) @nogc nothrow;
    c_ulong __mbrlen(const(char)*, c_ulong, __mbstate_t*) @nogc nothrow;
    c_ulong wcrtomb(char*, int, __mbstate_t*) @nogc nothrow;
    c_ulong mbrtowc(int*, const(char)*, c_ulong, __mbstate_t*) @nogc nothrow;
    int mbsinit(const(__mbstate_t)*) @nogc nothrow;
    int wctob(uint) @nogc nothrow;
    uint btowc(int) @nogc nothrow;
    int* wmempcpy(int*, const(int)*, c_ulong) @nogc nothrow;
    int* wmemset(int*, int, c_ulong) @nogc nothrow;
    int* wmemmove(int*, const(int)*, c_ulong) @nogc nothrow;
    int* wmemcpy(int*, const(int)*, c_ulong) @nogc nothrow;
    int wmemcmp(const(int)*, const(int)*, c_ulong) @nogc nothrow;
    int* wmemchr(const(int)*, int, c_ulong) @nogc nothrow;
    c_ulong wcsnlen(const(int)*, c_ulong) @nogc nothrow;
    int* wcswcs(const(int)*, const(int)*) @nogc nothrow;
    c_ulong wcslen(const(int)*) @nogc nothrow;
    int* wcstok(int*, const(int)*, int**) @nogc nothrow;
    int* wcsstr(const(int)*, const(int)*) @nogc nothrow;
    int* wcspbrk(const(int)*, const(int)*) @nogc nothrow;
    c_ulong wcsspn(const(int)*, const(int)*) @nogc nothrow;
    c_ulong wcscspn(const(int)*, const(int)*) @nogc nothrow;
    int* wcschrnul(const(int)*, int) @nogc nothrow;
    int* wcsrchr(const(int)*, int) @nogc nothrow;
    int* wcschr(const(int)*, int) @nogc nothrow;
    int* wcsdup(const(int)*) @nogc nothrow;
    c_ulong wcsxfrm_l(int*, const(int)*, c_ulong, __locale_struct*) @nogc nothrow;
    int wcscoll_l(const(int)*, const(int)*, __locale_struct*) @nogc nothrow;
    c_ulong wcsxfrm(int*, const(int)*, c_ulong) @nogc nothrow;
    int wcscoll(const(int)*, const(int)*) @nogc nothrow;
    int wcsncasecmp_l(const(int)*, const(int)*, c_ulong, __locale_struct*) @nogc nothrow;
    int wcscasecmp_l(const(int)*, const(int)*, __locale_struct*) @nogc nothrow;
    int wcsncasecmp(const(int)*, const(int)*, c_ulong) @nogc nothrow;
    int wcscasecmp(const(int)*, const(int)*) @nogc nothrow;
    pragma(mangle, "alloca") void* alloca_(c_ulong) @nogc nothrow;
    int wcsncmp(const(int)*, const(int)*, c_ulong) @nogc nothrow;
    int wcscmp(const(int)*, const(int)*) @nogc nothrow;
    int* wcsncat(int*, const(int)*, c_ulong) @nogc nothrow;
    int* wcscat(int*, const(int)*) @nogc nothrow;
    int* wcsncpy(int*, const(int)*, c_ulong) @nogc nothrow;
    int* wcscpy(int*, const(int)*) @nogc nothrow;
    int getentropy(void*, c_ulong) @nogc nothrow;
    void swab(const(void)*, void*, c_long) @nogc nothrow;
    char* crypt(const(char)*, const(char)*) @nogc nothrow;
    int fdatasync(int) @nogc nothrow;
    c_long copy_file_range(int, c_long*, int, c_long*, c_ulong, uint) @nogc nothrow;
    int lockf64(int, int, c_long) @nogc nothrow;
    int lockf(int, int, c_long) @nogc nothrow;
    c_long syscall(c_long, ...) @nogc nothrow;
    void* sbrk(c_long) @nogc nothrow;
    int brk(void*) @nogc nothrow;
    int ftruncate64(int, c_long) @nogc nothrow;
    int ftruncate(int, c_long) @nogc nothrow;
    int truncate64(const(char)*, c_long) @nogc nothrow;
    int truncate(const(char)*, c_long) @nogc nothrow;
    int getdtablesize() @nogc nothrow;
    int getpagesize() @nogc nothrow;
    void sync() @nogc nothrow;
    c_long gethostid() @nogc nothrow;
    int syncfs(int) @nogc nothrow;
    int fsync(int) @nogc nothrow;
    char* getpass(const(char)*) @nogc nothrow;
    int chroot(const(char)*) @nogc nothrow;
    int daemon(int, int) @nogc nothrow;
    void __assert_fail(const(char)*, const(char)*, uint, const(char)*) @nogc nothrow;
    void __assert_perror_fail(int, const(char)*, uint, const(char)*) @nogc nothrow;
    void __assert(const(char)*, const(char)*, int) @nogc nothrow;
    void setusershell() @nogc nothrow;
    void endusershell() @nogc nothrow;
    char* getusershell() @nogc nothrow;
    static ushort __bswap_16(ushort) @nogc nothrow;
    int acct(const(char)*) @nogc nothrow;
    static uint __bswap_32(uint) @nogc nothrow;
    static c_ulong __bswap_64(c_ulong) @nogc nothrow;
    enum _Anonymous_0
    {
        _PC_LINK_MAX = 0,
        _PC_MAX_CANON = 1,
        _PC_MAX_INPUT = 2,
        _PC_NAME_MAX = 3,
        _PC_PATH_MAX = 4,
        _PC_PIPE_BUF = 5,
        _PC_CHOWN_RESTRICTED = 6,
        _PC_NO_TRUNC = 7,
        _PC_VDISABLE = 8,
        _PC_SYNC_IO = 9,
        _PC_ASYNC_IO = 10,
        _PC_PRIO_IO = 11,
        _PC_SOCK_MAXBUF = 12,
        _PC_FILESIZEBITS = 13,
        _PC_REC_INCR_XFER_SIZE = 14,
        _PC_REC_MAX_XFER_SIZE = 15,
        _PC_REC_MIN_XFER_SIZE = 16,
        _PC_REC_XFER_ALIGN = 17,
        _PC_ALLOC_SIZE_MIN = 18,
        _PC_SYMLINK_MAX = 19,
        _PC_2_SYMLINKS = 20,
    }
    enum _PC_LINK_MAX = _Anonymous_0._PC_LINK_MAX;
    enum _PC_MAX_CANON = _Anonymous_0._PC_MAX_CANON;
    enum _PC_MAX_INPUT = _Anonymous_0._PC_MAX_INPUT;
    enum _PC_NAME_MAX = _Anonymous_0._PC_NAME_MAX;
    enum _PC_PATH_MAX = _Anonymous_0._PC_PATH_MAX;
    enum _PC_PIPE_BUF = _Anonymous_0._PC_PIPE_BUF;
    enum _PC_CHOWN_RESTRICTED = _Anonymous_0._PC_CHOWN_RESTRICTED;
    enum _PC_NO_TRUNC = _Anonymous_0._PC_NO_TRUNC;
    enum _PC_VDISABLE = _Anonymous_0._PC_VDISABLE;
    enum _PC_SYNC_IO = _Anonymous_0._PC_SYNC_IO;
    enum _PC_ASYNC_IO = _Anonymous_0._PC_ASYNC_IO;
    enum _PC_PRIO_IO = _Anonymous_0._PC_PRIO_IO;
    enum _PC_SOCK_MAXBUF = _Anonymous_0._PC_SOCK_MAXBUF;
    enum _PC_FILESIZEBITS = _Anonymous_0._PC_FILESIZEBITS;
    enum _PC_REC_INCR_XFER_SIZE = _Anonymous_0._PC_REC_INCR_XFER_SIZE;
    enum _PC_REC_MAX_XFER_SIZE = _Anonymous_0._PC_REC_MAX_XFER_SIZE;
    enum _PC_REC_MIN_XFER_SIZE = _Anonymous_0._PC_REC_MIN_XFER_SIZE;
    enum _PC_REC_XFER_ALIGN = _Anonymous_0._PC_REC_XFER_ALIGN;
    enum _PC_ALLOC_SIZE_MIN = _Anonymous_0._PC_ALLOC_SIZE_MIN;
    enum _PC_SYMLINK_MAX = _Anonymous_0._PC_SYMLINK_MAX;
    enum _PC_2_SYMLINKS = _Anonymous_0._PC_2_SYMLINKS;
    int profil(ushort*, c_ulong, c_ulong, uint) @nogc nothrow;
    int revoke(const(char)*) @nogc nothrow;
    int vhangup() @nogc nothrow;
    int setdomainname(const(char)*, c_ulong) @nogc nothrow;
    int getdomainname(char*, c_ulong) @nogc nothrow;
    int sethostid(c_long) @nogc nothrow;
    enum _Anonymous_1
    {
        _SC_ARG_MAX = 0,
        _SC_CHILD_MAX = 1,
        _SC_CLK_TCK = 2,
        _SC_NGROUPS_MAX = 3,
        _SC_OPEN_MAX = 4,
        _SC_STREAM_MAX = 5,
        _SC_TZNAME_MAX = 6,
        _SC_JOB_CONTROL = 7,
        _SC_SAVED_IDS = 8,
        _SC_REALTIME_SIGNALS = 9,
        _SC_PRIORITY_SCHEDULING = 10,
        _SC_TIMERS = 11,
        _SC_ASYNCHRONOUS_IO = 12,
        _SC_PRIORITIZED_IO = 13,
        _SC_SYNCHRONIZED_IO = 14,
        _SC_FSYNC = 15,
        _SC_MAPPED_FILES = 16,
        _SC_MEMLOCK = 17,
        _SC_MEMLOCK_RANGE = 18,
        _SC_MEMORY_PROTECTION = 19,
        _SC_MESSAGE_PASSING = 20,
        _SC_SEMAPHORES = 21,
        _SC_SHARED_MEMORY_OBJECTS = 22,
        _SC_AIO_LISTIO_MAX = 23,
        _SC_AIO_MAX = 24,
        _SC_AIO_PRIO_DELTA_MAX = 25,
        _SC_DELAYTIMER_MAX = 26,
        _SC_MQ_OPEN_MAX = 27,
        _SC_MQ_PRIO_MAX = 28,
        _SC_VERSION = 29,
        _SC_PAGESIZE = 30,
        _SC_RTSIG_MAX = 31,
        _SC_SEM_NSEMS_MAX = 32,
        _SC_SEM_VALUE_MAX = 33,
        _SC_SIGQUEUE_MAX = 34,
        _SC_TIMER_MAX = 35,
        _SC_BC_BASE_MAX = 36,
        _SC_BC_DIM_MAX = 37,
        _SC_BC_SCALE_MAX = 38,
        _SC_BC_STRING_MAX = 39,
        _SC_COLL_WEIGHTS_MAX = 40,
        _SC_EQUIV_CLASS_MAX = 41,
        _SC_EXPR_NEST_MAX = 42,
        _SC_LINE_MAX = 43,
        _SC_RE_DUP_MAX = 44,
        _SC_CHARCLASS_NAME_MAX = 45,
        _SC_2_VERSION = 46,
        _SC_2_C_BIND = 47,
        _SC_2_C_DEV = 48,
        _SC_2_FORT_DEV = 49,
        _SC_2_FORT_RUN = 50,
        _SC_2_SW_DEV = 51,
        _SC_2_LOCALEDEF = 52,
        _SC_PII = 53,
        _SC_PII_XTI = 54,
        _SC_PII_SOCKET = 55,
        _SC_PII_INTERNET = 56,
        _SC_PII_OSI = 57,
        _SC_POLL = 58,
        _SC_SELECT = 59,
        _SC_UIO_MAXIOV = 60,
        _SC_IOV_MAX = 60,
        _SC_PII_INTERNET_STREAM = 61,
        _SC_PII_INTERNET_DGRAM = 62,
        _SC_PII_OSI_COTS = 63,
        _SC_PII_OSI_CLTS = 64,
        _SC_PII_OSI_M = 65,
        _SC_T_IOV_MAX = 66,
        _SC_THREADS = 67,
        _SC_THREAD_SAFE_FUNCTIONS = 68,
        _SC_GETGR_R_SIZE_MAX = 69,
        _SC_GETPW_R_SIZE_MAX = 70,
        _SC_LOGIN_NAME_MAX = 71,
        _SC_TTY_NAME_MAX = 72,
        _SC_THREAD_DESTRUCTOR_ITERATIONS = 73,
        _SC_THREAD_KEYS_MAX = 74,
        _SC_THREAD_STACK_MIN = 75,
        _SC_THREAD_THREADS_MAX = 76,
        _SC_THREAD_ATTR_STACKADDR = 77,
        _SC_THREAD_ATTR_STACKSIZE = 78,
        _SC_THREAD_PRIORITY_SCHEDULING = 79,
        _SC_THREAD_PRIO_INHERIT = 80,
        _SC_THREAD_PRIO_PROTECT = 81,
        _SC_THREAD_PROCESS_SHARED = 82,
        _SC_NPROCESSORS_CONF = 83,
        _SC_NPROCESSORS_ONLN = 84,
        _SC_PHYS_PAGES = 85,
        _SC_AVPHYS_PAGES = 86,
        _SC_ATEXIT_MAX = 87,
        _SC_PASS_MAX = 88,
        _SC_XOPEN_VERSION = 89,
        _SC_XOPEN_XCU_VERSION = 90,
        _SC_XOPEN_UNIX = 91,
        _SC_XOPEN_CRYPT = 92,
        _SC_XOPEN_ENH_I18N = 93,
        _SC_XOPEN_SHM = 94,
        _SC_2_CHAR_TERM = 95,
        _SC_2_C_VERSION = 96,
        _SC_2_UPE = 97,
        _SC_XOPEN_XPG2 = 98,
        _SC_XOPEN_XPG3 = 99,
        _SC_XOPEN_XPG4 = 100,
        _SC_CHAR_BIT = 101,
        _SC_CHAR_MAX = 102,
        _SC_CHAR_MIN = 103,
        _SC_INT_MAX = 104,
        _SC_INT_MIN = 105,
        _SC_LONG_BIT = 106,
        _SC_WORD_BIT = 107,
        _SC_MB_LEN_MAX = 108,
        _SC_NZERO = 109,
        _SC_SSIZE_MAX = 110,
        _SC_SCHAR_MAX = 111,
        _SC_SCHAR_MIN = 112,
        _SC_SHRT_MAX = 113,
        _SC_SHRT_MIN = 114,
        _SC_UCHAR_MAX = 115,
        _SC_UINT_MAX = 116,
        _SC_ULONG_MAX = 117,
        _SC_USHRT_MAX = 118,
        _SC_NL_ARGMAX = 119,
        _SC_NL_LANGMAX = 120,
        _SC_NL_MSGMAX = 121,
        _SC_NL_NMAX = 122,
        _SC_NL_SETMAX = 123,
        _SC_NL_TEXTMAX = 124,
        _SC_XBS5_ILP32_OFF32 = 125,
        _SC_XBS5_ILP32_OFFBIG = 126,
        _SC_XBS5_LP64_OFF64 = 127,
        _SC_XBS5_LPBIG_OFFBIG = 128,
        _SC_XOPEN_LEGACY = 129,
        _SC_XOPEN_REALTIME = 130,
        _SC_XOPEN_REALTIME_THREADS = 131,
        _SC_ADVISORY_INFO = 132,
        _SC_BARRIERS = 133,
        _SC_BASE = 134,
        _SC_C_LANG_SUPPORT = 135,
        _SC_C_LANG_SUPPORT_R = 136,
        _SC_CLOCK_SELECTION = 137,
        _SC_CPUTIME = 138,
        _SC_THREAD_CPUTIME = 139,
        _SC_DEVICE_IO = 140,
        _SC_DEVICE_SPECIFIC = 141,
        _SC_DEVICE_SPECIFIC_R = 142,
        _SC_FD_MGMT = 143,
        _SC_FIFO = 144,
        _SC_PIPE = 145,
        _SC_FILE_ATTRIBUTES = 146,
        _SC_FILE_LOCKING = 147,
        _SC_FILE_SYSTEM = 148,
        _SC_MONOTONIC_CLOCK = 149,
        _SC_MULTI_PROCESS = 150,
        _SC_SINGLE_PROCESS = 151,
        _SC_NETWORKING = 152,
        _SC_READER_WRITER_LOCKS = 153,
        _SC_SPIN_LOCKS = 154,
        _SC_REGEXP = 155,
        _SC_REGEX_VERSION = 156,
        _SC_SHELL = 157,
        _SC_SIGNALS = 158,
        _SC_SPAWN = 159,
        _SC_SPORADIC_SERVER = 160,
        _SC_THREAD_SPORADIC_SERVER = 161,
        _SC_SYSTEM_DATABASE = 162,
        _SC_SYSTEM_DATABASE_R = 163,
        _SC_TIMEOUTS = 164,
        _SC_TYPED_MEMORY_OBJECTS = 165,
        _SC_USER_GROUPS = 166,
        _SC_USER_GROUPS_R = 167,
        _SC_2_PBS = 168,
        _SC_2_PBS_ACCOUNTING = 169,
        _SC_2_PBS_LOCATE = 170,
        _SC_2_PBS_MESSAGE = 171,
        _SC_2_PBS_TRACK = 172,
        _SC_SYMLOOP_MAX = 173,
        _SC_STREAMS = 174,
        _SC_2_PBS_CHECKPOINT = 175,
        _SC_V6_ILP32_OFF32 = 176,
        _SC_V6_ILP32_OFFBIG = 177,
        _SC_V6_LP64_OFF64 = 178,
        _SC_V6_LPBIG_OFFBIG = 179,
        _SC_HOST_NAME_MAX = 180,
        _SC_TRACE = 181,
        _SC_TRACE_EVENT_FILTER = 182,
        _SC_TRACE_INHERIT = 183,
        _SC_TRACE_LOG = 184,
        _SC_LEVEL1_ICACHE_SIZE = 185,
        _SC_LEVEL1_ICACHE_ASSOC = 186,
        _SC_LEVEL1_ICACHE_LINESIZE = 187,
        _SC_LEVEL1_DCACHE_SIZE = 188,
        _SC_LEVEL1_DCACHE_ASSOC = 189,
        _SC_LEVEL1_DCACHE_LINESIZE = 190,
        _SC_LEVEL2_CACHE_SIZE = 191,
        _SC_LEVEL2_CACHE_ASSOC = 192,
        _SC_LEVEL2_CACHE_LINESIZE = 193,
        _SC_LEVEL3_CACHE_SIZE = 194,
        _SC_LEVEL3_CACHE_ASSOC = 195,
        _SC_LEVEL3_CACHE_LINESIZE = 196,
        _SC_LEVEL4_CACHE_SIZE = 197,
        _SC_LEVEL4_CACHE_ASSOC = 198,
        _SC_LEVEL4_CACHE_LINESIZE = 199,
        _SC_IPV6 = 235,
        _SC_RAW_SOCKETS = 236,
        _SC_V7_ILP32_OFF32 = 237,
        _SC_V7_ILP32_OFFBIG = 238,
        _SC_V7_LP64_OFF64 = 239,
        _SC_V7_LPBIG_OFFBIG = 240,
        _SC_SS_REPL_MAX = 241,
        _SC_TRACE_EVENT_NAME_MAX = 242,
        _SC_TRACE_NAME_MAX = 243,
        _SC_TRACE_SYS_MAX = 244,
        _SC_TRACE_USER_EVENT_MAX = 245,
        _SC_XOPEN_STREAMS = 246,
        _SC_THREAD_ROBUST_PRIO_INHERIT = 247,
        _SC_THREAD_ROBUST_PRIO_PROTECT = 248,
    }
    enum _SC_ARG_MAX = _Anonymous_1._SC_ARG_MAX;
    enum _SC_CHILD_MAX = _Anonymous_1._SC_CHILD_MAX;
    enum _SC_CLK_TCK = _Anonymous_1._SC_CLK_TCK;
    enum _SC_NGROUPS_MAX = _Anonymous_1._SC_NGROUPS_MAX;
    enum _SC_OPEN_MAX = _Anonymous_1._SC_OPEN_MAX;
    enum _SC_STREAM_MAX = _Anonymous_1._SC_STREAM_MAX;
    enum _SC_TZNAME_MAX = _Anonymous_1._SC_TZNAME_MAX;
    enum _SC_JOB_CONTROL = _Anonymous_1._SC_JOB_CONTROL;
    enum _SC_SAVED_IDS = _Anonymous_1._SC_SAVED_IDS;
    enum _SC_REALTIME_SIGNALS = _Anonymous_1._SC_REALTIME_SIGNALS;
    enum _SC_PRIORITY_SCHEDULING = _Anonymous_1._SC_PRIORITY_SCHEDULING;
    enum _SC_TIMERS = _Anonymous_1._SC_TIMERS;
    enum _SC_ASYNCHRONOUS_IO = _Anonymous_1._SC_ASYNCHRONOUS_IO;
    enum _SC_PRIORITIZED_IO = _Anonymous_1._SC_PRIORITIZED_IO;
    enum _SC_SYNCHRONIZED_IO = _Anonymous_1._SC_SYNCHRONIZED_IO;
    enum _SC_FSYNC = _Anonymous_1._SC_FSYNC;
    enum _SC_MAPPED_FILES = _Anonymous_1._SC_MAPPED_FILES;
    enum _SC_MEMLOCK = _Anonymous_1._SC_MEMLOCK;
    enum _SC_MEMLOCK_RANGE = _Anonymous_1._SC_MEMLOCK_RANGE;
    enum _SC_MEMORY_PROTECTION = _Anonymous_1._SC_MEMORY_PROTECTION;
    enum _SC_MESSAGE_PASSING = _Anonymous_1._SC_MESSAGE_PASSING;
    enum _SC_SEMAPHORES = _Anonymous_1._SC_SEMAPHORES;
    enum _SC_SHARED_MEMORY_OBJECTS = _Anonymous_1._SC_SHARED_MEMORY_OBJECTS;
    enum _SC_AIO_LISTIO_MAX = _Anonymous_1._SC_AIO_LISTIO_MAX;
    enum _SC_AIO_MAX = _Anonymous_1._SC_AIO_MAX;
    enum _SC_AIO_PRIO_DELTA_MAX = _Anonymous_1._SC_AIO_PRIO_DELTA_MAX;
    enum _SC_DELAYTIMER_MAX = _Anonymous_1._SC_DELAYTIMER_MAX;
    enum _SC_MQ_OPEN_MAX = _Anonymous_1._SC_MQ_OPEN_MAX;
    enum _SC_MQ_PRIO_MAX = _Anonymous_1._SC_MQ_PRIO_MAX;
    enum _SC_VERSION = _Anonymous_1._SC_VERSION;
    enum _SC_PAGESIZE = _Anonymous_1._SC_PAGESIZE;
    enum _SC_RTSIG_MAX = _Anonymous_1._SC_RTSIG_MAX;
    enum _SC_SEM_NSEMS_MAX = _Anonymous_1._SC_SEM_NSEMS_MAX;
    enum _SC_SEM_VALUE_MAX = _Anonymous_1._SC_SEM_VALUE_MAX;
    enum _SC_SIGQUEUE_MAX = _Anonymous_1._SC_SIGQUEUE_MAX;
    enum _SC_TIMER_MAX = _Anonymous_1._SC_TIMER_MAX;
    enum _SC_BC_BASE_MAX = _Anonymous_1._SC_BC_BASE_MAX;
    enum _SC_BC_DIM_MAX = _Anonymous_1._SC_BC_DIM_MAX;
    enum _SC_BC_SCALE_MAX = _Anonymous_1._SC_BC_SCALE_MAX;
    enum _SC_BC_STRING_MAX = _Anonymous_1._SC_BC_STRING_MAX;
    enum _SC_COLL_WEIGHTS_MAX = _Anonymous_1._SC_COLL_WEIGHTS_MAX;
    enum _SC_EQUIV_CLASS_MAX = _Anonymous_1._SC_EQUIV_CLASS_MAX;
    enum _SC_EXPR_NEST_MAX = _Anonymous_1._SC_EXPR_NEST_MAX;
    enum _SC_LINE_MAX = _Anonymous_1._SC_LINE_MAX;
    enum _SC_RE_DUP_MAX = _Anonymous_1._SC_RE_DUP_MAX;
    enum _SC_CHARCLASS_NAME_MAX = _Anonymous_1._SC_CHARCLASS_NAME_MAX;
    enum _SC_2_VERSION = _Anonymous_1._SC_2_VERSION;
    enum _SC_2_C_BIND = _Anonymous_1._SC_2_C_BIND;
    enum _SC_2_C_DEV = _Anonymous_1._SC_2_C_DEV;
    enum _SC_2_FORT_DEV = _Anonymous_1._SC_2_FORT_DEV;
    enum _SC_2_FORT_RUN = _Anonymous_1._SC_2_FORT_RUN;
    enum _SC_2_SW_DEV = _Anonymous_1._SC_2_SW_DEV;
    enum _SC_2_LOCALEDEF = _Anonymous_1._SC_2_LOCALEDEF;
    enum _SC_PII = _Anonymous_1._SC_PII;
    enum _SC_PII_XTI = _Anonymous_1._SC_PII_XTI;
    enum _SC_PII_SOCKET = _Anonymous_1._SC_PII_SOCKET;
    enum _SC_PII_INTERNET = _Anonymous_1._SC_PII_INTERNET;
    enum _SC_PII_OSI = _Anonymous_1._SC_PII_OSI;
    enum _SC_POLL = _Anonymous_1._SC_POLL;
    enum _SC_SELECT = _Anonymous_1._SC_SELECT;
    enum _SC_UIO_MAXIOV = _Anonymous_1._SC_UIO_MAXIOV;
    enum _SC_IOV_MAX = _Anonymous_1._SC_IOV_MAX;
    enum _SC_PII_INTERNET_STREAM = _Anonymous_1._SC_PII_INTERNET_STREAM;
    enum _SC_PII_INTERNET_DGRAM = _Anonymous_1._SC_PII_INTERNET_DGRAM;
    enum _SC_PII_OSI_COTS = _Anonymous_1._SC_PII_OSI_COTS;
    enum _SC_PII_OSI_CLTS = _Anonymous_1._SC_PII_OSI_CLTS;
    enum _SC_PII_OSI_M = _Anonymous_1._SC_PII_OSI_M;
    enum _SC_T_IOV_MAX = _Anonymous_1._SC_T_IOV_MAX;
    enum _SC_THREADS = _Anonymous_1._SC_THREADS;
    enum _SC_THREAD_SAFE_FUNCTIONS = _Anonymous_1._SC_THREAD_SAFE_FUNCTIONS;
    enum _SC_GETGR_R_SIZE_MAX = _Anonymous_1._SC_GETGR_R_SIZE_MAX;
    enum _SC_GETPW_R_SIZE_MAX = _Anonymous_1._SC_GETPW_R_SIZE_MAX;
    enum _SC_LOGIN_NAME_MAX = _Anonymous_1._SC_LOGIN_NAME_MAX;
    enum _SC_TTY_NAME_MAX = _Anonymous_1._SC_TTY_NAME_MAX;
    enum _SC_THREAD_DESTRUCTOR_ITERATIONS = _Anonymous_1._SC_THREAD_DESTRUCTOR_ITERATIONS;
    enum _SC_THREAD_KEYS_MAX = _Anonymous_1._SC_THREAD_KEYS_MAX;
    enum _SC_THREAD_STACK_MIN = _Anonymous_1._SC_THREAD_STACK_MIN;
    enum _SC_THREAD_THREADS_MAX = _Anonymous_1._SC_THREAD_THREADS_MAX;
    enum _SC_THREAD_ATTR_STACKADDR = _Anonymous_1._SC_THREAD_ATTR_STACKADDR;
    enum _SC_THREAD_ATTR_STACKSIZE = _Anonymous_1._SC_THREAD_ATTR_STACKSIZE;
    enum _SC_THREAD_PRIORITY_SCHEDULING = _Anonymous_1._SC_THREAD_PRIORITY_SCHEDULING;
    enum _SC_THREAD_PRIO_INHERIT = _Anonymous_1._SC_THREAD_PRIO_INHERIT;
    enum _SC_THREAD_PRIO_PROTECT = _Anonymous_1._SC_THREAD_PRIO_PROTECT;
    enum _SC_THREAD_PROCESS_SHARED = _Anonymous_1._SC_THREAD_PROCESS_SHARED;
    enum _SC_NPROCESSORS_CONF = _Anonymous_1._SC_NPROCESSORS_CONF;
    enum _SC_NPROCESSORS_ONLN = _Anonymous_1._SC_NPROCESSORS_ONLN;
    enum _SC_PHYS_PAGES = _Anonymous_1._SC_PHYS_PAGES;
    enum _SC_AVPHYS_PAGES = _Anonymous_1._SC_AVPHYS_PAGES;
    enum _SC_ATEXIT_MAX = _Anonymous_1._SC_ATEXIT_MAX;
    enum _SC_PASS_MAX = _Anonymous_1._SC_PASS_MAX;
    enum _SC_XOPEN_VERSION = _Anonymous_1._SC_XOPEN_VERSION;
    enum _SC_XOPEN_XCU_VERSION = _Anonymous_1._SC_XOPEN_XCU_VERSION;
    enum _SC_XOPEN_UNIX = _Anonymous_1._SC_XOPEN_UNIX;
    enum _SC_XOPEN_CRYPT = _Anonymous_1._SC_XOPEN_CRYPT;
    enum _SC_XOPEN_ENH_I18N = _Anonymous_1._SC_XOPEN_ENH_I18N;
    enum _SC_XOPEN_SHM = _Anonymous_1._SC_XOPEN_SHM;
    enum _SC_2_CHAR_TERM = _Anonymous_1._SC_2_CHAR_TERM;
    enum _SC_2_C_VERSION = _Anonymous_1._SC_2_C_VERSION;
    enum _SC_2_UPE = _Anonymous_1._SC_2_UPE;
    enum _SC_XOPEN_XPG2 = _Anonymous_1._SC_XOPEN_XPG2;
    enum _SC_XOPEN_XPG3 = _Anonymous_1._SC_XOPEN_XPG3;
    enum _SC_XOPEN_XPG4 = _Anonymous_1._SC_XOPEN_XPG4;
    enum _SC_CHAR_BIT = _Anonymous_1._SC_CHAR_BIT;
    enum _SC_CHAR_MAX = _Anonymous_1._SC_CHAR_MAX;
    enum _SC_CHAR_MIN = _Anonymous_1._SC_CHAR_MIN;
    enum _SC_INT_MAX = _Anonymous_1._SC_INT_MAX;
    enum _SC_INT_MIN = _Anonymous_1._SC_INT_MIN;
    enum _SC_LONG_BIT = _Anonymous_1._SC_LONG_BIT;
    enum _SC_WORD_BIT = _Anonymous_1._SC_WORD_BIT;
    enum _SC_MB_LEN_MAX = _Anonymous_1._SC_MB_LEN_MAX;
    enum _SC_NZERO = _Anonymous_1._SC_NZERO;
    enum _SC_SSIZE_MAX = _Anonymous_1._SC_SSIZE_MAX;
    enum _SC_SCHAR_MAX = _Anonymous_1._SC_SCHAR_MAX;
    enum _SC_SCHAR_MIN = _Anonymous_1._SC_SCHAR_MIN;
    enum _SC_SHRT_MAX = _Anonymous_1._SC_SHRT_MAX;
    enum _SC_SHRT_MIN = _Anonymous_1._SC_SHRT_MIN;
    enum _SC_UCHAR_MAX = _Anonymous_1._SC_UCHAR_MAX;
    enum _SC_UINT_MAX = _Anonymous_1._SC_UINT_MAX;
    enum _SC_ULONG_MAX = _Anonymous_1._SC_ULONG_MAX;
    enum _SC_USHRT_MAX = _Anonymous_1._SC_USHRT_MAX;
    enum _SC_NL_ARGMAX = _Anonymous_1._SC_NL_ARGMAX;
    enum _SC_NL_LANGMAX = _Anonymous_1._SC_NL_LANGMAX;
    enum _SC_NL_MSGMAX = _Anonymous_1._SC_NL_MSGMAX;
    enum _SC_NL_NMAX = _Anonymous_1._SC_NL_NMAX;
    enum _SC_NL_SETMAX = _Anonymous_1._SC_NL_SETMAX;
    enum _SC_NL_TEXTMAX = _Anonymous_1._SC_NL_TEXTMAX;
    enum _SC_XBS5_ILP32_OFF32 = _Anonymous_1._SC_XBS5_ILP32_OFF32;
    enum _SC_XBS5_ILP32_OFFBIG = _Anonymous_1._SC_XBS5_ILP32_OFFBIG;
    enum _SC_XBS5_LP64_OFF64 = _Anonymous_1._SC_XBS5_LP64_OFF64;
    enum _SC_XBS5_LPBIG_OFFBIG = _Anonymous_1._SC_XBS5_LPBIG_OFFBIG;
    enum _SC_XOPEN_LEGACY = _Anonymous_1._SC_XOPEN_LEGACY;
    enum _SC_XOPEN_REALTIME = _Anonymous_1._SC_XOPEN_REALTIME;
    enum _SC_XOPEN_REALTIME_THREADS = _Anonymous_1._SC_XOPEN_REALTIME_THREADS;
    enum _SC_ADVISORY_INFO = _Anonymous_1._SC_ADVISORY_INFO;
    enum _SC_BARRIERS = _Anonymous_1._SC_BARRIERS;
    enum _SC_BASE = _Anonymous_1._SC_BASE;
    enum _SC_C_LANG_SUPPORT = _Anonymous_1._SC_C_LANG_SUPPORT;
    enum _SC_C_LANG_SUPPORT_R = _Anonymous_1._SC_C_LANG_SUPPORT_R;
    enum _SC_CLOCK_SELECTION = _Anonymous_1._SC_CLOCK_SELECTION;
    enum _SC_CPUTIME = _Anonymous_1._SC_CPUTIME;
    enum _SC_THREAD_CPUTIME = _Anonymous_1._SC_THREAD_CPUTIME;
    enum _SC_DEVICE_IO = _Anonymous_1._SC_DEVICE_IO;
    enum _SC_DEVICE_SPECIFIC = _Anonymous_1._SC_DEVICE_SPECIFIC;
    enum _SC_DEVICE_SPECIFIC_R = _Anonymous_1._SC_DEVICE_SPECIFIC_R;
    enum _SC_FD_MGMT = _Anonymous_1._SC_FD_MGMT;
    enum _SC_FIFO = _Anonymous_1._SC_FIFO;
    enum _SC_PIPE = _Anonymous_1._SC_PIPE;
    enum _SC_FILE_ATTRIBUTES = _Anonymous_1._SC_FILE_ATTRIBUTES;
    enum _SC_FILE_LOCKING = _Anonymous_1._SC_FILE_LOCKING;
    enum _SC_FILE_SYSTEM = _Anonymous_1._SC_FILE_SYSTEM;
    enum _SC_MONOTONIC_CLOCK = _Anonymous_1._SC_MONOTONIC_CLOCK;
    enum _SC_MULTI_PROCESS = _Anonymous_1._SC_MULTI_PROCESS;
    enum _SC_SINGLE_PROCESS = _Anonymous_1._SC_SINGLE_PROCESS;
    enum _SC_NETWORKING = _Anonymous_1._SC_NETWORKING;
    enum _SC_READER_WRITER_LOCKS = _Anonymous_1._SC_READER_WRITER_LOCKS;
    enum _SC_SPIN_LOCKS = _Anonymous_1._SC_SPIN_LOCKS;
    enum _SC_REGEXP = _Anonymous_1._SC_REGEXP;
    enum _SC_REGEX_VERSION = _Anonymous_1._SC_REGEX_VERSION;
    enum _SC_SHELL = _Anonymous_1._SC_SHELL;
    enum _SC_SIGNALS = _Anonymous_1._SC_SIGNALS;
    enum _SC_SPAWN = _Anonymous_1._SC_SPAWN;
    enum _SC_SPORADIC_SERVER = _Anonymous_1._SC_SPORADIC_SERVER;
    enum _SC_THREAD_SPORADIC_SERVER = _Anonymous_1._SC_THREAD_SPORADIC_SERVER;
    enum _SC_SYSTEM_DATABASE = _Anonymous_1._SC_SYSTEM_DATABASE;
    enum _SC_SYSTEM_DATABASE_R = _Anonymous_1._SC_SYSTEM_DATABASE_R;
    enum _SC_TIMEOUTS = _Anonymous_1._SC_TIMEOUTS;
    enum _SC_TYPED_MEMORY_OBJECTS = _Anonymous_1._SC_TYPED_MEMORY_OBJECTS;
    enum _SC_USER_GROUPS = _Anonymous_1._SC_USER_GROUPS;
    enum _SC_USER_GROUPS_R = _Anonymous_1._SC_USER_GROUPS_R;
    enum _SC_2_PBS = _Anonymous_1._SC_2_PBS;
    enum _SC_2_PBS_ACCOUNTING = _Anonymous_1._SC_2_PBS_ACCOUNTING;
    enum _SC_2_PBS_LOCATE = _Anonymous_1._SC_2_PBS_LOCATE;
    enum _SC_2_PBS_MESSAGE = _Anonymous_1._SC_2_PBS_MESSAGE;
    enum _SC_2_PBS_TRACK = _Anonymous_1._SC_2_PBS_TRACK;
    enum _SC_SYMLOOP_MAX = _Anonymous_1._SC_SYMLOOP_MAX;
    enum _SC_STREAMS = _Anonymous_1._SC_STREAMS;
    enum _SC_2_PBS_CHECKPOINT = _Anonymous_1._SC_2_PBS_CHECKPOINT;
    enum _SC_V6_ILP32_OFF32 = _Anonymous_1._SC_V6_ILP32_OFF32;
    enum _SC_V6_ILP32_OFFBIG = _Anonymous_1._SC_V6_ILP32_OFFBIG;
    enum _SC_V6_LP64_OFF64 = _Anonymous_1._SC_V6_LP64_OFF64;
    enum _SC_V6_LPBIG_OFFBIG = _Anonymous_1._SC_V6_LPBIG_OFFBIG;
    enum _SC_HOST_NAME_MAX = _Anonymous_1._SC_HOST_NAME_MAX;
    enum _SC_TRACE = _Anonymous_1._SC_TRACE;
    enum _SC_TRACE_EVENT_FILTER = _Anonymous_1._SC_TRACE_EVENT_FILTER;
    enum _SC_TRACE_INHERIT = _Anonymous_1._SC_TRACE_INHERIT;
    enum _SC_TRACE_LOG = _Anonymous_1._SC_TRACE_LOG;
    enum _SC_LEVEL1_ICACHE_SIZE = _Anonymous_1._SC_LEVEL1_ICACHE_SIZE;
    enum _SC_LEVEL1_ICACHE_ASSOC = _Anonymous_1._SC_LEVEL1_ICACHE_ASSOC;
    enum _SC_LEVEL1_ICACHE_LINESIZE = _Anonymous_1._SC_LEVEL1_ICACHE_LINESIZE;
    enum _SC_LEVEL1_DCACHE_SIZE = _Anonymous_1._SC_LEVEL1_DCACHE_SIZE;
    enum _SC_LEVEL1_DCACHE_ASSOC = _Anonymous_1._SC_LEVEL1_DCACHE_ASSOC;
    enum _SC_LEVEL1_DCACHE_LINESIZE = _Anonymous_1._SC_LEVEL1_DCACHE_LINESIZE;
    enum _SC_LEVEL2_CACHE_SIZE = _Anonymous_1._SC_LEVEL2_CACHE_SIZE;
    enum _SC_LEVEL2_CACHE_ASSOC = _Anonymous_1._SC_LEVEL2_CACHE_ASSOC;
    enum _SC_LEVEL2_CACHE_LINESIZE = _Anonymous_1._SC_LEVEL2_CACHE_LINESIZE;
    enum _SC_LEVEL3_CACHE_SIZE = _Anonymous_1._SC_LEVEL3_CACHE_SIZE;
    enum _SC_LEVEL3_CACHE_ASSOC = _Anonymous_1._SC_LEVEL3_CACHE_ASSOC;
    enum _SC_LEVEL3_CACHE_LINESIZE = _Anonymous_1._SC_LEVEL3_CACHE_LINESIZE;
    enum _SC_LEVEL4_CACHE_SIZE = _Anonymous_1._SC_LEVEL4_CACHE_SIZE;
    enum _SC_LEVEL4_CACHE_ASSOC = _Anonymous_1._SC_LEVEL4_CACHE_ASSOC;
    enum _SC_LEVEL4_CACHE_LINESIZE = _Anonymous_1._SC_LEVEL4_CACHE_LINESIZE;
    enum _SC_IPV6 = _Anonymous_1._SC_IPV6;
    enum _SC_RAW_SOCKETS = _Anonymous_1._SC_RAW_SOCKETS;
    enum _SC_V7_ILP32_OFF32 = _Anonymous_1._SC_V7_ILP32_OFF32;
    enum _SC_V7_ILP32_OFFBIG = _Anonymous_1._SC_V7_ILP32_OFFBIG;
    enum _SC_V7_LP64_OFF64 = _Anonymous_1._SC_V7_LP64_OFF64;
    enum _SC_V7_LPBIG_OFFBIG = _Anonymous_1._SC_V7_LPBIG_OFFBIG;
    enum _SC_SS_REPL_MAX = _Anonymous_1._SC_SS_REPL_MAX;
    enum _SC_TRACE_EVENT_NAME_MAX = _Anonymous_1._SC_TRACE_EVENT_NAME_MAX;
    enum _SC_TRACE_NAME_MAX = _Anonymous_1._SC_TRACE_NAME_MAX;
    enum _SC_TRACE_SYS_MAX = _Anonymous_1._SC_TRACE_SYS_MAX;
    enum _SC_TRACE_USER_EVENT_MAX = _Anonymous_1._SC_TRACE_USER_EVENT_MAX;
    enum _SC_XOPEN_STREAMS = _Anonymous_1._SC_XOPEN_STREAMS;
    enum _SC_THREAD_ROBUST_PRIO_INHERIT = _Anonymous_1._SC_THREAD_ROBUST_PRIO_INHERIT;
    enum _SC_THREAD_ROBUST_PRIO_PROTECT = _Anonymous_1._SC_THREAD_ROBUST_PRIO_PROTECT;
    int sethostname(const(char)*, c_ulong) @nogc nothrow;
    int gethostname(char*, c_ulong) @nogc nothrow;
    int setlogin(const(char)*) @nogc nothrow;
    int getlogin_r(char*, c_ulong) @nogc nothrow;
    char* getlogin() @nogc nothrow;
    int tcsetpgrp(int, int) @nogc nothrow;
    int tcgetpgrp(int) @nogc nothrow;
    int rmdir(const(char)*) @nogc nothrow;
    int unlinkat(int, const(char)*, int) @nogc nothrow;
    int unlink(const(char)*) @nogc nothrow;
    c_long readlinkat(int, const(char)*, char*, c_ulong) @nogc nothrow;
    int symlinkat(const(char)*, int, const(char)*) @nogc nothrow;
    c_long readlink(const(char)*, char*, c_ulong) @nogc nothrow;
    int symlink(const(char)*, const(char)*) @nogc nothrow;
    int linkat(int, const(char)*, int, const(char)*, int) @nogc nothrow;
    int link(const(char)*, const(char)*) @nogc nothrow;
    int ttyslot() @nogc nothrow;
    int isatty(int) @nogc nothrow;
    int ttyname_r(int, char*, c_ulong) @nogc nothrow;
    char* ttyname(int) @nogc nothrow;
    int vfork() @nogc nothrow;
    int fork() @nogc nothrow;
    int setresgid(uint, uint, uint) @nogc nothrow;
    int setresuid(uint, uint, uint) @nogc nothrow;
    int getresgid(uint*, uint*, uint*) @nogc nothrow;
    int getresuid(uint*, uint*, uint*) @nogc nothrow;
    int setegid(uint) @nogc nothrow;
    int setregid(uint, uint) @nogc nothrow;
    int setgid(uint) @nogc nothrow;
    int seteuid(uint) @nogc nothrow;
    int setreuid(uint, uint) @nogc nothrow;
    int setuid(uint) @nogc nothrow;
    int group_member(uint) @nogc nothrow;
    int getgroups(int, uint*) @nogc nothrow;
    uint getegid() @nogc nothrow;
    uint getgid() @nogc nothrow;
    uint geteuid() @nogc nothrow;
    uint getuid() @nogc nothrow;
    int getsid(int) @nogc nothrow;
    int setsid() @nogc nothrow;
    int setpgrp() @nogc nothrow;
    int setpgid(int, int) @nogc nothrow;
    int getpgid(int) @nogc nothrow;
    int __getpgid(int) @nogc nothrow;
    int getpgrp() @nogc nothrow;
    int getppid() @nogc nothrow;
    int getpid() @nogc nothrow;
    c_ulong confstr(int, char*, c_ulong) @nogc nothrow;
    c_long sysconf(int) @nogc nothrow;
    c_long fpathconf(int, int) @nogc nothrow;
    c_long pathconf(const(char)*, int) @nogc nothrow;
    void _exit(int) @nogc nothrow;
    int nice(int) @nogc nothrow;
    int execvpe(const(char)*, char**, char**) @nogc nothrow;
    int execlp(const(char)*, const(char)*, ...) @nogc nothrow;
    int execvp(const(char)*, char**) @nogc nothrow;
    int execl(const(char)*, const(char)*, ...) @nogc nothrow;
    int execle(const(char)*, const(char)*, ...) @nogc nothrow;
    int execv(const(char)*, char**) @nogc nothrow;
    int fexecve(int, char**, char**) @nogc nothrow;
    int execve(const(char)*, char**, char**) @nogc nothrow;
    extern __gshared char** environ;
    extern __gshared char** __environ;
    int dup3(int, int, int) @nogc nothrow;
    int dup2(int, int) @nogc nothrow;
    int dup(int) @nogc nothrow;
    char* getwd(char*) @nogc nothrow;
    char* get_current_dir_name() @nogc nothrow;
    enum _Anonymous_2
    {
        _CS_PATH = 0,
        _CS_V6_WIDTH_RESTRICTED_ENVS = 1,
        _CS_GNU_LIBC_VERSION = 2,
        _CS_GNU_LIBPTHREAD_VERSION = 3,
        _CS_V5_WIDTH_RESTRICTED_ENVS = 4,
        _CS_V7_WIDTH_RESTRICTED_ENVS = 5,
        _CS_LFS_CFLAGS = 1000,
        _CS_LFS_LDFLAGS = 1001,
        _CS_LFS_LIBS = 1002,
        _CS_LFS_LINTFLAGS = 1003,
        _CS_LFS64_CFLAGS = 1004,
        _CS_LFS64_LDFLAGS = 1005,
        _CS_LFS64_LIBS = 1006,
        _CS_LFS64_LINTFLAGS = 1007,
        _CS_XBS5_ILP32_OFF32_CFLAGS = 1100,
        _CS_XBS5_ILP32_OFF32_LDFLAGS = 1101,
        _CS_XBS5_ILP32_OFF32_LIBS = 1102,
        _CS_XBS5_ILP32_OFF32_LINTFLAGS = 1103,
        _CS_XBS5_ILP32_OFFBIG_CFLAGS = 1104,
        _CS_XBS5_ILP32_OFFBIG_LDFLAGS = 1105,
        _CS_XBS5_ILP32_OFFBIG_LIBS = 1106,
        _CS_XBS5_ILP32_OFFBIG_LINTFLAGS = 1107,
        _CS_XBS5_LP64_OFF64_CFLAGS = 1108,
        _CS_XBS5_LP64_OFF64_LDFLAGS = 1109,
        _CS_XBS5_LP64_OFF64_LIBS = 1110,
        _CS_XBS5_LP64_OFF64_LINTFLAGS = 1111,
        _CS_XBS5_LPBIG_OFFBIG_CFLAGS = 1112,
        _CS_XBS5_LPBIG_OFFBIG_LDFLAGS = 1113,
        _CS_XBS5_LPBIG_OFFBIG_LIBS = 1114,
        _CS_XBS5_LPBIG_OFFBIG_LINTFLAGS = 1115,
        _CS_POSIX_V6_ILP32_OFF32_CFLAGS = 1116,
        _CS_POSIX_V6_ILP32_OFF32_LDFLAGS = 1117,
        _CS_POSIX_V6_ILP32_OFF32_LIBS = 1118,
        _CS_POSIX_V6_ILP32_OFF32_LINTFLAGS = 1119,
        _CS_POSIX_V6_ILP32_OFFBIG_CFLAGS = 1120,
        _CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS = 1121,
        _CS_POSIX_V6_ILP32_OFFBIG_LIBS = 1122,
        _CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS = 1123,
        _CS_POSIX_V6_LP64_OFF64_CFLAGS = 1124,
        _CS_POSIX_V6_LP64_OFF64_LDFLAGS = 1125,
        _CS_POSIX_V6_LP64_OFF64_LIBS = 1126,
        _CS_POSIX_V6_LP64_OFF64_LINTFLAGS = 1127,
        _CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS = 1128,
        _CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS = 1129,
        _CS_POSIX_V6_LPBIG_OFFBIG_LIBS = 1130,
        _CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS = 1131,
        _CS_POSIX_V7_ILP32_OFF32_CFLAGS = 1132,
        _CS_POSIX_V7_ILP32_OFF32_LDFLAGS = 1133,
        _CS_POSIX_V7_ILP32_OFF32_LIBS = 1134,
        _CS_POSIX_V7_ILP32_OFF32_LINTFLAGS = 1135,
        _CS_POSIX_V7_ILP32_OFFBIG_CFLAGS = 1136,
        _CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS = 1137,
        _CS_POSIX_V7_ILP32_OFFBIG_LIBS = 1138,
        _CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS = 1139,
        _CS_POSIX_V7_LP64_OFF64_CFLAGS = 1140,
        _CS_POSIX_V7_LP64_OFF64_LDFLAGS = 1141,
        _CS_POSIX_V7_LP64_OFF64_LIBS = 1142,
        _CS_POSIX_V7_LP64_OFF64_LINTFLAGS = 1143,
        _CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS = 1144,
        _CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS = 1145,
        _CS_POSIX_V7_LPBIG_OFFBIG_LIBS = 1146,
        _CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS = 1147,
        _CS_V6_ENV = 1148,
        _CS_V7_ENV = 1149,
    }
    enum _CS_PATH = _Anonymous_2._CS_PATH;
    enum _CS_V6_WIDTH_RESTRICTED_ENVS = _Anonymous_2._CS_V6_WIDTH_RESTRICTED_ENVS;
    enum _CS_GNU_LIBC_VERSION = _Anonymous_2._CS_GNU_LIBC_VERSION;
    enum _CS_GNU_LIBPTHREAD_VERSION = _Anonymous_2._CS_GNU_LIBPTHREAD_VERSION;
    enum _CS_V5_WIDTH_RESTRICTED_ENVS = _Anonymous_2._CS_V5_WIDTH_RESTRICTED_ENVS;
    enum _CS_V7_WIDTH_RESTRICTED_ENVS = _Anonymous_2._CS_V7_WIDTH_RESTRICTED_ENVS;
    enum _CS_LFS_CFLAGS = _Anonymous_2._CS_LFS_CFLAGS;
    enum _CS_LFS_LDFLAGS = _Anonymous_2._CS_LFS_LDFLAGS;
    enum _CS_LFS_LIBS = _Anonymous_2._CS_LFS_LIBS;
    enum _CS_LFS_LINTFLAGS = _Anonymous_2._CS_LFS_LINTFLAGS;
    enum _CS_LFS64_CFLAGS = _Anonymous_2._CS_LFS64_CFLAGS;
    enum _CS_LFS64_LDFLAGS = _Anonymous_2._CS_LFS64_LDFLAGS;
    enum _CS_LFS64_LIBS = _Anonymous_2._CS_LFS64_LIBS;
    enum _CS_LFS64_LINTFLAGS = _Anonymous_2._CS_LFS64_LINTFLAGS;
    enum _CS_XBS5_ILP32_OFF32_CFLAGS = _Anonymous_2._CS_XBS5_ILP32_OFF32_CFLAGS;
    enum _CS_XBS5_ILP32_OFF32_LDFLAGS = _Anonymous_2._CS_XBS5_ILP32_OFF32_LDFLAGS;
    enum _CS_XBS5_ILP32_OFF32_LIBS = _Anonymous_2._CS_XBS5_ILP32_OFF32_LIBS;
    enum _CS_XBS5_ILP32_OFF32_LINTFLAGS = _Anonymous_2._CS_XBS5_ILP32_OFF32_LINTFLAGS;
    enum _CS_XBS5_ILP32_OFFBIG_CFLAGS = _Anonymous_2._CS_XBS5_ILP32_OFFBIG_CFLAGS;
    enum _CS_XBS5_ILP32_OFFBIG_LDFLAGS = _Anonymous_2._CS_XBS5_ILP32_OFFBIG_LDFLAGS;
    enum _CS_XBS5_ILP32_OFFBIG_LIBS = _Anonymous_2._CS_XBS5_ILP32_OFFBIG_LIBS;
    enum _CS_XBS5_ILP32_OFFBIG_LINTFLAGS = _Anonymous_2._CS_XBS5_ILP32_OFFBIG_LINTFLAGS;
    enum _CS_XBS5_LP64_OFF64_CFLAGS = _Anonymous_2._CS_XBS5_LP64_OFF64_CFLAGS;
    enum _CS_XBS5_LP64_OFF64_LDFLAGS = _Anonymous_2._CS_XBS5_LP64_OFF64_LDFLAGS;
    enum _CS_XBS5_LP64_OFF64_LIBS = _Anonymous_2._CS_XBS5_LP64_OFF64_LIBS;
    enum _CS_XBS5_LP64_OFF64_LINTFLAGS = _Anonymous_2._CS_XBS5_LP64_OFF64_LINTFLAGS;
    enum _CS_XBS5_LPBIG_OFFBIG_CFLAGS = _Anonymous_2._CS_XBS5_LPBIG_OFFBIG_CFLAGS;
    enum _CS_XBS5_LPBIG_OFFBIG_LDFLAGS = _Anonymous_2._CS_XBS5_LPBIG_OFFBIG_LDFLAGS;
    enum _CS_XBS5_LPBIG_OFFBIG_LIBS = _Anonymous_2._CS_XBS5_LPBIG_OFFBIG_LIBS;
    enum _CS_XBS5_LPBIG_OFFBIG_LINTFLAGS = _Anonymous_2._CS_XBS5_LPBIG_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V6_ILP32_OFF32_CFLAGS = _Anonymous_2._CS_POSIX_V6_ILP32_OFF32_CFLAGS;
    enum _CS_POSIX_V6_ILP32_OFF32_LDFLAGS = _Anonymous_2._CS_POSIX_V6_ILP32_OFF32_LDFLAGS;
    enum _CS_POSIX_V6_ILP32_OFF32_LIBS = _Anonymous_2._CS_POSIX_V6_ILP32_OFF32_LIBS;
    enum _CS_POSIX_V6_ILP32_OFF32_LINTFLAGS = _Anonymous_2._CS_POSIX_V6_ILP32_OFF32_LINTFLAGS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_CFLAGS = _Anonymous_2._CS_POSIX_V6_ILP32_OFFBIG_CFLAGS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS = _Anonymous_2._CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_LIBS = _Anonymous_2._CS_POSIX_V6_ILP32_OFFBIG_LIBS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS = _Anonymous_2._CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V6_LP64_OFF64_CFLAGS = _Anonymous_2._CS_POSIX_V6_LP64_OFF64_CFLAGS;
    enum _CS_POSIX_V6_LP64_OFF64_LDFLAGS = _Anonymous_2._CS_POSIX_V6_LP64_OFF64_LDFLAGS;
    enum _CS_POSIX_V6_LP64_OFF64_LIBS = _Anonymous_2._CS_POSIX_V6_LP64_OFF64_LIBS;
    enum _CS_POSIX_V6_LP64_OFF64_LINTFLAGS = _Anonymous_2._CS_POSIX_V6_LP64_OFF64_LINTFLAGS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS = _Anonymous_2._CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS = _Anonymous_2._CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_LIBS = _Anonymous_2._CS_POSIX_V6_LPBIG_OFFBIG_LIBS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS = _Anonymous_2._CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V7_ILP32_OFF32_CFLAGS = _Anonymous_2._CS_POSIX_V7_ILP32_OFF32_CFLAGS;
    enum _CS_POSIX_V7_ILP32_OFF32_LDFLAGS = _Anonymous_2._CS_POSIX_V7_ILP32_OFF32_LDFLAGS;
    enum _CS_POSIX_V7_ILP32_OFF32_LIBS = _Anonymous_2._CS_POSIX_V7_ILP32_OFF32_LIBS;
    enum _CS_POSIX_V7_ILP32_OFF32_LINTFLAGS = _Anonymous_2._CS_POSIX_V7_ILP32_OFF32_LINTFLAGS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_CFLAGS = _Anonymous_2._CS_POSIX_V7_ILP32_OFFBIG_CFLAGS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS = _Anonymous_2._CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_LIBS = _Anonymous_2._CS_POSIX_V7_ILP32_OFFBIG_LIBS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS = _Anonymous_2._CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V7_LP64_OFF64_CFLAGS = _Anonymous_2._CS_POSIX_V7_LP64_OFF64_CFLAGS;
    enum _CS_POSIX_V7_LP64_OFF64_LDFLAGS = _Anonymous_2._CS_POSIX_V7_LP64_OFF64_LDFLAGS;
    enum _CS_POSIX_V7_LP64_OFF64_LIBS = _Anonymous_2._CS_POSIX_V7_LP64_OFF64_LIBS;
    enum _CS_POSIX_V7_LP64_OFF64_LINTFLAGS = _Anonymous_2._CS_POSIX_V7_LP64_OFF64_LINTFLAGS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS = _Anonymous_2._CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS = _Anonymous_2._CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_LIBS = _Anonymous_2._CS_POSIX_V7_LPBIG_OFFBIG_LIBS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS = _Anonymous_2._CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS;
    enum _CS_V6_ENV = _Anonymous_2._CS_V6_ENV;
    enum _CS_V7_ENV = _Anonymous_2._CS_V7_ENV;
    char* getcwd(char*, c_ulong) @nogc nothrow;
    int fchdir(int) @nogc nothrow;
    int chdir(const(char)*) @nogc nothrow;
    int fchownat(int, const(char)*, uint, uint, int) @nogc nothrow;
    int lchown(const(char)*, uint, uint) @nogc nothrow;
    int fchown(int, uint, uint) @nogc nothrow;
    int chown(const(char)*, uint, uint) @nogc nothrow;
    int pause() @nogc nothrow;
    int usleep(uint) @nogc nothrow;
    uint ualarm(uint, uint) @nogc nothrow;
    uint sleep(uint) @nogc nothrow;
    uint alarm(uint) @nogc nothrow;
    int pipe2(int*, int) @nogc nothrow;
    int pipe(int*) @nogc nothrow;
    c_long pwrite64(int, const(void)*, c_ulong, c_long) @nogc nothrow;
    c_long pread64(int, void*, c_ulong, c_long) @nogc nothrow;
    c_long pwrite(int, const(void)*, c_ulong, c_long) @nogc nothrow;
    c_long pread(int, void*, c_ulong, c_long) @nogc nothrow;
    c_long write(int, const(void)*, c_ulong) @nogc nothrow;
    c_long read(int, void*, c_ulong) @nogc nothrow;
    int close(int) @nogc nothrow;
    c_long lseek64(int, c_long, int) @nogc nothrow;
    alias __cpu_mask = c_ulong;
    c_long lseek(int, c_long, int) @nogc nothrow;
    struct cpu_set_t
    {
        c_ulong[16] __bits;
    }
    int faccessat(int, const(char)*, int, int) @nogc nothrow;
    int __sched_cpucount(c_ulong, const(cpu_set_t)*) @nogc nothrow;
    cpu_set_t* __sched_cpualloc(c_ulong) @nogc nothrow;
    void __sched_cpufree(cpu_set_t*) @nogc nothrow;
    int eaccess(const(char)*, int) @nogc nothrow;
    int euidaccess(const(char)*, int) @nogc nothrow;
    int access(const(char)*, int) @nogc nothrow;
    alias socklen_t = uint;
    alias intptr_t = c_long;
    alias _Float32 = float;
    int getdate_r(const(char)*, tm*) @nogc nothrow;
    tm* getdate(const(char)*) @nogc nothrow;
    extern __gshared int getdate_err;
    alias _Float64 = double;
    int timespec_get(timespec*, int) @nogc nothrow;
    alias _Float32x = double;
    int timer_getoverrun(void*) @nogc nothrow;
    alias _Float64x = real;
    int timer_gettime(void*, itimerspec*) @nogc nothrow;
    int timer_settime(void*, int, const(itimerspec)*, itimerspec*) @nogc nothrow;
    int timer_delete(void*) @nogc nothrow;
    int timer_create(int, sigevent*, void**) @nogc nothrow;
    int clock_getcpuclockid(int, int*) @nogc nothrow;
    int clock_nanosleep(int, int, const(timespec)*, timespec*) @nogc nothrow;
    int clock_settime(int, const(timespec)*) @nogc nothrow;
    extern __gshared char* optarg;
    extern __gshared int optind;
    extern __gshared int opterr;
    extern __gshared int optopt;
    int getopt(int, char**, const(char)*) @nogc nothrow;
    int __iscanonicall(real) @nogc nothrow;
    int clock_gettime(int, timespec*) @nogc nothrow;
    int clock_getres(int, timespec*) @nogc nothrow;
    int nanosleep(const(timespec)*, timespec*) @nogc nothrow;
    int dysize(int) @nogc nothrow;
    c_long timelocal(tm*) @nogc nothrow;
    c_long timegm(tm*) @nogc nothrow;
    int stime(const(c_long)*) @nogc nothrow;
    pragma(mangle, "timezone") extern __gshared c_long timezone_;
    extern __gshared int daylight;
    void tzset() @nogc nothrow;
    extern __gshared char*[2] tzname;
    extern __gshared c_long __timezone;
    extern __gshared int __daylight;
    extern __gshared char*[2] __tzname;
    char* ctime_r(const(c_long)*, char*) @nogc nothrow;
    char* asctime_r(const(tm)*, char*) @nogc nothrow;
    char* ctime(const(c_long)*) @nogc nothrow;
    char* asctime(const(tm)*) @nogc nothrow;
    tm* localtime_r(const(c_long)*, tm*) @nogc nothrow;
    tm* gmtime_r(const(c_long)*, tm*) @nogc nothrow;
    tm* localtime(const(c_long)*) @nogc nothrow;
    tm* gmtime(const(c_long)*) @nogc nothrow;
    char* strptime_l(const(char)*, const(char)*, tm*, __locale_struct*) @nogc nothrow;
    c_ulong strftime_l(char*, c_ulong, const(char)*, const(tm)*, __locale_struct*) @nogc nothrow;
    char* strptime(const(char)*, const(char)*, tm*) @nogc nothrow;
    c_ulong strftime(char*, c_ulong, const(char)*, const(tm)*) @nogc nothrow;
    c_long mktime(tm*) @nogc nothrow;
    double difftime(c_long, c_long) @nogc nothrow;
    c_long time(c_long*) @nogc nothrow;
    c_long clock() @nogc nothrow;
    struct sigevent;
    alias fsfilcnt64_t = c_ulong;
    alias fsblkcnt64_t = c_ulong;
    alias blkcnt64_t = c_long;
    alias fsfilcnt_t = c_ulong;
    alias fsblkcnt_t = c_ulong;
    alias blkcnt_t = c_long;
    alias blksize_t = c_long;
    alias register_t = c_long;
    alias u_int64_t = c_ulong;
    alias u_int32_t = uint;
    alias u_int16_t = ushort;
    alias u_int8_t = ubyte;
    int __fpclassifyl(real) @nogc nothrow;
    int __fpclassifyf(float) @nogc nothrow;
    int __fpclassify(double) @nogc nothrow;
    int __signbit(double) @nogc nothrow;
    int __signbitf(float) @nogc nothrow;
    int __signbitl(real) @nogc nothrow;
    int __isinfl(real) @nogc nothrow;
    int __isinf(double) @nogc nothrow;
    int __isinff(float) @nogc nothrow;
    int __finitel(real) @nogc nothrow;
    int __finitef(float) @nogc nothrow;
    int __finite(double) @nogc nothrow;
    int __isnanl(real) @nogc nothrow;
    int __isnan(double) @nogc nothrow;
    int __isnanf(float) @nogc nothrow;
    int __iseqsigl(real, real) @nogc nothrow;
    int __iseqsigf(float, float) @nogc nothrow;
    int __iseqsig(double, double) @nogc nothrow;
    int __issignalingl(real) @nogc nothrow;
    int __issignaling(double) @nogc nothrow;
    int __issignalingf(float) @nogc nothrow;
    float fadd(double, double) @nogc nothrow;
    float faddl(real, real) @nogc nothrow;
    double f32xaddf64(double, double) @nogc nothrow;
    double daddl(real, real) @nogc nothrow;
    float f32addf64x(real, real) @nogc nothrow;
    double f32xaddf64x(real, real) @nogc nothrow;
    float f32addf32x(double, double) @nogc nothrow;
    float f32addf64(double, double) @nogc nothrow;
    double f64addf64x(real, real) @nogc nothrow;
    double f32xdivf64x(real, real) @nogc nothrow;
    float f32divf64(double, double) @nogc nothrow;
    double f32xdivf64(double, double) @nogc nothrow;
    float f32divf64x(real, real) @nogc nothrow;
    double f64divf64x(real, real) @nogc nothrow;
    double ddivl(real, real) @nogc nothrow;
    float f32divf32x(double, double) @nogc nothrow;
    float fdiv(double, double) @nogc nothrow;
    float fdivl(real, real) @nogc nothrow;
    float f32mulf32x(double, double) @nogc nothrow;
    double dmull(real, real) @nogc nothrow;
    float f32mulf64(double, double) @nogc nothrow;
    float f32mulf64x(real, real) @nogc nothrow;
    double f32xmulf64(double, double) @nogc nothrow;
    double f32xmulf64x(real, real) @nogc nothrow;
    float fmull(real, real) @nogc nothrow;
    double f64mulf64x(real, real) @nogc nothrow;
    float fmul(double, double) @nogc nothrow;
    float fsub(double, double) @nogc nothrow;
    float fsubl(real, real) @nogc nothrow;
    double dsubl(real, real) @nogc nothrow;
    float f32subf32x(double, double) @nogc nothrow;
    float f32subf64(double, double) @nogc nothrow;
    float f32subf64x(real, real) @nogc nothrow;
    double f32xsubf64(double, double) @nogc nothrow;
    double f32xsubf64x(real, real) @nogc nothrow;
    double f64subf64x(real, real) @nogc nothrow;
    real acosf64x(real) @nogc nothrow;
    real __acosf64x(real) @nogc nothrow;
    float __acosf32(float) @nogc nothrow;
    real __acosl(real) @nogc nothrow;
    real acosl(real) @nogc nothrow;
    double acosf32x(double) @nogc nothrow;
    double __acosf32x(double) @nogc nothrow;
    float acosf32(float) @nogc nothrow;
    float __acosf(float) @nogc nothrow;
    float acosf(float) @nogc nothrow;
    double __acosf64(double) @nogc nothrow;
    double acosf64(double) @nogc nothrow;
    double __acos(double) @nogc nothrow;
    double acos(double) @nogc nothrow;
    float asinf(float) @nogc nothrow;
    float __asinf(float) @nogc nothrow;
    double __asinf64(double) @nogc nothrow;
    float __asinf32(float) @nogc nothrow;
    float asinf32(float) @nogc nothrow;
    double __asin(double) @nogc nothrow;
    double asinf64(double) @nogc nothrow;
    double __asinf32x(double) @nogc nothrow;
    double asinf32x(double) @nogc nothrow;
    real __asinf64x(real) @nogc nothrow;
    real asinf64x(real) @nogc nothrow;
    real asinl(real) @nogc nothrow;
    real __asinl(real) @nogc nothrow;
    double asin(double) @nogc nothrow;
    float __atanf32(float) @nogc nothrow;
    float atanf32(float) @nogc nothrow;
    real __atanl(real) @nogc nothrow;
    real atanl(real) @nogc nothrow;
    double atanf64(double) @nogc nothrow;
    double __atanf64(double) @nogc nothrow;
    double __atanf32x(double) @nogc nothrow;
    double atanf32x(double) @nogc nothrow;
    real atanf64x(real) @nogc nothrow;
    double __atan(double) @nogc nothrow;
    float __atanf(float) @nogc nothrow;
    float atanf(float) @nogc nothrow;
    real __atanf64x(real) @nogc nothrow;
    double atan(double) @nogc nothrow;
    real __atan2f64x(real, real) @nogc nothrow;
    real atan2f64x(real, real) @nogc nothrow;
    double __atan2(double, double) @nogc nothrow;
    float atan2f(float, float) @nogc nothrow;
    float __atan2f32(float, float) @nogc nothrow;
    float atan2f32(float, float) @nogc nothrow;
    float __atan2f(float, float) @nogc nothrow;
    real __atan2l(real, real) @nogc nothrow;
    real atan2l(real, real) @nogc nothrow;
    double atan2f32x(double, double) @nogc nothrow;
    double __atan2f64(double, double) @nogc nothrow;
    double atan2f64(double, double) @nogc nothrow;
    double __atan2f32x(double, double) @nogc nothrow;
    double atan2(double, double) @nogc nothrow;
    double cosf64(double) @nogc nothrow;
    double __cosf64(double) @nogc nothrow;
    float __cosf(float) @nogc nothrow;
    float cosf(float) @nogc nothrow;
    float cosf32(float) @nogc nothrow;
    float __cosf32(float) @nogc nothrow;
    real __cosf64x(real) @nogc nothrow;
    real cosf64x(real) @nogc nothrow;
    double __cosf32x(double) @nogc nothrow;
    double cosf32x(double) @nogc nothrow;
    double __cos(double) @nogc nothrow;
    real __cosl(real) @nogc nothrow;
    real cosl(real) @nogc nothrow;
    double cos(double) @nogc nothrow;
    float __sinf(float) @nogc nothrow;
    double __sinf64(double) @nogc nothrow;
    double sinf64(double) @nogc nothrow;
    float __sinf32(float) @nogc nothrow;
    float sinf32(float) @nogc nothrow;
    real __sinf64x(real) @nogc nothrow;
    real sinf64x(real) @nogc nothrow;
    real __sinl(real) @nogc nothrow;
    real sinl(real) @nogc nothrow;
    float sinf(float) @nogc nothrow;
    double __sin(double) @nogc nothrow;
    double sinf32x(double) @nogc nothrow;
    double __sinf32x(double) @nogc nothrow;
    double sin(double) @nogc nothrow;
    float tanf(float) @nogc nothrow;
    float __tanf(float) @nogc nothrow;
    double __tanf64(double) @nogc nothrow;
    double tanf64(double) @nogc nothrow;
    float __tanf32(float) @nogc nothrow;
    float tanf32(float) @nogc nothrow;
    real __tanf64x(real) @nogc nothrow;
    double __tanf32x(double) @nogc nothrow;
    double tanf32x(double) @nogc nothrow;
    real __tanl(real) @nogc nothrow;
    real tanl(real) @nogc nothrow;
    double __tan(double) @nogc nothrow;
    real tanf64x(real) @nogc nothrow;
    double tan(double) @nogc nothrow;
    float __coshf32(float) @nogc nothrow;
    double __coshf64(double) @nogc nothrow;
    double coshf64(double) @nogc nothrow;
    float coshf32(float) @nogc nothrow;
    float coshf(float) @nogc nothrow;
    float __coshf(float) @nogc nothrow;
    real __coshf64x(real) @nogc nothrow;
    real coshf64x(real) @nogc nothrow;
    double __coshf32x(double) @nogc nothrow;
    double coshf32x(double) @nogc nothrow;
    double __cosh(double) @nogc nothrow;
    real __coshl(real) @nogc nothrow;
    real coshl(real) @nogc nothrow;
    double cosh(double) @nogc nothrow;
    real __sinhl(real) @nogc nothrow;
    real sinhl(real) @nogc nothrow;
    double __sinh(double) @nogc nothrow;
    double sinhf32x(double) @nogc nothrow;
    double __sinhf32x(double) @nogc nothrow;
    real sinhf64x(real) @nogc nothrow;
    real __sinhf64x(real) @nogc nothrow;
    float sinhf32(float) @nogc nothrow;
    float __sinhf32(float) @nogc nothrow;
    double __sinhf64(double) @nogc nothrow;
    float sinhf(float) @nogc nothrow;
    float __sinhf(float) @nogc nothrow;
    double sinhf64(double) @nogc nothrow;
    double sinh(double) @nogc nothrow;
    double __tanhf32x(double) @nogc nothrow;
    double tanhf32x(double) @nogc nothrow;
    float tanhf(float) @nogc nothrow;
    float __tanhf(float) @nogc nothrow;
    real tanhf64x(real) @nogc nothrow;
    double __tanh(double) @nogc nothrow;
    real __tanhf64x(real) @nogc nothrow;
    double __tanhf64(double) @nogc nothrow;
    double tanhf64(double) @nogc nothrow;
    real __tanhl(real) @nogc nothrow;
    float tanhf32(float) @nogc nothrow;
    float __tanhf32(float) @nogc nothrow;
    real tanhl(real) @nogc nothrow;
    double tanh(double) @nogc nothrow;
    void sincosf64(double, double*, double*) @nogc nothrow;
    void __sincosl(real, real*, real*) @nogc nothrow;
    void sincosl(real, real*, real*) @nogc nothrow;
    void sincosf32x(double, double*, double*) @nogc nothrow;
    void sincos(double, double*, double*) @nogc nothrow;
    void sincosf64x(real, real*, real*) @nogc nothrow;
    void __sincosf64x(real, real*, real*) @nogc nothrow;
    void __sincosf(float, float*, float*) @nogc nothrow;
    void sincosf(float, float*, float*) @nogc nothrow;
    void __sincos(double, double*, double*) @nogc nothrow;
    void sincosf32(float, float*, float*) @nogc nothrow;
    void __sincosf32(float, float*, float*) @nogc nothrow;
    void __sincosf64(double, double*, double*) @nogc nothrow;
    void __sincosf32x(double, double*, double*) @nogc nothrow;
    real __acoshf64x(real) @nogc nothrow;
    real acoshf64x(real) @nogc nothrow;
    double __acosh(double) @nogc nothrow;
    double acoshf64(double) @nogc nothrow;
    float acoshf32(float) @nogc nothrow;
    double __acoshf32x(double) @nogc nothrow;
    real acoshl(real) @nogc nothrow;
    float __acoshf(float) @nogc nothrow;
    real __acoshl(real) @nogc nothrow;
    float acoshf(float) @nogc nothrow;
    double __acoshf64(double) @nogc nothrow;
    float __acoshf32(float) @nogc nothrow;
    double acoshf32x(double) @nogc nothrow;
    double acosh(double) @nogc nothrow;
    float __asinhf(float) @nogc nothrow;
    float asinhf(float) @nogc nothrow;
    double __asinh(double) @nogc nothrow;
    real __asinhf64x(real) @nogc nothrow;
    real asinhf64x(real) @nogc nothrow;
    double __asinhf32x(double) @nogc nothrow;
    float __asinhf32(float) @nogc nothrow;
    float asinhf32(float) @nogc nothrow;
    double asinhf64(double) @nogc nothrow;
    double __asinhf64(double) @nogc nothrow;
    double asinhf32x(double) @nogc nothrow;
    real asinhl(real) @nogc nothrow;
    real __asinhl(real) @nogc nothrow;
    double asinh(double) @nogc nothrow;
    real atanhf64x(real) @nogc nothrow;
    real __atanhl(real) @nogc nothrow;
    double atanhf32x(double) @nogc nothrow;
    real atanhl(real) @nogc nothrow;
    float atanhf(float) @nogc nothrow;
    float __atanhf(float) @nogc nothrow;
    float __atanhf32(float) @nogc nothrow;
    float atanhf32(float) @nogc nothrow;
    real __atanhf64x(real) @nogc nothrow;
    double __atanhf32x(double) @nogc nothrow;
    double __atanh(double) @nogc nothrow;
    double atanhf64(double) @nogc nothrow;
    double __atanhf64(double) @nogc nothrow;
    double atanh(double) @nogc nothrow;
    real __expl(real) @nogc nothrow;
    real expl(real) @nogc nothrow;
    double __expf32x(double) @nogc nothrow;
    float __expf32(float) @nogc nothrow;
    double __expf64(double) @nogc nothrow;
    float expf32(float) @nogc nothrow;
    float __expf(float) @nogc nothrow;
    real expf64x(real) @nogc nothrow;
    float expf(float) @nogc nothrow;
    double expf32x(double) @nogc nothrow;
    real __expf64x(real) @nogc nothrow;
    double __exp(double) @nogc nothrow;
    double expf64(double) @nogc nothrow;
    double exp(double) @nogc nothrow;
    double __frexpf32x(double, int*) @nogc nothrow;
    double frexpf32x(double, int*) @nogc nothrow;
    real __frexpf64x(real, int*) @nogc nothrow;
    float frexpf(float, int*) @nogc nothrow;
    float frexpf32(float, int*) @nogc nothrow;
    real frexpf64x(real, int*) @nogc nothrow;
    float __frexpf32(float, int*) @nogc nothrow;
    double __frexp(double, int*) @nogc nothrow;
    real frexpl(real, int*) @nogc nothrow;
    real __frexpl(real, int*) @nogc nothrow;
    float __frexpf(float, int*) @nogc nothrow;
    double __frexpf64(double, int*) @nogc nothrow;
    double frexpf64(double, int*) @nogc nothrow;
    double frexp(double, int*) @nogc nothrow;
    double __ldexpf64(double, int) @nogc nothrow;
    float ldexpf(float, int) @nogc nothrow;
    float __ldexpf(float, int) @nogc nothrow;
    float __ldexpf32(float, int) @nogc nothrow;
    double ldexpf32x(double, int) @nogc nothrow;
    double __ldexpf32x(double, int) @nogc nothrow;
    float ldexpf32(float, int) @nogc nothrow;
    real __ldexpf64x(real, int) @nogc nothrow;
    real ldexpf64x(real, int) @nogc nothrow;
    double __ldexp(double, int) @nogc nothrow;
    double ldexpf64(double, int) @nogc nothrow;
    real __ldexpl(real, int) @nogc nothrow;
    real ldexpl(real, int) @nogc nothrow;
    double ldexp(double, int) @nogc nothrow;
    double __logf32x(double) @nogc nothrow;
    real __logl(real) @nogc nothrow;
    float __logf32(float) @nogc nothrow;
    real logl(real) @nogc nothrow;
    float logf32(float) @nogc nothrow;
    double __log(double) @nogc nothrow;
    float __logf(float) @nogc nothrow;
    double logf32x(double) @nogc nothrow;
    double __logf64(double) @nogc nothrow;
    double logf64(double) @nogc nothrow;
    real __logf64x(real) @nogc nothrow;
    real logf64x(real) @nogc nothrow;
    float logf(float) @nogc nothrow;
    double log(double) @nogc nothrow;
    float log10f(float) @nogc nothrow;
    float __log10f(float) @nogc nothrow;
    real __log10l(real) @nogc nothrow;
    double log10f32x(double) @nogc nothrow;
    real log10l(real) @nogc nothrow;
    float __log10f32(float) @nogc nothrow;
    float log10f32(float) @nogc nothrow;
    double __log10f32x(double) @nogc nothrow;
    double __log10f64(double) @nogc nothrow;
    double __log10(double) @nogc nothrow;
    double log10f64(double) @nogc nothrow;
    real __log10f64x(real) @nogc nothrow;
    real log10f64x(real) @nogc nothrow;
    double log10(double) @nogc nothrow;
    double modff64(double, double*) @nogc nothrow;
    double __modff64(double, double*) @nogc nothrow;
    real __modff64x(real, real*) @nogc nothrow;
    real modff64x(real, real*) @nogc nothrow;
    real __modfl(real, real*) @nogc nothrow;
    real modfl(real, real*) @nogc nothrow;
    float modff(float, float*) @nogc nothrow;
    float __modff(float, float*) @nogc nothrow;
    float __modff32(float, float*) @nogc nothrow;
    float modff32(float, float*) @nogc nothrow;
    double __modf(double, double*) @nogc nothrow;
    double modff32x(double, double*) @nogc nothrow;
    double __modff32x(double, double*) @nogc nothrow;
    double modf(double, double*) @nogc nothrow;
    double __exp10f32x(double) @nogc nothrow;
    double exp10f32x(double) @nogc nothrow;
    double exp10(double) @nogc nothrow;
    double __exp10(double) @nogc nothrow;
    float exp10f32(float) @nogc nothrow;
    float __exp10f32(float) @nogc nothrow;
    float __exp10f(float) @nogc nothrow;
    float exp10f(float) @nogc nothrow;
    real exp10l(real) @nogc nothrow;
    real __exp10l(real) @nogc nothrow;
    double __exp10f64(double) @nogc nothrow;
    real exp10f64x(real) @nogc nothrow;
    real __exp10f64x(real) @nogc nothrow;
    double exp10f64(double) @nogc nothrow;
    double expm1f32x(double) @nogc nothrow;
    double __expm1f64(double) @nogc nothrow;
    double expm1f64(double) @nogc nothrow;
    real expm1f64x(real) @nogc nothrow;
    real __expm1f64x(real) @nogc nothrow;
    double __expm1f32x(double) @nogc nothrow;
    float expm1f(float) @nogc nothrow;
    real __expm1l(real) @nogc nothrow;
    float __expm1f(float) @nogc nothrow;
    float __expm1f32(float) @nogc nothrow;
    float expm1f32(float) @nogc nothrow;
    double __expm1(double) @nogc nothrow;
    real expm1l(real) @nogc nothrow;
    double expm1(double) @nogc nothrow;
    double __log1p(double) @nogc nothrow;
    float log1pf32(float) @nogc nothrow;
    float __log1pf32(float) @nogc nothrow;
    double log1pf64(double) @nogc nothrow;
    real log1pf64x(real) @nogc nothrow;
    real __log1pf64x(real) @nogc nothrow;
    double log1pf32x(double) @nogc nothrow;
    float log1pf(float) @nogc nothrow;
    float __log1pf(float) @nogc nothrow;
    double __log1pf32x(double) @nogc nothrow;
    double __log1pf64(double) @nogc nothrow;
    real log1pl(real) @nogc nothrow;
    real __log1pl(real) @nogc nothrow;
    double log1p(double) @nogc nothrow;
    float logbf(float) @nogc nothrow;
    double __logb(double) @nogc nothrow;
    float logbf32(float) @nogc nothrow;
    real __logbl(real) @nogc nothrow;
    real logbl(real) @nogc nothrow;
    float __logbf32(float) @nogc nothrow;
    real logbf64x(real) @nogc nothrow;
    float __logbf(float) @nogc nothrow;
    double logbf32x(double) @nogc nothrow;
    double __logbf32x(double) @nogc nothrow;
    double __logbf64(double) @nogc nothrow;
    double logbf64(double) @nogc nothrow;
    real __logbf64x(real) @nogc nothrow;
    double logb(double) @nogc nothrow;
    float __exp2f(float) @nogc nothrow;
    real __exp2f64x(real) @nogc nothrow;
    real exp2f64x(real) @nogc nothrow;
    float exp2f(float) @nogc nothrow;
    double __exp2f32x(double) @nogc nothrow;
    double exp2f32x(double) @nogc nothrow;
    real exp2l(real) @nogc nothrow;
    real __exp2l(real) @nogc nothrow;
    double __exp2(double) @nogc nothrow;
    float exp2f32(float) @nogc nothrow;
    float __exp2f32(float) @nogc nothrow;
    double exp2f64(double) @nogc nothrow;
    double __exp2f64(double) @nogc nothrow;
    double exp2(double) @nogc nothrow;
    real log2l(real) @nogc nothrow;
    float __log2f(float) @nogc nothrow;
    float log2f(float) @nogc nothrow;
    real __log2l(real) @nogc nothrow;
    double log2f64(double) @nogc nothrow;
    double __log2(double) @nogc nothrow;
    double __log2f64(double) @nogc nothrow;
    double log2f32x(double) @nogc nothrow;
    double __log2f32x(double) @nogc nothrow;
    real log2f64x(real) @nogc nothrow;
    float log2f32(float) @nogc nothrow;
    float __log2f32(float) @nogc nothrow;
    real __log2f64x(real) @nogc nothrow;
    double log2(double) @nogc nothrow;
    real __powl(real, real) @nogc nothrow;
    double powf64(double, double) @nogc nothrow;
    real powf64x(real, real) @nogc nothrow;
    float __powf(float, float) @nogc nothrow;
    float powf(float, float) @nogc nothrow;
    float __powf32(float, float) @nogc nothrow;
    double __pow(double, double) @nogc nothrow;
    real powl(real, real) @nogc nothrow;
    float powf32(float, float) @nogc nothrow;
    double powf32x(double, double) @nogc nothrow;
    double __powf32x(double, double) @nogc nothrow;
    real __powf64x(real, real) @nogc nothrow;
    double __powf64(double, double) @nogc nothrow;
    double pow(double, double) @nogc nothrow;
    double __sqrt(double) @nogc nothrow;
    real sqrtf64x(real) @nogc nothrow;
    real __sqrtf64x(real) @nogc nothrow;
    float __sqrtf(float) @nogc nothrow;
    float sqrtf(float) @nogc nothrow;
    float sqrtf32(float) @nogc nothrow;
    float __sqrtf32(float) @nogc nothrow;
    double __sqrtf64(double) @nogc nothrow;
    real __sqrtl(real) @nogc nothrow;
    real sqrtl(real) @nogc nothrow;
    double __sqrtf32x(double) @nogc nothrow;
    double sqrtf32x(double) @nogc nothrow;
    double sqrtf64(double) @nogc nothrow;
    double sqrt(double) @nogc nothrow;
    float __hypotf32(float, float) @nogc nothrow;
    real hypotf64x(real, real) @nogc nothrow;
    real __hypotf64x(real, real) @nogc nothrow;
    double __hypot(double, double) @nogc nothrow;
    float hypotf32(float, float) @nogc nothrow;
    float __hypotf(float, float) @nogc nothrow;
    float hypotf(float, float) @nogc nothrow;
    double __hypotf64(double, double) @nogc nothrow;
    double __hypotf32x(double, double) @nogc nothrow;
    double hypotf32x(double, double) @nogc nothrow;
    double hypotf64(double, double) @nogc nothrow;
    real hypotl(real, real) @nogc nothrow;
    real __hypotl(real, real) @nogc nothrow;
    double hypot(double, double) @nogc nothrow;
    real __cbrtf64x(real) @nogc nothrow;
    float cbrtf(float) @nogc nothrow;
    float __cbrtf(float) @nogc nothrow;
    real cbrtf64x(real) @nogc nothrow;
    double cbrtf32x(double) @nogc nothrow;
    float __cbrtf32(float) @nogc nothrow;
    float cbrtf32(float) @nogc nothrow;
    double __cbrtf32x(double) @nogc nothrow;
    double cbrtf64(double) @nogc nothrow;
    real cbrtl(real) @nogc nothrow;
    real __cbrtl(real) @nogc nothrow;
    double __cbrt(double) @nogc nothrow;
    double __cbrtf64(double) @nogc nothrow;
    double cbrt(double) @nogc nothrow;
    double ceilf32x(double) @nogc nothrow;
    double __ceilf32x(double) @nogc nothrow;
    real ceill(real) @nogc nothrow;
    real __ceill(real) @nogc nothrow;
    float __ceilf(float) @nogc nothrow;
    real __ceilf64x(real) @nogc nothrow;
    real ceilf64x(real) @nogc nothrow;
    float ceilf(float) @nogc nothrow;
    double __ceil(double) @nogc nothrow;
    float __ceilf32(float) @nogc nothrow;
    float ceilf32(float) @nogc nothrow;
    double __ceilf64(double) @nogc nothrow;
    double ceilf64(double) @nogc nothrow;
    double ceil(double) @nogc nothrow;
    double fabsf32x(double) @nogc nothrow;
    double __fabsf32x(double) @nogc nothrow;
    double __fabs(double) @nogc nothrow;
    float __fabsf(float) @nogc nothrow;
    float fabsf(float) @nogc nothrow;
    real __fabsf64x(real) @nogc nothrow;
    real fabsl(real) @nogc nothrow;
    real fabsf64x(real) @nogc nothrow;
    float fabsf32(float) @nogc nothrow;
    float __fabsf32(float) @nogc nothrow;
    double fabsf64(double) @nogc nothrow;
    real __fabsl(real) @nogc nothrow;
    double __fabsf64(double) @nogc nothrow;
    double fabs(double) @nogc nothrow;
    double floorf64(double) @nogc nothrow;
    float floorf32(float) @nogc nothrow;
    double __floorf32x(double) @nogc nothrow;
    double floorf32x(double) @nogc nothrow;
    float __floorf32(float) @nogc nothrow;
    real floorf64x(real) @nogc nothrow;
    real __floorf64x(real) @nogc nothrow;
    double __floor(double) @nogc nothrow;
    double __floorf64(double) @nogc nothrow;
    real floorl(real) @nogc nothrow;
    real __floorl(real) @nogc nothrow;
    float floorf(float) @nogc nothrow;
    float __floorf(float) @nogc nothrow;
    double floor(double) @nogc nothrow;
    real fmodl(real, real) @nogc nothrow;
    real __fmodl(real, real) @nogc nothrow;
    double fmodf64(double, double) @nogc nothrow;
    float fmodf(float, float) @nogc nothrow;
    float __fmodf(float, float) @nogc nothrow;
    float __fmodf32(float, float) @nogc nothrow;
    float fmodf32(float, float) @nogc nothrow;
    double __fmodf64(double, double) @nogc nothrow;
    real fmodf64x(real, real) @nogc nothrow;
    real __fmodf64x(real, real) @nogc nothrow;
    double __fmod(double, double) @nogc nothrow;
    double fmodf32x(double, double) @nogc nothrow;
    double __fmodf32x(double, double) @nogc nothrow;
    double fmod(double, double) @nogc nothrow;
    int isinff(float) @nogc nothrow;
    pragma(mangle, "isinf") int isinf_(double) @nogc nothrow;
    int isinfl(real) @nogc nothrow;
    int finitef(float) @nogc nothrow;
    int finitel(real) @nogc nothrow;
    int finite(double) @nogc nothrow;
    real __dreml(real, real) @nogc nothrow;
    real dreml(real, real) @nogc nothrow;
    float dremf(float, float) @nogc nothrow;
    float __dremf(float, float) @nogc nothrow;
    double drem(double, double) @nogc nothrow;
    double __drem(double, double) @nogc nothrow;
    double significand(double) @nogc nothrow;
    double __significand(double) @nogc nothrow;
    float __significandf(float) @nogc nothrow;
    float significandf(float) @nogc nothrow;
    real significandl(real) @nogc nothrow;
    real __significandl(real) @nogc nothrow;
    double copysignf32x(double, double) @nogc nothrow;
    double __copysignf32x(double, double) @nogc nothrow;
    double __copysignf64(double, double) @nogc nothrow;
    double copysignf64(double, double) @nogc nothrow;
    real __copysignl(real, real) @nogc nothrow;
    float __copysignf(float, float) @nogc nothrow;
    float copysignf(float, float) @nogc nothrow;
    real copysignf64x(real, real) @nogc nothrow;
    float copysignf32(float, float) @nogc nothrow;
    float __copysignf32(float, float) @nogc nothrow;
    double __copysign(double, double) @nogc nothrow;
    real copysignl(real, real) @nogc nothrow;
    real __copysignf64x(real, real) @nogc nothrow;
    double copysign(double, double) @nogc nothrow;
    double __nan(const(char)*) @nogc nothrow;
    double nanf64(const(char)*) @nogc nothrow;
    double __nanf64(const(char)*) @nogc nothrow;
    real __nanl(const(char)*) @nogc nothrow;
    real nanl(const(char)*) @nogc nothrow;
    float nanf32(const(char)*) @nogc nothrow;
    float __nanf32(const(char)*) @nogc nothrow;
    real __nanf64x(const(char)*) @nogc nothrow;
    real nanf64x(const(char)*) @nogc nothrow;
    float nanf(const(char)*) @nogc nothrow;
    float __nanf(const(char)*) @nogc nothrow;
    double __nanf32x(const(char)*) @nogc nothrow;
    double nanf32x(const(char)*) @nogc nothrow;
    double nan(const(char)*) @nogc nothrow;
    int isnanf(float) @nogc nothrow;
    int isnanl(real) @nogc nothrow;
    pragma(mangle, "isnan") int isnan_(double) @nogc nothrow;
    float __j0f(float) @nogc nothrow;
    double j0f32x(double) @nogc nothrow;
    double __j0f32x(double) @nogc nothrow;
    float j0f(float) @nogc nothrow;
    float __j0f32(float) @nogc nothrow;
    real j0f64x(real) @nogc nothrow;
    real __j0f64x(real) @nogc nothrow;
    double j0f64(double) @nogc nothrow;
    double __j0f64(double) @nogc nothrow;
    double __j0(double) @nogc nothrow;
    float j0f32(float) @nogc nothrow;
    real __j0l(real) @nogc nothrow;
    real j0l(real) @nogc nothrow;
    double j0(double) @nogc nothrow;
    float __j1f32(float) @nogc nothrow;
    double __j1f64(double) @nogc nothrow;
    float j1f32(float) @nogc nothrow;
    real j1l(real) @nogc nothrow;
    real __j1l(real) @nogc nothrow;
    double j1f64(double) @nogc nothrow;
    real __j1f64x(real) @nogc nothrow;
    float __j1f(float) @nogc nothrow;
    float j1f(float) @nogc nothrow;
    real j1f64x(real) @nogc nothrow;
    double __j1(double) @nogc nothrow;
    double __j1f32x(double) @nogc nothrow;
    double j1(double) @nogc nothrow;
    double j1f32x(double) @nogc nothrow;
    double jnf64(int, double) @nogc nothrow;
    double __jnf64(int, double) @nogc nothrow;
    double jnf32x(int, double) @nogc nothrow;
    double __jnf32x(int, double) @nogc nothrow;
    real jnf64x(int, real) @nogc nothrow;
    real __jnf64x(int, real) @nogc nothrow;
    float __jnf(int, float) @nogc nothrow;
    float jnf(int, float) @nogc nothrow;
    float __jnf32(int, float) @nogc nothrow;
    real jnl(int, real) @nogc nothrow;
    real __jnl(int, real) @nogc nothrow;
    float jnf32(int, float) @nogc nothrow;
    double jn(int, double) @nogc nothrow;
    double __jn(int, double) @nogc nothrow;
    float __y0f(float) @nogc nothrow;
    float __y0f32(float) @nogc nothrow;
    float y0f32(float) @nogc nothrow;
    double __y0f32x(double) @nogc nothrow;
    real __y0f64x(real) @nogc nothrow;
    real y0f64x(real) @nogc nothrow;
    double y0f32x(double) @nogc nothrow;
    float y0f(float) @nogc nothrow;
    double __y0(double) @nogc nothrow;
    double y0(double) @nogc nothrow;
    real y0l(real) @nogc nothrow;
    real __y0l(real) @nogc nothrow;
    double __y0f64(double) @nogc nothrow;
    double y0f64(double) @nogc nothrow;
    double y1(double) @nogc nothrow;
    double __y1(double) @nogc nothrow;
    real y1f64x(real) @nogc nothrow;
    real __y1f64x(real) @nogc nothrow;
    double __y1f64(double) @nogc nothrow;
    double y1f64(double) @nogc nothrow;
    float __y1f(float) @nogc nothrow;
    float y1f(float) @nogc nothrow;
    real __y1l(real) @nogc nothrow;
    real y1l(real) @nogc nothrow;
    double y1f32x(double) @nogc nothrow;
    double __y1f32x(double) @nogc nothrow;
    float __y1f32(float) @nogc nothrow;
    float y1f32(float) @nogc nothrow;
    real __ynf64x(int, real) @nogc nothrow;
    real ynf64x(int, real) @nogc nothrow;
    real __ynl(int, real) @nogc nothrow;
    real ynl(int, real) @nogc nothrow;
    double ynf64(int, double) @nogc nothrow;
    double __ynf64(int, double) @nogc nothrow;
    double __yn(int, double) @nogc nothrow;
    double yn(int, double) @nogc nothrow;
    float __ynf(int, float) @nogc nothrow;
    float ynf(int, float) @nogc nothrow;
    float ynf32(int, float) @nogc nothrow;
    double ynf32x(int, double) @nogc nothrow;
    float __ynf32(int, float) @nogc nothrow;
    double __ynf32x(int, double) @nogc nothrow;
    double erff64(double) @nogc nothrow;
    double __erff64(double) @nogc nothrow;
    double __erff32x(double) @nogc nothrow;
    double erff32x(double) @nogc nothrow;
    real erff64x(real) @nogc nothrow;
    double __erf(double) @nogc nothrow;
    real __erff64x(real) @nogc nothrow;
    float erff32(float) @nogc nothrow;
    float __erff32(float) @nogc nothrow;
    float __erff(float) @nogc nothrow;
    real __erfl(real) @nogc nothrow;
    real erfl(real) @nogc nothrow;
    float erff(float) @nogc nothrow;
    double erf(double) @nogc nothrow;
    double __erfc(double) @nogc nothrow;
    float erfcf32(float) @nogc nothrow;
    real erfcf64x(real) @nogc nothrow;
    real __erfcf64x(real) @nogc nothrow;
    double __erfcf64(double) @nogc nothrow;
    double erfcf64(double) @nogc nothrow;
    float __erfcf32(float) @nogc nothrow;
    real erfcl(real) @nogc nothrow;
    real __erfcl(real) @nogc nothrow;
    double erfcf32x(double) @nogc nothrow;
    double __erfcf32x(double) @nogc nothrow;
    float erfcf(float) @nogc nothrow;
    float __erfcf(float) @nogc nothrow;
    double erfc(double) @nogc nothrow;
    real __lgammaf64x(real) @nogc nothrow;
    double __lgammaf64(double) @nogc nothrow;
    double lgammaf64(double) @nogc nothrow;
    double lgammaf32x(double) @nogc nothrow;
    real lgammaf64x(real) @nogc nothrow;
    float __lgammaf(float) @nogc nothrow;
    double __lgamma(double) @nogc nothrow;
    float lgammaf(float) @nogc nothrow;
    real __lgammal(real) @nogc nothrow;
    real lgammal(real) @nogc nothrow;
    float lgammaf32(float) @nogc nothrow;
    float __lgammaf32(float) @nogc nothrow;
    double __lgammaf32x(double) @nogc nothrow;
    double lgamma(double) @nogc nothrow;
    real __tgammal(real) @nogc nothrow;
    float __tgammaf32(float) @nogc nothrow;
    float tgammaf32(float) @nogc nothrow;
    real tgammal(real) @nogc nothrow;
    double __tgamma(double) @nogc nothrow;
    double __tgammaf32x(double) @nogc nothrow;
    double tgammaf32x(double) @nogc nothrow;
    real __tgammaf64x(real) @nogc nothrow;
    float tgammaf(float) @nogc nothrow;
    float __tgammaf(float) @nogc nothrow;
    double tgammaf64(double) @nogc nothrow;
    real tgammaf64x(real) @nogc nothrow;
    double __tgammaf64(double) @nogc nothrow;
    double tgamma(double) @nogc nothrow;
    double __gamma(double) @nogc nothrow;
    real gammal(real) @nogc nothrow;
    real __gammal(real) @nogc nothrow;
    float __gammaf(float) @nogc nothrow;
    float gammaf(float) @nogc nothrow;
    double gamma(double) @nogc nothrow;
    real __lgammal_r(real, int*) @nogc nothrow;
    float __lgammaf_r(float, int*) @nogc nothrow;
    double lgammaf32x_r(double, int*) @nogc nothrow;
    double __lgammaf32x_r(double, int*) @nogc nothrow;
    float __lgammaf32_r(float, int*) @nogc nothrow;
    real lgammal_r(real, int*) @nogc nothrow;
    real __lgammaf64x_r(real, int*) @nogc nothrow;
    real lgammaf64x_r(real, int*) @nogc nothrow;
    double lgammaf64_r(double, int*) @nogc nothrow;
    double __lgammaf64_r(double, int*) @nogc nothrow;
    double lgamma_r(double, int*) @nogc nothrow;
    double __lgamma_r(double, int*) @nogc nothrow;
    float lgammaf32_r(float, int*) @nogc nothrow;
    float lgammaf_r(float, int*) @nogc nothrow;
    real __rintl(real) @nogc nothrow;
    double rintf64(double) @nogc nothrow;
    double __rintf64(double) @nogc nothrow;
    float __rintf(float) @nogc nothrow;
    float rintf(float) @nogc nothrow;
    double __rint(double) @nogc nothrow;
    real rintl(real) @nogc nothrow;
    double __rintf32x(double) @nogc nothrow;
    double rintf32x(double) @nogc nothrow;
    float rintf32(float) @nogc nothrow;
    float __rintf32(float) @nogc nothrow;
    real rintf64x(real) @nogc nothrow;
    real __rintf64x(real) @nogc nothrow;
    double rint(double) @nogc nothrow;
    float nextafterf(float, float) @nogc nothrow;
    float __nextafterf(float, float) @nogc nothrow;
    real __nextafterl(real, real) @nogc nothrow;
    real nextafterl(real, real) @nogc nothrow;
    real nextafterf64x(real, real) @nogc nothrow;
    real __nextafterf64x(real, real) @nogc nothrow;
    double nextafterf64(double, double) @nogc nothrow;
    double __nextafterf64(double, double) @nogc nothrow;
    double __nextafter(double, double) @nogc nothrow;
    double nextafterf32x(double, double) @nogc nothrow;
    double __nextafterf32x(double, double) @nogc nothrow;
    float nextafterf32(float, float) @nogc nothrow;
    float __nextafterf32(float, float) @nogc nothrow;
    double nextafter(double, double) @nogc nothrow;
    real __nexttowardl(real, real) @nogc nothrow;
    real nexttowardl(real, real) @nogc nothrow;
    float __nexttowardf(float, real) @nogc nothrow;
    double __nexttoward(double, real) @nogc nothrow;
    float nexttowardf(float, real) @nogc nothrow;
    double nexttoward(double, real) @nogc nothrow;
    float __nextdownf(float) @nogc nothrow;
    double __nextdownf64(double) @nogc nothrow;
    float nextdownf32(float) @nogc nothrow;
    float __nextdownf32(float) @nogc nothrow;
    float nextdownf(float) @nogc nothrow;
    double nextdownf64(double) @nogc nothrow;
    double nextdown(double) @nogc nothrow;
    real nextdownf64x(real) @nogc nothrow;
    double __nextdown(double) @nogc nothrow;
    double nextdownf32x(double) @nogc nothrow;
    double __nextdownf32x(double) @nogc nothrow;
    real __nextdownf64x(real) @nogc nothrow;
    real __nextdownl(real) @nogc nothrow;
    real nextdownl(real) @nogc nothrow;
    float __nextupf32(float) @nogc nothrow;
    real __nextupl(real) @nogc nothrow;
    real nextupl(real) @nogc nothrow;
    real __nextupf64x(real) @nogc nothrow;
    real nextupf64x(real) @nogc nothrow;
    double __nextupf32x(double) @nogc nothrow;
    double nextupf32x(double) @nogc nothrow;
    double nextup(double) @nogc nothrow;
    float __nextupf(float) @nogc nothrow;
    double __nextup(double) @nogc nothrow;
    double nextupf64(double) @nogc nothrow;
    double __nextupf64(double) @nogc nothrow;
    float nextupf(float) @nogc nothrow;
    float nextupf32(float) @nogc nothrow;
    double __remainderf64(double, double) @nogc nothrow;
    double remainderf64(double, double) @nogc nothrow;
    float __remainderf32(float, float) @nogc nothrow;
    float remainderf32(float, float) @nogc nothrow;
    real remainderf64x(real, real) @nogc nothrow;
    real __remainderf64x(real, real) @nogc nothrow;
    real __remainderl(real, real) @nogc nothrow;
    double remainderf32x(double, double) @nogc nothrow;
    double __remainder(double, double) @nogc nothrow;
    float __remainderf(float, float) @nogc nothrow;
    float remainderf(float, float) @nogc nothrow;
    double __remainderf32x(double, double) @nogc nothrow;
    real remainderl(real, real) @nogc nothrow;
    double remainder(double, double) @nogc nothrow;
    float __scalbnf32(float, int) @nogc nothrow;
    float scalbnf32(float, int) @nogc nothrow;
    double scalbnf64(double, int) @nogc nothrow;
    double __scalbnf64(double, int) @nogc nothrow;
    double __scalbnf32x(double, int) @nogc nothrow;
    double scalbnf32x(double, int) @nogc nothrow;
    real scalbnf64x(real, int) @nogc nothrow;
    real __scalbnf64x(real, int) @nogc nothrow;
    real __scalbnl(real, int) @nogc nothrow;
    real scalbnl(real, int) @nogc nothrow;
    float __scalbnf(float, int) @nogc nothrow;
    double __scalbn(double, int) @nogc nothrow;
    float scalbnf(float, int) @nogc nothrow;
    double scalbn(double, int) @nogc nothrow;
    int ilogbf32x(double) @nogc nothrow;
    int __ilogbf32x(double) @nogc nothrow;
    int ilogbf64(double) @nogc nothrow;
    int __ilogbf64(double) @nogc nothrow;
    int ilogbf(float) @nogc nothrow;
    int __ilogbf(float) @nogc nothrow;
    int ilogbf64x(real) @nogc nothrow;
    int __ilogbl(real) @nogc nothrow;
    int ilogbl(real) @nogc nothrow;
    int __ilogb(double) @nogc nothrow;
    int ilogbf32(float) @nogc nothrow;
    int __ilogbf64x(real) @nogc nothrow;
    int __ilogbf32(float) @nogc nothrow;
    int ilogb(double) @nogc nothrow;
    c_long llogbf(float) @nogc nothrow;
    c_long llogbl(real) @nogc nothrow;
    c_long llogb(double) @nogc nothrow;
    c_long __llogb(double) @nogc nothrow;
    c_long llogbf32(float) @nogc nothrow;
    c_long __llogbf64x(real) @nogc nothrow;
    c_long llogbf64x(real) @nogc nothrow;
    c_long __llogbf64(double) @nogc nothrow;
    c_long llogbf64(double) @nogc nothrow;
    c_long __llogbf32x(double) @nogc nothrow;
    c_long __llogbl(real) @nogc nothrow;
    c_long llogbf32x(double) @nogc nothrow;
    c_long __llogbf(float) @nogc nothrow;
    c_long __llogbf32(float) @nogc nothrow;
    float scalblnf32(float, c_long) @nogc nothrow;
    double __scalblnf32x(double, c_long) @nogc nothrow;
    double __scalbln(double, c_long) @nogc nothrow;
    float __scalblnf32(float, c_long) @nogc nothrow;
    double scalblnf32x(double, c_long) @nogc nothrow;
    real __scalblnf64x(real, c_long) @nogc nothrow;
    real scalblnf64x(real, c_long) @nogc nothrow;
    float __scalblnf(float, c_long) @nogc nothrow;
    double scalblnf64(double, c_long) @nogc nothrow;
    float scalblnf(float, c_long) @nogc nothrow;
    double __scalblnf64(double, c_long) @nogc nothrow;
    real scalblnl(real, c_long) @nogc nothrow;
    real __scalblnl(real, c_long) @nogc nothrow;
    double scalbln(double, c_long) @nogc nothrow;
    real __nearbyintl(real) @nogc nothrow;
    real nearbyintl(real) @nogc nothrow;
    float nearbyintf(float) @nogc nothrow;
    double __nearbyintf64(double) @nogc nothrow;
    real __nearbyintf64x(real) @nogc nothrow;
    double nearbyintf32x(double) @nogc nothrow;
    double __nearbyintf32x(double) @nogc nothrow;
    double __nearbyint(double) @nogc nothrow;
    float __nearbyintf32(float) @nogc nothrow;
    float nearbyintf32(float) @nogc nothrow;
    real nearbyintf64x(real) @nogc nothrow;
    float __nearbyintf(float) @nogc nothrow;
    double nearbyintf64(double) @nogc nothrow;
    double nearbyint(double) @nogc nothrow;
    double roundf64(double) @nogc nothrow;
    double __roundf64(double) @nogc nothrow;
    double roundf32x(double) @nogc nothrow;
    double __roundf32x(double) @nogc nothrow;
    real __roundf64x(real) @nogc nothrow;
    real roundf64x(real) @nogc nothrow;
    real __roundl(real) @nogc nothrow;
    float __roundf32(float) @nogc nothrow;
    real roundl(real) @nogc nothrow;
    float __roundf(float) @nogc nothrow;
    float roundf32(float) @nogc nothrow;
    float roundf(float) @nogc nothrow;
    double __round(double) @nogc nothrow;
    double round(double) @nogc nothrow;
    double truncf64(double) @nogc nothrow;
    double __truncf64(double) @nogc nothrow;
    real truncf64x(real) @nogc nothrow;
    double truncf32x(double) @nogc nothrow;
    double __trunc(double) @nogc nothrow;
    real __truncl(real) @nogc nothrow;
    real truncl(real) @nogc nothrow;
    float __truncf32(float) @nogc nothrow;
    float truncf32(float) @nogc nothrow;
    float truncf(float) @nogc nothrow;
    float __truncf(float) @nogc nothrow;
    double __truncf32x(double) @nogc nothrow;
    real __truncf64x(real) @nogc nothrow;
    double trunc(double) @nogc nothrow;
    real __remquol(real, real, int*) @nogc nothrow;
    double remquof64(double, double, int*) @nogc nothrow;
    real __remquof64x(real, real, int*) @nogc nothrow;
    real remquof64x(real, real, int*) @nogc nothrow;
    real remquol(real, real, int*) @nogc nothrow;
    double __remquof64(double, double, int*) @nogc nothrow;
    float __remquof32(float, float, int*) @nogc nothrow;
    float remquof32(float, float, int*) @nogc nothrow;
    double remquof32x(double, double, int*) @nogc nothrow;
    double __remquof32x(double, double, int*) @nogc nothrow;
    double __remquo(double, double, int*) @nogc nothrow;
    float __remquof(float, float, int*) @nogc nothrow;
    float remquof(float, float, int*) @nogc nothrow;
    double remquo(double, double, int*) @nogc nothrow;
    c_long __lrintl(real) @nogc nothrow;
    c_long __lrintf(float) @nogc nothrow;
    c_long lrintf(float) @nogc nothrow;
    c_long lrintl(real) @nogc nothrow;
    c_long __lrint(double) @nogc nothrow;
    c_long lrintf64(double) @nogc nothrow;
    c_long __lrintf64(double) @nogc nothrow;
    c_long __lrintf32x(double) @nogc nothrow;
    c_long lrintf64x(real) @nogc nothrow;
    c_long __lrintf64x(real) @nogc nothrow;
    c_long __lrintf32(float) @nogc nothrow;
    c_long lrintf32(float) @nogc nothrow;
    c_long lrintf32x(double) @nogc nothrow;
    c_long lrint(double) @nogc nothrow;
    long llrintf32(float) @nogc nothrow;
    long __llrintf32(float) @nogc nothrow;
    long __llrintf64(double) @nogc nothrow;
    long __llrintf32x(double) @nogc nothrow;
    long llrintf64(double) @nogc nothrow;
    long __llrintl(real) @nogc nothrow;
    long llrintf(float) @nogc nothrow;
    long __llrintf(float) @nogc nothrow;
    long __llrint(double) @nogc nothrow;
    long llrintf32x(double) @nogc nothrow;
    long llrintl(real) @nogc nothrow;
    long __llrintf64x(real) @nogc nothrow;
    long llrintf64x(real) @nogc nothrow;
    long llrint(double) @nogc nothrow;
    c_long __lroundf(float) @nogc nothrow;
    c_long lroundf64(double) @nogc nothrow;
    c_long __lroundf64(double) @nogc nothrow;
    c_long __lroundf32(float) @nogc nothrow;
    c_long lroundf32(float) @nogc nothrow;
    c_long __lroundf64x(real) @nogc nothrow;
    c_long lroundf64x(real) @nogc nothrow;
    c_long __lround(double) @nogc nothrow;
    c_long __lroundl(real) @nogc nothrow;
    c_long lroundf32x(double) @nogc nothrow;
    c_long __lroundf32x(double) @nogc nothrow;
    c_long lroundl(real) @nogc nothrow;
    c_long lroundf(float) @nogc nothrow;
    c_long lround(double) @nogc nothrow;
    long __llroundf64(double) @nogc nothrow;
    long __llroundf32(float) @nogc nothrow;
    long llroundf32(float) @nogc nothrow;
    long llroundf64(double) @nogc nothrow;
    long llroundf64x(real) @nogc nothrow;
    long __llroundl(real) @nogc nothrow;
    long llroundl(real) @nogc nothrow;
    long __llroundf(float) @nogc nothrow;
    long llroundf32x(double) @nogc nothrow;
    long __llroundf32x(double) @nogc nothrow;
    long llroundf(float) @nogc nothrow;
    long __llround(double) @nogc nothrow;
    long __llroundf64x(real) @nogc nothrow;
    long llround(double) @nogc nothrow;
    float fdimf(float, float) @nogc nothrow;
    float __fdimf(float, float) @nogc nothrow;
    real __fdimf64x(real, real) @nogc nothrow;
    real __fdiml(real, real) @nogc nothrow;
    real fdiml(real, real) @nogc nothrow;
    double fdimf64(double, double) @nogc nothrow;
    double __fdimf64(double, double) @nogc nothrow;
    float __fdimf32(float, float) @nogc nothrow;
    real fdimf64x(real, real) @nogc nothrow;
    float fdimf32(float, float) @nogc nothrow;
    double fdimf32x(double, double) @nogc nothrow;
    double __fdimf32x(double, double) @nogc nothrow;
    double __fdim(double, double) @nogc nothrow;
    double fdim(double, double) @nogc nothrow;
    real __fmaxl(real, real) @nogc nothrow;
    real __fmaxf64x(real, real) @nogc nothrow;
    float fmaxf(float, float) @nogc nothrow;
    float __fmaxf(float, float) @nogc nothrow;
    real fmaxf64x(real, real) @nogc nothrow;
    float __fmaxf32(float, float) @nogc nothrow;
    float fmaxf32(float, float) @nogc nothrow;
    double fmaxf64(double, double) @nogc nothrow;
    double __fmaxf64(double, double) @nogc nothrow;
    double fmaxf32x(double, double) @nogc nothrow;
    double __fmaxf32x(double, double) @nogc nothrow;
    double __fmax(double, double) @nogc nothrow;
    real fmaxl(real, real) @nogc nothrow;
    double fmax(double, double) @nogc nothrow;
    float fminf(float, float) @nogc nothrow;
    double fminf32x(double, double) @nogc nothrow;
    real __fminl(real, real) @nogc nothrow;
    real fminl(real, real) @nogc nothrow;
    real fminf64x(real, real) @nogc nothrow;
    real __fminf64x(real, real) @nogc nothrow;
    double __fminf32x(double, double) @nogc nothrow;
    double __fminf64(double, double) @nogc nothrow;
    float fminf32(float, float) @nogc nothrow;
    float __fminf32(float, float) @nogc nothrow;
    double __fmin(double, double) @nogc nothrow;
    float __fminf(float, float) @nogc nothrow;
    double fminf64(double, double) @nogc nothrow;
    double fmin(double, double) @nogc nothrow;
    real fmaf64x(real, real, real) @nogc nothrow;
    float __fmaf32(float, float, float) @nogc nothrow;
    float fmaf32(float, float, float) @nogc nothrow;
    double __fmaf32x(double, double, double) @nogc nothrow;
    double fmaf32x(double, double, double) @nogc nothrow;
    float __fmaf(float, float, float) @nogc nothrow;
    float fmaf(float, float, float) @nogc nothrow;
    double __fma(double, double, double) @nogc nothrow;
    double fmaf64(double, double, double) @nogc nothrow;
    real __fmal(real, real, real) @nogc nothrow;
    double __fmaf64(double, double, double) @nogc nothrow;
    real fmal(real, real, real) @nogc nothrow;
    real __fmaf64x(real, real, real) @nogc nothrow;
    double fma(double, double, double) @nogc nothrow;
    float roundevenf32(float) @nogc nothrow;
    double __roundevenf64(double) @nogc nothrow;
    real __roundevenf64x(real) @nogc nothrow;
    real roundevenf64x(real) @nogc nothrow;
    real roundevenl(real) @nogc nothrow;
    double __roundevenf32x(double) @nogc nothrow;
    real __roundevenl(real) @nogc nothrow;
    float __roundevenf32(float) @nogc nothrow;
    double roundevenf64(double) @nogc nothrow;
    double roundevenf32x(double) @nogc nothrow;
    double roundeven(double) @nogc nothrow;
    double __roundeven(double) @nogc nothrow;
    float roundevenf(float) @nogc nothrow;
    float __roundevenf(float) @nogc nothrow;
    c_long fromfpf32x(double, int, uint) @nogc nothrow;
    c_long fromfpl(real, int, uint) @nogc nothrow;
    c_long __fromfpl(real, int, uint) @nogc nothrow;
    c_long __fromfpf64(double, int, uint) @nogc nothrow;
    c_long fromfpf64(double, int, uint) @nogc nothrow;
    c_long __fromfpf(float, int, uint) @nogc nothrow;
    c_long __fromfpf64x(real, int, uint) @nogc nothrow;
    c_long fromfpf64x(real, int, uint) @nogc nothrow;
    c_long fromfpf(float, int, uint) @nogc nothrow;
    c_long __fromfpf32x(double, int, uint) @nogc nothrow;
    c_long __fromfp(double, int, uint) @nogc nothrow;
    c_long fromfp(double, int, uint) @nogc nothrow;
    c_long fromfpf32(float, int, uint) @nogc nothrow;
    c_long __fromfpf32(float, int, uint) @nogc nothrow;
    c_ulong ufromfpf(float, int, uint) @nogc nothrow;
    c_ulong __ufromfpf32x(double, int, uint) @nogc nothrow;
    c_ulong __ufromfpf(float, int, uint) @nogc nothrow;
    c_ulong ufromfpl(real, int, uint) @nogc nothrow;
    c_ulong __ufromfpf32(float, int, uint) @nogc nothrow;
    c_ulong __ufromfp(double, int, uint) @nogc nothrow;
    c_ulong ufromfp(double, int, uint) @nogc nothrow;
    c_ulong ufromfpf32x(double, int, uint) @nogc nothrow;
    c_ulong __ufromfpl(real, int, uint) @nogc nothrow;
    c_ulong ufromfpf64(double, int, uint) @nogc nothrow;
    c_ulong __ufromfpf64(double, int, uint) @nogc nothrow;
    c_ulong ufromfpf32(float, int, uint) @nogc nothrow;
    c_ulong __ufromfpf64x(real, int, uint) @nogc nothrow;
    c_ulong ufromfpf64x(real, int, uint) @nogc nothrow;
    c_long fromfpxf64(double, int, uint) @nogc nothrow;
    c_long __fromfpxf64(double, int, uint) @nogc nothrow;
    c_long __fromfpxl(real, int, uint) @nogc nothrow;
    c_long fromfpxf(float, int, uint) @nogc nothrow;
    c_long __fromfpxf32x(double, int, uint) @nogc nothrow;
    c_long __fromfpx(double, int, uint) @nogc nothrow;
    c_long __fromfpxf(float, int, uint) @nogc nothrow;
    c_long fromfpxl(real, int, uint) @nogc nothrow;
    c_long fromfpx(double, int, uint) @nogc nothrow;
    c_long __fromfpxf32(float, int, uint) @nogc nothrow;
    c_long fromfpxf32(float, int, uint) @nogc nothrow;
    c_long __fromfpxf64x(real, int, uint) @nogc nothrow;
    c_long fromfpxf64x(real, int, uint) @nogc nothrow;
    c_long fromfpxf32x(double, int, uint) @nogc nothrow;
    c_ulong ufromfpx(double, int, uint) @nogc nothrow;
    c_ulong ufromfpxl(real, int, uint) @nogc nothrow;
    c_ulong __ufromfpxf(float, int, uint) @nogc nothrow;
    c_ulong __ufromfpxf32(float, int, uint) @nogc nothrow;
    c_ulong ufromfpxf32(float, int, uint) @nogc nothrow;
    c_ulong __ufromfpxl(real, int, uint) @nogc nothrow;
    c_ulong __ufromfpx(double, int, uint) @nogc nothrow;
    c_ulong __ufromfpxf64x(real, int, uint) @nogc nothrow;
    c_ulong ufromfpxf(float, int, uint) @nogc nothrow;
    c_ulong ufromfpxf64x(real, int, uint) @nogc nothrow;
    c_ulong __ufromfpxf64(double, int, uint) @nogc nothrow;
    c_ulong ufromfpxf64(double, int, uint) @nogc nothrow;
    c_ulong ufromfpxf32x(double, int, uint) @nogc nothrow;
    c_ulong __ufromfpxf32x(double, int, uint) @nogc nothrow;
    real __fmaxmagl(real, real) @nogc nothrow;
    float __fmaxmagf32(float, float) @nogc nothrow;
    float fmaxmagf32(float, float) @nogc nothrow;
    double __fmaxmagf64(double, double) @nogc nothrow;
    double fmaxmagf64(double, double) @nogc nothrow;
    double fmaxmagf32x(double, double) @nogc nothrow;
    double __fmaxmagf32x(double, double) @nogc nothrow;
    real __fmaxmagf64x(real, real) @nogc nothrow;
    double fmaxmag(double, double) @nogc nothrow;
    double __fmaxmag(double, double) @nogc nothrow;
    real fmaxmagl(real, real) @nogc nothrow;
    real fmaxmagf64x(real, real) @nogc nothrow;
    float __fmaxmagf(float, float) @nogc nothrow;
    float fmaxmagf(float, float) @nogc nothrow;
    float __fminmagf(float, float) @nogc nothrow;
    real fminmagf64x(real, real) @nogc nothrow;
    real __fminmagf64x(real, real) @nogc nothrow;
    float fminmagf32(float, float) @nogc nothrow;
    double fminmagf64(double, double) @nogc nothrow;
    real fminmagl(real, real) @nogc nothrow;
    real __fminmagl(real, real) @nogc nothrow;
    double __fminmagf64(double, double) @nogc nothrow;
    double fminmagf32x(double, double) @nogc nothrow;
    double __fminmagf32x(double, double) @nogc nothrow;
    float __fminmagf32(float, float) @nogc nothrow;
    double fminmag(double, double) @nogc nothrow;
    double __fminmag(double, double) @nogc nothrow;
    float fminmagf(float, float) @nogc nothrow;
    int totalorder(double, double) @nogc nothrow;
    int totalorderf(float, float) @nogc nothrow;
    int totalorderf32(float, float) @nogc nothrow;
    int totalorderf64x(real, real) @nogc nothrow;
    int totalorderf64(double, double) @nogc nothrow;
    int totalorderf32x(double, double) @nogc nothrow;
    int totalorderl(real, real) @nogc nothrow;
    int totalordermagf32x(double, double) @nogc nothrow;
    int totalordermagf64(double, double) @nogc nothrow;
    int totalordermag(double, double) @nogc nothrow;
    int totalordermagf(float, float) @nogc nothrow;
    int totalordermagl(real, real) @nogc nothrow;
    int totalordermagf64x(real, real) @nogc nothrow;
    int totalordermagf32(float, float) @nogc nothrow;
    int canonicalize(double*, const(double)*) @nogc nothrow;
    int canonicalizef64x(real*, const(real)*) @nogc nothrow;
    int canonicalizel(real*, const(real)*) @nogc nothrow;
    int canonicalizef32x(double*, const(double)*) @nogc nothrow;
    int canonicalizef64(double*, const(double)*) @nogc nothrow;
    int canonicalizef32(float*, const(float)*) @nogc nothrow;
    int canonicalizef(float*, const(float)*) @nogc nothrow;
    float __getpayloadf(const(float)*) @nogc nothrow;
    float getpayloadf(const(float)*) @nogc nothrow;
    double getpayload(const(double)*) @nogc nothrow;
    double __getpayload(const(double)*) @nogc nothrow;
    float __getpayloadf32(const(float)*) @nogc nothrow;
    float getpayloadf32(const(float)*) @nogc nothrow;
    double getpayloadf64(const(double)*) @nogc nothrow;
    double __getpayloadf64(const(double)*) @nogc nothrow;
    double getpayloadf32x(const(double)*) @nogc nothrow;
    double __getpayloadf32x(const(double)*) @nogc nothrow;
    real __getpayloadl(const(real)*) @nogc nothrow;
    real getpayloadl(const(real)*) @nogc nothrow;
    real __getpayloadf64x(const(real)*) @nogc nothrow;
    real getpayloadf64x(const(real)*) @nogc nothrow;
    int setpayloadf32x(double*, double) @nogc nothrow;
    int setpayloadf(float*, float) @nogc nothrow;
    int setpayloadf64x(real*, real) @nogc nothrow;
    int setpayloadl(real*, real) @nogc nothrow;
    int setpayload(double*, double) @nogc nothrow;
    int setpayloadf64(double*, double) @nogc nothrow;
    int setpayloadf32(float*, float) @nogc nothrow;
    int setpayloadsig(double*, double) @nogc nothrow;
    int setpayloadsigf32(float*, float) @nogc nothrow;
    int setpayloadsigf(float*, float) @nogc nothrow;
    int setpayloadsigf64(double*, double) @nogc nothrow;
    int setpayloadsigf32x(double*, double) @nogc nothrow;
    int setpayloadsigf64x(real*, real) @nogc nothrow;
    int setpayloadsigl(real*, real) @nogc nothrow;
    float scalbf(float, float) @nogc nothrow;
    double __scalb(double, double) @nogc nothrow;
    double scalb(double, double) @nogc nothrow;
    real scalbl(real, real) @nogc nothrow;
    real __scalbl(real, real) @nogc nothrow;
    float __scalbf(float, float) @nogc nothrow;
    alias suseconds_t = c_long;
    alias useconds_t = uint;
    alias key_t = int;
    alias caddr_t = char*;
    alias daddr_t = int;
    alias id_t = uint;
    alias pid_t = int;
    alias uid_t = uint;
    alias nlink_t = c_ulong;
    alias mode_t = uint;
    alias gid_t = uint;
    alias dev_t = c_ulong;
    alias ino64_t = c_ulong;
    alias ino_t = c_ulong;
    alias loff_t = c_long;
    alias fsid_t = __fsid_t;
    alias u_quad_t = c_ulong;
    alias quad_t = c_long;
    alias u_long = c_ulong;
    alias u_int = uint;
    alias u_short = ushort;
    alias u_char = ubyte;
    int futimesat(int, const(char)*, const(timeval)*) @nogc nothrow;
    int futimes(int, const(timeval)*) @nogc nothrow;
    int lutimes(const(char)*, const(timeval)*) @nogc nothrow;
    int utimes(const(char)*, const(timeval)*) @nogc nothrow;
    int setitimer(__itimer_which, const(itimerval)*, itimerval*) @nogc nothrow;
    int getitimer(__itimer_which, itimerval*) @nogc nothrow;
    alias __itimer_which_t = __itimer_which;
    struct itimerval
    {
        timeval it_interval;
        timeval it_value;
    }
    enum __itimer_which
    {
        ITIMER_REAL = 0,
        ITIMER_VIRTUAL = 1,
        ITIMER_PROF = 2,
    }
    enum ITIMER_REAL = __itimer_which.ITIMER_REAL;
    enum ITIMER_VIRTUAL = __itimer_which.ITIMER_VIRTUAL;
    enum ITIMER_PROF = __itimer_which.ITIMER_PROF;
    int adjtime(const(timeval)*, timeval*) @nogc nothrow;
    int settimeofday(const(timeval)*, const(timezone)*) @nogc nothrow;
    int gettimeofday(timeval*, timezone*) @nogc nothrow;
    alias __timezone_ptr_t = timezone*;
    struct timezone
    {
        int tz_minuteswest;
        int tz_dsttime;
    }
    int __xmknodat(int, int, const(char)*, uint, c_ulong*) @nogc nothrow;
    int __xmknod(int, const(char)*, uint, c_ulong*) @nogc nothrow;
    int __fxstatat64(int, int, const(char)*, stat64*, int) @nogc nothrow;
    int __lxstat64(int, const(char)*, stat64*) @nogc nothrow;
    int __xstat64(int, const(char)*, stat64*) @nogc nothrow;
    int __fxstat64(int, int, stat64*) @nogc nothrow;
    int __fxstatat(int, int, const(char)*, stat*, int) @nogc nothrow;
    int __lxstat(int, const(char)*, stat*) @nogc nothrow;
    int __xstat(int, const(char)*, stat*) @nogc nothrow;
    int __fxstat(int, int, stat*) @nogc nothrow;
    int futimens(int, const(timespec)*) @nogc nothrow;
    struct __pthread_rwlock_arch_t
    {
        uint __readers;
        uint __writers;
        uint __wrphase_futex;
        uint __writers_futex;
        uint __pad3;
        uint __pad4;
        int __cur_writer;
        int __shared;
        byte __rwelision;
        ubyte[7] __pad1;
        c_ulong __pad2;
        uint __flags;
    }
    int utimensat(int, const(char)*, const(timespec)*, int) @nogc nothrow;
    alias pthread_t = c_ulong;
    union pthread_mutexattr_t
    {
        char[4] __size;
        int __align;
    }
    union pthread_condattr_t
    {
        char[4] __size;
        int __align;
    }
    alias pthread_key_t = uint;
    alias pthread_once_t = int;
    union pthread_attr_t
    {
        char[56] __size;
        c_long __align;
    }
    union pthread_mutex_t
    {
        __pthread_mutex_s __data;
        char[40] __size;
        c_long __align;
    }
    union pthread_cond_t
    {
        __pthread_cond_s __data;
        char[48] __size;
        long __align;
    }
    union pthread_rwlock_t
    {
        __pthread_rwlock_arch_t __data;
        char[56] __size;
        c_long __align;
    }
    union pthread_rwlockattr_t
    {
        char[8] __size;
        c_long __align;
    }
    alias pthread_spinlock_t = int;
    union pthread_barrier_t
    {
        char[32] __size;
        c_long __align;
    }
    union pthread_barrierattr_t
    {
        char[4] __size;
        int __align;
    }
    int mkfifoat(int, const(char)*, uint) @nogc nothrow;
    int mkfifo(const(char)*, uint) @nogc nothrow;
    int mknodat(int, const(char)*, uint, c_ulong) @nogc nothrow;
    int mknod(const(char)*, uint, c_ulong) @nogc nothrow;
    int mkdirat(int, const(char)*, uint) @nogc nothrow;
    int mkdir(const(char)*, uint) @nogc nothrow;
    uint getumask() @nogc nothrow;
    uint umask(uint) @nogc nothrow;
    int fchmodat(int, const(char)*, uint, int) @nogc nothrow;
    int fchmod(int, uint) @nogc nothrow;
    int clone(int function(void*), void*, int, void*, ...) @nogc nothrow;
    int unshare(int) @nogc nothrow;
    int sched_getcpu() @nogc nothrow;
    int setns(int, int) @nogc nothrow;
    int lchmod(const(char)*, uint) @nogc nothrow;
    alias __jmp_buf = c_long[8];
    int chmod(const(char)*, uint) @nogc nothrow;
    struct stat
    {
        c_ulong st_dev;
        c_ulong st_ino;
        c_ulong st_nlink;
        uint st_mode;
        uint st_uid;
        uint st_gid;
        int __pad0;
        c_ulong st_rdev;
        c_long st_size;
        c_long st_blksize;
        c_long st_blocks;
        timespec st_atim;
        timespec st_mtim;
        timespec st_ctim;
        c_long[3] __glibc_reserved;
    }
    int lstat64(const(char)*, stat64*) @nogc nothrow;
    struct stat64
    {
        c_ulong st_dev;
        c_ulong st_ino;
        c_ulong st_nlink;
        uint st_mode;
        uint st_uid;
        uint st_gid;
        int __pad0;
        c_ulong st_rdev;
        c_long st_size;
        c_long st_blksize;
        c_long st_blocks;
        timespec st_atim;
        timespec st_mtim;
        timespec st_ctim;
        c_long[3] __glibc_reserved;
    }
    int lstat(const(char)*, stat*) @nogc nothrow;
    int fstatat64(int, const(char)*, stat64*, int) @nogc nothrow;
    int fstatat(int, const(char)*, stat*, int) @nogc nothrow;
    int fstat64(int, stat64*) @nogc nothrow;
    pragma(mangle, "stat64") int stat64_(const(char)*, stat64*) @nogc nothrow;
    struct statx_timestamp
    {
        c_long tv_sec;
        uint tv_nsec;
        int[1] __statx_timestamp_pad1;
    }
    struct statx
    {
        uint stx_mask;
        uint stx_blksize;
        c_ulong stx_attributes;
        uint stx_nlink;
        uint stx_uid;
        uint stx_gid;
        ushort stx_mode;
        ushort[1] __statx_pad1;
        c_ulong stx_ino;
        c_ulong stx_size;
        c_ulong stx_blocks;
        c_ulong stx_attributes_mask;
        statx_timestamp stx_atime;
        statx_timestamp stx_btime;
        statx_timestamp stx_ctime;
        statx_timestamp stx_mtime;
        uint stx_rdev_major;
        uint stx_rdev_minor;
        uint stx_dev_major;
        uint stx_dev_minor;
        c_ulong[14] __statx_pad2;
    }
    int fstat(int, stat*) @nogc nothrow;
    pragma(mangle, "stat64") int stat_(const(char)*, stat*) @nogc nothrow;
    pragma(mangle, "statx") int statx_(int, const(char)*, int, uint, statx*) @nogc nothrow;
    alias int8_t = byte;
    alias int16_t = short;
    alias int32_t = int;
    alias int64_t = c_long;
    alias uint8_t = ubyte;
    alias uint16_t = ushort;
    alias uint32_t = uint;
    alias uint64_t = ulong;
    extern __gshared int sys_nerr;
    extern __gshared const(const(char)*)[0] sys_errlist;
    extern __gshared int _sys_nerr;
    extern __gshared const(const(char)*)[0] _sys_errlist;
    alias __pthread_list_t = __pthread_internal_list;
    struct __pthread_internal_list
    {
        __pthread_internal_list* __prev;
        __pthread_internal_list* __next;
    }
    struct __pthread_mutex_s
    {
        int __lock;
        uint __count;
        int __owner;
        uint __nusers;
        int __kind;
        short __spins;
        short __elision;
        __pthread_internal_list __list;
    }
    struct __pthread_cond_s
    {
        static union _Anonymous_3
        {
            ulong __wseq;
            static struct _Anonymous_4
            {
                uint __low;
                uint __high;
            }
            _Anonymous_4 __wseq32;
        }
        _Anonymous_3 _anonymous_5;
        auto __wseq() @property @nogc pure nothrow { return _anonymous_5.__wseq; }
        void __wseq(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_5.__wseq = val; }
        auto __wseq32() @property @nogc pure nothrow { return _anonymous_5.__wseq32; }
        void __wseq32(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_5.__wseq32 = val; }
        static union _Anonymous_6
        {
            ulong __g1_start;
            static struct _Anonymous_7
            {
                uint __low;
                uint __high;
            }
            _Anonymous_7 __g1_start32;
        }
        _Anonymous_6 _anonymous_8;
        auto __g1_start() @property @nogc pure nothrow { return _anonymous_8.__g1_start; }
        void __g1_start(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_8.__g1_start = val; }
        auto __g1_start32() @property @nogc pure nothrow { return _anonymous_8.__g1_start32; }
        void __g1_start32(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_8.__g1_start32 = val; }
        uint[2] __g_refs;
        uint[2] __g_size;
        uint __g1_orig_size;
        uint __wrefs;
        uint[2] __g_signals;
    }
    int clock_adjtime(int, timex*) @nogc nothrow;
    struct timex
    {
        import std.bitmanip: bitfields;

        align(4):
        uint modes;
        c_long offset;
        c_long freq;
        c_long maxerror;
        c_long esterror;
        int status;
        c_long constant;
        c_long precision;
        c_long tolerance;
        timeval time;
        c_long tick;
        c_long ppsfreq;
        c_long jitter;
        int shift;
        c_long stabil;
        c_long jitcnt;
        c_long calcnt;
        c_long errcnt;
        c_long stbcnt;
        int tai;
        mixin(bitfields!(
            int, "_anonymous_9", 32,
            int, "_anonymous_10", 32,
        ));
        mixin(bitfields!(
            int, "_anonymous_11", 32,
            int, "_anonymous_12", 32,
        ));
        mixin(bitfields!(
            int, "_anonymous_13", 32,
            int, "_anonymous_14", 32,
        ));
        mixin(bitfields!(
            int, "_anonymous_15", 32,
            int, "_anonymous_16", 32,
        ));
        mixin(bitfields!(
            int, "_anonymous_17", 32,
            int, "_anonymous_18", 32,
        ));
        mixin(bitfields!(
            int, "_anonymous_19", 32,
        ));
    }
    int pselect(int, fd_set*, fd_set*, fd_set*, const(timespec)*, const(__sigset_t)*) @nogc nothrow;
    int select(int, fd_set*, fd_set*, fd_set*, timeval*) @nogc nothrow;
    alias fd_mask = c_long;
    struct fd_set
    {
        c_long[16] fds_bits;
    }
    alias __fd_mask = c_long;
    alias __u_char = ubyte;
    alias __u_short = ushort;
    alias __u_int = uint;
    alias __u_long = c_ulong;
    alias __int8_t = byte;
    alias __uint8_t = ubyte;
    alias __int16_t = short;
    alias __uint16_t = ushort;
    alias __int32_t = int;
    alias __uint32_t = uint;
    alias __int64_t = c_long;
    alias __uint64_t = c_ulong;
    alias __int_least8_t = byte;
    alias __uint_least8_t = ubyte;
    alias __int_least16_t = short;
    alias __uint_least16_t = ushort;
    alias __int_least32_t = int;
    alias __uint_least32_t = uint;
    alias __int_least64_t = c_long;
    alias __uint_least64_t = c_ulong;
    alias __quad_t = c_long;
    alias __u_quad_t = c_ulong;
    alias __intmax_t = c_long;
    alias __uintmax_t = c_ulong;
    alias __dev_t = c_ulong;
    alias __uid_t = uint;
    alias __gid_t = uint;
    alias __ino_t = c_ulong;
    alias __ino64_t = c_ulong;
    alias __mode_t = uint;
    alias __nlink_t = c_ulong;
    alias __off_t = c_long;
    alias __off64_t = c_long;
    alias __pid_t = int;
    struct __fsid_t
    {
        int[2] __val;
    }
    alias __clock_t = c_long;
    alias __rlim_t = c_ulong;
    alias __rlim64_t = c_ulong;
    alias __id_t = uint;
    alias __time_t = c_long;
    alias __useconds_t = uint;
    alias __suseconds_t = c_long;
    alias __daddr_t = int;
    alias __key_t = int;
    alias __clockid_t = int;
    alias __timer_t = void*;
    alias __blksize_t = c_long;
    alias __blkcnt_t = c_long;
    alias __blkcnt64_t = c_long;
    alias __fsblkcnt_t = c_ulong;
    alias __fsblkcnt64_t = c_ulong;
    alias __fsfilcnt_t = c_ulong;
    alias __fsfilcnt64_t = c_ulong;
    alias __fsword_t = c_long;
    alias __ssize_t = c_long;
    alias __syscall_slong_t = c_long;
    alias __syscall_ulong_t = c_ulong;
    alias __loff_t = c_long;
    alias __caddr_t = char*;
    alias __intptr_t = c_long;
    alias __socklen_t = uint;
    alias __sig_atomic_t = int;
    alias FILE = _IO_FILE;
    struct _IO_FILE
    {
        int _flags;
        char* _IO_read_ptr;
        char* _IO_read_end;
        char* _IO_read_base;
        char* _IO_write_base;
        char* _IO_write_ptr;
        char* _IO_write_end;
        char* _IO_buf_base;
        char* _IO_buf_end;
        char* _IO_save_base;
        char* _IO_backup_base;
        char* _IO_save_end;
        _IO_marker* _markers;
        _IO_FILE* _chain;
        int _fileno;
        int _flags2;
        c_long _old_offset;
        ushort _cur_column;
        byte _vtable_offset;
        char[1] _shortbuf;
        void* _lock;
        c_long _offset;
        _IO_codecvt* _codecvt;
        _IO_wide_data* _wide_data;
        _IO_FILE* _freeres_list;
        void* _freeres_buf;
        c_ulong __pad5;
        int _mode;
        char[20] _unused2;
    }
    alias __FILE = _IO_FILE;
    alias __fpos64_t = _G_fpos64_t;
    struct _G_fpos64_t
    {
        c_long __pos;
        __mbstate_t __state;
    }
    alias __fpos_t = _G_fpos_t;
    struct _G_fpos_t
    {
        c_long __pos;
        __mbstate_t __state;
    }
    struct __locale_struct
    {
        __locale_data*[13] __locales;
        const(ushort)* __ctype_b;
        const(int)* __ctype_tolower;
        const(int)* __ctype_toupper;
        const(char)*[13] __names;
    }
    alias __locale_t = __locale_struct*;
    struct __mbstate_t
    {
        int __count;
        static union _Anonymous_20
        {
            uint __wch;
            char[4] __wchb;
        }
        _Anonymous_20 __value;
    }
    struct __sigset_t
    {
        c_ulong[16] __val;
    }
    alias clock_t = c_long;
    alias clockid_t = int;
    alias cookie_read_function_t = c_long function(void*, char*, c_ulong);
    alias cookie_write_function_t = c_long function(void*, const(char)*, c_ulong);
    alias cookie_seek_function_t = int function(void*, c_long*, int);
    alias cookie_close_function_t = int function(void*);
    alias cookie_io_functions_t = _IO_cookie_io_functions_t;
    struct _IO_cookie_io_functions_t
    {
        c_long function(void*, char*, c_ulong) read;
        c_long function(void*, const(char)*, c_ulong) write;
        int function(void*, c_long*, int) seek;
        int function(void*) close;
    }
    alias error_t = int;
    alias locale_t = __locale_struct*;
    alias mbstate_t = __mbstate_t;
    alias sigset_t = __sigset_t;
    struct _IO_marker;
    struct _IO_codecvt;
    struct _IO_wide_data;
    alias _IO_lock_t = void;
    struct itimerspec
    {
        timespec it_interval;
        timespec it_value;
    }
    struct sched_param
    {
        int sched_priority;
    }
    struct timespec
    {
        c_long tv_sec;
        c_long tv_nsec;
    }
    struct timeval
    {
        c_long tv_sec;
        c_long tv_usec;
    }
    struct tm
    {
        int tm_sec;
        int tm_min;
        int tm_hour;
        int tm_mday;
        int tm_mon;
        int tm_year;
        int tm_wday;
        int tm_yday;
        int tm_isdst;
        c_long tm_gmtoff;
        const(char)* tm_zone;
    }
    alias time_t = c_long;
    alias timer_t = void*;
    int strncasecmp_l(const(char)*, const(char)*, c_ulong, __locale_struct*) @nogc nothrow;
    alias wint_t = uint;
    int strcasecmp_l(const(char)*, const(char)*, __locale_struct*) @nogc nothrow;
    int strncasecmp(const(char)*, const(char)*, c_ulong) @nogc nothrow;
    int strcasecmp(const(char)*, const(char)*) @nogc nothrow;
    int ffsll(long) @nogc nothrow;
    int ffsl(c_long) @nogc nothrow;
    int ffs(int) @nogc nothrow;
    char* rindex(const(char)*, int) @nogc nothrow;
    char* index(const(char)*, int) @nogc nothrow;
    void bzero(void*, c_ulong) @nogc nothrow;
    static ushort __uint16_identity(ushort) @nogc nothrow;
    static uint __uint32_identity(uint) @nogc nothrow;
    static c_ulong __uint64_identity(c_ulong) @nogc nothrow;
    void bcopy(const(void)*, void*, c_ulong) @nogc nothrow;
    int bcmp(const(void)*, const(void)*, c_ulong) @nogc nothrow;
    char* basename(const(char)*) @nogc nothrow;
    void* memfrob(void*, c_ulong) @nogc nothrow;
    char* strfry(char*) @nogc nothrow;
    int strverscmp(const(char)*, const(char)*) @nogc nothrow;
    char* stpncpy(char*, const(char)*, c_ulong) @nogc nothrow;
    char* __stpncpy(char*, const(char)*, c_ulong) @nogc nothrow;
    char* stpcpy(char*, const(char)*) @nogc nothrow;
    char* __stpcpy(char*, const(char)*) @nogc nothrow;
    char* strsignal(int) @nogc nothrow;
    char* strsep(char**, const(char)*) @nogc nothrow;
    void explicit_bzero(void*, c_ulong) @nogc nothrow;
    char* strerror_l(int, __locale_struct*) @nogc nothrow;
    char* strerror_r(int, char*, c_ulong) @nogc nothrow;
    char* strerror(int) @nogc nothrow;
    struct crypt_data
    {
        char[128] keysched;
        char[32768] sb0;
        char[32768] sb1;
        char[32768] sb2;
        char[32768] sb3;
        char[14] crypt_3_buf;
        char[2] current_salt;
        c_long current_saltbits;
        int direction;
        int initialized;
    }
    char* crypt_r(const(char)*, const(char)*, crypt_data*) @nogc nothrow;
    c_ulong strnlen(const(char)*, c_ulong) @nogc nothrow;
    enum _Anonymous_21
    {
        _ISupper = 256,
        _ISlower = 512,
        _ISalpha = 1024,
        _ISdigit = 2048,
        _ISxdigit = 4096,
        _ISspace = 8192,
        _ISprint = 16384,
        _ISgraph = 32768,
        _ISblank = 1,
        _IScntrl = 2,
        _ISpunct = 4,
        _ISalnum = 8,
    }
    enum _ISupper = _Anonymous_21._ISupper;
    enum _ISlower = _Anonymous_21._ISlower;
    enum _ISalpha = _Anonymous_21._ISalpha;
    enum _ISdigit = _Anonymous_21._ISdigit;
    enum _ISxdigit = _Anonymous_21._ISxdigit;
    enum _ISspace = _Anonymous_21._ISspace;
    enum _ISprint = _Anonymous_21._ISprint;
    enum _ISgraph = _Anonymous_21._ISgraph;
    enum _ISblank = _Anonymous_21._ISblank;
    enum _IScntrl = _Anonymous_21._IScntrl;
    enum _ISpunct = _Anonymous_21._ISpunct;
    enum _ISalnum = _Anonymous_21._ISalnum;
    const(ushort)** __ctype_b_loc() @nogc nothrow;
    const(int)** __ctype_tolower_loc() @nogc nothrow;
    const(int)** __ctype_toupper_loc() @nogc nothrow;
    pragma(mangle, "isalnum") int isalnum_(int) @nogc nothrow;
    pragma(mangle, "isalpha") int isalpha_(int) @nogc nothrow;
    pragma(mangle, "iscntrl") int iscntrl_(int) @nogc nothrow;
    pragma(mangle, "isdigit") int isdigit_(int) @nogc nothrow;
    pragma(mangle, "islower") int islower_(int) @nogc nothrow;
    pragma(mangle, "isgraph") int isgraph_(int) @nogc nothrow;
    pragma(mangle, "isprint") int isprint_(int) @nogc nothrow;
    pragma(mangle, "ispunct") int ispunct_(int) @nogc nothrow;
    pragma(mangle, "isspace") int isspace_(int) @nogc nothrow;
    pragma(mangle, "isupper") int isupper_(int) @nogc nothrow;
    pragma(mangle, "isxdigit") int isxdigit_(int) @nogc nothrow;
    int tolower(int) @nogc nothrow;
    int toupper(int) @nogc nothrow;
    pragma(mangle, "isblank") int isblank_(int) @nogc nothrow;
    int isctype(int, int) @nogc nothrow;
    pragma(mangle, "isascii") int isascii_(int) @nogc nothrow;
    pragma(mangle, "toascii") int toascii_(int) @nogc nothrow;
    pragma(mangle, "_toupper") int _toupper_(int) @nogc nothrow;
    pragma(mangle, "_tolower") int _tolower_(int) @nogc nothrow;
    c_ulong strlen(const(char)*) @nogc nothrow;
    void* mempcpy(void*, const(void)*, c_ulong) @nogc nothrow;
    void* __mempcpy(void*, const(void)*, c_ulong) @nogc nothrow;
    void* memmem(const(void)*, c_ulong, const(void)*, c_ulong) @nogc nothrow;
    char* strcasestr(const(char)*, const(char)*) @nogc nothrow;
    pragma(mangle, "isalnum_l") int isalnum_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isalpha_l") int isalpha_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "iscntrl_l") int iscntrl_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isdigit_l") int isdigit_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "islower_l") int islower_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isgraph_l") int isgraph_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isprint_l") int isprint_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "ispunct_l") int ispunct_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isspace_l") int isspace_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isupper_l") int isupper_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isxdigit_l") int isxdigit_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isblank_l") int isblank_l_(int, __locale_struct*) @nogc nothrow;
    int __tolower_l(int, __locale_struct*) @nogc nothrow;
    int tolower_l(int, __locale_struct*) @nogc nothrow;
    int __toupper_l(int, __locale_struct*) @nogc nothrow;
    int toupper_l(int, __locale_struct*) @nogc nothrow;
    char* strtok_r(char*, const(char)*, char**) @nogc nothrow;
    char* __strtok_r(char*, const(char)*, char**) @nogc nothrow;
    char* strtok(char*, const(char)*) @nogc nothrow;
    char* strstr(const(char)*, const(char)*) @nogc nothrow;
    char* strpbrk(const(char)*, const(char)*) @nogc nothrow;
    c_ulong strspn(const(char)*, const(char)*) @nogc nothrow;
    c_ulong strcspn(const(char)*, const(char)*) @nogc nothrow;
    char* strchrnul(const(char)*, int) @nogc nothrow;
    char* strrchr(const(char)*, int) @nogc nothrow;
    char* strchr(const(char)*, int) @nogc nothrow;
    char* strndup(const(char)*, c_ulong) @nogc nothrow;
    char* strdup(const(char)*) @nogc nothrow;
    int* __errno_location() @nogc nothrow;
    extern __gshared char* program_invocation_name;
    extern __gshared char* program_invocation_short_name;
    c_ulong strxfrm_l(char*, const(char)*, c_ulong, __locale_struct*) @nogc nothrow;
    int strcoll_l(const(char)*, const(char)*, __locale_struct*) @nogc nothrow;
    c_ulong strxfrm(char*, const(char)*, c_ulong) @nogc nothrow;
    int strcoll(const(char)*, const(char)*) @nogc nothrow;
    int strncmp(const(char)*, const(char)*, c_ulong) @nogc nothrow;
    int strcmp(const(char)*, const(char)*) @nogc nothrow;
    char* strncat(char*, const(char)*, c_ulong) @nogc nothrow;
    char* strcat(char*, const(char)*) @nogc nothrow;
    char* strncpy(char*, const(char)*, c_ulong) @nogc nothrow;
    char* strcpy(char*, const(char)*) @nogc nothrow;
    void* memrchr(const(void)*, int, c_ulong) @nogc nothrow;
    void* rawmemchr(const(void)*, int) @nogc nothrow;
    void* memchr(const(void)*, int, c_ulong) @nogc nothrow;
    int memcmp(const(void)*, const(void)*, c_ulong) @nogc nothrow;
    void* memset(void*, int, c_ulong) @nogc nothrow;
    void* memccpy(void*, const(void)*, int, c_ulong) @nogc nothrow;
    void* memmove(void*, const(void)*, c_ulong) @nogc nothrow;
    void* memcpy(void*, const(void)*, c_ulong) @nogc nothrow;
    alias __gwchar_t = int;
    int getloadavg(double*, int) @nogc nothrow;
    int getpt() @nogc nothrow;
    int ptsname_r(int, char*, c_ulong) @nogc nothrow;
    char* ptsname(int) @nogc nothrow;
    int unlockpt(int) @nogc nothrow;
    int grantpt(int) @nogc nothrow;
    int posix_openpt(int) @nogc nothrow;
    int getsubopt(char**, char**, char**) @nogc nothrow;
    int rpmatch(const(char)*) @nogc nothrow;
    c_ulong wcstombs(char*, const(int)*, c_ulong) @nogc nothrow;
    c_ulong mbstowcs(int*, const(char)*, c_ulong) @nogc nothrow;
    int wctomb(char*, int) @nogc nothrow;
    int mbtowc(int*, const(char)*, c_ulong) @nogc nothrow;
    int mblen(const(char)*, c_ulong) @nogc nothrow;
    int qfcvt_r(real, int, int*, int*, char*, c_ulong) @nogc nothrow;
    int qecvt_r(real, int, int*, int*, char*, c_ulong) @nogc nothrow;
    int fcvt_r(double, int, int*, int*, char*, c_ulong) @nogc nothrow;
    int ecvt_r(double, int, int*, int*, char*, c_ulong) @nogc nothrow;
    char* qgcvt(real, int, char*) @nogc nothrow;
    char* qfcvt(real, int, int*, int*) @nogc nothrow;
    char* qecvt(real, int, int*, int*) @nogc nothrow;
    char* gcvt(double, int, char*) @nogc nothrow;
    char* fcvt(double, int, int*, int*) @nogc nothrow;
    char* ecvt(double, int, int*, int*) @nogc nothrow;
    lldiv_t lldiv(long, long) @nogc nothrow;
    ldiv_t ldiv(c_long, c_long) @nogc nothrow;
    div_t div(int, int) @nogc nothrow;
    long llabs(long) @nogc nothrow;
    c_long labs(c_long) @nogc nothrow;
    int abs(int) @nogc nothrow;
    void qsort_r(void*, c_ulong, c_ulong, int function(const(void)*, const(void)*, void*), void*) @nogc nothrow;
    void qsort(void*, c_ulong, c_ulong, int function(const(void)*, const(void)*)) @nogc nothrow;
    void* bsearch(const(void)*, const(void)*, c_ulong, c_ulong, int function(const(void)*, const(void)*)) @nogc nothrow;
    alias __compar_d_fn_t = int function(const(void)*, const(void)*, void*);
    alias comparison_fn_t = int function();
    alias __compar_fn_t = int function(const(void)*, const(void)*);
    char* realpath(const(char)*, char*) @nogc nothrow;
    char* canonicalize_file_name(const(char)*) @nogc nothrow;
    int system(const(char)*) @nogc nothrow;
    int mkostemps64(char*, int, int) @nogc nothrow;
    int mkostemps(char*, int, int) @nogc nothrow;
    int mkostemp64(char*, int) @nogc nothrow;
    int mkostemp(char*, int) @nogc nothrow;
    struct imaxdiv_t
    {
        c_long quot;
        c_long rem;
    }
    c_long imaxabs(c_long) @nogc nothrow;
    imaxdiv_t imaxdiv(c_long, c_long) @nogc nothrow;
    c_long strtoimax(const(char)*, char**, int) @nogc nothrow;
    c_ulong strtoumax(const(char)*, char**, int) @nogc nothrow;
    c_long wcstoimax(const(int)*, int**, int) @nogc nothrow;
    c_ulong wcstoumax(const(int)*, int**, int) @nogc nothrow;
    char* mkdtemp(char*) @nogc nothrow;
    int mkstemps64(char*, int) @nogc nothrow;
    int mkstemps(char*, int) @nogc nothrow;
    int mkstemp64(char*) @nogc nothrow;
    int mkstemp(char*) @nogc nothrow;
    char* mktemp(char*) @nogc nothrow;
    int clearenv() @nogc nothrow;
    int unsetenv(const(char)*) @nogc nothrow;
    int setenv(const(char)*, const(char)*, int) @nogc nothrow;
    int putenv(char*) @nogc nothrow;
    alias float_t = float;
    alias double_t = double;
    char* secure_getenv(const(char)*) @nogc nothrow;
    enum _Anonymous_22
    {
        FP_INT_UPWARD = 0,
        FP_INT_DOWNWARD = 1,
        FP_INT_TOWARDZERO = 2,
        FP_INT_TONEARESTFROMZERO = 3,
        FP_INT_TONEAREST = 4,
    }
    enum FP_INT_UPWARD = _Anonymous_22.FP_INT_UPWARD;
    enum FP_INT_DOWNWARD = _Anonymous_22.FP_INT_DOWNWARD;
    enum FP_INT_TOWARDZERO = _Anonymous_22.FP_INT_TOWARDZERO;
    enum FP_INT_TONEARESTFROMZERO = _Anonymous_22.FP_INT_TONEARESTFROMZERO;
    enum FP_INT_TONEAREST = _Anonymous_22.FP_INT_TONEAREST;
    char* getenv(const(char)*) @nogc nothrow;
    void _Exit(int) @nogc nothrow;
    void quick_exit(int) @nogc nothrow;
    void exit(int) @nogc nothrow;
    int on_exit(void function(int, void*), void*) @nogc nothrow;
    int at_quick_exit(void function()) @nogc nothrow;
    int atexit(void function()) @nogc nothrow;
    void abort() @nogc nothrow;
    void* aligned_alloc(c_ulong, c_ulong) @nogc nothrow;
    int posix_memalign(void**, c_ulong, c_ulong) @nogc nothrow;
    void* valloc(c_ulong) @nogc nothrow;
    void free(void*) @nogc nothrow;
    void* reallocarray(void*, c_ulong, c_ulong) @nogc nothrow;
    void* realloc(void*, c_ulong) @nogc nothrow;
    void* calloc(c_ulong, c_ulong) @nogc nothrow;
    void* malloc(c_ulong) @nogc nothrow;
    int lcong48_r(ushort*, drand48_data*) @nogc nothrow;
    int seed48_r(ushort*, drand48_data*) @nogc nothrow;
    int srand48_r(c_long, drand48_data*) @nogc nothrow;
    int jrand48_r(ushort*, drand48_data*, c_long*) @nogc nothrow;
    extern __gshared int signgam;
    enum _Anonymous_23
    {
        FP_NAN = 0,
        FP_INFINITE = 1,
        FP_ZERO = 2,
        FP_SUBNORMAL = 3,
        FP_NORMAL = 4,
    }
    enum FP_NAN = _Anonymous_23.FP_NAN;
    enum FP_INFINITE = _Anonymous_23.FP_INFINITE;
    enum FP_ZERO = _Anonymous_23.FP_ZERO;
    enum FP_SUBNORMAL = _Anonymous_23.FP_SUBNORMAL;
    enum FP_NORMAL = _Anonymous_23.FP_NORMAL;
    int mrand48_r(drand48_data*, c_long*) @nogc nothrow;
    int nrand48_r(ushort*, drand48_data*, c_long*) @nogc nothrow;
    int lrand48_r(drand48_data*, c_long*) @nogc nothrow;
    int erand48_r(ushort*, drand48_data*, double*) @nogc nothrow;
    int drand48_r(drand48_data*, double*) @nogc nothrow;
    struct drand48_data
    {
        ushort[3] __x;
        ushort[3] __old_x;
        ushort __c;
        ushort __init;
        ulong __a;
    }
    void lcong48(ushort*) @nogc nothrow;
    ushort* seed48(ushort*) @nogc nothrow;
    void srand48(c_long) @nogc nothrow;
    c_long jrand48(ushort*) @nogc nothrow;
    c_long mrand48() @nogc nothrow;
    c_long nrand48(ushort*) @nogc nothrow;
    c_long lrand48() @nogc nothrow;
    double erand48(ushort*) @nogc nothrow;
    double drand48() @nogc nothrow;
    int rand_r(uint*) @nogc nothrow;
    void srand(uint) @nogc nothrow;
    int rand() @nogc nothrow;
    int setstate_r(char*, random_data*) @nogc nothrow;
    int initstate_r(uint, char*, c_ulong, random_data*) @nogc nothrow;
    int srandom_r(uint, random_data*) @nogc nothrow;
    int random_r(random_data*, int*) @nogc nothrow;
    struct random_data
    {
        int* fptr;
        int* rptr;
        int* state;
        int rand_type;
        int rand_deg;
        int rand_sep;
        int* end_ptr;
    }
    char* setstate(char*) @nogc nothrow;
    char* initstate(uint, char*, c_ulong) @nogc nothrow;
    void srandom(uint) @nogc nothrow;
    c_long random() @nogc nothrow;
    c_long a64l(const(char)*) @nogc nothrow;
    char* l64a(c_long) @nogc nothrow;
    real strtof64x_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    double strtof32x_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    double strtof64_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    float strtof32_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    enum _Anonymous_24
    {
        PTHREAD_CREATE_JOINABLE = 0,
        PTHREAD_CREATE_DETACHED = 1,
    }
    enum PTHREAD_CREATE_JOINABLE = _Anonymous_24.PTHREAD_CREATE_JOINABLE;
    enum PTHREAD_CREATE_DETACHED = _Anonymous_24.PTHREAD_CREATE_DETACHED;
    real strtold_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    enum _Anonymous_25
    {
        PTHREAD_MUTEX_TIMED_NP = 0,
        PTHREAD_MUTEX_RECURSIVE_NP = 1,
        PTHREAD_MUTEX_ERRORCHECK_NP = 2,
        PTHREAD_MUTEX_ADAPTIVE_NP = 3,
        PTHREAD_MUTEX_NORMAL = 0,
        PTHREAD_MUTEX_RECURSIVE = 1,
        PTHREAD_MUTEX_ERRORCHECK = 2,
        PTHREAD_MUTEX_DEFAULT = 0,
        PTHREAD_MUTEX_FAST_NP = 0,
    }
    enum PTHREAD_MUTEX_TIMED_NP = _Anonymous_25.PTHREAD_MUTEX_TIMED_NP;
    enum PTHREAD_MUTEX_RECURSIVE_NP = _Anonymous_25.PTHREAD_MUTEX_RECURSIVE_NP;
    enum PTHREAD_MUTEX_ERRORCHECK_NP = _Anonymous_25.PTHREAD_MUTEX_ERRORCHECK_NP;
    enum PTHREAD_MUTEX_ADAPTIVE_NP = _Anonymous_25.PTHREAD_MUTEX_ADAPTIVE_NP;
    enum PTHREAD_MUTEX_NORMAL = _Anonymous_25.PTHREAD_MUTEX_NORMAL;
    enum PTHREAD_MUTEX_RECURSIVE = _Anonymous_25.PTHREAD_MUTEX_RECURSIVE;
    enum PTHREAD_MUTEX_ERRORCHECK = _Anonymous_25.PTHREAD_MUTEX_ERRORCHECK;
    enum PTHREAD_MUTEX_DEFAULT = _Anonymous_25.PTHREAD_MUTEX_DEFAULT;
    enum PTHREAD_MUTEX_FAST_NP = _Anonymous_25.PTHREAD_MUTEX_FAST_NP;
    enum _Anonymous_26
    {
        PTHREAD_MUTEX_STALLED = 0,
        PTHREAD_MUTEX_STALLED_NP = 0,
        PTHREAD_MUTEX_ROBUST = 1,
        PTHREAD_MUTEX_ROBUST_NP = 1,
    }
    enum PTHREAD_MUTEX_STALLED = _Anonymous_26.PTHREAD_MUTEX_STALLED;
    enum PTHREAD_MUTEX_STALLED_NP = _Anonymous_26.PTHREAD_MUTEX_STALLED_NP;
    enum PTHREAD_MUTEX_ROBUST = _Anonymous_26.PTHREAD_MUTEX_ROBUST;
    enum PTHREAD_MUTEX_ROBUST_NP = _Anonymous_26.PTHREAD_MUTEX_ROBUST_NP;
    enum _Anonymous_27
    {
        PTHREAD_PRIO_NONE = 0,
        PTHREAD_PRIO_INHERIT = 1,
        PTHREAD_PRIO_PROTECT = 2,
    }
    enum PTHREAD_PRIO_NONE = _Anonymous_27.PTHREAD_PRIO_NONE;
    enum PTHREAD_PRIO_INHERIT = _Anonymous_27.PTHREAD_PRIO_INHERIT;
    enum PTHREAD_PRIO_PROTECT = _Anonymous_27.PTHREAD_PRIO_PROTECT;
    float strtof_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    enum _Anonymous_28
    {
        PTHREAD_RWLOCK_PREFER_READER_NP = 0,
        PTHREAD_RWLOCK_PREFER_WRITER_NP = 1,
        PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP = 2,
        PTHREAD_RWLOCK_DEFAULT_NP = 0,
    }
    enum PTHREAD_RWLOCK_PREFER_READER_NP = _Anonymous_28.PTHREAD_RWLOCK_PREFER_READER_NP;
    enum PTHREAD_RWLOCK_PREFER_WRITER_NP = _Anonymous_28.PTHREAD_RWLOCK_PREFER_WRITER_NP;
    enum PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP = _Anonymous_28.PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP;
    enum PTHREAD_RWLOCK_DEFAULT_NP = _Anonymous_28.PTHREAD_RWLOCK_DEFAULT_NP;
    double strtod_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    enum _Anonymous_29
    {
        PTHREAD_INHERIT_SCHED = 0,
        PTHREAD_EXPLICIT_SCHED = 1,
    }
    enum PTHREAD_INHERIT_SCHED = _Anonymous_29.PTHREAD_INHERIT_SCHED;
    enum PTHREAD_EXPLICIT_SCHED = _Anonymous_29.PTHREAD_EXPLICIT_SCHED;
    ulong strtoull_l(const(char)*, char**, int, __locale_struct*) @nogc nothrow;
    enum _Anonymous_30
    {
        PTHREAD_SCOPE_SYSTEM = 0,
        PTHREAD_SCOPE_PROCESS = 1,
    }
    enum PTHREAD_SCOPE_SYSTEM = _Anonymous_30.PTHREAD_SCOPE_SYSTEM;
    enum PTHREAD_SCOPE_PROCESS = _Anonymous_30.PTHREAD_SCOPE_PROCESS;
    enum _Anonymous_31
    {
        PTHREAD_PROCESS_PRIVATE = 0,
        PTHREAD_PROCESS_SHARED = 1,
    }
    enum PTHREAD_PROCESS_PRIVATE = _Anonymous_31.PTHREAD_PROCESS_PRIVATE;
    enum PTHREAD_PROCESS_SHARED = _Anonymous_31.PTHREAD_PROCESS_SHARED;
    long strtoll_l(const(char)*, char**, int, __locale_struct*) @nogc nothrow;
    struct _pthread_cleanup_buffer
    {
        void function(void*) __routine;
        void* __arg;
        int __canceltype;
        _pthread_cleanup_buffer* __prev;
    }
    enum _Anonymous_32
    {
        PTHREAD_CANCEL_ENABLE = 0,
        PTHREAD_CANCEL_DISABLE = 1,
    }
    enum PTHREAD_CANCEL_ENABLE = _Anonymous_32.PTHREAD_CANCEL_ENABLE;
    enum PTHREAD_CANCEL_DISABLE = _Anonymous_32.PTHREAD_CANCEL_DISABLE;
    c_ulong strtoul_l(const(char)*, char**, int, __locale_struct*) @nogc nothrow;
    enum _Anonymous_33
    {
        PTHREAD_CANCEL_DEFERRED = 0,
        PTHREAD_CANCEL_ASYNCHRONOUS = 1,
    }
    enum PTHREAD_CANCEL_DEFERRED = _Anonymous_33.PTHREAD_CANCEL_DEFERRED;
    enum PTHREAD_CANCEL_ASYNCHRONOUS = _Anonymous_33.PTHREAD_CANCEL_ASYNCHRONOUS;
    c_long strtol_l(const(char)*, char**, int, __locale_struct*) @nogc nothrow;
    int pthread_create(c_ulong*, const(pthread_attr_t)*, void* function(void*), void*) @nogc nothrow;
    void pthread_exit(void*) @nogc nothrow;
    int pthread_join(c_ulong, void**) @nogc nothrow;
    int pthread_tryjoin_np(c_ulong, void**) @nogc nothrow;
    int pthread_timedjoin_np(c_ulong, void**, const(timespec)*) @nogc nothrow;
    int pthread_detach(c_ulong) @nogc nothrow;
    c_ulong pthread_self() @nogc nothrow;
    int pthread_equal(c_ulong, c_ulong) @nogc nothrow;
    int pthread_attr_init(pthread_attr_t*) @nogc nothrow;
    int pthread_attr_destroy(pthread_attr_t*) @nogc nothrow;
    int pthread_attr_getdetachstate(const(pthread_attr_t)*, int*) @nogc nothrow;
    int pthread_attr_setdetachstate(pthread_attr_t*, int) @nogc nothrow;
    int pthread_attr_getguardsize(const(pthread_attr_t)*, c_ulong*) @nogc nothrow;
    int pthread_attr_setguardsize(pthread_attr_t*, c_ulong) @nogc nothrow;
    int pthread_attr_getschedparam(const(pthread_attr_t)*, sched_param*) @nogc nothrow;
    int pthread_attr_setschedparam(pthread_attr_t*, const(sched_param)*) @nogc nothrow;
    int pthread_attr_getschedpolicy(const(pthread_attr_t)*, int*) @nogc nothrow;
    int pthread_attr_setschedpolicy(pthread_attr_t*, int) @nogc nothrow;
    int pthread_attr_getinheritsched(const(pthread_attr_t)*, int*) @nogc nothrow;
    int pthread_attr_setinheritsched(pthread_attr_t*, int) @nogc nothrow;
    int pthread_attr_getscope(const(pthread_attr_t)*, int*) @nogc nothrow;
    int pthread_attr_setscope(pthread_attr_t*, int) @nogc nothrow;
    int pthread_attr_getstackaddr(const(pthread_attr_t)*, void**) @nogc nothrow;
    int pthread_attr_setstackaddr(pthread_attr_t*, void*) @nogc nothrow;
    int pthread_attr_getstacksize(const(pthread_attr_t)*, c_ulong*) @nogc nothrow;
    int pthread_attr_setstacksize(pthread_attr_t*, c_ulong) @nogc nothrow;
    int pthread_attr_getstack(const(pthread_attr_t)*, void**, c_ulong*) @nogc nothrow;
    int pthread_attr_setstack(pthread_attr_t*, void*, c_ulong) @nogc nothrow;
    int pthread_attr_setaffinity_np(pthread_attr_t*, c_ulong, const(cpu_set_t)*) @nogc nothrow;
    int pthread_attr_getaffinity_np(const(pthread_attr_t)*, c_ulong, cpu_set_t*) @nogc nothrow;
    int pthread_getattr_default_np(pthread_attr_t*) @nogc nothrow;
    int pthread_setattr_default_np(const(pthread_attr_t)*) @nogc nothrow;
    int pthread_getattr_np(c_ulong, pthread_attr_t*) @nogc nothrow;
    int pthread_setschedparam(c_ulong, int, const(sched_param)*) @nogc nothrow;
    int pthread_getschedparam(c_ulong, int*, sched_param*) @nogc nothrow;
    int pthread_setschedprio(c_ulong, int) @nogc nothrow;
    int pthread_getname_np(c_ulong, char*, c_ulong) @nogc nothrow;
    int pthread_setname_np(c_ulong, const(char)*) @nogc nothrow;
    int pthread_getconcurrency() @nogc nothrow;
    int pthread_setconcurrency(int) @nogc nothrow;
    int pthread_yield() @nogc nothrow;
    int pthread_setaffinity_np(c_ulong, c_ulong, const(cpu_set_t)*) @nogc nothrow;
    int pthread_getaffinity_np(c_ulong, c_ulong, cpu_set_t*) @nogc nothrow;
    int pthread_once(int*, void function()) @nogc nothrow;
    int pthread_setcancelstate(int, int*) @nogc nothrow;
    int pthread_setcanceltype(int, int*) @nogc nothrow;
    int pthread_cancel(c_ulong) @nogc nothrow;
    void pthread_testcancel() @nogc nothrow;
    struct __pthread_unwind_buf_t
    {
        static struct _Anonymous_34
        {
            c_long[8] __cancel_jmp_buf;
            int __mask_was_saved;
        }
        _Anonymous_34[1] __cancel_jmp_buf;
        void*[4] __pad;
    }
    struct __pthread_cleanup_frame
    {
        void function(void*) __cancel_routine;
        void* __cancel_arg;
        int __do_it;
        int __cancel_type;
    }
    void __pthread_register_cancel(__pthread_unwind_buf_t*) @nogc nothrow;
    void __pthread_unregister_cancel(__pthread_unwind_buf_t*) @nogc nothrow;
    int strfromf64x(char*, c_ulong, const(char)*, real) @nogc nothrow;
    void __pthread_register_cancel_defer(__pthread_unwind_buf_t*) @nogc nothrow;
    void __pthread_unregister_cancel_restore(__pthread_unwind_buf_t*) @nogc nothrow;
    void __pthread_unwind_next(__pthread_unwind_buf_t*) @nogc nothrow;
    struct __jmp_buf_tag;
    int __sigsetjmp(__jmp_buf_tag*, int) @nogc nothrow;
    int pthread_mutex_init(pthread_mutex_t*, const(pthread_mutexattr_t)*) @nogc nothrow;
    int pthread_mutex_destroy(pthread_mutex_t*) @nogc nothrow;
    int pthread_mutex_trylock(pthread_mutex_t*) @nogc nothrow;
    int pthread_mutex_lock(pthread_mutex_t*) @nogc nothrow;
    int pthread_mutex_timedlock(pthread_mutex_t*, const(timespec)*) @nogc nothrow;
    int pthread_mutex_unlock(pthread_mutex_t*) @nogc nothrow;
    int pthread_mutex_getprioceiling(const(pthread_mutex_t)*, int*) @nogc nothrow;
    int pthread_mutex_setprioceiling(pthread_mutex_t*, int, int*) @nogc nothrow;
    int pthread_mutex_consistent(pthread_mutex_t*) @nogc nothrow;
    int pthread_mutex_consistent_np(pthread_mutex_t*) @nogc nothrow;
    int pthread_mutexattr_init(pthread_mutexattr_t*) @nogc nothrow;
    int pthread_mutexattr_destroy(pthread_mutexattr_t*) @nogc nothrow;
    int pthread_mutexattr_getpshared(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    int pthread_mutexattr_setpshared(pthread_mutexattr_t*, int) @nogc nothrow;
    int pthread_mutexattr_gettype(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    int pthread_mutexattr_settype(pthread_mutexattr_t*, int) @nogc nothrow;
    int pthread_mutexattr_getprotocol(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    int pthread_mutexattr_setprotocol(pthread_mutexattr_t*, int) @nogc nothrow;
    int pthread_mutexattr_getprioceiling(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    int pthread_mutexattr_setprioceiling(pthread_mutexattr_t*, int) @nogc nothrow;
    int pthread_mutexattr_getrobust(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    int pthread_mutexattr_getrobust_np(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    int pthread_mutexattr_setrobust(pthread_mutexattr_t*, int) @nogc nothrow;
    int pthread_mutexattr_setrobust_np(pthread_mutexattr_t*, int) @nogc nothrow;
    int pthread_rwlock_init(pthread_rwlock_t*, const(pthread_rwlockattr_t)*) @nogc nothrow;
    int pthread_rwlock_destroy(pthread_rwlock_t*) @nogc nothrow;
    int pthread_rwlock_rdlock(pthread_rwlock_t*) @nogc nothrow;
    int pthread_rwlock_tryrdlock(pthread_rwlock_t*) @nogc nothrow;
    int pthread_rwlock_timedrdlock(pthread_rwlock_t*, const(timespec)*) @nogc nothrow;
    int pthread_rwlock_wrlock(pthread_rwlock_t*) @nogc nothrow;
    int pthread_rwlock_trywrlock(pthread_rwlock_t*) @nogc nothrow;
    int pthread_rwlock_timedwrlock(pthread_rwlock_t*, const(timespec)*) @nogc nothrow;
    int pthread_rwlock_unlock(pthread_rwlock_t*) @nogc nothrow;
    int pthread_rwlockattr_init(pthread_rwlockattr_t*) @nogc nothrow;
    int pthread_rwlockattr_destroy(pthread_rwlockattr_t*) @nogc nothrow;
    int pthread_rwlockattr_getpshared(const(pthread_rwlockattr_t)*, int*) @nogc nothrow;
    int pthread_rwlockattr_setpshared(pthread_rwlockattr_t*, int) @nogc nothrow;
    int pthread_rwlockattr_getkind_np(const(pthread_rwlockattr_t)*, int*) @nogc nothrow;
    int pthread_rwlockattr_setkind_np(pthread_rwlockattr_t*, int) @nogc nothrow;
    int pthread_cond_init(pthread_cond_t*, const(pthread_condattr_t)*) @nogc nothrow;
    int pthread_cond_destroy(pthread_cond_t*) @nogc nothrow;
    int pthread_cond_signal(pthread_cond_t*) @nogc nothrow;
    int pthread_cond_broadcast(pthread_cond_t*) @nogc nothrow;
    int pthread_cond_wait(pthread_cond_t*, pthread_mutex_t*) @nogc nothrow;
    int pthread_cond_timedwait(pthread_cond_t*, pthread_mutex_t*, const(timespec)*) @nogc nothrow;
    int pthread_condattr_init(pthread_condattr_t*) @nogc nothrow;
    int pthread_condattr_destroy(pthread_condattr_t*) @nogc nothrow;
    int pthread_condattr_getpshared(const(pthread_condattr_t)*, int*) @nogc nothrow;
    int pthread_condattr_setpshared(pthread_condattr_t*, int) @nogc nothrow;
    int pthread_condattr_getclock(const(pthread_condattr_t)*, int*) @nogc nothrow;
    int pthread_condattr_setclock(pthread_condattr_t*, int) @nogc nothrow;
    int pthread_spin_init(int*, int) @nogc nothrow;
    int pthread_spin_destroy(int*) @nogc nothrow;
    int pthread_spin_lock(int*) @nogc nothrow;
    int pthread_spin_trylock(int*) @nogc nothrow;
    int pthread_spin_unlock(int*) @nogc nothrow;
    int pthread_barrier_init(pthread_barrier_t*, const(pthread_barrierattr_t)*, uint) @nogc nothrow;
    int pthread_barrier_destroy(pthread_barrier_t*) @nogc nothrow;
    int pthread_barrier_wait(pthread_barrier_t*) @nogc nothrow;
    int pthread_barrierattr_init(pthread_barrierattr_t*) @nogc nothrow;
    int pthread_barrierattr_destroy(pthread_barrierattr_t*) @nogc nothrow;
    int pthread_barrierattr_getpshared(const(pthread_barrierattr_t)*, int*) @nogc nothrow;
    int pthread_barrierattr_setpshared(pthread_barrierattr_t*, int) @nogc nothrow;
    int pthread_key_create(uint*, void function(void*)) @nogc nothrow;
    int pthread_key_delete(uint) @nogc nothrow;
    void* pthread_getspecific(uint) @nogc nothrow;
    int pthread_setspecific(uint, const(void)*) @nogc nothrow;
    int pthread_getcpuclockid(c_ulong, int*) @nogc nothrow;
    int pthread_atfork(void function(), void function(), void function()) @nogc nothrow;
    int strfromf32x(char*, c_ulong, const(char)*, double) @nogc nothrow;
    _object* PyObject_Call(_object*, _object*, _object*) @nogc nothrow;
    _object* _PyStack_AsTuple(_object**, c_long) @nogc nothrow;
    _object* _PyStack_AsTupleSlice(_object**, c_long, c_long, c_long) @nogc nothrow;
    _object* _PyStack_AsDict(_object**, _object*) @nogc nothrow;
    int _PyStack_UnpackDict(_object**, c_long, _object*, _object***, _object**) @nogc nothrow;
    int _PyObject_HasFastCall(_object*) @nogc nothrow;
    _object* _PyObject_FastCallDict(_object*, _object**, c_long, _object*) @nogc nothrow;
    _object* _PyObject_FastCallKeywords(_object*, _object**, c_long, _object*) @nogc nothrow;
    _object* _PyObject_Call_Prepend(_object*, _object*, _object*, _object*) @nogc nothrow;
    _object* _PyObject_FastCall_Prepend(_object*, _object*, _object**, c_long) @nogc nothrow;
    _object* _Py_CheckFunctionResult(_object*, _object*, const(char)*) @nogc nothrow;
    _object* PyObject_CallObject(_object*, _object*) @nogc nothrow;
    _object* PyObject_CallFunction(_object*, const(char)*, ...) @nogc nothrow;
    _object* PyObject_CallMethod(_object*, const(char)*, const(char)*, ...) @nogc nothrow;
    _object* _PyObject_CallMethodId(_object*, _Py_Identifier*, const(char)*, ...) @nogc nothrow;
    _object* _PyObject_CallFunction_SizeT(_object*, const(char)*, ...) @nogc nothrow;
    _object* _PyObject_CallMethod_SizeT(_object*, const(char)*, const(char)*, ...) @nogc nothrow;
    _object* _PyObject_CallMethodId_SizeT(_object*, _Py_Identifier*, const(char)*, ...) @nogc nothrow;
    _object* PyObject_CallFunctionObjArgs(_object*, ...) @nogc nothrow;
    _object* PyObject_CallMethodObjArgs(_object*, _object*, ...) @nogc nothrow;
    _object* _PyObject_CallMethodIdObjArgs(_object*, _Py_Identifier*, ...) @nogc nothrow;
    _object* PyObject_Type(_object*) @nogc nothrow;
    c_long PyObject_Size(_object*) @nogc nothrow;
    c_long PyObject_Length(_object*) @nogc nothrow;
    int _PyObject_HasLen(_object*) @nogc nothrow;
    c_long PyObject_LengthHint(_object*, c_long) @nogc nothrow;
    _object* PyObject_GetItem(_object*, _object*) @nogc nothrow;
    int PyObject_SetItem(_object*, _object*, _object*) @nogc nothrow;
    int PyObject_DelItemString(_object*, const(char)*) @nogc nothrow;
    int PyObject_DelItem(_object*, _object*) @nogc nothrow;
    int PyObject_AsCharBuffer(_object*, const(char)**, c_long*) @nogc nothrow;
    int PyObject_CheckReadBuffer(_object*) @nogc nothrow;
    int PyObject_AsReadBuffer(_object*, const(void)**, c_long*) @nogc nothrow;
    int PyObject_AsWriteBuffer(_object*, void**, c_long*) @nogc nothrow;
    int PyObject_GetBuffer(_object*, bufferinfo*, int) @nogc nothrow;
    void* PyBuffer_GetPointer(bufferinfo*, c_long*) @nogc nothrow;
    int PyBuffer_SizeFromFormat(const(char)*) @nogc nothrow;
    int PyBuffer_ToContiguous(void*, bufferinfo*, c_long, char) @nogc nothrow;
    int PyBuffer_FromContiguous(bufferinfo*, void*, c_long, char) @nogc nothrow;
    int PyObject_CopyData(_object*, _object*) @nogc nothrow;
    int PyBuffer_IsContiguous(const(bufferinfo)*, char) @nogc nothrow;
    void PyBuffer_FillContiguousStrides(int, c_long*, c_long*, int, char) @nogc nothrow;
    int PyBuffer_FillInfo(bufferinfo*, _object*, void*, c_long, int, int) @nogc nothrow;
    void PyBuffer_Release(bufferinfo*) @nogc nothrow;
    _object* PyObject_Format(_object*, _object*) @nogc nothrow;
    _object* PyObject_GetIter(_object*) @nogc nothrow;
    _object* PyIter_Next(_object*) @nogc nothrow;
    int PyNumber_Check(_object*) @nogc nothrow;
    _object* PyNumber_Add(_object*, _object*) @nogc nothrow;
    _object* PyNumber_Subtract(_object*, _object*) @nogc nothrow;
    _object* PyNumber_Multiply(_object*, _object*) @nogc nothrow;
    _object* PyNumber_MatrixMultiply(_object*, _object*) @nogc nothrow;
    _object* PyNumber_FloorDivide(_object*, _object*) @nogc nothrow;
    _object* PyNumber_TrueDivide(_object*, _object*) @nogc nothrow;
    _object* PyNumber_Remainder(_object*, _object*) @nogc nothrow;
    _object* PyNumber_Divmod(_object*, _object*) @nogc nothrow;
    _object* PyNumber_Power(_object*, _object*, _object*) @nogc nothrow;
    _object* PyNumber_Negative(_object*) @nogc nothrow;
    _object* PyNumber_Positive(_object*) @nogc nothrow;
    _object* PyNumber_Absolute(_object*) @nogc nothrow;
    _object* PyNumber_Invert(_object*) @nogc nothrow;
    _object* PyNumber_Lshift(_object*, _object*) @nogc nothrow;
    _object* PyNumber_Rshift(_object*, _object*) @nogc nothrow;
    _object* PyNumber_And(_object*, _object*) @nogc nothrow;
    _object* PyNumber_Xor(_object*, _object*) @nogc nothrow;
    _object* PyNumber_Or(_object*, _object*) @nogc nothrow;
    int strfromf64(char*, c_ulong, const(char)*, double) @nogc nothrow;
    _object* PyNumber_Index(_object*) @nogc nothrow;
    c_long PyNumber_AsSsize_t(_object*, _object*) @nogc nothrow;
    _object* PyNumber_Long(_object*) @nogc nothrow;
    _object* PyNumber_Float(_object*) @nogc nothrow;
    _object* PyNumber_InPlaceAdd(_object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlaceSubtract(_object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlaceMultiply(_object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlaceMatrixMultiply(_object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlaceFloorDivide(_object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlaceTrueDivide(_object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlaceRemainder(_object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlacePower(_object*, _object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlaceLshift(_object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlaceRshift(_object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlaceAnd(_object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlaceXor(_object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlaceOr(_object*, _object*) @nogc nothrow;
    _object* PyNumber_ToBase(_object*, int) @nogc nothrow;
    int PySequence_Check(_object*) @nogc nothrow;
    c_long PySequence_Size(_object*) @nogc nothrow;
    c_long PySequence_Length(_object*) @nogc nothrow;
    _object* PySequence_Concat(_object*, _object*) @nogc nothrow;
    _object* PySequence_Repeat(_object*, c_long) @nogc nothrow;
    _object* PySequence_GetItem(_object*, c_long) @nogc nothrow;
    _object* PySequence_GetSlice(_object*, c_long, c_long) @nogc nothrow;
    int PySequence_SetItem(_object*, c_long, _object*) @nogc nothrow;
    int PySequence_DelItem(_object*, c_long) @nogc nothrow;
    int PySequence_SetSlice(_object*, c_long, c_long, _object*) @nogc nothrow;
    int PySequence_DelSlice(_object*, c_long, c_long) @nogc nothrow;
    _object* PySequence_Tuple(_object*) @nogc nothrow;
    _object* PySequence_List(_object*) @nogc nothrow;
    _object* PySequence_Fast(_object*, const(char)*) @nogc nothrow;
    int strfromf32(char*, c_ulong, const(char)*, float) @nogc nothrow;
    c_long PySequence_Count(_object*, _object*) @nogc nothrow;
    int PySequence_Contains(_object*, _object*) @nogc nothrow;
    c_long _PySequence_IterSearch(_object*, _object*, int) @nogc nothrow;
    int PySequence_In(_object*, _object*) @nogc nothrow;
    c_long PySequence_Index(_object*, _object*) @nogc nothrow;
    _object* PySequence_InPlaceConcat(_object*, _object*) @nogc nothrow;
    _object* PySequence_InPlaceRepeat(_object*, c_long) @nogc nothrow;
    int PyMapping_Check(_object*) @nogc nothrow;
    c_long PyMapping_Size(_object*) @nogc nothrow;
    c_long PyMapping_Length(_object*) @nogc nothrow;
    int strfroml(char*, c_ulong, const(char)*, real) @nogc nothrow;
    int PyMapping_HasKeyString(_object*, const(char)*) @nogc nothrow;
    int PyMapping_HasKey(_object*, _object*) @nogc nothrow;
    _object* PyMapping_Keys(_object*) @nogc nothrow;
    _object* PyMapping_Values(_object*) @nogc nothrow;
    _object* PyMapping_Items(_object*) @nogc nothrow;
    _object* PyMapping_GetItemString(_object*, const(char)*) @nogc nothrow;
    int PyMapping_SetItemString(_object*, const(char)*, _object*) @nogc nothrow;
    int PyObject_IsInstance(_object*, _object*) @nogc nothrow;
    int PyObject_IsSubclass(_object*, _object*) @nogc nothrow;
    int _PyObject_RealIsInstance(_object*, _object*) @nogc nothrow;
    int _PyObject_RealIsSubclass(_object*, _object*) @nogc nothrow;
    char** _PySequence_BytesToCharpArray(_object*) @nogc nothrow;
    void _Py_FreeCharPArray(char**) @nogc nothrow;
    void _Py_add_one_to_index_F(int, c_long*, const(c_long)*) @nogc nothrow;
    void _Py_add_one_to_index_C(int, c_long*, const(c_long)*) @nogc nothrow;
    int _Py_convert_optional_to_ssize_t(_object*, void*) @nogc nothrow;
    extern __gshared _typeobject PyFilter_Type;
    extern __gshared _typeobject PyMap_Type;
    extern __gshared _typeobject PyZip_Type;
    extern __gshared _typeobject PyBool_Type;
    int strfromf(char*, c_ulong, const(char)*, float) @nogc nothrow;
    extern __gshared _longobject _Py_FalseStruct;
    extern __gshared _longobject _Py_TrueStruct;
    int strfromd(char*, c_ulong, const(char)*, double) @nogc nothrow;
    _object* PyBool_FromLong(c_long) @nogc nothrow;
    struct PyByteArrayObject
    {
        PyVarObject ob_base;
        c_long ob_alloc;
        char* ob_bytes;
        char* ob_start;
        int ob_exports;
    }
    extern __gshared _typeobject PyByteArray_Type;
    extern __gshared _typeobject PyByteArrayIter_Type;
    ulong strtoull(const(char)*, char**, int) @nogc nothrow;
    _object* PyByteArray_FromObject(_object*) @nogc nothrow;
    _object* PyByteArray_Concat(_object*, _object*) @nogc nothrow;
    _object* PyByteArray_FromStringAndSize(const(char)*, c_long) @nogc nothrow;
    c_long PyByteArray_Size(_object*) @nogc nothrow;
    char* PyByteArray_AsString(_object*) @nogc nothrow;
    int PyByteArray_Resize(_object*, c_long) @nogc nothrow;
    extern __gshared char[0] _PyByteArray_empty_string;
    long strtoll(const(char)*, char**, int) @nogc nothrow;
    struct PyBytesObject
    {
        PyVarObject ob_base;
        c_long ob_shash;
        char[1] ob_sval;
    }
    extern __gshared _typeobject PyBytes_Type;
    extern __gshared _typeobject PyBytesIter_Type;
    _object* PyBytes_FromStringAndSize(const(char)*, c_long) @nogc nothrow;
    _object* PyBytes_FromString(const(char)*) @nogc nothrow;
    _object* PyBytes_FromObject(_object*) @nogc nothrow;
    _object* PyBytes_FromFormatV(const(char)*, va_list*) @nogc nothrow;
    _object* PyBytes_FromFormat(const(char)*, ...) @nogc nothrow;
    c_long PyBytes_Size(_object*) @nogc nothrow;
    char* PyBytes_AsString(_object*) @nogc nothrow;
    _object* PyBytes_Repr(_object*, int) @nogc nothrow;
    void PyBytes_Concat(_object**, _object*) @nogc nothrow;
    void PyBytes_ConcatAndDel(_object**, _object*) @nogc nothrow;
    int _PyBytes_Resize(_object**, c_long) @nogc nothrow;
    _object* _PyBytes_FormatEx(const(char)*, c_long, _object*, int) @nogc nothrow;
    _object* _PyBytes_FromHex(_object*, int) @nogc nothrow;
    _object* PyBytes_DecodeEscape(const(char)*, c_long, const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* _PyBytes_DecodeEscape(const(char)*, c_long, const(char)*, c_long, const(char)*, const(char)**) @nogc nothrow;
    ulong strtouq(const(char)*, char**, int) @nogc nothrow;
    _object* _PyBytes_Join(_object*, _object*) @nogc nothrow;
    int PyBytes_AsStringAndSize(_object*, char**, c_long*) @nogc nothrow;
    c_long _PyBytes_InsertThousandsGroupingLocale(char*, c_long, char*, c_long, c_long) @nogc nothrow;
    c_long _PyBytes_InsertThousandsGrouping(char*, c_long, char*, c_long, c_long, const(char)*, const(char)*) @nogc nothrow;
    long strtoq(const(char)*, char**, int) @nogc nothrow;
    struct _PyBytesWriter
    {
        _object* buffer;
        c_long allocated;
        c_long min_size;
        int use_bytearray;
        int overallocate;
        int use_small_buffer;
        char[512] small_buffer;
    }
    void _PyBytesWriter_Init(_PyBytesWriter*) @nogc nothrow;
    _object* _PyBytesWriter_Finish(_PyBytesWriter*, void*) @nogc nothrow;
    void _PyBytesWriter_Dealloc(_PyBytesWriter*) @nogc nothrow;
    void* _PyBytesWriter_Alloc(_PyBytesWriter*, c_long) @nogc nothrow;
    void* _PyBytesWriter_Prepare(_PyBytesWriter*, void*, c_long) @nogc nothrow;
    void* _PyBytesWriter_Resize(_PyBytesWriter*, void*, c_long) @nogc nothrow;
    void* _PyBytesWriter_WriteBytes(_PyBytesWriter*, void*, const(void)*, c_long) @nogc nothrow;
    struct PyCellObject
    {
        _object ob_base;
        _object* ob_ref;
    }
    extern __gshared _typeobject PyCell_Type;
    c_ulong strtoul(const(char)*, char**, int) @nogc nothrow;
    _object* PyCell_New(_object*) @nogc nothrow;
    _object* PyCell_Get(_object*) @nogc nothrow;
    int PyCell_Set(_object*, _object*) @nogc nothrow;
    c_long strtol(const(char)*, char**, int) @nogc nothrow;
    _object* PyEval_CallObjectWithKeywords(_object*, _object*, _object*) @nogc nothrow;
    _object* PyEval_CallFunction(_object*, const(char)*, ...) @nogc nothrow;
    _object* PyEval_CallMethod(_object*, const(char)*, const(char)*, ...) @nogc nothrow;
    void PyEval_SetProfile(int function(_object*, _frame*, int, _object*), _object*) @nogc nothrow;
    void PyEval_SetTrace(int function(_object*, _frame*, int, _object*), _object*) @nogc nothrow;
    void _PyEval_SetCoroutineOriginTrackingDepth(int) @nogc nothrow;
    int _PyEval_GetCoroutineOriginTrackingDepth() @nogc nothrow;
    void _PyEval_SetCoroutineWrapper(_object*) @nogc nothrow;
    _object* _PyEval_GetCoroutineWrapper() @nogc nothrow;
    void _PyEval_SetAsyncGenFirstiter(_object*) @nogc nothrow;
    _object* _PyEval_GetAsyncGenFirstiter() @nogc nothrow;
    void _PyEval_SetAsyncGenFinalizer(_object*) @nogc nothrow;
    _object* _PyEval_GetAsyncGenFinalizer() @nogc nothrow;
    _object* PyEval_GetBuiltins() @nogc nothrow;
    _object* PyEval_GetGlobals() @nogc nothrow;
    _object* PyEval_GetLocals() @nogc nothrow;
    _frame* PyEval_GetFrame() @nogc nothrow;
    int PyEval_MergeCompilerFlags(PyCompilerFlags*) @nogc nothrow;
    int Py_AddPendingCall(int function(void*), void*) @nogc nothrow;
    void _PyEval_SignalReceived() @nogc nothrow;
    int Py_MakePendingCalls() @nogc nothrow;
    void Py_SetRecursionLimit(int) @nogc nothrow;
    int Py_GetRecursionLimit() @nogc nothrow;
    int _Py_CheckRecursiveCall(const(char)*) @nogc nothrow;
    extern __gshared int _Py_CheckRecursionLimit;
    real strtof64x(const(char)*, char**) @nogc nothrow;
    const(char)* PyEval_GetFuncName(_object*) @nogc nothrow;
    const(char)* PyEval_GetFuncDesc(_object*) @nogc nothrow;
    _object* PyEval_EvalFrame(_frame*) @nogc nothrow;
    _object* PyEval_EvalFrameEx(_frame*, int) @nogc nothrow;
    _object* _PyEval_EvalFrameDefault(_frame*, int) @nogc nothrow;
    _ts* PyEval_SaveThread() @nogc nothrow;
    void PyEval_RestoreThread(_ts*) @nogc nothrow;
    int PyEval_ThreadsInitialized() @nogc nothrow;
    void PyEval_InitThreads() @nogc nothrow;
    void _PyEval_FiniThreads() @nogc nothrow;
    void PyEval_AcquireLock() @nogc nothrow;
    void PyEval_ReleaseLock() @nogc nothrow;
    void PyEval_AcquireThread(_ts*) @nogc nothrow;
    void PyEval_ReleaseThread(_ts*) @nogc nothrow;
    void PyEval_ReInitThreads() @nogc nothrow;
    void _PyEval_SetSwitchInterval(c_ulong) @nogc nothrow;
    c_ulong _PyEval_GetSwitchInterval() @nogc nothrow;
    c_long _PyEval_RequestCodeExtraIndex(void function(void*)) @nogc nothrow;
    double strtof32x(const(char)*, char**) @nogc nothrow;
    int _PyEval_SliceIndex(_object*, c_long*) @nogc nothrow;
    int _PyEval_SliceIndexNotNone(_object*, c_long*) @nogc nothrow;
    void _PyEval_SignalAsyncExc() @nogc nothrow;
    double strtof64(const(char)*, char**) @nogc nothrow;
    struct PyMethodObject
    {
        _object ob_base;
        _object* im_func;
        _object* im_self;
        _object* im_weakreflist;
    }
    extern __gshared _typeobject PyMethod_Type;
    _object* PyMethod_New(_object*, _object*) @nogc nothrow;
    _object* PyMethod_Function(_object*) @nogc nothrow;
    _object* PyMethod_Self(_object*) @nogc nothrow;
    float strtof32(const(char)*, char**) @nogc nothrow;
    int PyMethod_ClearFreeList() @nogc nothrow;
    struct PyInstanceMethodObject
    {
        _object ob_base;
        _object* func;
    }
    extern __gshared _typeobject PyInstanceMethod_Type;
    _object* PyInstanceMethod_New(_object*) @nogc nothrow;
    _object* PyInstanceMethod_Function(_object*) @nogc nothrow;
    alias _Py_CODEUNIT = ushort;
    struct PyCodeObject
    {
        _object ob_base;
        int co_argcount;
        int co_kwonlyargcount;
        int co_nlocals;
        int co_stacksize;
        int co_flags;
        int co_firstlineno;
        _object* co_code;
        _object* co_consts;
        _object* co_names;
        _object* co_varnames;
        _object* co_freevars;
        _object* co_cellvars;
        c_long* co_cell2arg;
        _object* co_filename;
        _object* co_name;
        _object* co_lnotab;
        void* co_zombieframe;
        _object* co_weakreflist;
        void* co_extra;
    }
    real strtold(const(char)*, char**) @nogc nothrow;
    float strtof(const(char)*, char**) @nogc nothrow;
    double strtod(const(char)*, char**) @nogc nothrow;
    long atoll(const(char)*) @nogc nothrow;
    c_long atol(const(char)*) @nogc nothrow;
    extern __gshared _typeobject PyCode_Type;
    PyCodeObject* PyCode_New(int, int, int, int, int, _object*, _object*, _object*, _object*, _object*, _object*, _object*, _object*, int, _object*) @nogc nothrow;
    PyCodeObject* PyCode_NewEmpty(const(char)*, const(char)*, int) @nogc nothrow;
    int PyCode_Addr2Line(PyCodeObject*, int) @nogc nothrow;
    alias PyAddrPair = _addr_pair;
    struct _addr_pair
    {
        int ap_lower;
        int ap_upper;
    }
    int _PyCode_CheckLineNumber(PyCodeObject*, int, _addr_pair*) @nogc nothrow;
    _object* _PyCode_ConstantKey(_object*) @nogc nothrow;
    _object* PyCode_Optimize(_object*, _object*, _object*, _object*) @nogc nothrow;
    int _PyCode_GetExtra(_object*, c_long, void**) @nogc nothrow;
    int _PyCode_SetExtra(_object*, c_long, void*) @nogc nothrow;
    int atoi(const(char)*) @nogc nothrow;
    int PyCodec_Register(_object*) @nogc nothrow;
    _object* _PyCodec_Lookup(const(char)*) @nogc nothrow;
    int _PyCodec_Forget(const(char)*) @nogc nothrow;
    int PyCodec_KnownEncoding(const(char)*) @nogc nothrow;
    _object* PyCodec_Encode(_object*, const(char)*, const(char)*) @nogc nothrow;
    _object* PyCodec_Decode(_object*, const(char)*, const(char)*) @nogc nothrow;
    _object* _PyCodec_LookupTextEncoding(const(char)*, const(char)*) @nogc nothrow;
    _object* _PyCodec_EncodeText(_object*, const(char)*, const(char)*) @nogc nothrow;
    _object* _PyCodec_DecodeText(_object*, const(char)*, const(char)*) @nogc nothrow;
    _object* _PyCodecInfo_GetIncrementalDecoder(_object*, const(char)*) @nogc nothrow;
    _object* _PyCodecInfo_GetIncrementalEncoder(_object*, const(char)*) @nogc nothrow;
    _object* PyCodec_Encoder(const(char)*) @nogc nothrow;
    _object* PyCodec_Decoder(const(char)*) @nogc nothrow;
    _object* PyCodec_IncrementalEncoder(const(char)*, const(char)*) @nogc nothrow;
    _object* PyCodec_IncrementalDecoder(const(char)*, const(char)*) @nogc nothrow;
    _object* PyCodec_StreamReader(const(char)*, _object*, const(char)*) @nogc nothrow;
    _object* PyCodec_StreamWriter(const(char)*, _object*, const(char)*) @nogc nothrow;
    int PyCodec_RegisterError(const(char)*, _object*) @nogc nothrow;
    _object* PyCodec_LookupError(const(char)*) @nogc nothrow;
    _object* PyCodec_StrictErrors(_object*) @nogc nothrow;
    _object* PyCodec_IgnoreErrors(_object*) @nogc nothrow;
    _object* PyCodec_ReplaceErrors(_object*) @nogc nothrow;
    _object* PyCodec_XMLCharRefReplaceErrors(_object*) @nogc nothrow;
    _object* PyCodec_BackslashReplaceErrors(_object*) @nogc nothrow;
    _object* PyCodec_NameReplaceErrors(_object*) @nogc nothrow;
    extern __gshared const(char)* Py_hexdigits;
    struct _node;
    PyCodeObject* PyNode_Compile(_node*, const(char)*) @nogc nothrow;
    double atof(const(char)*) @nogc nothrow;
    struct PyCompilerFlags
    {
        int cf_flags;
    }
    struct PyFutureFeatures
    {
        int ff_features;
        int ff_lineno;
    }
    c_ulong __ctype_get_mb_cur_max() @nogc nothrow;
    struct lldiv_t
    {
        long quot;
        long rem;
    }
    struct ldiv_t
    {
        c_long quot;
        c_long rem;
    }
    struct div_t
    {
        int quot;
        int rem;
    }
    struct _mod;
    PyCodeObject* PyAST_CompileEx(_mod*, const(char)*, PyCompilerFlags*, int, _arena*) @nogc nothrow;
    PyCodeObject* PyAST_CompileObject(_mod*, _object*, PyCompilerFlags*, int, _arena*) @nogc nothrow;
    PyFutureFeatures* PyFuture_FromAST(_mod*, const(char)*) @nogc nothrow;
    PyFutureFeatures* PyFuture_FromASTObject(_mod*, _object*) @nogc nothrow;
    _object* _Py_Mangle(_object*, _object*) @nogc nothrow;
    int PyCompile_OpcodeStackEffect(int, int) @nogc nothrow;
    int _PyAST_Optimize(_mod*, _arena*, int) @nogc nothrow;
    struct Py_complex
    {
        double real_;
        double imag;
    }
    Py_complex _Py_c_sum(Py_complex, Py_complex) @nogc nothrow;
    Py_complex _Py_c_diff(Py_complex, Py_complex) @nogc nothrow;
    Py_complex _Py_c_neg(Py_complex) @nogc nothrow;
    Py_complex _Py_c_prod(Py_complex, Py_complex) @nogc nothrow;
    Py_complex _Py_c_quot(Py_complex, Py_complex) @nogc nothrow;
    Py_complex _Py_c_pow(Py_complex, Py_complex) @nogc nothrow;
    double _Py_c_abs(Py_complex) @nogc nothrow;
    struct PyComplexObject
    {
        _object ob_base;
        Py_complex cval;
    }
    extern __gshared _typeobject PyComplex_Type;
    _object* PyComplex_FromCComplex(Py_complex) @nogc nothrow;
    _object* PyComplex_FromDoubles(double, double) @nogc nothrow;
    double PyComplex_RealAsDouble(_object*) @nogc nothrow;
    double PyComplex_ImagAsDouble(_object*) @nogc nothrow;
    Py_complex PyComplex_AsCComplex(_object*) @nogc nothrow;
    int _PyComplex_FormatAdvancedWriter(_PyUnicodeWriter*, _object*, _object*, c_long, c_long) @nogc nothrow;
    extern __gshared _typeobject PyContext_Type;
    alias PyContext = _pycontextobject;
    struct _pycontextobject;
    extern __gshared _typeobject PyContextVar_Type;
    alias PyContextVar = _pycontextvarobject;
    struct _pycontextvarobject;
    extern __gshared _typeobject PyContextToken_Type;
    alias PyContextToken = _pycontexttokenobject;
    struct _pycontexttokenobject;
    int __overflow(_IO_FILE*, int) @nogc nothrow;
    int __uflow(_IO_FILE*) @nogc nothrow;
    _object* PyContext_New() @nogc nothrow;
    _object* PyContext_Copy(_object*) @nogc nothrow;
    _object* PyContext_CopyCurrent() @nogc nothrow;
    int PyContext_Enter(_object*) @nogc nothrow;
    int PyContext_Exit(_object*) @nogc nothrow;
    _object* PyContextVar_New(const(char)*, _object*) @nogc nothrow;
    int PyContextVar_Get(_object*, _object*, _object**) @nogc nothrow;
    _object* PyContextVar_Set(_object*, _object*) @nogc nothrow;
    int PyContextVar_Reset(_object*, _object*) @nogc nothrow;
    _object* _PyContext_NewHamtForTests() @nogc nothrow;
    int PyContext_ClearFreeList() @nogc nothrow;
    struct PyDateTime_Delta
    {
        _object ob_base;
        c_long hashcode;
        int days;
        int seconds;
        int microseconds;
    }
    struct PyDateTime_TZInfo
    {
        _object ob_base;
    }
    void funlockfile(_IO_FILE*) @nogc nothrow;
    struct _PyDateTime_BaseTZInfo
    {
        _object ob_base;
        c_long hashcode;
        char hastzinfo;
    }
    struct _PyDateTime_BaseTime
    {
        _object ob_base;
        c_long hashcode;
        char hastzinfo;
        ubyte[6] data;
    }
    struct PyDateTime_Time
    {
        _object ob_base;
        c_long hashcode;
        char hastzinfo;
        ubyte[6] data;
        ubyte fold;
        _object* tzinfo;
    }
    struct PyDateTime_Date
    {
        _object ob_base;
        c_long hashcode;
        char hastzinfo;
        ubyte[4] data;
    }
    struct _PyDateTime_BaseDateTime
    {
        _object ob_base;
        c_long hashcode;
        char hastzinfo;
        ubyte[10] data;
    }
    struct PyDateTime_DateTime
    {
        _object ob_base;
        c_long hashcode;
        char hastzinfo;
        ubyte[10] data;
        ubyte fold;
        _object* tzinfo;
    }
    int ftrylockfile(_IO_FILE*) @nogc nothrow;
    void flockfile(_IO_FILE*) @nogc nothrow;
    int obstack_vprintf(obstack*, const(char)*, va_list*) @nogc nothrow;
    int obstack_printf(obstack*, const(char)*, ...) @nogc nothrow;
    struct obstack;
    char* cuserid(char*) @nogc nothrow;
    char* ctermid(char*) @nogc nothrow;
    struct PyDateTime_CAPI
    {
        _typeobject* DateType;
        _typeobject* DateTimeType;
        _typeobject* TimeType;
        _typeobject* DeltaType;
        _typeobject* TZInfoType;
        _object* TimeZone_UTC;
        _object* function(int, int, int, _typeobject*) Date_FromDate;
        _object* function(int, int, int, int, int, int, int, _object*, _typeobject*) DateTime_FromDateAndTime;
        _object* function(int, int, int, int, _object*, _typeobject*) Time_FromTime;
        _object* function(int, int, int, int, _typeobject*) Delta_FromDelta;
        _object* function(_object*, _object*) TimeZone_FromTimeZone;
        _object* function(_object*, _object*, _object*) DateTime_FromTimestamp;
        _object* function(_object*, _object*) Date_FromTimestamp;
        _object* function(int, int, int, int, int, int, int, _object*, int, _typeobject*) DateTime_FromDateAndTimeAndFold;
        _object* function(int, int, int, int, _object*, int, _typeobject*) Time_FromTimeAndFold;
    }
    extern __gshared PyDateTime_CAPI* PyDateTimeAPI;
    int pclose(_IO_FILE*) @nogc nothrow;
    _IO_FILE* popen(const(char)*, const(char)*) @nogc nothrow;
    int fileno_unlocked(_IO_FILE*) @nogc nothrow;
    int fileno(_IO_FILE*) @nogc nothrow;
    void perror(const(char)*) @nogc nothrow;
    int ferror_unlocked(_IO_FILE*) @nogc nothrow;
    int feof_unlocked(_IO_FILE*) @nogc nothrow;
    void clearerr_unlocked(_IO_FILE*) @nogc nothrow;
    alias getter = _object* function(_object*, void*);
    alias setter = int function(_object*, _object*, void*);
    alias wrapperfunc = _object* function(_object*, _object*, void*);
    alias wrapperfunc_kwds = _object* function(_object*, _object*, void*, _object*);
    struct wrapperbase
    {
        const(char)* name;
        int offset;
        void* function_;
        _object* function(_object*, _object*, void*) wrapper;
        const(char)* doc;
        int flags;
        _object* name_strobj;
    }
    struct PyDescrObject
    {
        _object ob_base;
        _typeobject* d_type;
        _object* d_name;
        _object* d_qualname;
    }
    int ferror(_IO_FILE*) @nogc nothrow;
    struct PyMethodDescrObject
    {
        PyDescrObject d_common;
        PyMethodDef* d_method;
    }
    struct PyMemberDescrObject
    {
        PyDescrObject d_common;
        PyMemberDef* d_member;
    }
    struct PyGetSetDescrObject
    {
        PyDescrObject d_common;
        PyGetSetDef* d_getset;
    }
    struct PyWrapperDescrObject
    {
        PyDescrObject d_common;
        wrapperbase* d_base;
        void* d_wrapped;
    }
    extern __gshared _typeobject PyClassMethodDescr_Type;
    extern __gshared _typeobject PyGetSetDescr_Type;
    extern __gshared _typeobject PyMemberDescr_Type;
    extern __gshared _typeobject PyMethodDescr_Type;
    extern __gshared _typeobject PyWrapperDescr_Type;
    extern __gshared _typeobject PyDictProxy_Type;
    extern __gshared _typeobject _PyMethodWrapper_Type;
    _object* PyDescr_NewMethod(_typeobject*, PyMethodDef*) @nogc nothrow;
    _object* PyDescr_NewClassMethod(_typeobject*, PyMethodDef*) @nogc nothrow;
    _object* PyDescr_NewMember(_typeobject*, PyMemberDef*) @nogc nothrow;
    _object* PyDescr_NewGetSet(_typeobject*, PyGetSetDef*) @nogc nothrow;
    _object* _PyMethodDescr_FastCallKeywords(_object*, _object**, c_long, _object*) @nogc nothrow;
    _object* PyDescr_NewWrapper(_typeobject*, wrapperbase*, void*) @nogc nothrow;
    _object* PyDictProxy_New(_object*) @nogc nothrow;
    _object* PyWrapper_New(_object*, _object*) @nogc nothrow;
    extern __gshared _typeobject PyProperty_Type;
    int feof(_IO_FILE*) @nogc nothrow;
    alias PyDictKeysObject = _dictkeysobject;
    struct PyDictObject
    {
        _object ob_base;
        c_long ma_used;
        c_ulong ma_version_tag;
        _dictkeysobject* ma_keys;
        _object** ma_values;
    }
    struct _PyDictViewObject
    {
        _object ob_base;
        PyDictObject* dv_dict;
    }
    extern __gshared _typeobject PyDict_Type;
    extern __gshared _typeobject PyDictIterKey_Type;
    extern __gshared _typeobject PyDictIterValue_Type;
    extern __gshared _typeobject PyDictIterItem_Type;
    extern __gshared _typeobject PyDictKeys_Type;
    extern __gshared _typeobject PyDictItems_Type;
    extern __gshared _typeobject PyDictValues_Type;
    void clearerr(_IO_FILE*) @nogc nothrow;
    int fsetpos64(_IO_FILE*, const(_G_fpos64_t)*) @nogc nothrow;
    int fgetpos64(_IO_FILE*, _G_fpos64_t*) @nogc nothrow;
    c_long ftello64(_IO_FILE*) @nogc nothrow;
    _object* PyDict_New() @nogc nothrow;
    _object* PyDict_GetItem(_object*, _object*) @nogc nothrow;
    _object* _PyDict_GetItem_KnownHash(_object*, _object*, c_long) @nogc nothrow;
    _object* PyDict_GetItemWithError(_object*, _object*) @nogc nothrow;
    _object* _PyDict_GetItemIdWithError(_object*, _Py_Identifier*) @nogc nothrow;
    _object* PyDict_SetDefault(_object*, _object*, _object*) @nogc nothrow;
    int PyDict_SetItem(_object*, _object*, _object*) @nogc nothrow;
    int _PyDict_SetItem_KnownHash(_object*, _object*, _object*, c_long) @nogc nothrow;
    int PyDict_DelItem(_object*, _object*) @nogc nothrow;
    int _PyDict_DelItem_KnownHash(_object*, _object*, c_long) @nogc nothrow;
    int _PyDict_DelItemIf(_object*, _object*, int function(_object*)) @nogc nothrow;
    void PyDict_Clear(_object*) @nogc nothrow;
    int PyDict_Next(_object*, c_long*, _object**, _object**) @nogc nothrow;
    _dictkeysobject* _PyDict_NewKeysForClass() @nogc nothrow;
    _object* PyObject_GenericGetDict(_object*, void*) @nogc nothrow;
    int _PyDict_Next(_object*, c_long*, _object**, _object**, c_long*) @nogc nothrow;
    _object* _PyDictView_New(_object*, _typeobject*) @nogc nothrow;
    _object* PyDict_Keys(_object*) @nogc nothrow;
    _object* PyDict_Values(_object*) @nogc nothrow;
    _object* PyDict_Items(_object*) @nogc nothrow;
    c_long PyDict_Size(_object*) @nogc nothrow;
    _object* PyDict_Copy(_object*) @nogc nothrow;
    int PyDict_Contains(_object*, _object*) @nogc nothrow;
    int fseeko64(_IO_FILE*, c_long, int) @nogc nothrow;
    int _PyDict_Contains(_object*, _object*, c_long) @nogc nothrow;
    _object* _PyDict_NewPresized(c_long) @nogc nothrow;
    void _PyDict_MaybeUntrack(_object*) @nogc nothrow;
    int _PyDict_HasOnlyStringKeys(_object*) @nogc nothrow;
    c_long _PyDict_KeysSize(_dictkeysobject*) @nogc nothrow;
    c_long _PyDict_SizeOf(PyDictObject*) @nogc nothrow;
    _object* _PyDict_Pop(_object*, _object*, _object*) @nogc nothrow;
    _object* _PyDict_Pop_KnownHash(_object*, _object*, c_long, _object*) @nogc nothrow;
    _object* _PyDict_FromKeys(_object*, _object*, _object*) @nogc nothrow;
    int PyDict_ClearFreeList() @nogc nothrow;
    int PyDict_Update(_object*, _object*) @nogc nothrow;
    int PyDict_Merge(_object*, _object*, int) @nogc nothrow;
    int _PyDict_MergeEx(_object*, _object*, int) @nogc nothrow;
    _object* _PyDictView_Intersect(_object*, _object*) @nogc nothrow;
    int PyDict_MergeFromSeq2(_object*, _object*, int) @nogc nothrow;
    _object* PyDict_GetItemString(_object*, const(char)*) @nogc nothrow;
    _object* _PyDict_GetItemId(_object*, _Py_Identifier*) @nogc nothrow;
    int PyDict_SetItemString(_object*, const(char)*, _object*) @nogc nothrow;
    int _PyDict_SetItemId(_object*, _Py_Identifier*, _object*) @nogc nothrow;
    int PyDict_DelItemString(_object*, const(char)*) @nogc nothrow;
    int _PyDict_DelItemId(_object*, _Py_Identifier*) @nogc nothrow;
    void _PyDict_DebugMallocStats(_IO_FILE*) @nogc nothrow;
    int _PyObjectDict_SetItem(_typeobject*, _object**, _object*, _object*) @nogc nothrow;
    _object* _PyDict_LoadGlobal(PyDictObject*, PyDictObject*, _object*) @nogc nothrow;
    double _Py_dg_strtod(const(char)*, char**) @nogc nothrow;
    char* _Py_dg_dtoa(double, int, int, int*, int*, char**) @nogc nothrow;
    void _Py_dg_freedtoa(char*) @nogc nothrow;
    double _Py_dg_stdnan(int) @nogc nothrow;
    double _Py_dg_infinity(int) @nogc nothrow;
    extern __gshared _typeobject PyEnum_Type;
    extern __gshared _typeobject PyReversed_Type;
    int fsetpos(_IO_FILE*, const(_G_fpos64_t)*) @nogc nothrow;
    _object* PyEval_EvalCode(_object*, _object*, _object*) @nogc nothrow;
    _object* PyEval_EvalCodeEx(_object*, _object*, _object*, _object**, int, _object**, int, _object**, int, _object*, _object*) @nogc nothrow;
    _object* _PyEval_EvalCodeWithName(_object*, _object*, _object*, _object**, c_long, _object**, _object**, c_long, int, _object**, c_long, _object*, _object*, _object*, _object*) @nogc nothrow;
    _object* _PyEval_CallTracing(_object*, _object*) @nogc nothrow;
    int fgetpos(_IO_FILE*, _G_fpos64_t*) @nogc nothrow;
    _object* PyFile_FromFd(int, const(char)*, const(char)*, int, const(char)*, const(char)*, const(char)*, int) @nogc nothrow;
    _object* PyFile_GetLine(_object*, int) @nogc nothrow;
    int PyFile_WriteObject(_object*, _object*, int) @nogc nothrow;
    int PyFile_WriteString(const(char)*, _object*) @nogc nothrow;
    int PyObject_AsFileDescriptor(_object*) @nogc nothrow;
    char* Py_UniversalNewlineFgets(char*, int, _IO_FILE*, _object*) @nogc nothrow;
    extern __gshared const(char)* Py_FileSystemDefaultEncoding;
    extern __gshared const(char)* Py_FileSystemDefaultEncodeErrors;
    extern __gshared int Py_HasFileSystemDefaultEncoding;
    extern __gshared int Py_UTF8Mode;
    _object* PyFile_NewStdPrinter(int) @nogc nothrow;
    extern __gshared _typeobject PyStdPrinter_Type;
    int* Py_DecodeLocale(const(char)*, c_ulong*) @nogc nothrow;
    char* Py_EncodeLocale(const(int)*, c_ulong*) @nogc nothrow;
    char* _Py_EncodeLocaleRaw(const(int)*, c_ulong*) @nogc nothrow;
    _object* _Py_device_encoding(int) @nogc nothrow;
    int _Py_fstat(int, stat*) @nogc nothrow;
    int _Py_fstat_noraise(int, stat*) @nogc nothrow;
    int _Py_stat(_object*, stat*) @nogc nothrow;
    int _Py_open(const(char)*, int) @nogc nothrow;
    int _Py_open_noraise(const(char)*, int) @nogc nothrow;
    _IO_FILE* _Py_wfopen(const(int)*, const(int)*) @nogc nothrow;
    _IO_FILE* _Py_fopen(const(char)*, const(char)*) @nogc nothrow;
    _IO_FILE* _Py_fopen_obj(_object*, const(char)*) @nogc nothrow;
    c_long _Py_read(int, void*, c_ulong) @nogc nothrow;
    c_long _Py_write(int, const(void)*, c_ulong) @nogc nothrow;
    c_long _Py_write_noraise(int, const(void)*, c_ulong) @nogc nothrow;
    int _Py_wreadlink(const(int)*, int*, c_ulong) @nogc nothrow;
    int* _Py_wrealpath(const(int)*, int*, c_ulong) @nogc nothrow;
    int* _Py_wgetcwd(int*, c_ulong) @nogc nothrow;
    int _Py_get_inheritable(int) @nogc nothrow;
    int _Py_set_inheritable(int, int, int*) @nogc nothrow;
    int _Py_set_inheritable_async_safe(int, int, int*) @nogc nothrow;
    int _Py_dup(int) @nogc nothrow;
    int _Py_get_blocking(int) @nogc nothrow;
    int _Py_set_blocking(int, int) @nogc nothrow;
    int _Py_GetLocaleconvNumeric(_object**, _object**, const(char)**) @nogc nothrow;
    c_long ftello(_IO_FILE*) @nogc nothrow;
    struct PyFloatObject
    {
        _object ob_base;
        double ob_fval;
    }
    extern __gshared _typeobject PyFloat_Type;
    int fseeko(_IO_FILE*, c_long, int) @nogc nothrow;
    double PyFloat_GetMax() @nogc nothrow;
    double PyFloat_GetMin() @nogc nothrow;
    _object* PyFloat_GetInfo() @nogc nothrow;
    _object* PyFloat_FromString(_object*) @nogc nothrow;
    _object* PyFloat_FromDouble(double) @nogc nothrow;
    double PyFloat_AsDouble(_object*) @nogc nothrow;
    int _PyFloat_Pack2(double, ubyte*, int) @nogc nothrow;
    int _PyFloat_Pack4(double, ubyte*, int) @nogc nothrow;
    int _PyFloat_Pack8(double, ubyte*, int) @nogc nothrow;
    int _PyFloat_Repr(double, char*, c_ulong) @nogc nothrow;
    int _PyFloat_Digits(char*, double, int*) @nogc nothrow;
    void _PyFloat_DigitsInit() @nogc nothrow;
    double _PyFloat_Unpack2(const(ubyte)*, int) @nogc nothrow;
    double _PyFloat_Unpack4(const(ubyte)*, int) @nogc nothrow;
    double _PyFloat_Unpack8(const(ubyte)*, int) @nogc nothrow;
    int PyFloat_ClearFreeList() @nogc nothrow;
    void _PyFloat_DebugMallocStats(_IO_FILE*) @nogc nothrow;
    int _PyFloat_FormatAdvancedWriter(_PyUnicodeWriter*, _object*, _object*, c_long, c_long) @nogc nothrow;
    struct PyFunctionObject
    {
        _object ob_base;
        _object* func_code;
        _object* func_globals;
        _object* func_defaults;
        _object* func_kwdefaults;
        _object* func_closure;
        _object* func_doc;
        _object* func_name;
        _object* func_dict;
        _object* func_weakreflist;
        _object* func_module;
        _object* func_annotations;
        _object* func_qualname;
    }
    extern __gshared _typeobject PyFunction_Type;
    void rewind(_IO_FILE*) @nogc nothrow;
    _object* PyFunction_New(_object*, _object*) @nogc nothrow;
    _object* PyFunction_NewWithQualName(_object*, _object*, _object*) @nogc nothrow;
    _object* PyFunction_GetCode(_object*) @nogc nothrow;
    _object* PyFunction_GetGlobals(_object*) @nogc nothrow;
    _object* PyFunction_GetModule(_object*) @nogc nothrow;
    _object* PyFunction_GetDefaults(_object*) @nogc nothrow;
    int PyFunction_SetDefaults(_object*, _object*) @nogc nothrow;
    _object* PyFunction_GetKwDefaults(_object*) @nogc nothrow;
    int PyFunction_SetKwDefaults(_object*, _object*) @nogc nothrow;
    _object* PyFunction_GetClosure(_object*) @nogc nothrow;
    int PyFunction_SetClosure(_object*, _object*) @nogc nothrow;
    _object* PyFunction_GetAnnotations(_object*) @nogc nothrow;
    int PyFunction_SetAnnotations(_object*, _object*) @nogc nothrow;
    _object* _PyFunction_FastCallDict(_object*, _object**, c_long, _object*) @nogc nothrow;
    _object* _PyFunction_FastCallKeywords(_object*, _object**, c_long, _object*) @nogc nothrow;
    c_long ftell(_IO_FILE*) @nogc nothrow;
    int fseek(_IO_FILE*, c_long, int) @nogc nothrow;
    c_ulong fwrite_unlocked(const(void)*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;
    c_ulong fread_unlocked(void*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;
    extern __gshared _typeobject PyClassMethod_Type;
    extern __gshared _typeobject PyStaticMethod_Type;
    _object* PyClassMethod_New(_object*) @nogc nothrow;
    _object* PyStaticMethod_New(_object*) @nogc nothrow;
    int fputs_unlocked(const(char)*, _IO_FILE*) @nogc nothrow;
    struct PyGenObject
    {
        _object ob_base;
        _frame* gi_frame;
        char gi_running;
        _object* gi_code;
        _object* gi_weakreflist;
        _object* gi_name;
        _object* gi_qualname;
        _err_stackitem gi_exc_state;
    }
    extern __gshared _typeobject PyGen_Type;
    c_ulong fwrite(const(void)*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;
    _object* PyGen_New(_frame*) @nogc nothrow;
    _object* PyGen_NewWithQualName(_frame*, _object*, _object*) @nogc nothrow;
    int PyGen_NeedsFinalizing(PyGenObject*) @nogc nothrow;
    int _PyGen_SetStopIterationValue(_object*) @nogc nothrow;
    int _PyGen_FetchStopIterationValue(_object**) @nogc nothrow;
    _object* _PyGen_Send(PyGenObject*, _object*) @nogc nothrow;
    _object* _PyGen_yf(PyGenObject*) @nogc nothrow;
    void _PyGen_Finalize(_object*) @nogc nothrow;
    struct PyCoroObject
    {
        _object ob_base;
        _frame* cr_frame;
        char cr_running;
        _object* cr_code;
        _object* cr_weakreflist;
        _object* cr_name;
        _object* cr_qualname;
        _err_stackitem cr_exc_state;
        _object* cr_origin;
    }
    extern __gshared _typeobject PyCoro_Type;
    extern __gshared _typeobject _PyCoroWrapper_Type;
    extern __gshared _typeobject _PyAIterWrapper_Type;
    c_ulong fread(void*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;
    _object* _PyCoro_GetAwaitableIter(_object*) @nogc nothrow;
    _object* PyCoro_New(_frame*, _object*, _object*) @nogc nothrow;
    struct PyAsyncGenObject
    {
        _object ob_base;
        _frame* ag_frame;
        char ag_running;
        _object* ag_code;
        _object* ag_weakreflist;
        _object* ag_name;
        _object* ag_qualname;
        _err_stackitem ag_exc_state;
        _object* ag_finalizer;
        int ag_hooks_inited;
        int ag_closed;
    }
    extern __gshared _typeobject PyAsyncGen_Type;
    extern __gshared _typeobject _PyAsyncGenASend_Type;
    extern __gshared _typeobject _PyAsyncGenWrappedValue_Type;
    extern __gshared _typeobject _PyAsyncGenAThrow_Type;
    _object* PyAsyncGen_New(_frame*, _object*, _object*) @nogc nothrow;
    int ungetc(int, _IO_FILE*) @nogc nothrow;
    _object* _PyAsyncGenValueWrapperNew(_object*) @nogc nothrow;
    int PyAsyncGen_ClearFreeLists() @nogc nothrow;
    int puts(const(char)*) @nogc nothrow;
    _PyInitError _PyImportZip_Init() @nogc nothrow;
    _object* PyInit__imp() @nogc nothrow;
    c_long PyImport_GetMagicNumber() @nogc nothrow;
    const(char)* PyImport_GetMagicTag() @nogc nothrow;
    _object* PyImport_ExecCodeModule(const(char)*, _object*) @nogc nothrow;
    _object* PyImport_ExecCodeModuleEx(const(char)*, _object*, const(char)*) @nogc nothrow;
    _object* PyImport_ExecCodeModuleWithPathnames(const(char)*, _object*, const(char)*, const(char)*) @nogc nothrow;
    _object* PyImport_ExecCodeModuleObject(_object*, _object*, _object*, _object*) @nogc nothrow;
    _object* PyImport_GetModuleDict() @nogc nothrow;
    _object* PyImport_GetModule(_object*) @nogc nothrow;
    int _PyImport_IsInitialized(_is*) @nogc nothrow;
    _object* _PyImport_GetModuleId(_Py_Identifier*) @nogc nothrow;
    _object* _PyImport_AddModuleObject(_object*, _object*) @nogc nothrow;
    int _PyImport_SetModule(_object*, _object*) @nogc nothrow;
    int _PyImport_SetModuleString(const(char)*, _object*) @nogc nothrow;
    _object* PyImport_AddModuleObject(_object*) @nogc nothrow;
    _object* PyImport_AddModule(const(char)*) @nogc nothrow;
    _object* PyImport_ImportModule(const(char)*) @nogc nothrow;
    _object* PyImport_ImportModuleNoBlock(const(char)*) @nogc nothrow;
    _object* PyImport_ImportModuleLevel(const(char)*, _object*, _object*, _object*, int) @nogc nothrow;
    _object* PyImport_ImportModuleLevelObject(_object*, _object*, _object*, _object*, int) @nogc nothrow;
    int fputs(const(char)*, _IO_FILE*) @nogc nothrow;
    _object* PyImport_GetImporter(_object*) @nogc nothrow;
    _object* PyImport_Import(_object*) @nogc nothrow;
    _object* PyImport_ReloadModule(_object*) @nogc nothrow;
    void PyImport_Cleanup() @nogc nothrow;
    int PyImport_ImportFrozenModuleObject(_object*) @nogc nothrow;
    int PyImport_ImportFrozenModule(const(char)*) @nogc nothrow;
    void _PyImport_AcquireLock() @nogc nothrow;
    int _PyImport_ReleaseLock() @nogc nothrow;
    void _PyImport_ReInitLock() @nogc nothrow;
    _object* _PyImport_FindBuiltin(const(char)*, _object*) @nogc nothrow;
    _object* _PyImport_FindExtensionObject(_object*, _object*) @nogc nothrow;
    _object* _PyImport_FindExtensionObjectEx(_object*, _object*, _object*) @nogc nothrow;
    int _PyImport_FixupBuiltin(_object*, const(char)*, _object*) @nogc nothrow;
    int _PyImport_FixupExtensionObject(_object*, _object*, _object*, _object*) @nogc nothrow;
    struct _inittab
    {
        const(char)* name;
        _object* function() initfunc;
    }
    extern __gshared _inittab* PyImport_Inittab;
    int PyImport_ExtendInittab(_inittab*) @nogc nothrow;
    extern __gshared _typeobject PyNullImporter_Type;
    int PyImport_AppendInittab(const(char)*, _object* function()) @nogc nothrow;
    struct _frozen
    {
        const(char)* name;
        const(ubyte)* code;
        int size;
    }
    extern __gshared const(_frozen)* PyImport_FrozenModules;
    int PyOS_InterruptOccurred() @nogc nothrow;
    void PyOS_InitInterrupts() @nogc nothrow;
    void PyOS_BeforeFork() @nogc nothrow;
    void PyOS_AfterFork_Parent() @nogc nothrow;
    void PyOS_AfterFork_Child() @nogc nothrow;
    void PyOS_AfterFork() @nogc nothrow;
    int _PyOS_IsMainThread() @nogc nothrow;
    void _PySignal_AfterFork() @nogc nothrow;
    c_long getline(char**, c_ulong*, _IO_FILE*) @nogc nothrow;
    extern __gshared _typeobject PySeqIter_Type;
    extern __gshared _typeobject PyCallIter_Type;
    extern __gshared _typeobject PyCmpWrapper_Type;
    _object* PySeqIter_New(_object*) @nogc nothrow;
    c_long getdelim(char**, c_ulong*, int, _IO_FILE*) @nogc nothrow;
    _object* PyCallIter_New(_object*, _object*) @nogc nothrow;
    struct PyListObject
    {
        PyVarObject ob_base;
        _object** ob_item;
        c_long allocated;
    }
    extern __gshared _typeobject PyList_Type;
    extern __gshared _typeobject PyListIter_Type;
    extern __gshared _typeobject PyListRevIter_Type;
    extern __gshared _typeobject PySortWrapper_Type;
    c_long __getdelim(char**, c_ulong*, int, _IO_FILE*) @nogc nothrow;
    _object* PyList_New(c_long) @nogc nothrow;
    c_long PyList_Size(_object*) @nogc nothrow;
    _object* PyList_GetItem(_object*, c_long) @nogc nothrow;
    int PyList_SetItem(_object*, c_long, _object*) @nogc nothrow;
    int PyList_Insert(_object*, c_long, _object*) @nogc nothrow;
    int PyList_Append(_object*, _object*) @nogc nothrow;
    _object* PyList_GetSlice(_object*, c_long, c_long) @nogc nothrow;
    int PyList_SetSlice(_object*, c_long, c_long, _object*) @nogc nothrow;
    int PyList_Sort(_object*) @nogc nothrow;
    int PyList_Reverse(_object*) @nogc nothrow;
    _object* PyList_AsTuple(_object*) @nogc nothrow;
    _object* _PyList_Extend(PyListObject*, _object*) @nogc nothrow;
    int PyList_ClearFreeList() @nogc nothrow;
    void _PyList_DebugMallocStats(_IO_FILE*) @nogc nothrow;
    char* fgets_unlocked(char*, int, _IO_FILE*) @nogc nothrow;
    alias digit = uint;
    alias sdigit = int;
    alias twodigits = c_ulong;
    alias stwodigits = c_long;
    char* fgets(char*, int, _IO_FILE*) @nogc nothrow;
    int putw(int, _IO_FILE*) @nogc nothrow;
    int getw(_IO_FILE*) @nogc nothrow;
    _longobject* _PyLong_New(c_long) @nogc nothrow;
    _object* _PyLong_Copy(_longobject*) @nogc nothrow;
    alias PyLongObject = _longobject;
    struct _longobject
    {
        PyVarObject ob_base;
        uint[1] ob_digit;
    }
    extern __gshared _typeobject PyLong_Type;
    int putchar_unlocked(int) @nogc nothrow;
    _object* PyLong_FromLong(c_long) @nogc nothrow;
    _object* PyLong_FromUnsignedLong(c_ulong) @nogc nothrow;
    _object* PyLong_FromSize_t(c_ulong) @nogc nothrow;
    _object* PyLong_FromSsize_t(c_long) @nogc nothrow;
    _object* PyLong_FromDouble(double) @nogc nothrow;
    c_long PyLong_AsLong(_object*) @nogc nothrow;
    c_long PyLong_AsLongAndOverflow(_object*, int*) @nogc nothrow;
    c_long PyLong_AsSsize_t(_object*) @nogc nothrow;
    c_ulong PyLong_AsSize_t(_object*) @nogc nothrow;
    c_ulong PyLong_AsUnsignedLong(_object*) @nogc nothrow;
    c_ulong PyLong_AsUnsignedLongMask(_object*) @nogc nothrow;
    int _PyLong_AsInt(_object*) @nogc nothrow;
    _object* PyLong_GetInfo() @nogc nothrow;
    int putc_unlocked(int, _IO_FILE*) @nogc nothrow;
    int fputc_unlocked(int, _IO_FILE*) @nogc nothrow;
    int putchar(int) @nogc nothrow;
    int putc(int, _IO_FILE*) @nogc nothrow;
    extern __gshared ubyte[256] _PyLong_DigitValue;
    double _PyLong_Frexp(_longobject*, c_long*) @nogc nothrow;
    double PyLong_AsDouble(_object*) @nogc nothrow;
    _object* PyLong_FromVoidPtr(void*) @nogc nothrow;
    void* PyLong_AsVoidPtr(_object*) @nogc nothrow;
    _object* PyLong_FromLongLong(long) @nogc nothrow;
    _object* PyLong_FromUnsignedLongLong(ulong) @nogc nothrow;
    long PyLong_AsLongLong(_object*) @nogc nothrow;
    ulong PyLong_AsUnsignedLongLong(_object*) @nogc nothrow;
    ulong PyLong_AsUnsignedLongLongMask(_object*) @nogc nothrow;
    long PyLong_AsLongLongAndOverflow(_object*, int*) @nogc nothrow;
    _object* PyLong_FromString(const(char)*, char**, int) @nogc nothrow;
    _object* PyLong_FromUnicode(int*, c_long, int) @nogc nothrow;
    _object* PyLong_FromUnicodeObject(_object*, int) @nogc nothrow;
    _object* _PyLong_FromBytes(const(char)*, c_long, int) @nogc nothrow;
    int _PyLong_Sign(_object*) @nogc nothrow;
    c_ulong _PyLong_NumBits(_object*) @nogc nothrow;
    _object* _PyLong_DivmodNear(_object*, _object*) @nogc nothrow;
    _object* _PyLong_FromByteArray(const(ubyte)*, c_ulong, int, int) @nogc nothrow;
    int _PyLong_AsByteArray(_longobject*, ubyte*, c_ulong, int, int) @nogc nothrow;
    _longobject* _PyLong_FromNbInt(_object*) @nogc nothrow;
    _object* _PyLong_Format(_object*, int) @nogc nothrow;
    int _PyLong_FormatWriter(_PyUnicodeWriter*, _object*, int, int) @nogc nothrow;
    char* _PyLong_FormatBytesWriter(_PyBytesWriter*, char*, _object*, int, int) @nogc nothrow;
    int _PyLong_FormatAdvancedWriter(_PyUnicodeWriter*, _object*, _object*, c_long, c_long) @nogc nothrow;
    c_ulong PyOS_strtoul(const(char)*, char**, int) @nogc nothrow;
    c_long PyOS_strtol(const(char)*, char**, int) @nogc nothrow;
    _object* _PyLong_GCD(_object*, _object*) @nogc nothrow;
    extern __gshared _object* _PyLong_Zero;
    extern __gshared _object* _PyLong_One;
    int fputc(int, _IO_FILE*) @nogc nothrow;
    extern __gshared _typeobject _PyManagedBuffer_Type;
    extern __gshared _typeobject PyMemoryView_Type;
    int fgetc_unlocked(_IO_FILE*) @nogc nothrow;
    int getchar_unlocked() @nogc nothrow;
    _object* PyMemoryView_FromObject(_object*) @nogc nothrow;
    _object* PyMemoryView_FromMemory(char*, c_long, int) @nogc nothrow;
    _object* PyMemoryView_FromBuffer(bufferinfo*) @nogc nothrow;
    _object* PyMemoryView_GetContiguous(_object*, int, char) @nogc nothrow;
    int getc_unlocked(_IO_FILE*) @nogc nothrow;
    struct _PyManagedBufferObject
    {
        _object ob_base;
        int flags;
        c_long exports;
        bufferinfo master;
    }
    int getchar() @nogc nothrow;
    int getc(_IO_FILE*) @nogc nothrow;
    int fgetc(_IO_FILE*) @nogc nothrow;
    struct PyMemoryViewObject
    {
        PyVarObject ob_base;
        _PyManagedBufferObject* mbuf;
        c_long hash;
        int flags;
        c_long exports;
        bufferinfo view;
        _object* weakreflist;
        c_long[1] ob_array;
    }
    extern __gshared _typeobject PyCFunction_Type;
    alias PyCFunction = _object* function(_object*, _object*);
    alias _PyCFunctionFast = _object* function(_object*, _object**, c_long);
    alias PyCFunctionWithKeywords = _object* function(_object*, _object*, _object*);
    alias _PyCFunctionFastWithKeywords = _object* function(_object*, _object**, c_long, _object*);
    alias PyNoArgsFunction = _object* function(_object*);
    _object* function(_object*, _object*) PyCFunction_GetFunction(_object*) @nogc nothrow;
    _object* PyCFunction_GetSelf(_object*) @nogc nothrow;
    int PyCFunction_GetFlags(_object*) @nogc nothrow;
    int vsscanf(const(char)*, const(char)*, va_list*) @nogc nothrow;
    int vscanf(const(char)*, va_list*) @nogc nothrow;
    _object* PyCFunction_Call(_object*, _object*, _object*) @nogc nothrow;
    _object* _PyCFunction_FastCallDict(_object*, _object**, c_long, _object*) @nogc nothrow;
    _object* _PyCFunction_FastCallKeywords(_object*, _object**, c_long, _object*) @nogc nothrow;
    _object* PyCFunction_NewEx(PyMethodDef*, _object*, _object*) @nogc nothrow;
    int vfscanf(_IO_FILE*, const(char)*, va_list*) @nogc nothrow;
    int sscanf(const(char)*, const(char)*, ...) @nogc nothrow;
    struct PyCFunctionObject
    {
        _object ob_base;
        PyMethodDef* m_ml;
        _object* m_self;
        _object* m_module;
        _object* m_weakreflist;
    }
    _object* _PyMethodDef_RawFastCallDict(PyMethodDef*, _object*, _object**, c_long, _object*) @nogc nothrow;
    _object* _PyMethodDef_RawFastCallKeywords(PyMethodDef*, _object*, _object**, c_long, _object*) @nogc nothrow;
    int PyCFunction_ClearFreeList() @nogc nothrow;
    void _PyCFunction_DebugMallocStats(_IO_FILE*) @nogc nothrow;
    void _PyMethod_DebugMallocStats(_IO_FILE*) @nogc nothrow;
    int scanf(const(char)*, ...) @nogc nothrow;
    _object* _Py_VaBuildValue_SizeT(const(char)*, va_list*) @nogc nothrow;
    _object** _Py_VaBuildStack_SizeT(_object**, c_long, const(char)*, va_list*, c_long*) @nogc nothrow;
    int PyArg_Parse(_object*, const(char)*, ...) @nogc nothrow;
    int PyArg_ParseTuple(_object*, const(char)*, ...) @nogc nothrow;
    int PyArg_ParseTupleAndKeywords(_object*, _object*, const(char)*, char**, ...) @nogc nothrow;
    int PyArg_VaParse(_object*, const(char)*, va_list*) @nogc nothrow;
    int PyArg_VaParseTupleAndKeywords(_object*, _object*, const(char)*, char**, va_list*) @nogc nothrow;
    int PyArg_ValidateKeywordArguments(_object*) @nogc nothrow;
    int PyArg_UnpackTuple(_object*, const(char)*, c_long, c_long, ...) @nogc nothrow;
    _object* Py_BuildValue(const(char)*, ...) @nogc nothrow;
    _object* _Py_BuildValue_SizeT(const(char)*, ...) @nogc nothrow;
    int _PyArg_UnpackStack(_object**, c_long, const(char)*, c_long, c_long, ...) @nogc nothrow;
    pragma(mangle, "_PyArg_NoKeywords") int _PyArg_NoKeywords_(const(char)*, _object*) @nogc nothrow;
    pragma(mangle, "_PyArg_NoPositional") int _PyArg_NoPositional_(const(char)*, _object*) @nogc nothrow;
    int fscanf(_IO_FILE*, const(char)*, ...) @nogc nothrow;
    _object* Py_VaBuildValue(const(char)*, va_list*) @nogc nothrow;
    _object** _Py_VaBuildStack(_object**, c_long, const(char)*, va_list*, c_long*) @nogc nothrow;
    struct _PyArg_Parser
    {
        const(char)* format;
        const(const(char)*)* keywords;
        const(char)* fname;
        const(char)* custom_msg;
        int pos;
        int min;
        int max;
        _object* kwtuple;
        _PyArg_Parser* next;
    }
    int _PyArg_ParseTupleAndKeywordsFast(_object*, _object*, _PyArg_Parser*, ...) @nogc nothrow;
    int _PyArg_ParseStack(_object**, c_long, const(char)*, ...) @nogc nothrow;
    int _PyArg_ParseStackAndKeywords(_object**, c_long, _object*, _PyArg_Parser*, ...) @nogc nothrow;
    int _PyArg_VaParseTupleAndKeywordsFast(_object*, _object*, _PyArg_Parser*, va_list*) @nogc nothrow;
    void _PyArg_Fini() @nogc nothrow;
    int PyModule_AddObject(_object*, const(char)*, _object*) @nogc nothrow;
    int PyModule_AddIntConstant(_object*, const(char)*, c_long) @nogc nothrow;
    int PyModule_AddStringConstant(_object*, const(char)*, const(char)*) @nogc nothrow;
    int dprintf(int, const(char)*, ...) @nogc nothrow;
    int vdprintf(int, const(char)*, va_list*) @nogc nothrow;
    int PyModule_SetDocString(_object*, const(char)*) @nogc nothrow;
    int PyModule_AddFunctions(_object*, PyMethodDef*) @nogc nothrow;
    int PyModule_ExecDef(_object*, PyModuleDef*) @nogc nothrow;
    int asprintf(char**, const(char)*, ...) @nogc nothrow;
    _object* PyModule_Create2(PyModuleDef*, int) @nogc nothrow;
    _object* _PyModule_CreateInitialized(PyModuleDef*, int) @nogc nothrow;
    _object* PyModule_FromDefAndSpec2(PyModuleDef*, _object*, int) @nogc nothrow;
    int __asprintf(char**, const(char)*, ...) @nogc nothrow;
    extern __gshared const(char)* _Py_PackageContext;
    extern __gshared _typeobject PyModule_Type;
    int vasprintf(char**, const(char)*, va_list*) @nogc nothrow;
    _object* PyModule_NewObject(_object*) @nogc nothrow;
    _object* PyModule_New(const(char)*) @nogc nothrow;
    _object* PyModule_GetDict(_object*) @nogc nothrow;
    _object* PyModule_GetNameObject(_object*) @nogc nothrow;
    const(char)* PyModule_GetName(_object*) @nogc nothrow;
    const(char)* PyModule_GetFilename(_object*) @nogc nothrow;
    _object* PyModule_GetFilenameObject(_object*) @nogc nothrow;
    void _PyModule_Clear(_object*) @nogc nothrow;
    void _PyModule_ClearDict(_object*) @nogc nothrow;
    PyModuleDef* PyModule_GetDef(_object*) @nogc nothrow;
    struct PyModuleDef
    {
        PyModuleDef_Base m_base;
        const(char)* m_name;
        const(char)* m_doc;
        c_long m_size;
        PyMethodDef* m_methods;
        PyModuleDef_Slot* m_slots;
        int function(_object*, int function(_object*, void*), void*) m_traverse;
        int function(_object*) m_clear;
        void function(void*) m_free;
    }
    void* PyModule_GetState(_object*) @nogc nothrow;
    _object* PyModuleDef_Init(PyModuleDef*) @nogc nothrow;
    extern __gshared _typeobject PyModuleDef_Type;
    struct PyModuleDef_Base
    {
        _object ob_base;
        _object* function() m_init;
        c_long m_index;
        _object* m_copy;
    }
    struct PyModuleDef_Slot
    {
        int slot;
        void* value;
    }
    int vsnprintf(char*, c_ulong, const(char)*, va_list*) @nogc nothrow;
    int snprintf(char*, c_ulong, const(char)*, ...) @nogc nothrow;
    extern __gshared _typeobject _PyNamespace_Type;
    _object* _PyNamespace_New(_object*) @nogc nothrow;
    int vsprintf(char*, const(char)*, va_list*) @nogc nothrow;
    int vprintf(const(char)*, va_list*) @nogc nothrow;
    int vfprintf(_IO_FILE*, const(char)*, va_list*) @nogc nothrow;
    int sprintf(char*, const(char)*, ...) @nogc nothrow;
    alias PyObject = _object;
    struct _object
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
    }
    struct _typeobject
    {
        PyVarObject ob_base;
        const(char)* tp_name;
        c_long tp_basicsize;
        c_long tp_itemsize;
        void function(_object*) tp_dealloc;
        int function(_object*, _IO_FILE*, int) tp_print;
        _object* function(_object*, char*) tp_getattr;
        int function(_object*, char*, _object*) tp_setattr;
        PyAsyncMethods* tp_as_async;
        _object* function(_object*) tp_repr;
        PyNumberMethods* tp_as_number;
        PySequenceMethods* tp_as_sequence;
        PyMappingMethods* tp_as_mapping;
        c_long function(_object*) tp_hash;
        _object* function(_object*, _object*, _object*) tp_call;
        _object* function(_object*) tp_str;
        _object* function(_object*, _object*) tp_getattro;
        int function(_object*, _object*, _object*) tp_setattro;
        PyBufferProcs* tp_as_buffer;
        c_ulong tp_flags;
        const(char)* tp_doc;
        int function(_object*, int function(_object*, void*), void*) tp_traverse;
        int function(_object*) tp_clear;
        _object* function(_object*, _object*, int) tp_richcompare;
        c_long tp_weaklistoffset;
        _object* function(_object*) tp_iter;
        _object* function(_object*) tp_iternext;
        PyMethodDef* tp_methods;
        PyMemberDef* tp_members;
        PyGetSetDef* tp_getset;
        _typeobject* tp_base;
        _object* tp_dict;
        _object* function(_object*, _object*, _object*) tp_descr_get;
        int function(_object*, _object*, _object*) tp_descr_set;
        c_long tp_dictoffset;
        int function(_object*, _object*, _object*) tp_init;
        _object* function(_typeobject*, c_long) tp_alloc;
        _object* function(_typeobject*, _object*, _object*) tp_new;
        void function(void*) tp_free;
        int function(_object*) tp_is_gc;
        _object* tp_bases;
        _object* tp_mro;
        _object* tp_cache;
        _object* tp_subclasses;
        _object* tp_weaklist;
        void function(_object*) tp_del;
        uint tp_version_tag;
        void function(_object*) tp_finalize;
    }
    struct PyVarObject
    {
        _object ob_base;
        c_long ob_size;
    }
    int printf(const(char)*, ...) @nogc nothrow;
    int fprintf(_IO_FILE*, const(char)*, ...) @nogc nothrow;
    struct _Py_Identifier
    {
        _Py_Identifier* next;
        const(char)* string;
        _object* object;
    }
    void setlinebuf(_IO_FILE*) @nogc nothrow;
    void setbuffer(_IO_FILE*, char*, c_ulong) @nogc nothrow;
    alias unaryfunc = _object* function(_object*);
    alias binaryfunc = _object* function(_object*, _object*);
    alias ternaryfunc = _object* function(_object*, _object*, _object*);
    alias inquiry = int function(_object*);
    alias lenfunc = c_long function(_object*);
    alias ssizeargfunc = _object* function(_object*, c_long);
    alias ssizessizeargfunc = _object* function(_object*, c_long, c_long);
    alias ssizeobjargproc = int function(_object*, c_long, _object*);
    alias ssizessizeobjargproc = int function(_object*, c_long, c_long, _object*);
    alias objobjargproc = int function(_object*, _object*, _object*);
    alias Py_buffer = bufferinfo;
    struct bufferinfo
    {
        void* buf;
        _object* obj;
        c_long len;
        c_long itemsize;
        int readonly;
        int ndim;
        char* format;
        c_long* shape;
        c_long* strides;
        c_long* suboffsets;
        void* internal;
    }
    alias getbufferproc = int function(_object*, bufferinfo*, int);
    alias releasebufferproc = void function(_object*, bufferinfo*);
    int setvbuf(_IO_FILE*, char*, int, c_ulong) @nogc nothrow;
    void setbuf(_IO_FILE*, char*) @nogc nothrow;
    _IO_FILE* open_memstream(char**, c_ulong*) @nogc nothrow;
    _IO_FILE* fmemopen(void*, c_ulong, const(char)*) @nogc nothrow;
    _IO_FILE* fopencookie(void*, const(char)*, _IO_cookie_io_functions_t) @nogc nothrow;
    _IO_FILE* fdopen(int, const(char)*) @nogc nothrow;
    alias objobjproc = int function(_object*, _object*);
    alias visitproc = int function(_object*, void*);
    alias traverseproc = int function(_object*, int function(_object*, void*), void*);
    struct PyNumberMethods
    {
        _object* function(_object*, _object*) nb_add;
        _object* function(_object*, _object*) nb_subtract;
        _object* function(_object*, _object*) nb_multiply;
        _object* function(_object*, _object*) nb_remainder;
        _object* function(_object*, _object*) nb_divmod;
        _object* function(_object*, _object*, _object*) nb_power;
        _object* function(_object*) nb_negative;
        _object* function(_object*) nb_positive;
        _object* function(_object*) nb_absolute;
        int function(_object*) nb_bool;
        _object* function(_object*) nb_invert;
        _object* function(_object*, _object*) nb_lshift;
        _object* function(_object*, _object*) nb_rshift;
        _object* function(_object*, _object*) nb_and;
        _object* function(_object*, _object*) nb_xor;
        _object* function(_object*, _object*) nb_or;
        _object* function(_object*) nb_int;
        void* nb_reserved;
        _object* function(_object*) nb_float;
        _object* function(_object*, _object*) nb_inplace_add;
        _object* function(_object*, _object*) nb_inplace_subtract;
        _object* function(_object*, _object*) nb_inplace_multiply;
        _object* function(_object*, _object*) nb_inplace_remainder;
        _object* function(_object*, _object*, _object*) nb_inplace_power;
        _object* function(_object*, _object*) nb_inplace_lshift;
        _object* function(_object*, _object*) nb_inplace_rshift;
        _object* function(_object*, _object*) nb_inplace_and;
        _object* function(_object*, _object*) nb_inplace_xor;
        _object* function(_object*, _object*) nb_inplace_or;
        _object* function(_object*, _object*) nb_floor_divide;
        _object* function(_object*, _object*) nb_true_divide;
        _object* function(_object*, _object*) nb_inplace_floor_divide;
        _object* function(_object*, _object*) nb_inplace_true_divide;
        _object* function(_object*) nb_index;
        _object* function(_object*, _object*) nb_matrix_multiply;
        _object* function(_object*, _object*) nb_inplace_matrix_multiply;
    }
    struct PySequenceMethods
    {
        c_long function(_object*) sq_length;
        _object* function(_object*, _object*) sq_concat;
        _object* function(_object*, c_long) sq_repeat;
        _object* function(_object*, c_long) sq_item;
        void* was_sq_slice;
        int function(_object*, c_long, _object*) sq_ass_item;
        void* was_sq_ass_slice;
        int function(_object*, _object*) sq_contains;
        _object* function(_object*, _object*) sq_inplace_concat;
        _object* function(_object*, c_long) sq_inplace_repeat;
    }
    struct PyMappingMethods
    {
        c_long function(_object*) mp_length;
        _object* function(_object*, _object*) mp_subscript;
        int function(_object*, _object*, _object*) mp_ass_subscript;
    }
    struct PyAsyncMethods
    {
        _object* function(_object*) am_await;
        _object* function(_object*) am_aiter;
        _object* function(_object*) am_anext;
    }
    struct PyBufferProcs
    {
        int function(_object*, bufferinfo*, int) bf_getbuffer;
        void function(_object*, bufferinfo*) bf_releasebuffer;
    }
    alias freefunc = void function(void*);
    alias destructor = void function(_object*);
    alias printfunc = int function(_object*, _IO_FILE*, int);
    alias getattrfunc = _object* function(_object*, char*);
    alias getattrofunc = _object* function(_object*, _object*);
    alias setattrfunc = int function(_object*, char*, _object*);
    alias setattrofunc = int function(_object*, _object*, _object*);
    alias reprfunc = _object* function(_object*);
    alias hashfunc = c_long function(_object*);
    alias richcmpfunc = _object* function(_object*, _object*, int);
    alias getiterfunc = _object* function(_object*);
    alias iternextfunc = _object* function(_object*);
    alias descrgetfunc = _object* function(_object*, _object*, _object*);
    alias descrsetfunc = int function(_object*, _object*, _object*);
    alias initproc = int function(_object*, _object*, _object*);
    alias newfunc = _object* function(_typeobject*, _object*, _object*);
    alias allocfunc = _object* function(_typeobject*, c_long);
    alias PyTypeObject = _typeobject;
    struct PyMethodDef
    {
        const(char)* ml_name;
        _object* function(_object*, _object*) ml_meth;
        int ml_flags;
        const(char)* ml_doc;
    }
    struct PyMemberDef
    {
        const(char)* name;
        int type;
        c_long offset;
        int flags;
        const(char)* doc;
    }
    struct PyGetSetDef
    {
        const(char)* name;
        _object* function(_object*, void*) get;
        int function(_object*, _object*, void*) set;
        const(char)* doc;
        void* closure;
    }
    struct PyType_Slot
    {
        int slot;
        void* pfunc;
    }
    struct PyType_Spec
    {
        const(char)* name;
        int basicsize;
        int itemsize;
        uint flags;
        PyType_Slot* slots;
    }
    _object* PyType_FromSpec(PyType_Spec*) @nogc nothrow;
    _object* PyType_FromSpecWithBases(PyType_Spec*, _object*) @nogc nothrow;
    void* PyType_GetSlot(_typeobject*, int) @nogc nothrow;
    alias PyHeapTypeObject = _heaptypeobject;
    struct _heaptypeobject
    {
        _typeobject ht_type;
        PyAsyncMethods as_async;
        PyNumberMethods as_number;
        PyMappingMethods as_mapping;
        PySequenceMethods as_sequence;
        PyBufferProcs as_buffer;
        _object* ht_name;
        _object* ht_slots;
        _object* ht_qualname;
        _dictkeysobject* ht_cached_keys;
    }
    int PyType_IsSubtype(_typeobject*, _typeobject*) @nogc nothrow;
    _IO_FILE* freopen64(const(char)*, const(char)*, _IO_FILE*) @nogc nothrow;
    extern __gshared _typeobject PyType_Type;
    extern __gshared _typeobject PyBaseObject_Type;
    extern __gshared _typeobject PySuper_Type;
    c_ulong PyType_GetFlags(_typeobject*) @nogc nothrow;
    _IO_FILE* fopen64(const(char)*, const(char)*) @nogc nothrow;
    int PyType_Ready(_typeobject*) @nogc nothrow;
    _object* PyType_GenericAlloc(_typeobject*, c_long) @nogc nothrow;
    _object* PyType_GenericNew(_typeobject*, _object*, _object*) @nogc nothrow;
    const(char)* _PyType_Name(_typeobject*) @nogc nothrow;
    _object* _PyType_Lookup(_typeobject*, _object*) @nogc nothrow;
    _object* _PyType_LookupId(_typeobject*, _Py_Identifier*) @nogc nothrow;
    _object* _PyObject_LookupSpecial(_object*, _Py_Identifier*) @nogc nothrow;
    _typeobject* _PyType_CalculateMetaclass(_typeobject*, _object*) @nogc nothrow;
    uint PyType_ClearCache() @nogc nothrow;
    void PyType_Modified(_typeobject*) @nogc nothrow;
    _object* _PyType_GetDocFromInternalDoc(const(char)*, const(char)*) @nogc nothrow;
    _object* _PyType_GetTextSignatureFromInternalDoc(const(char)*, const(char)*) @nogc nothrow;
    int PyObject_Print(_object*, _IO_FILE*, int) @nogc nothrow;
    void _Py_BreakPoint() @nogc nothrow;
    void _PyObject_Dump(_object*) @nogc nothrow;
    _object* PyObject_Repr(_object*) @nogc nothrow;
    _object* PyObject_Str(_object*) @nogc nothrow;
    _object* PyObject_ASCII(_object*) @nogc nothrow;
    _object* PyObject_Bytes(_object*) @nogc nothrow;
    _object* PyObject_RichCompare(_object*, _object*, int) @nogc nothrow;
    int PyObject_RichCompareBool(_object*, _object*, int) @nogc nothrow;
    _object* PyObject_GetAttrString(_object*, const(char)*) @nogc nothrow;
    int PyObject_SetAttrString(_object*, const(char)*, _object*) @nogc nothrow;
    int PyObject_HasAttrString(_object*, const(char)*) @nogc nothrow;
    _object* PyObject_GetAttr(_object*, _object*) @nogc nothrow;
    int PyObject_SetAttr(_object*, _object*, _object*) @nogc nothrow;
    int PyObject_HasAttr(_object*, _object*) @nogc nothrow;
    int _PyObject_IsAbstract(_object*) @nogc nothrow;
    _object* _PyObject_GetAttrId(_object*, _Py_Identifier*) @nogc nothrow;
    int _PyObject_SetAttrId(_object*, _Py_Identifier*, _object*) @nogc nothrow;
    int _PyObject_HasAttrId(_object*, _Py_Identifier*) @nogc nothrow;
    int _PyObject_LookupAttr(_object*, _object*, _object**) @nogc nothrow;
    int _PyObject_LookupAttrId(_object*, _Py_Identifier*, _object**) @nogc nothrow;
    _object** _PyObject_GetDictPtr(_object*) @nogc nothrow;
    _object* PyObject_SelfIter(_object*) @nogc nothrow;
    _object* _PyObject_NextNotImplemented(_object*) @nogc nothrow;
    _object* PyObject_GenericGetAttr(_object*, _object*) @nogc nothrow;
    int PyObject_GenericSetAttr(_object*, _object*, _object*) @nogc nothrow;
    int PyObject_GenericSetDict(_object*, _object*, void*) @nogc nothrow;
    c_long PyObject_Hash(_object*) @nogc nothrow;
    c_long PyObject_HashNotImplemented(_object*) @nogc nothrow;
    int PyObject_IsTrue(_object*) @nogc nothrow;
    int PyObject_Not(_object*) @nogc nothrow;
    int PyCallable_Check(_object*) @nogc nothrow;
    void PyObject_ClearWeakRefs(_object*) @nogc nothrow;
    void PyObject_CallFinalizer(_object*) @nogc nothrow;
    int PyObject_CallFinalizerFromDealloc(_object*) @nogc nothrow;
    _object* _PyObject_GenericGetAttrWithDict(_object*, _object*, _object*, int) @nogc nothrow;
    int _PyObject_GenericSetAttrWithDict(_object*, _object*, _object*, _object*) @nogc nothrow;
    _object* _PyObject_GetBuiltin(const(char)*) @nogc nothrow;
    _object* PyObject_Dir(_object*) @nogc nothrow;
    int Py_ReprEnter(_object*) @nogc nothrow;
    void Py_ReprLeave(_object*) @nogc nothrow;
    _IO_FILE* freopen(const(char)*, const(char)*, _IO_FILE*) @nogc nothrow;
    _IO_FILE* fopen(const(char)*, const(char)*) @nogc nothrow;
    int fcloseall() @nogc nothrow;
    int fflush_unlocked(_IO_FILE*) @nogc nothrow;
    int fflush(_IO_FILE*) @nogc nothrow;
    int fclose(_IO_FILE*) @nogc nothrow;
    char* tempnam(const(char)*, const(char)*) @nogc nothrow;
    char* tmpnam_r(char*) @nogc nothrow;
    char* tmpnam(char*) @nogc nothrow;
    _IO_FILE* tmpfile64() @nogc nothrow;
    _IO_FILE* tmpfile() @nogc nothrow;
    int renameat2(int, const(char)*, int, const(char)*, uint) @nogc nothrow;
    void Py_IncRef(_object*) @nogc nothrow;
    void Py_DecRef(_object*) @nogc nothrow;
    extern __gshared _typeobject _PyNone_Type;
    extern __gshared _typeobject _PyNotImplemented_Type;
    extern __gshared _object _Py_NoneStruct;
    int renameat(int, const(char)*, int, const(char)*) @nogc nothrow;
    extern __gshared _object _Py_NotImplementedStruct;
    int rename(const(char)*, const(char)*) @nogc nothrow;
    int remove(const(char)*) @nogc nothrow;
    extern __gshared _IO_FILE* stderr;
    extern __gshared _IO_FILE* stdout;
    extern __gshared _IO_FILE* stdin;
    extern __gshared int[0] _Py_SwappedOp;
    void _PyTrash_deposit_object(_object*) @nogc nothrow;
    void _PyTrash_destroy_chain() @nogc nothrow;
    void _PyTrash_thread_deposit_object(_object*) @nogc nothrow;
    void _PyTrash_thread_destroy_chain() @nogc nothrow;
    alias fpos64_t = _G_fpos64_t;
    void _PyDebugAllocatorStats(_IO_FILE*, const(char)*, int, c_ulong) @nogc nothrow;
    void _PyObject_DebugTypeStats(_IO_FILE*) @nogc nothrow;
    void* PyObject_Malloc(c_ulong) @nogc nothrow;
    void* PyObject_Calloc(c_ulong, c_ulong) @nogc nothrow;
    void* PyObject_Realloc(void*, c_ulong) @nogc nothrow;
    void PyObject_Free(void*) @nogc nothrow;
    c_long _Py_GetAllocatedBlocks() @nogc nothrow;
    int _PyObject_DebugMallocStats(_IO_FILE*) @nogc nothrow;
    alias fpos_t = _G_fpos64_t;
    alias ssize_t = c_long;
    alias off64_t = c_long;
    _object* PyObject_Init(_object*, _typeobject*) @nogc nothrow;
    PyVarObject* PyObject_InitVar(PyVarObject*, _typeobject*, c_long) @nogc nothrow;
    _object* _PyObject_New(_typeobject*) @nogc nothrow;
    PyVarObject* _PyObject_NewVar(_typeobject*, c_long) @nogc nothrow;
    alias off_t = c_long;
    struct PyObjectArenaAllocator
    {
        void* ctx;
        void* function(void*, c_ulong) alloc;
        void function(void*, void*, c_ulong) free;
    }
    void PyObject_GetArenaAllocator(PyObjectArenaAllocator*) @nogc nothrow;
    void PyObject_SetArenaAllocator(PyObjectArenaAllocator*) @nogc nothrow;
    c_long PyGC_Collect() @nogc nothrow;
    c_long _PyGC_CollectNoFail() @nogc nothrow;
    c_long _PyGC_CollectIfEnabled() @nogc nothrow;
    PyVarObject* _PyObject_GC_Resize(PyVarObject*, c_long) @nogc nothrow;
    alias PyGC_Head = _gc_head;
    union _gc_head
    {
        static struct _Anonymous_35
        {
            _gc_head* gc_next;
            _gc_head* gc_prev;
            c_long gc_refs;
        }
        _Anonymous_35 gc;
        double dummy;
    }
    extern __gshared _gc_head* _PyGC_generation0;
    _object* _PyObject_GC_Malloc(c_ulong) @nogc nothrow;
    _object* _PyObject_GC_Calloc(c_ulong) @nogc nothrow;
    _object* _PyObject_GC_New(_typeobject*) @nogc nothrow;
    PyVarObject* _PyObject_GC_NewVar(_typeobject*, c_long) @nogc nothrow;
    void PyObject_GC_Track(void*) @nogc nothrow;
    void PyObject_GC_UnTrack(void*) @nogc nothrow;
    void PyObject_GC_Del(void*) @nogc nothrow;
    alias uintmax_t = c_ulong;
    alias intmax_t = c_long;
    alias uintptr_t = c_ulong;
    alias PyODictObject = _odictobject;
    struct _odictobject;
    extern __gshared _typeobject PyODict_Type;
    extern __gshared _typeobject PyODictIter_Type;
    extern __gshared _typeobject PyODictKeys_Type;
    extern __gshared _typeobject PyODictItems_Type;
    extern __gshared _typeobject PyODictValues_Type;
    alias uint_fast64_t = c_ulong;
    alias uint_fast32_t = c_ulong;
    alias uint_fast16_t = c_ulong;
    _object* PyODict_New() @nogc nothrow;
    int PyODict_SetItem(_object*, _object*, _object*) @nogc nothrow;
    int PyODict_DelItem(_object*, _object*) @nogc nothrow;
    alias uint_fast8_t = ubyte;
    alias int_fast64_t = c_long;
    alias int_fast32_t = c_long;
    alias int_fast16_t = c_long;
    _object* PyOS_FSPath(_object*) @nogc nothrow;
    alias int_fast8_t = byte;
    alias uint_least64_t = c_ulong;
    alias uint_least32_t = uint;
    alias uint_least16_t = ushort;
    alias uint_least8_t = ubyte;
    alias int_least64_t = c_long;
    alias int_least32_t = int;
    alias int_least16_t = short;
    alias int_least8_t = byte;
    alias PyArena = _arena;
    struct _arena;
    _arena* PyArena_New() @nogc nothrow;
    void PyArena_Free(_arena*) @nogc nothrow;
    void* PyArena_Malloc(_arena*, c_ulong) @nogc nothrow;
    int PyArena_AddPyObject(_arena*, _object*) @nogc nothrow;
    extern __gshared _typeobject PyCapsule_Type;
    alias PyCapsule_Destructor = void function(_object*);
    _object* PyCapsule_New(void*, const(char)*, void function(_object*)) @nogc nothrow;
    void* PyCapsule_GetPointer(_object*, const(char)*) @nogc nothrow;
    void function(_object*) PyCapsule_GetDestructor(_object*) @nogc nothrow;
    const(char)* PyCapsule_GetName(_object*) @nogc nothrow;
    void* PyCapsule_GetContext(_object*) @nogc nothrow;
    int PyCapsule_IsValid(_object*, const(char)*) @nogc nothrow;
    int PyCapsule_SetPointer(_object*, void*) @nogc nothrow;
    int PyCapsule_SetDestructor(_object*, void function(_object*)) @nogc nothrow;
    int PyCapsule_SetName(_object*, const(char)*) @nogc nothrow;
    int PyCapsule_SetContext(_object*, void*) @nogc nothrow;
    void* PyCapsule_Import(const(char)*, int) @nogc nothrow;
    int sched_getaffinity(int, c_ulong, cpu_set_t*) @nogc nothrow;
    int sched_setaffinity(int, c_ulong, const(cpu_set_t)*) @nogc nothrow;
    int sched_rr_get_interval(int, timespec*) @nogc nothrow;
    int sched_get_priority_min(int) @nogc nothrow;
    int sched_get_priority_max(int) @nogc nothrow;
    int sched_yield() @nogc nothrow;
    int sched_getscheduler(int) @nogc nothrow;
    int sched_setscheduler(int, int, const(sched_param)*) @nogc nothrow;
    int sched_getparam(int, sched_param*) @nogc nothrow;
    int sched_setparam(int, const(sched_param)*) @nogc nothrow;
    void _PyWeakref_ClearRef(_PyWeakReference*) @nogc nothrow;
    c_long _PyWeakref_GetWeakrefCount(_PyWeakReference*) @nogc nothrow;
    _object* PyWeakref_GetObject(_object*) @nogc nothrow;
    _object* PyWeakref_NewProxy(_object*, _object*) @nogc nothrow;
    _object* PyWeakref_NewRef(_object*, _object*) @nogc nothrow;
    extern __gshared _typeobject _PyWeakref_CallableProxyType;
    extern __gshared _typeobject _PyWeakref_ProxyType;
    extern __gshared _typeobject _PyWeakref_RefType;
    struct _PyWeakReference
    {
        _object ob_base;
        _object* wr_object;
        _object* wr_callback;
        c_long hash;
        _PyWeakReference* wr_prev;
        _PyWeakReference* wr_next;
    }
    alias PyWeakReference = _PyWeakReference;
    void _PyErr_WarnUnawaitedCoroutine(_object*) @nogc nothrow;
    int PyErr_WarnExplicitFormat(_object*, const(char)*, int, const(char)*, _object*, const(char)*, ...) @nogc nothrow;
    int PyErr_WarnExplicit(_object*, const(char)*, const(char)*, int, const(char)*, _object*) @nogc nothrow;
    int PyErr_WarnExplicitObject(_object*, _object*, _object*, int, _object*, _object*) @nogc nothrow;
    int PyErr_ResourceWarning(_object*, c_long, const(char)*, ...) @nogc nothrow;
    int PyErr_WarnFormat(_object*, c_long, const(char)*, ...) @nogc nothrow;
    int PyErr_WarnEx(_object*, const(char)*, c_long) @nogc nothrow;
    _object* _PyWarnings_Init() @nogc nothrow;
    int _PyUnicode_EQ(_object*, _object*) @nogc nothrow;
    void _PyUnicode_ClearStaticStrings() @nogc nothrow;
    _object* _PyUnicode_FromId(_Py_Identifier*) @nogc nothrow;
    int* PyUnicode_AsUnicodeCopy(_object*) @nogc nothrow;
    _object* _PyUnicode_FormatLong(_object*, int, int, int) @nogc nothrow;
    int* Py_UNICODE_strrchr(const(int)*, int) @nogc nothrow;
    int* Py_UNICODE_strchr(const(int)*, int) @nogc nothrow;
    int Py_UNICODE_strncmp(const(int)*, const(int)*, c_ulong) @nogc nothrow;
    int Py_UNICODE_strcmp(const(int)*, const(int)*) @nogc nothrow;
    int* Py_UNICODE_strncpy(int*, const(int)*, c_ulong) @nogc nothrow;
    int* Py_UNICODE_strcat(int*, const(int)*) @nogc nothrow;
    int* Py_UNICODE_strcpy(int*, const(int)*) @nogc nothrow;
    c_ulong Py_UNICODE_strlen(const(int)*) @nogc nothrow;
    int _PyUnicode_IsAlpha(uint) @nogc nothrow;
    int _PyUnicode_IsPrintable(uint) @nogc nothrow;
    int _PyUnicode_IsNumeric(uint) @nogc nothrow;
    int _PyUnicode_IsDigit(uint) @nogc nothrow;
    int _PyUnicode_IsDecimalDigit(uint) @nogc nothrow;
    double _PyUnicode_ToNumeric(uint) @nogc nothrow;
    int _PyUnicode_ToDigit(uint) @nogc nothrow;
    int _PyUnicode_ToDecimalDigit(uint) @nogc nothrow;
    int _PyUnicode_IsCased(uint) @nogc nothrow;
    int _PyUnicode_IsCaseIgnorable(uint) @nogc nothrow;
    int _PyUnicode_ToFoldedFull(uint, uint*) @nogc nothrow;
    int _PyUnicode_ToUpperFull(uint, uint*) @nogc nothrow;
    int _PyUnicode_ToTitleFull(uint, uint*) @nogc nothrow;
    int _PyUnicode_ToLowerFull(uint, uint*) @nogc nothrow;
    uint _PyUnicode_ToTitlecase(uint) @nogc nothrow;
    uint _PyUnicode_ToUppercase(uint) @nogc nothrow;
    uint _PyUnicode_ToLowercase(uint) @nogc nothrow;
    int _PyUnicode_IsLinebreak(const(uint)) @nogc nothrow;
    int _PyUnicode_IsWhitespace(const(uint)) @nogc nothrow;
    int _PyUnicode_IsXidContinue(uint) @nogc nothrow;
    int _PyUnicode_IsXidStart(uint) @nogc nothrow;
    int _PyUnicode_IsTitlecase(uint) @nogc nothrow;
    int _PyUnicode_IsUppercase(uint) @nogc nothrow;
    int _PyUnicode_IsLowercase(uint) @nogc nothrow;
    extern __gshared const(ubyte)[0] _Py_ascii_whitespace;
    c_long _PyUnicode_InsertThousandsGrouping(_object*, c_long, c_long, void*, c_long, c_long, const(char)*, _object*, uint*) @nogc nothrow;
    _object* _PyUnicode_XStrip(_object*, int, _object*) @nogc nothrow;
    int PyUnicode_IsIdentifier(_object*) @nogc nothrow;
    int PyUnicode_Contains(_object*, _object*) @nogc nothrow;
    _object* PyUnicode_Format(_object*, _object*) @nogc nothrow;
    _object* PyUnicode_RichCompare(_object*, _object*, int) @nogc nothrow;
    int _PyUnicode_EqualToASCIIString(_object*, const(char)*) @nogc nothrow;
    int PyUnicode_CompareWithASCIIString(_object*, const(char)*) @nogc nothrow;
    int _PyUnicode_EqualToASCIIId(_object*, _Py_Identifier*) @nogc nothrow;
    int PyUnicode_Compare(_object*, _object*) @nogc nothrow;
    _object* PyUnicode_Replace(_object*, _object*, _object*, c_long) @nogc nothrow;
    c_long PyUnicode_Count(_object*, _object*, c_long, c_long) @nogc nothrow;
    c_long PyUnicode_FindChar(_object*, uint, c_long, c_long, int) @nogc nothrow;
    c_long PyUnicode_Find(_object*, _object*, c_long, c_long, int) @nogc nothrow;
    c_long PyUnicode_Tailmatch(_object*, _object*, c_long, c_long, int) @nogc nothrow;
    _object* _PyUnicode_JoinArray(_object*, _object**, c_long) @nogc nothrow;
    _object* PyUnicode_Join(_object*, _object*) @nogc nothrow;
    _object* PyUnicode_Translate(_object*, _object*, const(char)*) @nogc nothrow;
    _object* PyUnicode_RSplit(_object*, _object*, c_long) @nogc nothrow;
    _object* PyUnicode_RPartition(_object*, _object*) @nogc nothrow;
    _object* PyUnicode_Partition(_object*, _object*) @nogc nothrow;
    _object* PyUnicode_Splitlines(_object*, int) @nogc nothrow;
    _object* PyUnicode_Split(_object*, _object*, c_long) @nogc nothrow;
    void PyUnicode_AppendAndDel(_object**, _object*) @nogc nothrow;
    void PyUnicode_Append(_object**, _object*) @nogc nothrow;
    _object* PyUnicode_Concat(_object*, _object*) @nogc nothrow;
    _object* PyUnicode_EncodeFSDefault(_object*) @nogc nothrow;
    _object* PyUnicode_DecodeFSDefaultAndSize(const(char)*, c_long) @nogc nothrow;
    _object* PyUnicode_DecodeFSDefault(const(char)*) @nogc nothrow;
    int PyUnicode_FSDecoder(_object*, void*) @nogc nothrow;
    int PyUnicode_FSConverter(_object*, void*) @nogc nothrow;
    _object* PyUnicode_EncodeLocale(_object*, const(char)*) @nogc nothrow;
    _object* PyUnicode_DecodeLocale(const(char)*, const(char)*) @nogc nothrow;
    _object* PyUnicode_DecodeLocaleAndSize(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* _PyUnicode_TransformDecimalAndSpaceToASCII(_object*) @nogc nothrow;
    _object* PyUnicode_TransformDecimalToASCII(int*, c_long) @nogc nothrow;
    int PyUnicode_EncodeDecimal(int*, c_long, char*, const(char)*) @nogc nothrow;
    _object* PyUnicode_TranslateCharmap(const(int)*, c_long, _object*, const(char)*) @nogc nothrow;
    _object* _PyUnicode_EncodeCharmap(_object*, _object*, const(char)*) @nogc nothrow;
    _object* PyUnicode_EncodeCharmap(const(int)*, c_long, _object*, const(char)*) @nogc nothrow;
    _object* PyUnicode_AsCharmapString(_object*, _object*) @nogc nothrow;
    _object* PyUnicode_DecodeCharmap(const(char)*, c_long, _object*, const(char)*) @nogc nothrow;
    _object* PyUnicode_EncodeASCII(const(int)*, c_long, const(char)*) @nogc nothrow;
    _object* _PyUnicode_AsASCIIString(_object*, const(char)*) @nogc nothrow;
    _object* PyUnicode_AsASCIIString(_object*) @nogc nothrow;
    _object* PyUnicode_DecodeASCII(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicode_EncodeLatin1(const(int)*, c_long, const(char)*) @nogc nothrow;
    _object* _PyUnicode_AsLatin1String(_object*, const(char)*) @nogc nothrow;
    _object* PyUnicode_AsLatin1String(_object*) @nogc nothrow;
    _object* PyUnicode_DecodeLatin1(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* _PyUnicode_DecodeUnicodeInternal(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicode_EncodeRawUnicodeEscape(const(int)*, c_long) @nogc nothrow;
    _object* PyUnicode_AsRawUnicodeEscapeString(_object*) @nogc nothrow;
    _object* PyUnicode_DecodeRawUnicodeEscape(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicode_EncodeUnicodeEscape(const(int)*, c_long) @nogc nothrow;
    _object* PyUnicode_AsUnicodeEscapeString(_object*) @nogc nothrow;
    _object* _PyUnicode_DecodeUnicodeEscape(const(char)*, c_long, const(char)*, const(char)**) @nogc nothrow;
    _object* PyUnicode_DecodeUnicodeEscape(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* _PyUnicode_EncodeUTF16(_object*, const(char)*, int) @nogc nothrow;
    _object* PyUnicode_EncodeUTF16(const(int)*, c_long, const(char)*, int) @nogc nothrow;
    _object* PyUnicode_AsUTF16String(_object*) @nogc nothrow;
    _object* PyUnicode_DecodeUTF16Stateful(const(char)*, c_long, const(char)*, int*, c_long*) @nogc nothrow;
    _object* PyUnicode_DecodeUTF16(const(char)*, c_long, const(char)*, int*) @nogc nothrow;
    _object* _PyUnicode_EncodeUTF32(_object*, const(char)*, int) @nogc nothrow;
    _object* PyUnicode_EncodeUTF32(const(int)*, c_long, const(char)*, int) @nogc nothrow;
    _object* PyUnicode_AsUTF32String(_object*) @nogc nothrow;
    _object* PyUnicode_DecodeUTF32Stateful(const(char)*, c_long, const(char)*, int*, c_long*) @nogc nothrow;
    _object* PyUnicode_DecodeUTF32(const(char)*, c_long, const(char)*, int*) @nogc nothrow;
    _object* PyUnicode_EncodeUTF8(const(int)*, c_long, const(char)*) @nogc nothrow;
    _object* _PyUnicode_AsUTF8String(_object*, const(char)*) @nogc nothrow;
    _object* PyUnicode_AsUTF8String(_object*) @nogc nothrow;
    _object* PyUnicode_DecodeUTF8Stateful(const(char)*, c_long, const(char)*, c_long*) @nogc nothrow;
    _object* PyUnicode_DecodeUTF8(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* _PyUnicode_EncodeUTF7(_object*, int, int, const(char)*) @nogc nothrow;
    _object* PyUnicode_EncodeUTF7(const(int)*, c_long, int, int, const(char)*) @nogc nothrow;
    _object* PyUnicode_DecodeUTF7Stateful(const(char)*, c_long, const(char)*, c_long*) @nogc nothrow;
    _object* PyUnicode_DecodeUTF7(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicode_BuildEncodingMap(_object*) @nogc nothrow;
    _object* PyUnicode_AsEncodedUnicode(_object*, const(char)*, const(char)*) @nogc nothrow;
    _object* PyUnicode_AsEncodedString(_object*, const(char)*, const(char)*) @nogc nothrow;
    _object* PyUnicode_AsEncodedObject(_object*, const(char)*, const(char)*) @nogc nothrow;
    _object* PyUnicode_Encode(const(int)*, c_long, const(char)*, const(char)*) @nogc nothrow;
    _object* PyUnicode_AsDecodedUnicode(_object*, const(char)*, const(char)*) @nogc nothrow;
    _object* PyUnicode_AsDecodedObject(_object*, const(char)*, const(char)*) @nogc nothrow;
    _object* PyUnicode_Decode(const(char)*, c_long, const(char)*, const(char)*) @nogc nothrow;
    const(char)* PyUnicode_GetDefaultEncoding() @nogc nothrow;
    const(char)* PyUnicode_AsUTF8(_object*) @nogc nothrow;
    const(char)* PyUnicode_AsUTF8AndSize(_object*, c_long*) @nogc nothrow;
    int PyUnicode_ClearFreeList() @nogc nothrow;
    _object* PyUnicode_FromOrdinal(int) @nogc nothrow;
    void* _PyUnicode_AsKind(_object*, uint) @nogc nothrow;
    int* PyUnicode_AsWideCharString(_object*, c_long*) @nogc nothrow;
    c_long PyUnicode_AsWideChar(_object*, int*, c_long) @nogc nothrow;
    _object* PyUnicode_FromWideChar(const(int)*, c_long) @nogc nothrow;
    void _Py_ReleaseInternedUnicodeStrings() @nogc nothrow;
    _object* PyUnicode_InternFromString(const(char)*) @nogc nothrow;
    void PyUnicode_InternImmortal(_object**) @nogc nothrow;
    void PyUnicode_InternInPlace(_object**) @nogc nothrow;
    int _PyUnicode_FormatAdvancedWriter(_PyUnicodeWriter*, _object*, _object*, c_long, c_long) @nogc nothrow;
    void _PyUnicodeWriter_Dealloc(_PyUnicodeWriter*) @nogc nothrow;
    _object* _PyUnicodeWriter_Finish(_PyUnicodeWriter*) @nogc nothrow;
    int _PyUnicodeWriter_WriteLatin1String(_PyUnicodeWriter*, const(char)*, c_long) @nogc nothrow;
    int _PyUnicodeWriter_WriteASCIIString(_PyUnicodeWriter*, const(char)*, c_long) @nogc nothrow;
    int _PyUnicodeWriter_WriteSubstring(_PyUnicodeWriter*, _object*, c_long, c_long) @nogc nothrow;
    int _PyUnicodeWriter_WriteStr(_PyUnicodeWriter*, _object*) @nogc nothrow;
    int _PyUnicodeWriter_WriteChar(_PyUnicodeWriter*, uint) @nogc nothrow;
    int _PyUnicodeWriter_PrepareKindInternal(_PyUnicodeWriter*, PyUnicode_Kind) @nogc nothrow;
    int _PyUnicodeWriter_PrepareInternal(_PyUnicodeWriter*, c_long, uint) @nogc nothrow;
    void _PyUnicodeWriter_Init(_PyUnicodeWriter*) @nogc nothrow;
    struct _PyUnicodeWriter
    {
        _object* buffer;
        void* data;
        PyUnicode_Kind kind;
        uint maxchar;
        c_long size;
        c_long pos;
        c_long min_length;
        uint min_char;
        ubyte overallocate;
        ubyte readonly;
    }
    _object* PyUnicode_FromFormat(const(char)*, ...) @nogc nothrow;
    _object* PyUnicode_FromFormatV(const(char)*, va_list*) @nogc nothrow;
    _object* PyUnicode_FromObject(_object*) @nogc nothrow;
    extern __gshared const(uint)[256] _Py_ctype_table;
    _object* PyUnicode_FromEncodedObject(_object*, const(char)*, const(char)*) @nogc nothrow;
    int PyUnicode_Resize(_object**, c_long) @nogc nothrow;
    int PyUnicode_GetMax() @nogc nothrow;
    extern __gshared const(ubyte)[256] _Py_ctype_tolower;
    extern __gshared const(ubyte)[256] _Py_ctype_toupper;
    int PyUnicode_WriteChar(_object*, c_long, uint) @nogc nothrow;
    extern __gshared int Py_DebugFlag;
    extern __gshared int Py_VerboseFlag;
    extern __gshared int Py_QuietFlag;
    extern __gshared int Py_InteractiveFlag;
    extern __gshared int Py_InspectFlag;
    extern __gshared int Py_OptimizeFlag;
    extern __gshared int Py_NoSiteFlag;
    extern __gshared int Py_BytesWarningFlag;
    extern __gshared int Py_FrozenFlag;
    extern __gshared int Py_IgnoreEnvironmentFlag;
    extern __gshared int Py_DontWriteBytecodeFlag;
    extern __gshared int Py_NoUserSiteDirectory;
    extern __gshared int Py_UnbufferedStdioFlag;
    extern __gshared int Py_HashRandomizationFlag;
    extern __gshared int Py_IsolatedFlag;
    uint PyUnicode_ReadChar(_object*, c_long) @nogc nothrow;
    struct PyBaseExceptionObject
    {
        _object ob_base;
        _object* dict;
        _object* args;
        _object* traceback;
        _object* context;
        _object* cause;
        char suppress_context;
    }
    struct PySyntaxErrorObject
    {
        _object ob_base;
        _object* dict;
        _object* args;
        _object* traceback;
        _object* context;
        _object* cause;
        char suppress_context;
        _object* msg;
        _object* filename;
        _object* lineno;
        _object* offset;
        _object* text;
        _object* print_file_and_line;
    }
    struct PyImportErrorObject
    {
        _object ob_base;
        _object* dict;
        _object* args;
        _object* traceback;
        _object* context;
        _object* cause;
        char suppress_context;
        _object* msg;
        _object* name;
        _object* path;
    }
    struct PyUnicodeErrorObject
    {
        _object ob_base;
        _object* dict;
        _object* args;
        _object* traceback;
        _object* context;
        _object* cause;
        char suppress_context;
        _object* encoding;
        _object* object;
        c_long start;
        c_long end;
        _object* reason;
    }
    struct PySystemExitObject
    {
        _object ob_base;
        _object* dict;
        _object* args;
        _object* traceback;
        _object* context;
        _object* cause;
        char suppress_context;
        _object* code;
    }
    struct PyOSErrorObject
    {
        _object ob_base;
        _object* dict;
        _object* args;
        _object* traceback;
        _object* context;
        _object* cause;
        char suppress_context;
        _object* myerrno;
        _object* strerror;
        _object* filename;
        _object* filename2;
        c_long written;
    }
    struct PyStopIterationObject
    {
        _object ob_base;
        _object* dict;
        _object* args;
        _object* traceback;
        _object* context;
        _object* cause;
        char suppress_context;
        _object* value;
    }
    alias PyEnvironmentErrorObject = PyOSErrorObject;
    void PyErr_SetNone(_object*) @nogc nothrow;
    void PyErr_SetObject(_object*, _object*) @nogc nothrow;
    void _PyErr_SetKeyError(_object*) @nogc nothrow;
    _err_stackitem* _PyErr_GetTopmostException(_ts*) @nogc nothrow;
    void PyErr_SetString(_object*, const(char)*) @nogc nothrow;
    _object* PyErr_Occurred() @nogc nothrow;
    void PyErr_Clear() @nogc nothrow;
    void PyErr_Fetch(_object**, _object**, _object**) @nogc nothrow;
    void PyErr_Restore(_object*, _object*, _object*) @nogc nothrow;
    void PyErr_GetExcInfo(_object**, _object**, _object**) @nogc nothrow;
    void PyErr_SetExcInfo(_object*, _object*, _object*) @nogc nothrow;
    c_long PyUnicode_GetSize(_object*) @nogc nothrow;
    void Py_FatalError(const(char)*) @nogc nothrow;
    int PyErr_GivenExceptionMatches(_object*, _object*) @nogc nothrow;
    int PyErr_ExceptionMatches(_object*) @nogc nothrow;
    void PyErr_NormalizeException(_object**, _object**, _object**) @nogc nothrow;
    int PyException_SetTraceback(_object*, _object*) @nogc nothrow;
    _object* PyException_GetTraceback(_object*) @nogc nothrow;
    _object* PyException_GetCause(_object*) @nogc nothrow;
    void PyException_SetCause(_object*, _object*) @nogc nothrow;
    _object* PyException_GetContext(_object*) @nogc nothrow;
    void PyException_SetContext(_object*, _object*) @nogc nothrow;
    void _PyErr_ChainExceptions(_object*, _object*, _object*) @nogc nothrow;
    c_long PyUnicode_GetLength(_object*) @nogc nothrow;
    int* PyUnicode_AsUnicodeAndSize(_object*, c_long*) @nogc nothrow;
    extern __gshared _object* PyExc_BaseException;
    extern __gshared _object* PyExc_Exception;
    extern __gshared _object* PyExc_StopAsyncIteration;
    extern __gshared _object* PyExc_StopIteration;
    extern __gshared _object* PyExc_GeneratorExit;
    extern __gshared _object* PyExc_ArithmeticError;
    extern __gshared _object* PyExc_LookupError;
    extern __gshared _object* PyExc_AssertionError;
    extern __gshared _object* PyExc_AttributeError;
    extern __gshared _object* PyExc_BufferError;
    extern __gshared _object* PyExc_EOFError;
    extern __gshared _object* PyExc_FloatingPointError;
    extern __gshared _object* PyExc_OSError;
    extern __gshared _object* PyExc_ImportError;
    extern __gshared _object* PyExc_ModuleNotFoundError;
    extern __gshared _object* PyExc_IndexError;
    extern __gshared _object* PyExc_KeyError;
    extern __gshared _object* PyExc_KeyboardInterrupt;
    extern __gshared _object* PyExc_MemoryError;
    extern __gshared _object* PyExc_NameError;
    extern __gshared _object* PyExc_OverflowError;
    extern __gshared _object* PyExc_RuntimeError;
    extern __gshared _object* PyExc_RecursionError;
    extern __gshared _object* PyExc_NotImplementedError;
    extern __gshared _object* PyExc_SyntaxError;
    extern __gshared _object* PyExc_IndentationError;
    extern __gshared _object* PyExc_TabError;
    extern __gshared _object* PyExc_ReferenceError;
    extern __gshared _object* PyExc_SystemError;
    extern __gshared _object* PyExc_SystemExit;
    extern __gshared _object* PyExc_TypeError;
    extern __gshared _object* PyExc_UnboundLocalError;
    extern __gshared _object* PyExc_UnicodeError;
    extern __gshared _object* PyExc_UnicodeEncodeError;
    extern __gshared _object* PyExc_UnicodeDecodeError;
    extern __gshared _object* PyExc_UnicodeTranslateError;
    extern __gshared _object* PyExc_ValueError;
    extern __gshared _object* PyExc_ZeroDivisionError;
    extern __gshared _object* PyExc_BlockingIOError;
    extern __gshared _object* PyExc_BrokenPipeError;
    extern __gshared _object* PyExc_ChildProcessError;
    extern __gshared _object* PyExc_ConnectionError;
    extern __gshared _object* PyExc_ConnectionAbortedError;
    extern __gshared _object* PyExc_ConnectionRefusedError;
    extern __gshared _object* PyExc_ConnectionResetError;
    extern __gshared _object* PyExc_FileExistsError;
    extern __gshared _object* PyExc_FileNotFoundError;
    extern __gshared _object* PyExc_InterruptedError;
    extern __gshared _object* PyExc_IsADirectoryError;
    extern __gshared _object* PyExc_NotADirectoryError;
    extern __gshared _object* PyExc_PermissionError;
    extern __gshared _object* PyExc_ProcessLookupError;
    extern __gshared _object* PyExc_TimeoutError;
    extern __gshared _object* PyExc_EnvironmentError;
    extern __gshared _object* PyExc_IOError;
    extern __gshared _object* PyExc_Warning;
    extern __gshared _object* PyExc_UserWarning;
    extern __gshared _object* PyExc_DeprecationWarning;
    extern __gshared _object* PyExc_PendingDeprecationWarning;
    extern __gshared _object* PyExc_SyntaxWarning;
    extern __gshared _object* PyExc_RuntimeWarning;
    extern __gshared _object* PyExc_FutureWarning;
    extern __gshared _object* PyExc_ImportWarning;
    extern __gshared _object* PyExc_UnicodeWarning;
    extern __gshared _object* PyExc_BytesWarning;
    extern __gshared _object* PyExc_ResourceWarning;
    int PyErr_BadArgument() @nogc nothrow;
    _object* PyErr_NoMemory() @nogc nothrow;
    _object* PyErr_SetFromErrno(_object*) @nogc nothrow;
    _object* PyErr_SetFromErrnoWithFilenameObject(_object*, _object*) @nogc nothrow;
    _object* PyErr_SetFromErrnoWithFilenameObjects(_object*, _object*, _object*) @nogc nothrow;
    _object* PyErr_SetFromErrnoWithFilename(_object*, const(char)*) @nogc nothrow;
    _object* PyErr_Format(_object*, const(char)*, ...) @nogc nothrow;
    _object* PyErr_FormatV(_object*, const(char)*, va_list*) @nogc nothrow;
    _object* _PyErr_FormatFromCause(_object*, const(char)*, ...) @nogc nothrow;
    _object* PyErr_SetImportErrorSubclass(_object*, _object*, _object*, _object*) @nogc nothrow;
    _object* PyErr_SetImportError(_object*, _object*, _object*) @nogc nothrow;
    pragma(mangle, "PyErr_BadInternalCall") void PyErr_BadInternalCall_() @nogc nothrow;
    void _PyErr_BadInternalCall(const(char)*, int) @nogc nothrow;
    const(int)* _PyUnicode_AsUnicode(_object*) @nogc nothrow;
    _object* PyErr_NewException(const(char)*, _object*, _object*) @nogc nothrow;
    _object* PyErr_NewExceptionWithDoc(const(char)*, const(char)*, _object*, _object*) @nogc nothrow;
    void PyErr_WriteUnraisable(_object*) @nogc nothrow;
    _object* _PyErr_TrySetFromCause(const(char)*, ...) @nogc nothrow;
    int PyErr_CheckSignals() @nogc nothrow;
    void PyErr_SetInterrupt() @nogc nothrow;
    int PySignal_SetWakeupFd(int) @nogc nothrow;
    void PyErr_SyntaxLocation(const(char)*, int) @nogc nothrow;
    void PyErr_SyntaxLocationEx(const(char)*, int, int) @nogc nothrow;
    void PyErr_SyntaxLocationObject(_object*, int, int) @nogc nothrow;
    _object* PyErr_ProgramText(const(char)*, int) @nogc nothrow;
    _object* PyErr_ProgramTextObject(_object*, int) @nogc nothrow;
    _object* PyUnicodeDecodeError_Create(const(char)*, const(char)*, c_long, c_long, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicodeEncodeError_Create(const(char)*, const(int)*, c_long, c_long, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicodeTranslateError_Create(const(int)*, c_long, c_long, c_long, const(char)*) @nogc nothrow;
    _object* _PyUnicodeTranslateError_Create(_object*, c_long, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicodeEncodeError_GetEncoding(_object*) @nogc nothrow;
    _object* PyUnicodeDecodeError_GetEncoding(_object*) @nogc nothrow;
    _object* PyUnicodeEncodeError_GetObject(_object*) @nogc nothrow;
    _object* PyUnicodeDecodeError_GetObject(_object*) @nogc nothrow;
    _object* PyUnicodeTranslateError_GetObject(_object*) @nogc nothrow;
    int PyUnicodeEncodeError_GetStart(_object*, c_long*) @nogc nothrow;
    int PyUnicodeDecodeError_GetStart(_object*, c_long*) @nogc nothrow;
    int PyUnicodeTranslateError_GetStart(_object*, c_long*) @nogc nothrow;
    int PyUnicodeEncodeError_SetStart(_object*, c_long) @nogc nothrow;
    int PyUnicodeDecodeError_SetStart(_object*, c_long) @nogc nothrow;
    int PyUnicodeTranslateError_SetStart(_object*, c_long) @nogc nothrow;
    int PyUnicodeEncodeError_GetEnd(_object*, c_long*) @nogc nothrow;
    int PyUnicodeDecodeError_GetEnd(_object*, c_long*) @nogc nothrow;
    int PyUnicodeTranslateError_GetEnd(_object*, c_long*) @nogc nothrow;
    int PyUnicodeEncodeError_SetEnd(_object*, c_long) @nogc nothrow;
    int PyUnicodeDecodeError_SetEnd(_object*, c_long) @nogc nothrow;
    int PyUnicodeTranslateError_SetEnd(_object*, c_long) @nogc nothrow;
    _object* PyUnicodeEncodeError_GetReason(_object*) @nogc nothrow;
    _object* PyUnicodeDecodeError_GetReason(_object*) @nogc nothrow;
    _object* PyUnicodeTranslateError_GetReason(_object*) @nogc nothrow;
    int PyUnicodeEncodeError_SetReason(_object*, const(char)*) @nogc nothrow;
    int PyUnicodeDecodeError_SetReason(_object*, const(char)*) @nogc nothrow;
    int PyUnicodeTranslateError_SetReason(_object*, const(char)*) @nogc nothrow;
    int PyOS_snprintf(char*, c_ulong, const(char)*, ...) @nogc nothrow;
    int PyOS_vsnprintf(char*, c_ulong, const(char)*, va_list*) @nogc nothrow;
    int* PyUnicode_AsUnicode(_object*) @nogc nothrow;
    uint* PyUnicode_AsUCS4Copy(_object*) @nogc nothrow;
    c_long _Py_HashDouble(double) @nogc nothrow;
    c_long _Py_HashPointer(void*) @nogc nothrow;
    c_long _Py_HashBytes(const(void)*, c_long) @nogc nothrow;
    uint* PyUnicode_AsUCS4(_object*, uint*, c_long, int) @nogc nothrow;
    uint _PyUnicode_FindMaxChar(_object*, c_long, c_long) @nogc nothrow;
    _object* PyUnicode_Substring(_object*, c_long, c_long) @nogc nothrow;
    union _Py_HashSecret_t
    {
        ubyte[24] uc;
        static struct _Anonymous_36
        {
            c_long prefix;
            c_long suffix;
        }
        _Anonymous_36 fnv;
        static struct _Anonymous_37
        {
            c_ulong k0;
            c_ulong k1;
        }
        _Anonymous_37 siphash;
        static struct _Anonymous_38
        {
            ubyte[16] padding;
            c_long suffix;
        }
        _Anonymous_38 djbx33a;
        static struct _Anonymous_39
        {
            ubyte[16] padding;
            c_long hashsalt;
        }
        _Anonymous_39 expat;
    }
    extern __gshared _Py_HashSecret_t _Py_HashSecret;
    struct PyHash_FuncDef
    {
        c_long function(const(void)*, c_long) hash;
        const(char)* name;
        const(int) hash_bits;
        const(int) seed_bits;
    }
    PyHash_FuncDef* PyHash_GetFuncDef() @nogc nothrow;
    _object* _PyUnicode_FromASCII(const(char)*, c_long) @nogc nothrow;
    _object* PyUnicode_FromKindAndData(int, const(void)*, c_long) @nogc nothrow;
    _object* PyUnicode_FromString(const(char)*) @nogc nothrow;
    struct _PyInitError
    {
        const(char)* prefix;
        const(char)* msg;
        int user_err;
    }
    _object* PyUnicode_FromStringAndSize(const(char)*, c_long) @nogc nothrow;
    _object* PyUnicode_FromUnicode(const(int)*, c_long) @nogc nothrow;
    void _PyUnicode_FastFill(_object*, c_long, c_long, uint) @nogc nothrow;
    void Py_SetProgramName(const(int)*) @nogc nothrow;
    int* Py_GetProgramName() @nogc nothrow;
    void Py_SetPythonHome(const(int)*) @nogc nothrow;
    int* Py_GetPythonHome() @nogc nothrow;
    int Py_SetStandardStreamEncoding(const(char)*, const(char)*) @nogc nothrow;
    _PyInitError _Py_InitializeCore(_is**, const(_PyCoreConfig)*) @nogc nothrow;
    int _Py_IsCoreInitialized() @nogc nothrow;
    _PyInitError _Py_InitializeFromConfig(const(_PyCoreConfig)*) @nogc nothrow;
    _PyInitError _PyCoreConfig_Read(_PyCoreConfig*) @nogc nothrow;
    void _PyCoreConfig_Clear(_PyCoreConfig*) @nogc nothrow;
    int _PyCoreConfig_Copy(_PyCoreConfig*, const(_PyCoreConfig)*) @nogc nothrow;
    void _PyCoreConfig_SetGlobalConfig(const(_PyCoreConfig)*) @nogc nothrow;
    _PyInitError _PyMainInterpreterConfig_Read(_PyMainInterpreterConfig*, const(_PyCoreConfig)*) @nogc nothrow;
    void _PyMainInterpreterConfig_Clear(_PyMainInterpreterConfig*) @nogc nothrow;
    int _PyMainInterpreterConfig_Copy(_PyMainInterpreterConfig*, const(_PyMainInterpreterConfig)*) @nogc nothrow;
    _PyInitError _Py_InitializeMainInterpreter(_is*, const(_PyMainInterpreterConfig)*) @nogc nothrow;
    void Py_Initialize() @nogc nothrow;
    void Py_InitializeEx(int) @nogc nothrow;
    void _Py_FatalInitError(_PyInitError) @nogc nothrow;
    void Py_Finalize() @nogc nothrow;
    int Py_FinalizeEx() @nogc nothrow;
    int Py_IsInitialized() @nogc nothrow;
    _ts* Py_NewInterpreter() @nogc nothrow;
    void Py_EndInterpreter(_ts*) @nogc nothrow;
    void _Py_PyAtExit(void function(_object*), _object*) @nogc nothrow;
    int Py_AtExit(void function()) @nogc nothrow;
    void Py_Exit(int) @nogc nothrow;
    void _Py_RestoreSignals() @nogc nothrow;
    int Py_FdIsInteractive(_IO_FILE*, const(char)*) @nogc nothrow;
    int Py_Main(int, int**) @nogc nothrow;
    int* Py_GetProgramFullPath() @nogc nothrow;
    int* Py_GetPrefix() @nogc nothrow;
    int* Py_GetExecPrefix() @nogc nothrow;
    int* Py_GetPath() @nogc nothrow;
    void Py_SetPath(const(int)*) @nogc nothrow;
    const(char)* Py_GetVersion() @nogc nothrow;
    const(char)* Py_GetPlatform() @nogc nothrow;
    const(char)* Py_GetCopyright() @nogc nothrow;
    const(char)* Py_GetCompiler() @nogc nothrow;
    const(char)* Py_GetBuildInfo() @nogc nothrow;
    const(char)* _Py_gitidentifier() @nogc nothrow;
    const(char)* _Py_gitversion() @nogc nothrow;
    _object* _PyBuiltin_Init() @nogc nothrow;
    _PyInitError _PySys_BeginInit(_object**) @nogc nothrow;
    int _PySys_EndInit(_object*, _PyMainInterpreterConfig*) @nogc nothrow;
    _PyInitError _PyImport_Init(_is*) @nogc nothrow;
    void _PyExc_Init(_object*) @nogc nothrow;
    _PyInitError _PyImportHooks_Init() @nogc nothrow;
    int _PyFrame_Init() @nogc nothrow;
    int _PyFloat_Init() @nogc nothrow;
    int PyByteArray_Init() @nogc nothrow;
    _PyInitError _Py_HashRandomization_Init(const(_PyCoreConfig)*) @nogc nothrow;
    void PyMethod_Fini() @nogc nothrow;
    void PyFrame_Fini() @nogc nothrow;
    void PyCFunction_Fini() @nogc nothrow;
    void PyDict_Fini() @nogc nothrow;
    void PyTuple_Fini() @nogc nothrow;
    void PyList_Fini() @nogc nothrow;
    void PySet_Fini() @nogc nothrow;
    void PyBytes_Fini() @nogc nothrow;
    void PyByteArray_Fini() @nogc nothrow;
    void PyFloat_Fini() @nogc nothrow;
    void PyOS_FiniInterrupts() @nogc nothrow;
    void PySlice_Fini() @nogc nothrow;
    void PyAsyncGen_Fini() @nogc nothrow;
    int _Py_IsFinalizing() @nogc nothrow;
    alias PyOS_sighandler_t = void function(int);
    void function(int) PyOS_getsig(int) @nogc nothrow;
    void function(int) PyOS_setsig(int, void function(int)) @nogc nothrow;
    int _PyOS_URandom(void*, c_long) @nogc nothrow;
    int _PyOS_URandomNonblock(void*, c_long) @nogc nothrow;
    void _Py_CoerceLegacyLocale(const(_PyCoreConfig)*) @nogc nothrow;
    int _Py_LegacyLocaleDetected() @nogc nothrow;
    char* _Py_SetLocaleFromEnv(int) @nogc nothrow;
    c_long PyUnicode_Fill(_object*, c_long, c_long, uint) @nogc nothrow;
    void _PyUnicode_FastCopyCharacters(_object*, c_long, _object*, c_long, c_long) @nogc nothrow;
    c_long PyUnicode_CopyCharacters(_object*, c_long, _object*, c_long, c_long) @nogc nothrow;
    _object* _PyUnicode_Copy(_object*) @nogc nothrow;
    int _PyUnicode_Ready(_object*) @nogc nothrow;
    _object* PyUnicode_New(c_long, uint) @nogc nothrow;
    enum PyUnicode_Kind
    {
        PyUnicode_WCHAR_KIND = 0,
        PyUnicode_1BYTE_KIND = 1,
        PyUnicode_2BYTE_KIND = 2,
        PyUnicode_4BYTE_KIND = 4,
    }
    enum PyUnicode_WCHAR_KIND = PyUnicode_Kind.PyUnicode_WCHAR_KIND;
    enum PyUnicode_1BYTE_KIND = PyUnicode_Kind.PyUnicode_1BYTE_KIND;
    enum PyUnicode_2BYTE_KIND = PyUnicode_Kind.PyUnicode_2BYTE_KIND;
    enum PyUnicode_4BYTE_KIND = PyUnicode_Kind.PyUnicode_4BYTE_KIND;
    extern __gshared _typeobject PyUnicodeIter_Type;
    extern __gshared _typeobject PyUnicode_Type;
    struct PyUnicodeObject
    {
        PyCompactUnicodeObject _base;
        static union _Anonymous_40
        {
            void* any;
            ubyte* latin1;
            ushort* ucs2;
            uint* ucs4;
        }
        _Anonymous_40 data;
    }
    struct PyCompactUnicodeObject
    {
        PyASCIIObject _base;
        c_long utf8_length;
        char* utf8;
        c_long wstr_length;
    }
    struct PyASCIIObject
    {
        _object ob_base;
        c_long length;
        c_long hash;
        static struct _Anonymous_41
        {
            import std.bitmanip: bitfields;

            align(4):
            mixin(bitfields!(
                uint, "interned", 2,
                uint, "kind", 3,
                uint, "compact", 1,
                uint, "ascii", 1,
                uint, "ready", 1,
                uint, "_anonymous_42", 24,
            ));
        }
        _Anonymous_41 state;
        int* wstr;
    }
    alias Py_UCS1 = ubyte;
    alias Py_UCS2 = ushort;
    alias Py_UCS4 = uint;
    ushort _Py_get_387controlword() @nogc nothrow;
    void _Py_set_387controlword(ushort) @nogc nothrow;
    alias Py_UNICODE = int;
    void _PyTuple_DebugMallocStats(_IO_FILE*) @nogc nothrow;
    int PyTuple_ClearFreeList() @nogc nothrow;
    void _PyTuple_MaybeUntrack(_object*) @nogc nothrow;
    void* PyMem_RawMalloc(c_ulong) @nogc nothrow;
    void* PyMem_RawCalloc(c_ulong, c_ulong) @nogc nothrow;
    void* PyMem_RawRealloc(void*, c_ulong) @nogc nothrow;
    void PyMem_RawFree(void*) @nogc nothrow;
    int _PyMem_SetupAllocators(const(char)*) @nogc nothrow;
    const(char)* _PyMem_GetAllocatorsName() @nogc nothrow;
    int PyTraceMalloc_Track(uint, c_ulong, c_ulong) @nogc nothrow;
    int PyTraceMalloc_Untrack(uint, c_ulong) @nogc nothrow;
    _object* _PyTraceMalloc_GetTraceback(uint, c_ulong) @nogc nothrow;
    void* PyMem_Malloc(c_ulong) @nogc nothrow;
    void* PyMem_Calloc(c_ulong, c_ulong) @nogc nothrow;
    void* PyMem_Realloc(void*, c_ulong) @nogc nothrow;
    void PyMem_Free(void*) @nogc nothrow;
    char* _PyMem_RawStrdup(const(char)*) @nogc nothrow;
    char* _PyMem_Strdup(const(char)*) @nogc nothrow;
    int* _PyMem_RawWcsdup(const(int)*) @nogc nothrow;
    _object* PyTuple_Pack(c_long, ...) @nogc nothrow;
    int _PyTuple_Resize(_object**, c_long) @nogc nothrow;
    _object* PyTuple_GetSlice(_object*, c_long, c_long) @nogc nothrow;
    int PyTuple_SetItem(_object*, c_long, _object*) @nogc nothrow;
    alias PyMemAllocatorDomain = _Anonymous_43;
    enum _Anonymous_43
    {
        PYMEM_DOMAIN_RAW = 0,
        PYMEM_DOMAIN_MEM = 1,
        PYMEM_DOMAIN_OBJ = 2,
    }
    enum PYMEM_DOMAIN_RAW = _Anonymous_43.PYMEM_DOMAIN_RAW;
    enum PYMEM_DOMAIN_MEM = _Anonymous_43.PYMEM_DOMAIN_MEM;
    enum PYMEM_DOMAIN_OBJ = _Anonymous_43.PYMEM_DOMAIN_OBJ;
    struct PyMemAllocatorEx
    {
        void* ctx;
        void* function(void*, c_ulong) malloc;
        void* function(void*, c_ulong, c_ulong) calloc;
        void* function(void*, void*, c_ulong) realloc;
        void function(void*, void*) free;
    }
    void PyMem_GetAllocator(PyMemAllocatorDomain, PyMemAllocatorEx*) @nogc nothrow;
    void PyMem_SetAllocator(PyMemAllocatorDomain, PyMemAllocatorEx*) @nogc nothrow;
    void PyMem_SetupDebugHooks() @nogc nothrow;
    _object* PyTuple_GetItem(_object*, c_long) @nogc nothrow;
    c_long PyTuple_Size(_object*) @nogc nothrow;
    _object* PyTuple_New(c_long) @nogc nothrow;
    extern __gshared _typeobject PyTupleIter_Type;
    extern __gshared _typeobject PyTuple_Type;
    alias Py_uintptr_t = c_ulong;
    alias Py_intptr_t = c_long;
    alias Py_ssize_t = c_long;
    alias Py_hash_t = c_long;
    struct PyTupleObject
    {
        PyVarObject ob_base;
        _object*[1] ob_item;
    }
    alias Py_uhash_t = c_ulong;
    alias Py_ssize_clean_t = int;
    void _Py_DumpHexadecimal(int, c_ulong, c_long) @nogc nothrow;
    void _Py_DumpDecimal(int, c_ulong) @nogc nothrow;
    void _Py_DumpASCII(int, _object*) @nogc nothrow;
    const(char)* _Py_DumpTracebackThreads(int, _is*, _ts*) @nogc nothrow;
    void _Py_DumpTraceback(int, _ts*) @nogc nothrow;
    extern __gshared _typeobject PyTraceBack_Type;
    void _PyTraceback_Add(const(char)*, const(char)*, int) @nogc nothrow;
    int _Py_DisplaySourceLine(_object*, _object*, int, int) @nogc nothrow;
    int PyTraceBack_Print(_object*, _object*) @nogc nothrow;
    int PyTraceBack_Here(_frame*) @nogc nothrow;
    struct _traceback
    {
        _object ob_base;
        _traceback* tb_next;
        _frame* tb_frame;
        int tb_lasti;
        int tb_lineno;
    }
    alias PyTracebackObject = _traceback;
    c_ulong _PySys_GetSizeOf(_object*) @nogc nothrow;
    _object* PySys_GetXOptions() @nogc nothrow;
    void PySys_AddXOption(const(int)*) @nogc nothrow;
    int PySys_HasWarnOptions() @nogc nothrow;
    void PySys_AddWarnOptionUnicode(_object*) @nogc nothrow;
    void PySys_AddWarnOption(const(int)*) @nogc nothrow;
    struct _ts
    {
        _ts* prev;
        _ts* next;
        _is* interp;
        _frame* frame;
        int recursion_depth;
        char overflowed;
        char recursion_critical;
        int stackcheck_counter;
        int tracing;
        int use_tracing;
        int function(_object*, _frame*, int, _object*) c_profilefunc;
        int function(_object*, _frame*, int, _object*) c_tracefunc;
        _object* c_profileobj;
        _object* c_traceobj;
        _object* curexc_type;
        _object* curexc_value;
        _object* curexc_traceback;
        _err_stackitem exc_state;
        _err_stackitem* exc_info;
        _object* dict;
        int gilstate_counter;
        _object* async_exc;
        c_ulong thread_id;
        int trash_delete_nesting;
        _object* trash_delete_later;
        void function(void*) on_delete;
        void* on_delete_data;
        int coroutine_origin_tracking_depth;
        _object* coroutine_wrapper;
        int in_coroutine_wrapper;
        _object* async_gen_firstiter;
        _object* async_gen_finalizer;
        _object* context;
        c_ulong context_ver;
        c_ulong id;
    }
    struct _is
    {
        _is* next;
        _ts* tstate_head;
        c_long id;
        c_long id_refcount;
        void* id_mutex;
        _object* modules;
        _object* modules_by_index;
        _object* sysdict;
        _object* builtins;
        _object* importlib;
        int check_interval;
        c_long num_threads;
        c_ulong pythread_stacksize;
        _object* codec_search_path;
        _object* codec_search_cache;
        _object* codec_error_registry;
        int codecs_initialized;
        int fscodec_initialized;
        _PyCoreConfig core_config;
        _PyMainInterpreterConfig config;
        int dlopenflags;
        _object* builtins_copy;
        _object* import_func;
        _object* function(_frame*, int) eval_frame;
        c_long co_extra_user_count;
        void function(void*)[255] co_extra_freefuncs;
        _object* before_forkers;
        _object* after_forkers_parent;
        _object* after_forkers_child;
        void function(_object*) pyexitfunc;
        _object* pyexitmodule;
        c_ulong tstate_next_unique_id;
    }
    struct _frame;
    alias _PyFrameEvalFunction = _object* function(_frame*, int);
    struct _PyCoreConfig
    {
        int install_signal_handlers;
        int ignore_environment;
        int use_hash_seed;
        c_ulong hash_seed;
        const(char)* allocator;
        int dev_mode;
        int faulthandler;
        int tracemalloc;
        int import_time;
        int show_ref_count;
        int show_alloc_count;
        int dump_refs;
        int malloc_stats;
        int coerce_c_locale;
        int coerce_c_locale_warn;
        int utf8_mode;
        int* program_name;
        int argc;
        int** argv;
        int* program;
        int nxoption;
        int** xoptions;
        int nwarnoption;
        int** warnoptions;
        int* module_search_path_env;
        int* home;
        int nmodule_search_path;
        int** module_search_paths;
        int* executable;
        int* prefix;
        int* base_prefix;
        int* exec_prefix;
        int* base_exec_prefix;
        int _disable_importlib;
    }
    struct _PyMainInterpreterConfig
    {
        int install_signal_handlers;
        _object* argv;
        _object* executable;
        _object* prefix;
        _object* base_prefix;
        _object* exec_prefix;
        _object* base_exec_prefix;
        _object* warnoptions;
        _object* xoptions;
        _object* module_search_path;
    }
    void PySys_ResetWarnOptions() @nogc nothrow;
    alias PyInterpreterState = _is;
    alias Py_tracefunc = int function(_object*, _frame*, int, _object*);
    void PySys_FormatStderr(const(char)*, ...) @nogc nothrow;
    void PySys_FormatStdout(const(char)*, ...) @nogc nothrow;
    void PySys_WriteStderr(const(char)*, ...) @nogc nothrow;
    alias _PyErr_StackItem = _err_stackitem;
    struct _err_stackitem
    {
        _object* exc_type;
        _object* exc_value;
        _object* exc_traceback;
        _err_stackitem* previous_item;
    }
    alias PyThreadState = _ts;
    _is* PyInterpreterState_New() @nogc nothrow;
    void PyInterpreterState_Clear(_is*) @nogc nothrow;
    void PyInterpreterState_Delete(_is*) @nogc nothrow;
    c_long PyInterpreterState_GetID(_is*) @nogc nothrow;
    int _PyState_AddModule(_object*, PyModuleDef*) @nogc nothrow;
    int PyState_AddModule(_object*, PyModuleDef*) @nogc nothrow;
    int PyState_RemoveModule(PyModuleDef*) @nogc nothrow;
    _object* PyState_FindModule(PyModuleDef*) @nogc nothrow;
    void _PyState_ClearModules() @nogc nothrow;
    _ts* PyThreadState_New(_is*) @nogc nothrow;
    _ts* _PyThreadState_Prealloc(_is*) @nogc nothrow;
    void _PyThreadState_Init(_ts*) @nogc nothrow;
    void PyThreadState_Clear(_ts*) @nogc nothrow;
    void PyThreadState_Delete(_ts*) @nogc nothrow;
    void _PyThreadState_DeleteExcept(_ts*) @nogc nothrow;
    void PyThreadState_DeleteCurrent() @nogc nothrow;
    void _PyGILState_Reinit() @nogc nothrow;
    _ts* PyThreadState_Get() @nogc nothrow;
    _ts* _PyThreadState_UncheckedGet() @nogc nothrow;
    _ts* PyThreadState_Swap(_ts*) @nogc nothrow;
    _object* PyThreadState_GetDict() @nogc nothrow;
    int PyThreadState_SetAsyncExc(c_ulong, _object*) @nogc nothrow;
    alias PyGILState_STATE = _Anonymous_44;
    enum _Anonymous_44
    {
        PyGILState_LOCKED = 0,
        PyGILState_UNLOCKED = 1,
    }
    enum PyGILState_LOCKED = _Anonymous_44.PyGILState_LOCKED;
    enum PyGILState_UNLOCKED = _Anonymous_44.PyGILState_UNLOCKED;
    PyGILState_STATE PyGILState_Ensure() @nogc nothrow;
    void PyGILState_Release(PyGILState_STATE) @nogc nothrow;
    _ts* PyGILState_GetThisThreadState() @nogc nothrow;
    int PyGILState_Check() @nogc nothrow;
    _is* _PyGILState_GetInterpreterStateUnsafe() @nogc nothrow;
    _object* _PyThread_CurrentFrames() @nogc nothrow;
    _is* PyInterpreterState_Main() @nogc nothrow;
    _is* PyInterpreterState_Head() @nogc nothrow;
    _is* PyInterpreterState_Next(_is*) @nogc nothrow;
    _ts* PyInterpreterState_ThreadHead(_is*) @nogc nothrow;
    _ts* PyThreadState_Next(_ts*) @nogc nothrow;
    alias PyThreadFrameGetter = _frame* function(_ts*);
    void PySys_WriteStdout(const(char)*, ...) @nogc nothrow;
    int PyOS_mystrnicmp(const(char)*, const(char)*, c_long) @nogc nothrow;
    int PyOS_mystricmp(const(char)*, const(char)*) @nogc nothrow;
    void PySys_SetPath(const(int)*) @nogc nothrow;
    double PyOS_string_to_double(const(char)*, char**, _object*) @nogc nothrow;
    char* PyOS_double_to_string(double, char, int, int, int*) @nogc nothrow;
    _object* _Py_string_to_number_with_underscores(const(char)*, c_long, const(char)*, _object*, void*, _object* function(const(char)*, c_long, void*)) @nogc nothrow;
    double _Py_parse_inf_or_nan(const(char)*, char**) @nogc nothrow;
    void PySys_SetArgvEx(int, int**, int) @nogc nothrow;
    void PySys_SetArgv(int, int**) @nogc nothrow;
    int _PySys_SetObjectId(_Py_Identifier*, _object*) @nogc nothrow;
    _object* _PySys_GetObjectId(_Py_Identifier*) @nogc nothrow;
    int PyRun_SimpleStringFlags(const(char)*, PyCompilerFlags*) @nogc nothrow;
    pragma(mangle, "PyRun_AnyFileFlags") int PyRun_AnyFileFlags_(_IO_FILE*, const(char)*, PyCompilerFlags*) @nogc nothrow;
    int PyRun_AnyFileExFlags(_IO_FILE*, const(char)*, int, PyCompilerFlags*) @nogc nothrow;
    int PyRun_SimpleFileExFlags(_IO_FILE*, const(char)*, int, PyCompilerFlags*) @nogc nothrow;
    int PyRun_InteractiveOneFlags(_IO_FILE*, const(char)*, PyCompilerFlags*) @nogc nothrow;
    int PyRun_InteractiveOneObject(_IO_FILE*, _object*, PyCompilerFlags*) @nogc nothrow;
    int PyRun_InteractiveLoopFlags(_IO_FILE*, const(char)*, PyCompilerFlags*) @nogc nothrow;
    _mod* PyParser_ASTFromString(const(char)*, const(char)*, int, PyCompilerFlags*, _arena*) @nogc nothrow;
    _mod* PyParser_ASTFromStringObject(const(char)*, _object*, int, PyCompilerFlags*, _arena*) @nogc nothrow;
    _mod* PyParser_ASTFromFile(_IO_FILE*, const(char)*, const(char)*, int, const(char)*, const(char)*, PyCompilerFlags*, int*, _arena*) @nogc nothrow;
    _mod* PyParser_ASTFromFileObject(_IO_FILE*, _object*, const(char)*, int, const(char)*, const(char)*, PyCompilerFlags*, int*, _arena*) @nogc nothrow;
    int PySys_SetObject(const(char)*, _object*) @nogc nothrow;
    _node* PyParser_SimpleParseStringFlags(const(char)*, int, int) @nogc nothrow;
    _node* PyParser_SimpleParseStringFlagsFilename(const(char)*, const(char)*, int, int) @nogc nothrow;
    _node* PyParser_SimpleParseFileFlags(_IO_FILE*, const(char)*, int, int) @nogc nothrow;
    _object* PyRun_StringFlags(const(char)*, int, _object*, _object*, PyCompilerFlags*) @nogc nothrow;
    _object* PyRun_FileExFlags(_IO_FILE*, const(char)*, int, _object*, _object*, int, PyCompilerFlags*) @nogc nothrow;
    _object* PySys_GetObject(const(char)*) @nogc nothrow;
    _object* Py_CompileStringExFlags(const(char)*, const(char)*, int, PyCompilerFlags*, int) @nogc nothrow;
    _object* Py_CompileStringObject(const(char)*, _object*, int, PyCompilerFlags*, int) @nogc nothrow;
    struct symtable;
    symtable* Py_SymtableString(const(char)*, const(char)*, int) @nogc nothrow;
    symtable* Py_SymtableStringObject(const(char)*, _object*, int) @nogc nothrow;
    void PyErr_Print() @nogc nothrow;
    void PyErr_PrintEx(int) @nogc nothrow;
    void PyErr_Display(_object*, _object*, _object*) @nogc nothrow;
    _object* PyStructSequence_GetItem(_object*, c_long) @nogc nothrow;
    void PyStructSequence_SetItem(_object*, c_long, _object*) @nogc nothrow;
    alias PyStructSequence = PyTupleObject;
    _object* PyStructSequence_New(_typeobject*) @nogc nothrow;
    _typeobject* PyStructSequence_NewType(PyStructSequence_Desc*) @nogc nothrow;
    int PyStructSequence_InitType2(_typeobject*, PyStructSequence_Desc*) @nogc nothrow;
    char* PyOS_Readline(_IO_FILE*, _IO_FILE*, const(char)*) @nogc nothrow;
    extern __gshared int function() PyOS_InputHook;
    extern __gshared char* function(_IO_FILE*, _IO_FILE*, const(char)*) PyOS_ReadlineFunctionPointer;
    extern __gshared _ts* _PyOS_ReadlineTState;
    void PyStructSequence_InitType(_typeobject*, PyStructSequence_Desc*) @nogc nothrow;
    alias PyThread_type_lock = void*;
    alias PyThread_type_sema = void*;
    enum PyLockStatus
    {
        PY_LOCK_FAILURE = 0,
        PY_LOCK_ACQUIRED = 1,
        PY_LOCK_INTR = 2,
    }
    enum PY_LOCK_FAILURE = PyLockStatus.PY_LOCK_FAILURE;
    enum PY_LOCK_ACQUIRED = PyLockStatus.PY_LOCK_ACQUIRED;
    enum PY_LOCK_INTR = PyLockStatus.PY_LOCK_INTR;
    extern __gshared char* PyStructSequence_UnnamedField;
    void PyThread_init_thread() @nogc nothrow;
    c_ulong PyThread_start_new_thread(void function(void*), void*) @nogc nothrow;
    void PyThread_exit_thread() @nogc nothrow;
    c_ulong PyThread_get_thread_ident() @nogc nothrow;
    void* PyThread_allocate_lock() @nogc nothrow;
    void PyThread_free_lock(void*) @nogc nothrow;
    int PyThread_acquire_lock(void*, int) @nogc nothrow;
    struct PyStructSequence_Desc
    {
        const(char)* name;
        const(char)* doc;
        PyStructSequence_Field* fields;
        int n_in_sequence;
    }
    struct PyStructSequence_Field
    {
        const(char)* name;
        const(char)* doc;
    }
    PyLockStatus PyThread_acquire_lock_timed(void*, long, int) @nogc nothrow;
    void PyThread_release_lock(void*) @nogc nothrow;
    c_ulong PyThread_get_stacksize() @nogc nothrow;
    int PyThread_set_stacksize(c_ulong) @nogc nothrow;
    _object* PyThread_GetInfo() @nogc nothrow;
    int PyThread_create_key() @nogc nothrow;
    void PyThread_delete_key(int) @nogc nothrow;
    int PyThread_set_key_value(int, void*) @nogc nothrow;
    void* PyThread_get_key_value(int) @nogc nothrow;
    void PyThread_delete_key_value(int) @nogc nothrow;
    void PyThread_ReInitTLS() @nogc nothrow;
    alias Py_tss_t = _Py_tss_t;
    struct _Py_tss_t
    {
        int _is_initialized;
        uint _key;
    }
    int PyMember_SetOne(char*, PyMemberDef*, _object*) @nogc nothrow;
    _Py_tss_t* PyThread_tss_alloc() @nogc nothrow;
    void PyThread_tss_free(_Py_tss_t*) @nogc nothrow;
    int PyThread_tss_is_created(_Py_tss_t*) @nogc nothrow;
    int PyThread_tss_create(_Py_tss_t*) @nogc nothrow;
    void PyThread_tss_delete(_Py_tss_t*) @nogc nothrow;
    int PyThread_tss_set(_Py_tss_t*, void*) @nogc nothrow;
    void* PyThread_tss_get(_Py_tss_t*) @nogc nothrow;
    _object* PyMember_GetOne(const(char)*, PyMemberDef*) @nogc nothrow;
    alias _PyTime_t = c_long;
    alias _PyTime_round_t = _Anonymous_45;
    enum _Anonymous_45
    {
        _PyTime_ROUND_FLOOR = 0,
        _PyTime_ROUND_CEILING = 1,
        _PyTime_ROUND_HALF_EVEN = 2,
        _PyTime_ROUND_UP = 3,
        _PyTime_ROUND_TIMEOUT = 3,
    }
    enum _PyTime_ROUND_FLOOR = _Anonymous_45._PyTime_ROUND_FLOOR;
    enum _PyTime_ROUND_CEILING = _Anonymous_45._PyTime_ROUND_CEILING;
    enum _PyTime_ROUND_HALF_EVEN = _Anonymous_45._PyTime_ROUND_HALF_EVEN;
    enum _PyTime_ROUND_UP = _Anonymous_45._PyTime_ROUND_UP;
    enum _PyTime_ROUND_TIMEOUT = _Anonymous_45._PyTime_ROUND_TIMEOUT;
    _object* _PyLong_FromTime_t(c_long) @nogc nothrow;
    c_long _PyLong_AsTime_t(_object*) @nogc nothrow;
    int _PyTime_ObjectToTime_t(_object*, c_long*, _PyTime_round_t) @nogc nothrow;
    int _PyTime_ObjectToTimeval(_object*, c_long*, c_long*, _PyTime_round_t) @nogc nothrow;
    int _PyTime_ObjectToTimespec(_object*, c_long*, c_long*, _PyTime_round_t) @nogc nothrow;
    c_long _PyTime_FromSeconds(int) @nogc nothrow;
    c_long _PyTime_FromNanoseconds(c_long) @nogc nothrow;
    int _PyTime_FromNanosecondsObject(c_long*, _object*) @nogc nothrow;
    int _PyTime_FromSecondsObject(c_long*, _object*, _PyTime_round_t) @nogc nothrow;
    int _PyTime_FromMillisecondsObject(c_long*, _object*, _PyTime_round_t) @nogc nothrow;
    double _PyTime_AsSecondsDouble(c_long) @nogc nothrow;
    c_long _PyTime_AsMilliseconds(c_long, _PyTime_round_t) @nogc nothrow;
    c_long _PyTime_AsMicroseconds(c_long, _PyTime_round_t) @nogc nothrow;
    _object* _PyTime_AsNanosecondsObject(c_long) @nogc nothrow;
    int _PyTime_FromTimeval(c_long*, timeval*) @nogc nothrow;
    int _PyTime_AsTimeval(c_long, timeval*, _PyTime_round_t) @nogc nothrow;
    int _PyTime_AsTimeval_noraise(c_long, timeval*, _PyTime_round_t) @nogc nothrow;
    int _PyTime_AsTimevalTime_t(c_long, c_long*, int*, _PyTime_round_t) @nogc nothrow;
    int _PyTime_FromTimespec(c_long*, timespec*) @nogc nothrow;
    int _PyTime_AsTimespec(c_long, timespec*) @nogc nothrow;
    c_long _PyTime_MulDiv(c_long, c_long, c_long) @nogc nothrow;
    c_long _PyTime_GetSystemClock() @nogc nothrow;
    c_long _PyTime_GetMonotonicClock() @nogc nothrow;
    struct _Py_clock_info_t
    {
        const(char)* implementation;
        int monotonic;
        int adjustable;
        double resolution;
    }
    int _PyTime_GetSystemClockWithInfo(c_long*, _Py_clock_info_t*) @nogc nothrow;
    int _PyTime_GetMonotonicClockWithInfo(c_long*, _Py_clock_info_t*) @nogc nothrow;
    int _PyTime_Init() @nogc nothrow;
    int _PyTime_localtime(c_long, tm*) @nogc nothrow;
    int _PyTime_gmtime(c_long, tm*) @nogc nothrow;
    c_long _PyTime_GetPerfCounter() @nogc nothrow;
    int _PyTime_GetPerfCounterWithInfo(c_long*, _Py_clock_info_t*) @nogc nothrow;
    c_long PySlice_AdjustIndices(c_long, c_long*, c_long*, c_long) @nogc nothrow;
    extern __gshared _typeobject PyRange_Type;
    extern __gshared _typeobject PyRangeIter_Type;
    extern __gshared _typeobject PyLongRangeIter_Type;
    int PySlice_Unpack(_object*, c_long*, c_long*, c_long*) @nogc nothrow;
    struct setentry
    {
        _object* key;
        c_long hash;
    }
    struct PySetObject
    {
        _object ob_base;
        c_long fill;
        c_long used;
        c_long mask;
        setentry* table;
        c_long hash;
        c_long finger;
        setentry[8] smalltable;
        _object* weakreflist;
    }
    extern __gshared _object* _PySet_Dummy;
    int _PySet_NextEntry(_object*, c_long*, _object**, c_long*) @nogc nothrow;
    int _PySet_Update(_object*, _object*) @nogc nothrow;
    int PySet_ClearFreeList() @nogc nothrow;
    extern __gshared _typeobject PySet_Type;
    extern __gshared _typeobject PyFrozenSet_Type;
    extern __gshared _typeobject PySetIter_Type;
    _object* PySet_New(_object*) @nogc nothrow;
    _object* PyFrozenSet_New(_object*) @nogc nothrow;
    int PySet_Add(_object*, _object*) @nogc nothrow;
    int PySet_Clear(_object*) @nogc nothrow;
    int PySet_Contains(_object*, _object*) @nogc nothrow;
    int PySet_Discard(_object*, _object*) @nogc nothrow;
    _object* PySet_Pop(_object*) @nogc nothrow;
    c_long PySet_Size(_object*) @nogc nothrow;
    pragma(mangle, "PySlice_GetIndicesEx") int PySlice_GetIndicesEx_(_object*, c_long, c_long*, c_long*, c_long*, c_long*) @nogc nothrow;
    int PySlice_GetIndices(_object*, c_long, c_long*, c_long*, c_long*) @nogc nothrow;
    int _PySlice_GetLongIndices(PySliceObject*, _object*, _object**, _object**, _object**) @nogc nothrow;
    extern __gshared _object _Py_EllipsisObject;
    _object* _PySlice_FromIndices(c_long, c_long) @nogc nothrow;
    struct PySliceObject
    {
        _object ob_base;
        _object* start;
        _object* stop;
        _object* step;
    }
    extern __gshared _typeobject PySlice_Type;
    extern __gshared _typeobject PyEllipsis_Type;
    _object* PySlice_New(_object*, _object*, _object*) @nogc nothrow;
    enum DPP_ENUM_PySet_MINSIZE = 8;
    enum DPP_ENUM_T_SHORT = 0;


    enum DPP_ENUM_T_INT = 1;


    enum DPP_ENUM_T_LONG = 2;


    enum DPP_ENUM_T_FLOAT = 3;


    enum DPP_ENUM_T_DOUBLE = 4;


    enum DPP_ENUM_T_STRING = 5;


    enum DPP_ENUM_T_OBJECT = 6;


    enum DPP_ENUM_T_CHAR = 7;


    enum DPP_ENUM_T_BYTE = 8;


    enum DPP_ENUM_T_UBYTE = 9;


    enum DPP_ENUM_T_USHORT = 10;


    enum DPP_ENUM_T_UINT = 11;


    enum DPP_ENUM_T_ULONG = 12;


    enum DPP_ENUM_T_STRING_INPLACE = 13;


    enum DPP_ENUM_T_BOOL = 14;


    enum DPP_ENUM_T_OBJECT_EX = 16;


    enum DPP_ENUM_T_LONGLONG = 17;


    enum DPP_ENUM_T_ULONGLONG = 18;


    enum DPP_ENUM_T_PYSSIZET = 19;


    enum DPP_ENUM_T_NONE = 20;


    enum DPP_ENUM_READONLY = 1;


    enum DPP_ENUM_READ_RESTRICTED = 2;


    enum DPP_ENUM_PY_WRITE_RESTRICTED = 4;
    enum DPP_ENUM_NOWAIT_LOCK = 0;


    enum DPP_ENUM_WAIT_LOCK = 1;






    enum DPP_ENUM_PYOS_STACK_MARGIN = 2048;
    enum DPP_ENUM_Py_DTST_NAN = 2;


    enum DPP_ENUM_Py_DTST_INFINITE = 1;


    enum DPP_ENUM_Py_DTST_FINITE = 0;
    enum DPP_ENUM_PyTrace_OPCODE = 7;


    enum DPP_ENUM_PyTrace_C_RETURN = 6;


    enum DPP_ENUM_PyTrace_C_EXCEPTION = 5;


    enum DPP_ENUM_PyTrace_C_CALL = 4;


    enum DPP_ENUM_PyTrace_RETURN = 3;


    enum DPP_ENUM_PyTrace_LINE = 2;


    enum DPP_ENUM_PyTrace_EXCEPTION = 1;


    enum DPP_ENUM_PyTrace_CALL = 0;
    enum DPP_ENUM_MAX_CO_EXTRA_USERS = 255;
    enum DPP_ENUM_PY_LITTLE_ENDIAN = 1;


    enum DPP_ENUM_PY_BIG_ENDIAN = 0;
    enum DPP_ENUM_HAVE_PY_SET_53BIT_PRECISION = 1;
    enum DPP_ENUM_PYLONG_BITS_IN_DIGIT = 30;
    enum DPP_ENUM_HAVE_LONG_LONG = 1;
    enum DPP_ENUM_Py_mp_ass_subscript = 3;


    enum DPP_ENUM_Py_mp_length = 4;


    enum DPP_ENUM_Py_mp_subscript = 5;


    enum DPP_ENUM_Py_nb_absolute = 6;


    enum DPP_ENUM_Py_nb_add = 7;


    enum DPP_ENUM_Py_nb_and = 8;


    enum DPP_ENUM_Py_nb_bool = 9;


    enum DPP_ENUM_Py_nb_divmod = 10;


    enum DPP_ENUM_Py_nb_float = 11;


    enum DPP_ENUM_Py_nb_floor_divide = 12;


    enum DPP_ENUM_Py_nb_index = 13;


    enum DPP_ENUM_Py_nb_inplace_add = 14;


    enum DPP_ENUM_Py_nb_inplace_and = 15;


    enum DPP_ENUM_Py_nb_inplace_floor_divide = 16;


    enum DPP_ENUM_Py_nb_inplace_lshift = 17;


    enum DPP_ENUM_Py_nb_inplace_multiply = 18;


    enum DPP_ENUM_Py_nb_inplace_or = 19;


    enum DPP_ENUM_Py_nb_inplace_power = 20;


    enum DPP_ENUM_Py_nb_inplace_remainder = 21;


    enum DPP_ENUM_Py_nb_inplace_rshift = 22;


    enum DPP_ENUM_Py_nb_inplace_subtract = 23;


    enum DPP_ENUM_Py_nb_inplace_true_divide = 24;


    enum DPP_ENUM_Py_nb_inplace_xor = 25;


    enum DPP_ENUM_Py_nb_int = 26;


    enum DPP_ENUM_Py_nb_invert = 27;


    enum DPP_ENUM_Py_nb_lshift = 28;


    enum DPP_ENUM_Py_nb_multiply = 29;


    enum DPP_ENUM_Py_nb_negative = 30;


    enum DPP_ENUM_Py_nb_or = 31;


    enum DPP_ENUM_Py_nb_positive = 32;


    enum DPP_ENUM_Py_nb_power = 33;


    enum DPP_ENUM_Py_nb_remainder = 34;


    enum DPP_ENUM_Py_nb_rshift = 35;


    enum DPP_ENUM_Py_nb_subtract = 36;


    enum DPP_ENUM_Py_nb_true_divide = 37;


    enum DPP_ENUM_Py_nb_xor = 38;


    enum DPP_ENUM_Py_sq_ass_item = 39;


    enum DPP_ENUM_Py_sq_concat = 40;


    enum DPP_ENUM_Py_sq_contains = 41;


    enum DPP_ENUM_Py_sq_inplace_concat = 42;


    enum DPP_ENUM_Py_sq_inplace_repeat = 43;


    enum DPP_ENUM_Py_sq_item = 44;


    enum DPP_ENUM_Py_sq_length = 45;


    enum DPP_ENUM_Py_sq_repeat = 46;


    enum DPP_ENUM_Py_tp_alloc = 47;


    enum DPP_ENUM_Py_tp_base = 48;


    enum DPP_ENUM_Py_tp_bases = 49;


    enum DPP_ENUM_Py_tp_call = 50;


    enum DPP_ENUM_Py_tp_clear = 51;


    enum DPP_ENUM_Py_tp_dealloc = 52;


    enum DPP_ENUM_Py_tp_del = 53;


    enum DPP_ENUM_Py_tp_descr_get = 54;


    enum DPP_ENUM_Py_tp_descr_set = 55;


    enum DPP_ENUM_Py_tp_doc = 56;


    enum DPP_ENUM_Py_tp_getattr = 57;


    enum DPP_ENUM_Py_tp_getattro = 58;


    enum DPP_ENUM_Py_tp_hash = 59;


    enum DPP_ENUM_Py_tp_init = 60;


    enum DPP_ENUM_Py_tp_is_gc = 61;


    enum DPP_ENUM_Py_tp_iter = 62;


    enum DPP_ENUM_Py_tp_iternext = 63;


    enum DPP_ENUM_Py_tp_methods = 64;


    enum DPP_ENUM_Py_tp_new = 65;


    enum DPP_ENUM_Py_tp_repr = 66;


    enum DPP_ENUM_Py_tp_richcompare = 67;


    enum DPP_ENUM_Py_tp_setattr = 68;


    enum DPP_ENUM_Py_tp_setattro = 69;


    enum DPP_ENUM_Py_tp_str = 70;


    enum DPP_ENUM_Py_tp_traverse = 71;


    enum DPP_ENUM_Py_tp_members = 72;


    enum DPP_ENUM_Py_tp_getset = 73;


    enum DPP_ENUM_Py_tp_free = 74;


    enum DPP_ENUM_Py_nb_matrix_multiply = 75;


    enum DPP_ENUM_Py_nb_inplace_matrix_multiply = 76;


    enum DPP_ENUM_Py_am_await = 77;


    enum DPP_ENUM_Py_am_aiter = 78;


    enum DPP_ENUM_Py_am_anext = 79;


    enum DPP_ENUM_Py_tp_finalize = 80;
    enum DPP_ENUM_Py_MATH_E = 2.7182818284590452354;
    enum DPP_ENUM_Py_MATH_PI = 3.14159265358979323846;
    enum DPP_ENUM_SSTATE_NOT_INTERNED = 0;


    enum DPP_ENUM_SSTATE_INTERNED_MORTAL = 1;


    enum DPP_ENUM_SSTATE_INTERNED_IMMORTAL = 2;
    enum DPP_ENUM_Py_HASH_FNV = 2;


    enum DPP_ENUM_Py_HASH_SIPHASH24 = 1;


    enum DPP_ENUM_Py_HASH_EXTERNAL = 0;


    enum DPP_ENUM_Py_HASH_CUTOFF = 0;




    enum DPP_ENUM__PyHASH_NAN = 0;


    enum DPP_ENUM__PyHASH_INF = 314159;




    enum DPP_ENUM__PyHASH_BITS = 61;
    enum DPP_ENUM___BSD_VISIBLE = 1;
    enum DPP_ENUM__XOPEN_SOURCE_EXTENDED = 1;


    enum DPP_ENUM__XOPEN_SOURCE = 700;
    enum DPP_ENUM__NETBSD_SOURCE = 1;


    enum DPP_ENUM__LARGEFILE_SOURCE = 1;


    enum DPP_ENUM__GNU_SOURCE = 1;


    enum DPP_ENUM__FILE_OFFSET_BITS = 64;


    enum DPP_ENUM__DARWIN_C_SOURCE = 1;


    enum DPP_ENUM_WITH_PYMALLOC = 1;


    enum DPP_ENUM_WITH_DOC_STRINGS = 1;


    enum DPP_ENUM_WINDOW_HAS_FLAGS = 1;


    enum DPP_ENUM___EXTENSIONS__ = 1;


    enum DPP_ENUM__TANDEM_SOURCE = 1;


    enum DPP_ENUM__POSIX_PTHREAD_SEMANTICS = 1;


    enum DPP_ENUM__ALL_SOURCE = 1;


    enum DPP_ENUM_USE_COMPUTED_GOTOS = 1;


    enum DPP_ENUM_TIME_WITH_SYS_TIME = 1;


    enum DPP_ENUM_TANH_PRESERVES_ZERO_SIGN = 1;


    enum DPP_ENUM_SYS_SELECT_WITH_SYS_TIME = 1;


    enum DPP_ENUM_STDC_HEADERS = 1;


    enum DPP_ENUM_SIZEOF__BOOL = 1;


    enum DPP_ENUM_SIZEOF_WCHAR_T = 4;


    enum DPP_ENUM_SIZEOF_VOID_P = 8;


    enum DPP_ENUM_SIZEOF_UINTPTR_T = 8;


    enum DPP_ENUM_SIZEOF_TIME_T = 8;


    enum DPP_ENUM_SIZEOF_SIZE_T = 8;





    enum DPP_ENUM_SIZEOF_SHORT = 2;


    enum DPP_ENUM_SIZEOF_PTHREAD_T = 8;


    enum DPP_ENUM_SIZEOF_PTHREAD_KEY_T = 4;


    enum DPP_ENUM_SIZEOF_PID_T = 4;


    enum DPP_ENUM_SIZEOF_OFF_T = 8;


    enum DPP_ENUM_SIZEOF_LONG_LONG = 8;


    enum DPP_ENUM_SIZEOF_LONG_DOUBLE = 16;


    enum DPP_ENUM_SIZEOF_LONG = 8;


    enum DPP_ENUM_SIZEOF_INT = 4;


    enum DPP_ENUM_SIZEOF_FPOS_T = 16;


    enum DPP_ENUM_SIZEOF_FLOAT = 4;


    enum DPP_ENUM_SIZEOF_DOUBLE = 8;




    enum DPP_ENUM_Py_ENABLE_SHARED = 1;


    enum DPP_ENUM_PY_SSL_DEFAULT_CIPHERS = 1;






    enum DPP_ENUM_PY_COERCE_C_LOCALE = 1;




    enum DPP_ENUM_PTHREAD_SYSTEM_SCHED_SUPPORTED = 1;


    enum DPP_ENUM_PTHREAD_KEY_T_IS_COMPATIBLE_WITH_INT = 1;


    enum DPP_ENUM_MVWDELCH_IS_EXPRESSION = 1;


    enum DPP_ENUM_MAJOR_IN_SYSMACROS = 1;


    enum DPP_ENUM_HAVE_ZLIB_COPY = 1;


    enum DPP_ENUM_HAVE_X509_VERIFY_PARAM_SET1_HOST = 1;


    enum DPP_ENUM_HAVE_WRITEV = 1;


    enum DPP_ENUM_HAVE_WORKING_TZSET = 1;


    enum DPP_ENUM_HAVE_WMEMCMP = 1;


    enum DPP_ENUM_HAVE_WCSXFRM = 1;


    enum DPP_ENUM_HAVE_WCSFTIME = 1;


    enum DPP_ENUM_HAVE_WCSCOLL = 1;


    enum DPP_ENUM_HAVE_WCHAR_H = 1;


    enum DPP_ENUM_HAVE_WAITPID = 1;


    enum DPP_ENUM_HAVE_WAITID = 1;


    enum DPP_ENUM_HAVE_WAIT4 = 1;


    enum DPP_ENUM_HAVE_WAIT3 = 1;


    enum DPP_ENUM_HAVE_UUID_UUID_H = 1;


    enum DPP_ENUM_HAVE_UUID_GENERATE_TIME_SAFE = 1;


    enum DPP_ENUM_HAVE_UTIME_H = 1;


    enum DPP_ENUM_HAVE_UTIMES = 1;


    enum DPP_ENUM_HAVE_UTIMENSAT = 1;


    enum DPP_ENUM_HAVE_UNSETENV = 1;


    enum DPP_ENUM_HAVE_UNLINKAT = 1;


    enum DPP_ENUM_HAVE_UNISTD_H = 1;


    enum DPP_ENUM_HAVE_UNAME = 1;


    enum DPP_ENUM_HAVE_TRUNCATE = 1;


    enum DPP_ENUM_HAVE_TM_ZONE = 1;


    enum DPP_ENUM_HAVE_TMPNAM_R = 1;


    enum DPP_ENUM_HAVE_TMPNAM = 1;


    enum DPP_ENUM_HAVE_TMPFILE = 1;


    enum DPP_ENUM_HAVE_TIMES = 1;


    enum DPP_ENUM_HAVE_TIMEGM = 1;


    enum DPP_ENUM_HAVE_TGAMMA = 1;


    enum DPP_ENUM_HAVE_TERM_H = 1;


    enum DPP_ENUM_HAVE_TERMIOS_H = 1;


    enum DPP_ENUM_HAVE_TEMPNAM = 1;


    enum DPP_ENUM_HAVE_TCSETPGRP = 1;


    enum DPP_ENUM_HAVE_TCGETPGRP = 1;


    enum DPP_ENUM_HAVE_SYS_XATTR_H = 1;


    enum DPP_ENUM_HAVE_SYS_WAIT_H = 1;


    enum DPP_ENUM_HAVE_SYS_UTSNAME_H = 1;


    enum DPP_ENUM_HAVE_SYS_UN_H = 1;


    enum DPP_ENUM_HAVE_SYS_UIO_H = 1;


    enum DPP_ENUM_HAVE_SYS_TYPES_H = 1;


    enum DPP_ENUM_HAVE_SYS_TIME_H = 1;


    enum DPP_ENUM_HAVE_SYS_TIMES_H = 1;


    enum DPP_ENUM_HAVE_SYS_SYSMACROS_H = 1;


    enum DPP_ENUM_HAVE_SYS_SYSCALL_H = 1;


    enum DPP_ENUM_HAVE_SYS_STAT_H = 1;


    enum DPP_ENUM_HAVE_SYS_STATVFS_H = 1;


    enum DPP_ENUM_HAVE_SYS_SOCKET_H = 1;


    enum DPP_ENUM_HAVE_SYS_SENDFILE_H = 1;


    enum DPP_ENUM_HAVE_SYS_SELECT_H = 1;


    enum DPP_ENUM_HAVE_SYS_RESOURCE_H = 1;


    enum DPP_ENUM_HAVE_SYS_RANDOM_H = 1;


    enum DPP_ENUM_HAVE_SYS_POLL_H = 1;


    enum DPP_ENUM_HAVE_SYS_PARAM_H = 1;


    enum DPP_ENUM_HAVE_SYS_IOCTL_H = 1;


    enum DPP_ENUM_HAVE_SYS_FILE_H = 1;


    enum DPP_ENUM_HAVE_SYS_EPOLL_H = 1;


    enum DPP_ENUM_HAVE_SYSEXITS_H = 1;


    enum DPP_ENUM_HAVE_SYSCONF = 1;


    enum DPP_ENUM_HAVE_SYNC = 1;


    enum DPP_ENUM_HAVE_SYMLINKAT = 1;


    enum DPP_ENUM_HAVE_SYMLINK = 1;


    enum DPP_ENUM_HAVE_STRUCT_TM_TM_ZONE = 1;


    enum DPP_ENUM_HAVE_STRUCT_STAT_ST_RDEV = 1;


    enum DPP_ENUM_HAVE_STRUCT_STAT_ST_BLOCKS = 1;


    enum DPP_ENUM_HAVE_STRUCT_STAT_ST_BLKSIZE = 1;


    enum DPP_ENUM_HAVE_STRUCT_PASSWD_PW_PASSWD = 1;


    enum DPP_ENUM_HAVE_STRUCT_PASSWD_PW_GECOS = 1;


    enum DPP_ENUM_HAVE_STROPTS_H = 1;


    enum DPP_ENUM_HAVE_STRING_H = 1;


    enum DPP_ENUM_HAVE_STRINGS_H = 1;


    enum DPP_ENUM_HAVE_STRFTIME = 1;


    enum DPP_ENUM_HAVE_STRDUP = 1;


    enum DPP_ENUM_HAVE_STD_ATOMIC = 1;


    enum DPP_ENUM_HAVE_STDLIB_H = 1;


    enum DPP_ENUM_HAVE_STDINT_H = 1;


    enum DPP_ENUM_HAVE_STDARG_PROTOTYPES = 1;


    enum DPP_ENUM_HAVE_STAT_TV_NSEC = 1;


    enum DPP_ENUM_HAVE_STATVFS = 1;


    enum DPP_ENUM_HAVE_SSIZE_T = 1;


    enum DPP_ENUM_HAVE_SPAWN_H = 1;


    enum DPP_ENUM_HAVE_SOCKETPAIR = 1;


    enum DPP_ENUM_HAVE_SOCKADDR_STORAGE = 1;


    enum DPP_ENUM_HAVE_SOCKADDR_ALG = 1;


    enum DPP_ENUM_HAVE_SNPRINTF = 1;


    enum DPP_ENUM_HAVE_SIGWAITINFO = 1;


    enum DPP_ENUM_HAVE_SIGWAIT = 1;


    enum DPP_ENUM_HAVE_SIGTIMEDWAIT = 1;


    enum DPP_ENUM_HAVE_SIGRELSE = 1;


    enum DPP_ENUM_HAVE_SIGPENDING = 1;


    enum DPP_ENUM_HAVE_SIGNAL_H = 1;


    enum DPP_ENUM_HAVE_SIGINTERRUPT = 1;


    enum DPP_ENUM_HAVE_SIGINFO_T_SI_BAND = 1;


    enum DPP_ENUM_HAVE_SIGALTSTACK = 1;


    enum DPP_ENUM_HAVE_SIGACTION = 1;


    enum DPP_ENUM_HAVE_SHADOW_H = 1;


    enum DPP_ENUM_HAVE_SETVBUF = 1;


    enum DPP_ENUM_HAVE_SETUID = 1;


    enum DPP_ENUM_HAVE_SETSID = 1;


    enum DPP_ENUM_HAVE_SETREUID = 1;


    enum DPP_ENUM_HAVE_SETRESUID = 1;


    enum DPP_ENUM_HAVE_SETRESGID = 1;


    enum DPP_ENUM_HAVE_SETREGID = 1;


    enum DPP_ENUM_HAVE_SETPRIORITY = 1;


    enum DPP_ENUM_HAVE_SETPGRP = 1;


    enum DPP_ENUM_HAVE_SETPGID = 1;


    enum DPP_ENUM_HAVE_SETLOCALE = 1;


    enum DPP_ENUM_HAVE_SETITIMER = 1;


    enum DPP_ENUM_HAVE_SETHOSTNAME = 1;


    enum DPP_ENUM_HAVE_SETGROUPS = 1;


    enum DPP_ENUM_HAVE_SETGID = 1;


    enum DPP_ENUM_HAVE_SETEUID = 1;


    enum DPP_ENUM_HAVE_SETEGID = 1;


    enum DPP_ENUM_HAVE_SENDFILE = 1;


    enum DPP_ENUM_HAVE_SEM_UNLINK = 1;


    enum DPP_ENUM_HAVE_SEM_TIMEDWAIT = 1;


    enum DPP_ENUM_HAVE_SEM_OPEN = 1;


    enum DPP_ENUM_HAVE_SEM_GETVALUE = 1;


    enum DPP_ENUM_HAVE_SCHED_SETSCHEDULER = 1;


    enum DPP_ENUM_HAVE_SCHED_SETPARAM = 1;


    enum DPP_ENUM_HAVE_SCHED_SETAFFINITY = 1;


    enum DPP_ENUM_HAVE_SCHED_RR_GET_INTERVAL = 1;


    enum DPP_ENUM_HAVE_SCHED_H = 1;


    enum DPP_ENUM_HAVE_SCHED_GET_PRIORITY_MAX = 1;


    enum DPP_ENUM_HAVE_ROUND = 1;


    enum DPP_ENUM_HAVE_RL_RESIZE_TERMINAL = 1;


    enum DPP_ENUM_HAVE_RL_PRE_INPUT_HOOK = 1;


    enum DPP_ENUM_HAVE_RL_COMPLETION_SUPPRESS_APPEND = 1;


    enum DPP_ENUM_HAVE_RL_COMPLETION_MATCHES = 1;


    enum DPP_ENUM_HAVE_RL_COMPLETION_DISPLAY_MATCHES_HOOK = 1;


    enum DPP_ENUM_HAVE_RL_COMPLETION_APPEND_CHARACTER = 1;


    enum DPP_ENUM_HAVE_RL_CATCH_SIGNAL = 1;


    enum DPP_ENUM_HAVE_RL_APPEND_HISTORY = 1;


    enum DPP_ENUM_HAVE_RENAMEAT = 1;


    enum DPP_ENUM_HAVE_REALPATH = 1;


    enum DPP_ENUM_HAVE_READV = 1;


    enum DPP_ENUM_HAVE_READLINKAT = 1;


    enum DPP_ENUM_HAVE_READLINK = 1;


    enum DPP_ENUM_HAVE_PWRITEV2 = 1;


    enum DPP_ENUM_HAVE_PWRITEV = 1;


    enum DPP_ENUM_HAVE_PWRITE = 1;


    enum DPP_ENUM_HAVE_PUTENV = 1;


    enum DPP_ENUM_HAVE_PTY_H = 1;


    enum DPP_ENUM_HAVE_PTHREAD_SIGMASK = 1;


    enum DPP_ENUM_HAVE_PTHREAD_KILL = 1;


    enum DPP_ENUM_HAVE_PTHREAD_H = 1;


    enum DPP_ENUM_HAVE_PTHREAD_GETCPUCLOCKID = 1;


    enum DPP_ENUM_HAVE_PROTOTYPES = 1;


    enum DPP_ENUM_HAVE_PRLIMIT = 1;


    enum DPP_ENUM_HAVE_PREADV2 = 1;


    enum DPP_ENUM_HAVE_PREADV = 1;


    enum DPP_ENUM_HAVE_PREAD = 1;


    enum DPP_ENUM_HAVE_POSIX_SPAWN = 1;


    enum DPP_ENUM_HAVE_POSIX_FALLOCATE = 1;


    enum DPP_ENUM_HAVE_POSIX_FADVISE = 1;


    enum DPP_ENUM_HAVE_POLL_H = 1;


    enum DPP_ENUM_HAVE_POLL = 1;


    enum DPP_ENUM_HAVE_PIPE2 = 1;


    enum DPP_ENUM_HAVE_PAUSE = 1;


    enum DPP_ENUM_HAVE_PATHCONF = 1;


    enum DPP_ENUM_HAVE_OPENPTY = 1;


    enum DPP_ENUM_HAVE_OPENAT = 1;


    enum DPP_ENUM_HAVE_NICE = 1;


    enum DPP_ENUM_HAVE_NET_IF_H = 1;


    enum DPP_ENUM_HAVE_NETPACKET_PACKET_H = 1;


    enum DPP_ENUM_HAVE_NCURSES_H = 1;


    enum DPP_ENUM_HAVE_MREMAP = 1;


    enum DPP_ENUM_HAVE_MMAP = 1;


    enum DPP_ENUM_HAVE_MKTIME = 1;


    enum DPP_ENUM_HAVE_MKNODAT = 1;


    enum DPP_ENUM_HAVE_MKNOD = 1;


    enum DPP_ENUM_HAVE_MKFIFOAT = 1;


    enum DPP_ENUM_HAVE_MKFIFO = 1;


    enum DPP_ENUM_HAVE_MKDIRAT = 1;


    enum DPP_ENUM_HAVE_MEMRCHR = 1;


    enum DPP_ENUM_HAVE_MEMORY_H = 1;


    enum DPP_ENUM_HAVE_MBRTOWC = 1;


    enum DPP_ENUM_HAVE_MAKEDEV = 1;


    enum DPP_ENUM_HAVE_LUTIMES = 1;


    enum DPP_ENUM_HAVE_LSTAT = 1;


    enum DPP_ENUM_HAVE_LONG_DOUBLE = 1;


    enum DPP_ENUM_HAVE_LOG2 = 1;


    enum DPP_ENUM_HAVE_LOG1P = 1;


    enum DPP_ENUM_HAVE_LOCKF = 1;


    enum DPP_ENUM_HAVE_LINUX_VM_SOCKETS_H = 1;


    enum DPP_ENUM_HAVE_LINUX_TIPC_H = 1;


    enum DPP_ENUM_HAVE_LINUX_RANDOM_H = 1;


    enum DPP_ENUM_HAVE_LINUX_NETLINK_H = 1;


    enum DPP_ENUM_HAVE_LINUX_CAN_RAW_H = 1;


    enum DPP_ENUM_HAVE_LINUX_CAN_RAW_FD_FRAMES = 1;


    enum DPP_ENUM_HAVE_LINUX_CAN_H = 1;


    enum DPP_ENUM_HAVE_LINUX_CAN_BCM_H = 1;


    enum DPP_ENUM_HAVE_LINKAT = 1;


    enum DPP_ENUM_HAVE_LINK = 1;


    enum DPP_ENUM_HAVE_LIBREADLINE = 1;


    enum DPP_ENUM_HAVE_LIBINTL_H = 1;


    enum DPP_ENUM_HAVE_LIBDL = 1;


    enum DPP_ENUM_HAVE_LGAMMA = 1;


    enum DPP_ENUM_HAVE_LCHOWN = 1;


    enum DPP_ENUM_HAVE_LANGINFO_H = 1;


    enum DPP_ENUM_HAVE_KILLPG = 1;


    enum DPP_ENUM_HAVE_KILL = 1;


    enum DPP_ENUM_HAVE_INTTYPES_H = 1;


    enum DPP_ENUM_HAVE_INITGROUPS = 1;


    enum DPP_ENUM_HAVE_INET_PTON = 1;


    enum DPP_ENUM_HAVE_INET_ATON = 1;


    enum DPP_ENUM_HAVE_IF_NAMEINDEX = 1;


    enum DPP_ENUM_HAVE_HYPOT = 1;


    enum DPP_ENUM_HAVE_HTOLE64 = 1;


    enum DPP_ENUM_HAVE_HSTRERROR = 1;


    enum DPP_ENUM_HAVE_GRP_H = 1;


    enum DPP_ENUM_HAVE_GETWD = 1;


    enum DPP_ENUM_HAVE_GETTIMEOFDAY = 1;


    enum DPP_ENUM_HAVE_GETSPNAM = 1;


    enum DPP_ENUM_HAVE_GETSPENT = 1;


    enum DPP_ENUM_HAVE_GETSID = 1;


    enum DPP_ENUM_HAVE_GETRESUID = 1;


    enum DPP_ENUM_HAVE_GETRESGID = 1;


    enum DPP_ENUM_HAVE_GETRANDOM_SYSCALL = 1;


    enum DPP_ENUM_HAVE_GETRANDOM = 1;


    enum DPP_ENUM_HAVE_GETPWENT = 1;


    enum DPP_ENUM_HAVE_GETPRIORITY = 1;


    enum DPP_ENUM_HAVE_GETPID = 1;


    enum DPP_ENUM_HAVE_GETPGRP = 1;


    enum DPP_ENUM_HAVE_GETPGID = 1;


    enum DPP_ENUM_HAVE_GETPEERNAME = 1;


    enum DPP_ENUM_HAVE_GETPAGESIZE = 1;


    enum DPP_ENUM_HAVE_GETNAMEINFO = 1;


    enum DPP_ENUM_HAVE_GETLOGIN = 1;


    enum DPP_ENUM_HAVE_GETLOADAVG = 1;


    enum DPP_ENUM_HAVE_GETITIMER = 1;


    enum DPP_ENUM_HAVE_GETHOSTBYNAME_R_6_ARG = 1;


    enum DPP_ENUM_HAVE_GETHOSTBYNAME_R = 1;


    enum DPP_ENUM_HAVE_GETGROUPS = 1;


    enum DPP_ENUM_HAVE_GETGROUPLIST = 1;


    enum DPP_ENUM_HAVE_GETENTROPY = 1;


    enum DPP_ENUM_HAVE_GETC_UNLOCKED = 1;


    enum DPP_ENUM_HAVE_GETADDRINFO = 1;


    enum DPP_ENUM_HAVE_GCC_UINT128_T = 1;


    enum DPP_ENUM_HAVE_GCC_ASM_FOR_X87 = 1;


    enum DPP_ENUM_HAVE_GCC_ASM_FOR_X64 = 1;


    enum DPP_ENUM_HAVE_GAMMA = 1;


    enum DPP_ENUM_HAVE_GAI_STRERROR = 1;


    enum DPP_ENUM_HAVE_FUTIMESAT = 1;


    enum DPP_ENUM_HAVE_FUTIMES = 1;


    enum DPP_ENUM_HAVE_FUTIMENS = 1;


    enum DPP_ENUM_HAVE_FTRUNCATE = 1;


    enum DPP_ENUM_HAVE_FTIME = 1;


    enum DPP_ENUM_HAVE_FTELLO = 1;


    enum DPP_ENUM_HAVE_FSYNC = 1;


    enum DPP_ENUM_HAVE_FSTATVFS = 1;


    enum DPP_ENUM_HAVE_FSTATAT = 1;


    enum DPP_ENUM_HAVE_FSEEKO = 1;


    enum DPP_ENUM_HAVE_FPATHCONF = 1;


    enum DPP_ENUM_HAVE_FORKPTY = 1;


    enum DPP_ENUM_HAVE_FORK = 1;


    enum DPP_ENUM_HAVE_FLOCK = 1;


    enum DPP_ENUM_HAVE_FINITE = 1;


    enum DPP_ENUM_HAVE_FEXECVE = 1;


    enum DPP_ENUM_HAVE_FDOPENDIR = 1;


    enum DPP_ENUM_HAVE_FDATASYNC = 1;


    enum DPP_ENUM_HAVE_FCNTL_H = 1;




    enum DPP_ENUM_HAVE_FCHOWNAT = 1;


    enum DPP_ENUM_HAVE_FCHOWN = 1;


    enum DPP_ENUM_HAVE_FCHMODAT = 1;


    enum DPP_ENUM_HAVE_FCHMOD = 1;


    enum DPP_ENUM_HAVE_FCHDIR = 1;


    enum DPP_ENUM_HAVE_FACCESSAT = 1;




    enum DPP_ENUM_HAVE_EXPM1 = 1;


    enum DPP_ENUM_HAVE_EXECV = 1;


    enum DPP_ENUM_HAVE_ERRNO_H = 1;


    enum DPP_ENUM_HAVE_ERFC = 1;


    enum DPP_ENUM_HAVE_ERF = 1;


    enum DPP_ENUM_HAVE_EPOLL_CREATE1 = 1;


    enum DPP_ENUM_HAVE_EPOLL = 1;


    enum DPP_ENUM_HAVE_ENDIAN_H = 1;


    enum DPP_ENUM_HAVE_DYNAMIC_LOADING = 1;


    enum DPP_ENUM_HAVE_DUP3 = 1;


    enum DPP_ENUM_HAVE_DUP2 = 1;


    enum DPP_ENUM_HAVE_DLOPEN = 1;


    enum DPP_ENUM_HAVE_DLFCN_H = 1;


    enum DPP_ENUM_HAVE_DIRFD = 1;




    enum DPP_ENUM_HAVE_DIRENT_H = 1;




    enum DPP_ENUM_HAVE_DIRENT_D_TYPE = 1;


    enum DPP_ENUM_HAVE_DEV_PTMX = 1;


    enum DPP_ENUM_HAVE_DEVICE_MACROS = 1;


    enum DPP_ENUM_HAVE_DECL_RTLD_NOW = 1;


    enum DPP_ENUM_HAVE_DECL_RTLD_NOLOAD = 1;


    enum DPP_ENUM_HAVE_DECL_RTLD_NODELETE = 1;


    enum DPP_ENUM_HAVE_DECL_RTLD_MEMBER = 0;


    enum DPP_ENUM_HAVE_DECL_RTLD_LOCAL = 1;


    enum DPP_ENUM_HAVE_DECL_RTLD_LAZY = 1;
    enum DPP_ENUM_HAVE_DECL_RTLD_GLOBAL = 1;


    enum DPP_ENUM_HAVE_DECL_RTLD_DEEPBIND = 1;


    enum DPP_ENUM_HAVE_DECL_ISNAN = 1;


    enum DPP_ENUM_HAVE_DECL_ISINF = 1;


    enum DPP_ENUM_HAVE_DECL_ISFINITE = 1;


    enum DPP_ENUM_HAVE_CURSES_WCHGAT = 1;


    enum DPP_ENUM_HAVE_CURSES_USE_ENV = 1;


    enum DPP_ENUM_HAVE_CURSES_TYPEAHEAD = 1;


    enum DPP_ENUM_HAVE_CURSES_SYNCOK = 1;


    enum DPP_ENUM_HAVE_CURSES_RESIZE_TERM = 1;







    enum DPP_ENUM__SCHED_H = 1;


    enum DPP_ENUM_HAVE_CURSES_RESIZETERM = 1;


    enum DPP_ENUM_HAVE_CURSES_IS_TERM_RESIZED = 1;






    enum DPP_ENUM_HAVE_CURSES_IS_PAD = 1;


    enum DPP_ENUM_HAVE_CURSES_IMMEDOK = 1;


    enum DPP_ENUM_HAVE_CURSES_HAS_KEY = 1;


    enum DPP_ENUM_HAVE_CURSES_H = 1;


    enum DPP_ENUM_HAVE_CURSES_FILTER = 1;


    enum DPP_ENUM_HAVE_CTERMID = 1;


    enum DPP_ENUM_HAVE_CRYPT_H = 1;






    enum DPP_ENUM_HAVE_COPYSIGN = 1;


    enum DPP_ENUM_HAVE_CONFSTR = 1;


    enum DPP_ENUM_HAVE_COMPUTED_GOTOS = 1;


    enum DPP_ENUM_HAVE_CLOCK_SETTIME = 1;


    enum DPP_ENUM_HAVE_CLOCK_GETTIME = 1;


    enum DPP_ENUM_HAVE_CLOCK_GETRES = 1;


    enum DPP_ENUM_HAVE_CLOCK = 1;


    enum DPP_ENUM_HAVE_CHROOT = 1;


    enum DPP_ENUM_HAVE_CHOWN = 1;


    enum DPP_ENUM_HAVE_BUILTIN_ATOMIC = 1;


    enum DPP_ENUM_HAVE_BLUETOOTH_BLUETOOTH_H = 1;


    enum DPP_ENUM_HAVE_BIND_TEXTDOMAIN_CODESET = 1;


    enum DPP_ENUM_HAVE_ATANH = 1;


    enum DPP_ENUM_HAVE_ASM_TYPES_H = 1;


    enum DPP_ENUM_HAVE_ASINH = 1;


    enum DPP_ENUM_HAVE_ALLOCA_H = 1;


    enum DPP_ENUM_HAVE_ALARM = 1;


    enum DPP_ENUM_HAVE_ADDRINFO = 1;
    enum DPP_ENUM_HAVE_ACOSH = 1;


    enum DPP_ENUM_HAVE_ACCEPT4 = 1;


    enum DPP_ENUM_ENABLE_IPV6 = 1;


    enum DPP_ENUM_DOUBLE_IS_LITTLE_ENDIAN_IEEE754 = 1;




    enum DPP_ENUM__STDC_PREDEF_H = 1;


    enum DPP_ENUM__STDINT_H = 1;
    enum DPP_ENUM_PY_RELEASE_SERIAL = 0;




    enum DPP_ENUM_PY_MICRO_VERSION = 1;


    enum DPP_ENUM_PY_MINOR_VERSION = 7;


    enum DPP_ENUM_PY_MAJOR_VERSION = 3;
    enum DPP_ENUM_INT8_WIDTH = 8;


    enum DPP_ENUM_UINT8_WIDTH = 8;


    enum DPP_ENUM_INT16_WIDTH = 16;


    enum DPP_ENUM_UINT16_WIDTH = 16;


    enum DPP_ENUM_INT32_WIDTH = 32;


    enum DPP_ENUM_UINT32_WIDTH = 32;


    enum DPP_ENUM_INT64_WIDTH = 64;


    enum DPP_ENUM_UINT64_WIDTH = 64;


    enum DPP_ENUM_INT_LEAST8_WIDTH = 8;


    enum DPP_ENUM_UINT_LEAST8_WIDTH = 8;


    enum DPP_ENUM_INT_LEAST16_WIDTH = 16;


    enum DPP_ENUM_UINT_LEAST16_WIDTH = 16;


    enum DPP_ENUM_INT_LEAST32_WIDTH = 32;


    enum DPP_ENUM_UINT_LEAST32_WIDTH = 32;


    enum DPP_ENUM_INT_LEAST64_WIDTH = 64;


    enum DPP_ENUM_UINT_LEAST64_WIDTH = 64;


    enum DPP_ENUM_INT_FAST8_WIDTH = 8;


    enum DPP_ENUM_UINT_FAST8_WIDTH = 8;
    enum DPP_ENUM_INT_FAST64_WIDTH = 64;


    enum DPP_ENUM_UINT_FAST64_WIDTH = 64;






    enum DPP_ENUM_INTMAX_WIDTH = 64;


    enum DPP_ENUM_UINTMAX_WIDTH = 64;




    enum DPP_ENUM_SIG_ATOMIC_WIDTH = 32;




    enum DPP_ENUM_WCHAR_WIDTH = 32;


    enum DPP_ENUM_WINT_WIDTH = 32;


    enum DPP_ENUM__STDIO_H = 1;
    enum DPP_ENUM__IOFBF = 0;


    enum DPP_ENUM__IOLBF = 1;


    enum DPP_ENUM__IONBF = 2;


    enum DPP_ENUM_BUFSIZ = 8192;




    enum DPP_ENUM_SEEK_SET = 0;


    enum DPP_ENUM_SEEK_CUR = 1;


    enum DPP_ENUM_SEEK_END = 2;
    enum DPP_ENUM_SEEK_DATA = 3;


    enum DPP_ENUM_SEEK_HOLE = 4;


    enum DPP_ENUM_PyTrash_UNWIND_LEVEL = 50;
    enum DPP_ENUM_Py_GE = 5;


    enum DPP_ENUM_Py_GT = 4;


    enum DPP_ENUM_Py_NE = 3;


    enum DPP_ENUM_Py_EQ = 2;
    enum DPP_ENUM_Py_LE = 1;


    enum DPP_ENUM_Py_LT = 0;
    enum DPP_ENUM_Py_TPFLAGS_HAVE_STACKLESS_EXTENSION = 0;
    enum DPP_ENUM_Py_PRINT_RAW = 1;
    enum DPP_ENUM_PyBUF_SIMPLE = 0;


    enum DPP_ENUM_PyBUF_MAX_NDIM = 64;
    enum DPP_ENUM__Py_mod_LAST_SLOT = 2;


    enum DPP_ENUM_Py_mod_exec = 2;


    enum DPP_ENUM_Py_mod_create = 1;
    enum DPP_ENUM_PYTHON_ABI_VERSION = 3;




    enum DPP_ENUM_PYTHON_API_VERSION = 1013;
    enum DPP_ENUM__PyLong_DECIMAL_SHIFT = 9;


    enum DPP_ENUM_PyLong_SHIFT = 30;
    enum DPP_ENUM_PyWrapperFlag_KEYWORDS = 1;
    enum DPP_ENUM__PyDateTime_DATETIME_DATASIZE = 10;


    enum DPP_ENUM__PyDateTime_TIME_DATASIZE = 6;


    enum DPP_ENUM__PyDateTime_DATE_DATASIZE = 4;
    enum DPP_ENUM_Py_eval_input = 258;


    enum DPP_ENUM__STDLIB_H = 1;


    enum DPP_ENUM_Py_file_input = 257;


    enum DPP_ENUM_Py_single_input = 256;
    enum DPP_ENUM___ldiv_t_defined = 1;
    enum DPP_ENUM___lldiv_t_defined = 1;


    enum DPP_ENUM_RAND_MAX = 2147483647;


    enum DPP_ENUM_EXIT_FAILURE = 1;


    enum DPP_ENUM_EXIT_SUCCESS = 0;
    enum DPP_ENUM_CO_MAXBLOCKS = 20;
    enum DPP_ENUM_PY_ITERSEARCH_CONTAINS = 3;


    enum DPP_ENUM_PY_ITERSEARCH_INDEX = 2;


    enum DPP_ENUM_PY_ITERSEARCH_COUNT = 1;
    enum DPP_ENUM__PY_FASTCALL_SMALL_STACK = 5;
    enum DPP_ENUM_PTHREAD_BARRIER_SERIAL_THREAD = -1;


    enum DPP_ENUM_PTHREAD_ONCE_INIT = 0;
    enum DPP_ENUM__PTHREAD_H = 1;
    enum DPP_ENUM_M_SQRT1_2 = 0.70710678118654752440;


    enum DPP_ENUM_M_SQRT2 = 1.41421356237309504880;


    enum DPP_ENUM_M_2_SQRTPI = 1.12837916709551257390;


    enum DPP_ENUM_M_2_PI = 0.63661977236758134308;


    enum DPP_ENUM_M_1_PI = 0.31830988618379067154;


    enum DPP_ENUM_M_PI_4 = 0.78539816339744830962;


    enum DPP_ENUM_M_PI_2 = 1.57079632679489661923;


    enum DPP_ENUM_M_PI = 3.14159265358979323846;


    enum DPP_ENUM_M_LN10 = 2.30258509299404568402;


    enum DPP_ENUM_M_LN2 = 0.69314718055994530942;


    enum DPP_ENUM_M_LOG10E = 0.43429448190325182765;


    enum DPP_ENUM_M_LOG2E = 1.4426950408889634074;


    enum DPP_ENUM_M_E = 2.7182818284590452354;
    enum DPP_ENUM_MATH_ERREXCEPT = 2;


    enum DPP_ENUM_MATH_ERRNO = 1;
    enum DPP_ENUM_FP_NORMAL = 4;


    enum DPP_ENUM_FP_SUBNORMAL = 3;


    enum DPP_ENUM_FP_ZERO = 2;


    enum DPP_ENUM_FP_INFINITE = 1;


    enum DPP_ENUM_FP_NAN = 0;
    enum DPP_ENUM___MATH_DECLARING_FLOATN = 1;


    enum DPP_ENUM___MATH_DECLARING_DOUBLE = 0;






    enum DPP_ENUM___MATH_DECLARE_LDOUBLE = 1;
    enum DPP_ENUM_FP_INT_TONEAREST = 4;


    enum DPP_ENUM_FP_INT_TONEARESTFROMZERO = 3;


    enum DPP_ENUM_FP_INT_TOWARDZERO = 2;


    enum DPP_ENUM_FP_INT_DOWNWARD = 1;


    enum DPP_ENUM_FP_INT_UPWARD = 0;
    enum DPP_ENUM__MATH_H = 1;


    enum DPP_ENUM_RTSIG_MAX = 32;


    enum DPP_ENUM_XATTR_LIST_MAX = 65536;


    enum DPP_ENUM_XATTR_SIZE_MAX = 65536;


    enum DPP_ENUM_XATTR_NAME_MAX = 255;


    enum DPP_ENUM_PIPE_BUF = 4096;


    enum DPP_ENUM_PATH_MAX = 4096;


    enum DPP_ENUM_NAME_MAX = 255;


    enum DPP_ENUM_MAX_INPUT = 255;


    enum DPP_ENUM_MAX_CANON = 255;


    enum DPP_ENUM_LINK_MAX = 127;


    enum DPP_ENUM_ARG_MAX = 131072;


    enum DPP_ENUM_NGROUPS_MAX = 65536;


    enum DPP_ENUM_NR_OPEN = 1024;




    enum DPP_ENUM_ULLONG_WIDTH = 64;


    enum DPP_ENUM_LLONG_WIDTH = 64;






    enum DPP_ENUM_UINT_WIDTH = 32;


    enum DPP_ENUM_INT_WIDTH = 32;


    enum DPP_ENUM_USHRT_WIDTH = 16;


    enum DPP_ENUM_SHRT_WIDTH = 16;


    enum DPP_ENUM_UCHAR_WIDTH = 8;


    enum DPP_ENUM_SCHAR_WIDTH = 8;


    enum DPP_ENUM_CHAR_WIDTH = 8;
    enum DPP_ENUM_MB_LEN_MAX = 16;


    enum DPP_ENUM__LIBC_LIMITS_H_ = 1;
    enum DPP_ENUM__STRING_H = 1;
    enum DPP_ENUM_____gwchar_t_defined = 1;


    enum DPP_ENUM__INTTYPES_H = 1;
    enum DPP_ENUM___GLIBC_MINOR__ = 28;


    enum DPP_ENUM___GLIBC__ = 2;


    enum DPP_ENUM___GNU_LIBRARY__ = 6;


    enum DPP_ENUM___GLIBC_USE_DEPRECATED_GETS = 0;


    enum DPP_ENUM___USE_FORTIFY_LEVEL = 0;


    enum DPP_ENUM___USE_GNU = 1;


    enum DPP_ENUM___USE_ATFILE = 1;


    enum DPP_ENUM___USE_MISC = 1;


    enum DPP_ENUM___USE_FILE_OFFSET64 = 1;


    enum DPP_ENUM___USE_LARGEFILE64 = 1;


    enum DPP_ENUM___USE_LARGEFILE = 1;


    enum DPP_ENUM___USE_ISOC99 = 1;


    enum DPP_ENUM___USE_ISOC95 = 1;


    enum DPP_ENUM___USE_XOPEN2KXSI = 1;


    enum DPP_ENUM___USE_XOPEN2K = 1;


    enum DPP_ENUM___USE_XOPEN2K8XSI = 1;


    enum DPP_ENUM___USE_XOPEN2K8 = 1;


    enum DPP_ENUM___USE_UNIX98 = 1;


    enum DPP_ENUM___USE_XOPEN_EXTENDED = 1;


    enum DPP_ENUM___USE_XOPEN = 1;


    enum DPP_ENUM__ATFILE_SOURCE = 1;


    enum DPP_ENUM___USE_POSIX199506 = 1;


    enum DPP_ENUM___USE_POSIX199309 = 1;


    enum DPP_ENUM___USE_POSIX2 = 1;


    enum DPP_ENUM___USE_POSIX = 1;


    enum DPP_ENUM__POSIX_SOURCE = 1;


    enum DPP_ENUM___USE_ISOC11 = 1;


    enum DPP_ENUM__DEFAULT_SOURCE = 1;


    enum DPP_ENUM__LARGEFILE64_SOURCE = 1;


    enum DPP_ENUM__ISOC11_SOURCE = 1;


    enum DPP_ENUM__ISOC99_SOURCE = 1;


    enum DPP_ENUM__ISOC95_SOURCE = 1;
    enum DPP_ENUM__FEATURES_H = 1;




    enum DPP_ENUM__ERRNO_H = 1;
    enum DPP_ENUM___PDP_ENDIAN = 3412;


    enum DPP_ENUM___BIG_ENDIAN = 4321;


    enum DPP_ENUM___LITTLE_ENDIAN = 1234;


    enum DPP_ENUM__ENDIAN_H = 1;
    enum DPP_ENUM__CTYPE_H = 1;


    enum DPP_ENUM__CRYPT_H = 1;


    enum DPP_ENUM_LONG_BIT = 64;


    enum DPP_ENUM_WORD_BIT = 32;


    enum DPP_ENUM_NZERO = 20;
    enum DPP_ENUM__XOPEN_LIM_H = 1;


    enum DPP_ENUM___SYSCALL_WORDSIZE = 64;


    enum DPP_ENUM___WORDSIZE_TIME64_COMPAT32 = 1;


    enum DPP_ENUM___WORDSIZE = 64;






    enum DPP_ENUM__BITS_WCHAR_H = 1;
    enum DPP_ENUM__STRINGS_H = 1;
    enum DPP_ENUM_WCONTINUED = 8;


    enum DPP_ENUM_WEXITED = 4;


    enum DPP_ENUM_WSTOPPED = 2;


    enum DPP_ENUM_WUNTRACED = 2;


    enum DPP_ENUM_WNOHANG = 1;


    enum DPP_ENUM___IOV_MAX = 1024;


    enum DPP_ENUM__BITS_UIO_LIM_H = 1;


    enum DPP_ENUM__BITS_UINTN_IDENTITY_H = 1;


    enum DPP_ENUM___FD_SETSIZE = 1024;


    enum DPP_ENUM___RLIM_T_MATCHES_RLIM64_T = 1;


    enum DPP_ENUM___INO_T_MATCHES_INO64_T = 1;


    enum DPP_ENUM___OFF_T_MATCHES_OFF64_T = 1;
    enum DPP_ENUM__BITS_TYPESIZES_H = 1;


    enum DPP_ENUM__WINT_T = 1;


    enum DPP_ENUM___wint_t_defined = 1;


    enum DPP_ENUM___timer_t_defined = 1;


    enum DPP_ENUM___time_t_defined = 1;


    enum DPP_ENUM___struct_tm_defined = 1;


    enum DPP_ENUM___timeval_defined = 1;


    enum DPP_ENUM__STRUCT_TIMESPEC = 1;


    enum DPP_ENUM__BITS_TYPES_STRUCT_SCHED_PARAM = 1;


    enum DPP_ENUM__SYS_CDEFS_H = 1;


    enum DPP_ENUM___itimerspec_defined = 1;
    enum DPP_ENUM___struct_FILE_defined = 1;
    enum DPP_ENUM___sigset_t_defined = 1;


    enum DPP_ENUM___mbstate_t_defined = 1;




    enum DPP_ENUM___glibc_c99_flexarr_available = 1;


    enum DPP_ENUM__BITS_TYPES_LOCALE_T_H = 1;


    enum DPP_ENUM___error_t_defined = 1;
    enum DPP_ENUM___cookie_io_functions_t_defined = 1;


    enum DPP_ENUM___clockid_t_defined = 1;


    enum DPP_ENUM___clock_t_defined = 1;
    enum DPP_ENUM_____mbstate_t_defined = 1;




    enum DPP_ENUM__BITS_TYPES___LOCALE_T_H = 1;






    enum DPP_ENUM______fpos_t_defined = 1;




    enum DPP_ENUM______fpos64_t_defined = 1;


    enum DPP_ENUM_____FILE_defined = 1;





    enum DPP_ENUM___FILE_defined = 1;
    enum DPP_ENUM__BITS_TYPES_H = 1;
    enum DPP_ENUM___HAVE_GENERIC_SELECTION = 1;


    enum DPP_ENUM__SYS_SELECT_H = 1;
    enum DPP_ENUM__BITS_TIMEX_H = 1;


    enum DPP_ENUM_TIMER_ABSTIME = 1;


    enum DPP_ENUM__SYS_STAT_H = 1;


    enum DPP_ENUM_CLOCK_TAI = 11;


    enum DPP_ENUM_CLOCK_BOOTTIME_ALARM = 9;


    enum DPP_ENUM_CLOCK_REALTIME_ALARM = 8;


    enum DPP_ENUM_CLOCK_BOOTTIME = 7;


    enum DPP_ENUM_CLOCK_MONOTONIC_COARSE = 6;


    enum DPP_ENUM_CLOCK_REALTIME_COARSE = 5;


    enum DPP_ENUM_CLOCK_MONOTONIC_RAW = 4;


    enum DPP_ENUM_CLOCK_THREAD_CPUTIME_ID = 3;


    enum DPP_ENUM_CLOCK_PROCESS_CPUTIME_ID = 2;


    enum DPP_ENUM_CLOCK_MONOTONIC = 1;


    enum DPP_ENUM_CLOCK_REALTIME = 0;




    enum DPP_ENUM__BITS_TIME_H = 1;


    enum DPP_ENUM___PTHREAD_MUTEX_HAVE_PREV = 1;
    enum DPP_ENUM__THREAD_SHARED_TYPES_H = 1;


    enum DPP_ENUM_FOPEN_MAX = 16;


    enum DPP_ENUM_L_cuserid = 9;


    enum DPP_ENUM_L_ctermid = 9;


    enum DPP_ENUM_FILENAME_MAX = 4096;
    enum DPP_ENUM_TMP_MAX = 238328;




    enum DPP_ENUM_L_tmpnam = 20;




    enum DPP_ENUM__BITS_STDIO_LIM_H = 1;


    enum DPP_ENUM__BITS_STDINT_UINTN_H = 1;


    enum DPP_ENUM__BITS_STDINT_INTN_H = 1;
    enum DPP_ENUM_S_BLKSIZE = 512;
    enum DPP_ENUM___S_IEXEC = std.conv.octal!100;


    enum DPP_ENUM___S_IWRITE = std.conv.octal!200;


    enum DPP_ENUM___S_IREAD = std.conv.octal!400;


    enum DPP_ENUM___S_ISVTX = std.conv.octal!1000;


    enum DPP_ENUM___S_ISGID = std.conv.octal!2000;


    enum DPP_ENUM___S_ISUID = std.conv.octal!4000;
    enum DPP_ENUM___S_IFSOCK = std.conv.octal!140000;


    enum DPP_ENUM___S_IFLNK = std.conv.octal!120000;


    enum DPP_ENUM___S_IFIFO = std.conv.octal!10000;


    enum DPP_ENUM___S_IFREG = std.conv.octal!100000;


    enum DPP_ENUM___S_IFBLK = std.conv.octal!60000;


    enum DPP_ENUM___S_IFCHR = std.conv.octal!20000;


    enum DPP_ENUM___S_IFDIR = std.conv.octal!40000;


    enum DPP_ENUM___S_IFMT = std.conv.octal!170000;
    enum DPP_ENUM__MKNOD_VER_LINUX = 0;


    enum DPP_ENUM__STAT_VER_LINUX = 1;


    enum DPP_ENUM__STAT_VER_KERNEL = 0;


    enum DPP_ENUM__BITS_STAT_H = 1;


    enum DPP_ENUM__BITS_SETJMP_H = 1;
    enum DPP_ENUM_SCHED_DEADLINE = 6;


    enum DPP_ENUM_SCHED_IDLE = 5;


    enum DPP_ENUM_SCHED_ISO = 4;


    enum DPP_ENUM_SCHED_BATCH = 3;


    enum DPP_ENUM_SCHED_RR = 2;


    enum DPP_ENUM_SCHED_FIFO = 1;


    enum DPP_ENUM_SCHED_OTHER = 0;


    enum DPP_ENUM__BITS_SCHED_H = 1;


    enum DPP_ENUM___have_pthread_attr_t = 1;


    enum DPP_ENUM__BITS_PTHREADTYPES_COMMON_H = 1;


    enum DPP_ENUM___PTHREAD_RWLOCK_INT_FLAGS_SHARED = 1;
    enum DPP_ENUM___PTHREAD_MUTEX_USE_UNION = 0;


    enum DPP_ENUM___PTHREAD_MUTEX_NUSERS_AFTER_KIND = 0;


    enum DPP_ENUM___PTHREAD_MUTEX_LOCK_ELISION = 1;




    enum DPP_ENUM__MKNOD_VER = 0;




    enum DPP_ENUM___SIZEOF_PTHREAD_BARRIERATTR_T = 4;


    enum DPP_ENUM___SIZEOF_PTHREAD_RWLOCKATTR_T = 8;


    enum DPP_ENUM___SIZEOF_PTHREAD_CONDATTR_T = 4;


    enum DPP_ENUM___SIZEOF_PTHREAD_COND_T = 48;


    enum DPP_ENUM___SIZEOF_PTHREAD_MUTEXATTR_T = 4;


    enum DPP_ENUM___SIZEOF_PTHREAD_BARRIER_T = 32;


    enum DPP_ENUM___SIZEOF_PTHREAD_RWLOCK_T = 56;


    enum DPP_ENUM___SIZEOF_PTHREAD_MUTEX_T = 40;


    enum DPP_ENUM___SIZEOF_PTHREAD_ATTR_T = 56;


    enum DPP_ENUM__BITS_PTHREADTYPES_ARCH_H = 1;


    enum DPP_ENUM__POSIX_TYPED_MEMORY_OBJECTS = -1;


    enum DPP_ENUM__POSIX_TRACE_LOG = -1;


    enum DPP_ENUM__POSIX_TRACE_INHERIT = -1;


    enum DPP_ENUM__POSIX_TRACE_EVENT_FILTER = -1;


    enum DPP_ENUM__POSIX_TRACE = -1;


    enum DPP_ENUM__POSIX_THREAD_SPORADIC_SERVER = -1;


    enum DPP_ENUM__POSIX_SPORADIC_SERVER = -1;
    enum DPP_ENUM__POSIX_MONOTONIC_CLOCK = 0;
    enum DPP_ENUM__POSIX_SHELL = 1;




    enum DPP_ENUM__POSIX_REGEXP = 1;


    enum DPP_ENUM__POSIX_THREAD_CPUTIME = 0;


    enum DPP_ENUM__SYS_TIME_H = 1;


    enum DPP_ENUM__POSIX_CPUTIME = 0;




    enum DPP_ENUM__LFS64_STDIO = 1;


    enum DPP_ENUM__LFS64_LARGEFILE = 1;


    enum DPP_ENUM__LFS_LARGEFILE = 1;


    enum DPP_ENUM__LFS64_ASYNCHRONOUS_IO = 1;




    enum DPP_ENUM__LFS_ASYNCHRONOUS_IO = 1;
    enum DPP_ENUM__POSIX_ASYNC_IO = 1;
    enum DPP_ENUM__POSIX_THREAD_ROBUST_PRIO_PROTECT = -1;
    enum DPP_ENUM__POSIX_REENTRANT_FUNCTIONS = 1;




    enum DPP_ENUM__XOPEN_SHM = 1;


    enum DPP_ENUM__XOPEN_REALTIME_THREADS = 1;


    enum DPP_ENUM__XOPEN_REALTIME = 1;


    enum DPP_ENUM__POSIX_NO_TRUNC = 1;




    enum DPP_ENUM__POSIX_CHOWN_RESTRICTED = 0;
    enum DPP_ENUM__POSIX_SAVED_IDS = 1;


    enum DPP_ENUM__POSIX_JOB_CONTROL = 1;


    enum DPP_ENUM__BITS_POSIX_OPT_H = 1;




    enum DPP_ENUM_CHARCLASS_NAME_MAX = 2048;
    enum DPP_ENUM__SYS_TYPES_H = 1;




    enum DPP_ENUM_COLL_WEIGHTS_MAX = 255;
    enum DPP_ENUM__POSIX2_CHARCLASS_NAME_MAX = 14;


    enum DPP_ENUM__POSIX2_RE_DUP_MAX = 255;


    enum DPP_ENUM__POSIX2_LINE_MAX = 2048;


    enum DPP_ENUM__POSIX2_EXPR_NEST_MAX = 32;


    enum DPP_ENUM__POSIX2_COLL_WEIGHTS_MAX = 2;




    enum DPP_ENUM__POSIX2_BC_STRING_MAX = 1000;


    enum DPP_ENUM__POSIX2_BC_SCALE_MAX = 99;


    enum DPP_ENUM__POSIX2_BC_DIM_MAX = 2048;




    enum DPP_ENUM__POSIX2_BC_BASE_MAX = 99;


    enum DPP_ENUM__BITS_POSIX2_LIM_H = 1;
    enum DPP_ENUM__POSIX_CLOCKRES_MIN = 20000000;




    enum DPP_ENUM__POSIX_UIO_MAXIOV = 16;
    enum DPP_ENUM__POSIX_QLIMIT = 1;




    enum DPP_ENUM__POSIX_TZNAME_MAX = 6;


    enum DPP_ENUM__POSIX_TTY_NAME_MAX = 9;


    enum DPP_ENUM__POSIX_TIMER_MAX = 32;


    enum DPP_ENUM__POSIX_SYMLOOP_MAX = 8;




    enum DPP_ENUM__POSIX_SYMLINK_MAX = 255;


    enum DPP_ENUM__POSIX_STREAM_MAX = 8;


    enum DPP_ENUM__POSIX_SSIZE_MAX = 32767;




    enum DPP_ENUM__POSIX_SIGQUEUE_MAX = 32;


    enum DPP_ENUM__POSIX_SEM_VALUE_MAX = 32767;


    enum DPP_ENUM__POSIX_SEM_NSEMS_MAX = 256;


    enum DPP_ENUM__POSIX_RTSIG_MAX = 8;




    enum DPP_ENUM__POSIX_RE_DUP_MAX = 255;


    enum DPP_ENUM__POSIX_PIPE_BUF = 512;


    enum DPP_ENUM__POSIX_PATH_MAX = 256;






    enum DPP_ENUM__POSIX_OPEN_MAX = 20;


    enum DPP_ENUM__POSIX_NGROUPS_MAX = 8;


    enum DPP_ENUM__POSIX_NAME_MAX = 14;


    enum DPP_ENUM__POSIX_MQ_PRIO_MAX = 32;


    enum DPP_ENUM__POSIX_MQ_OPEN_MAX = 8;


    enum DPP_ENUM__POSIX_MAX_INPUT = 255;


    enum DPP_ENUM__POSIX_MAX_CANON = 255;




    enum DPP_ENUM__POSIX_LOGIN_NAME_MAX = 9;




    enum DPP_ENUM__POSIX_LINK_MAX = 8;


    enum DPP_ENUM__POSIX_HOST_NAME_MAX = 255;


    enum DPP_ENUM__POSIX_DELAYTIMER_MAX = 32;


    enum DPP_ENUM__POSIX_CHILD_MAX = 25;


    enum DPP_ENUM__POSIX_ARG_MAX = 4096;


    enum DPP_ENUM__POSIX_AIO_MAX = 1;


    enum DPP_ENUM__POSIX_AIO_LISTIO_MAX = 2;





    enum DPP_ENUM__BITS_POSIX1_LIM_H = 1;




    enum DPP_ENUM_MQ_PRIO_MAX = 32768;


    enum DPP_ENUM_HOST_NAME_MAX = 64;


    enum DPP_ENUM_LOGIN_NAME_MAX = 256;


    enum DPP_ENUM_TTY_NAME_MAX = 32;


    enum DPP_ENUM_DELAYTIMER_MAX = 2147483647;


    enum DPP_ENUM_PTHREAD_STACK_MIN = 16384;


    enum DPP_ENUM_AIO_PRIO_DELTA_MAX = 20;


    enum DPP_ENUM___BIT_TYPES_DEFINED__ = 1;


    enum DPP_ENUM__POSIX_THREAD_THREADS_MAX = 64;




    enum DPP_ENUM__POSIX_THREAD_DESTRUCTOR_ITERATIONS = 4;


    enum DPP_ENUM_PTHREAD_KEYS_MAX = 1024;


    enum DPP_ENUM__POSIX_THREAD_KEYS_MAX = 128;
    enum DPP_ENUM__TIME_H = 1;
    enum DPP_ENUM_TIME_UTC = 1;
    enum DPP_ENUM__BITS_LIBM_SIMD_DECL_STUBS_H = 1;


    enum DPP_ENUM___GLIBC_USE_IEC_60559_TYPES_EXT = 1;


    enum DPP_ENUM___GLIBC_USE_IEC_60559_FUNCS_EXT = 1;


    enum DPP_ENUM___GLIBC_USE_IEC_60559_BFP_EXT = 1;





    enum DPP_ENUM___GLIBC_USE_LIB_EXT2 = 1;
    enum DPP_ENUM__GETOPT_POSIX_H = 1;


    enum DPP_ENUM__GETOPT_CORE_H = 1;


    enum DPP_ENUM___FP_LOGBNAN_IS_MIN = 1;


    enum DPP_ENUM___FP_LOGB0_IS_MIN = 1;




    enum DPP_ENUM___HAVE_FLOAT64X_LONG_DOUBLE = 1;


    enum DPP_ENUM___HAVE_FLOAT64X = 1;


    enum DPP_ENUM___HAVE_DISTINCT_FLOAT128 = 0;


    enum DPP_ENUM___HAVE_FLOAT128 = 0;
    enum DPP_ENUM__UNISTD_H = 1;
    enum DPP_ENUM__XOPEN_VERSION = 700;


    enum DPP_ENUM__XOPEN_XCU_VERSION = 4;


    enum DPP_ENUM__XOPEN_XPG2 = 1;


    enum DPP_ENUM__XOPEN_XPG3 = 1;


    enum DPP_ENUM__XOPEN_XPG4 = 1;


    enum DPP_ENUM__XOPEN_UNIX = 1;


    enum DPP_ENUM__XOPEN_ENH_I18N = 1;


    enum DPP_ENUM__XOPEN_LEGACY = 1;






    enum DPP_ENUM___HAVE_FLOATN_NOT_TYPEDEF = 0;





    enum DPP_ENUM_STDIN_FILENO = 0;


    enum DPP_ENUM_STDOUT_FILENO = 1;


    enum DPP_ENUM_STDERR_FILENO = 2;




    enum DPP_ENUM___HAVE_DISTINCT_FLOAT64X = 0;


    enum DPP_ENUM___HAVE_DISTINCT_FLOAT32X = 0;


    enum DPP_ENUM___HAVE_DISTINCT_FLOAT64 = 0;


    enum DPP_ENUM___HAVE_DISTINCT_FLOAT32 = 0;




    enum DPP_ENUM___HAVE_FLOAT128X = 0;


    enum DPP_ENUM___HAVE_FLOAT32X = 1;


    enum DPP_ENUM___HAVE_FLOAT64 = 1;


    enum DPP_ENUM___HAVE_FLOAT32 = 1;


    enum DPP_ENUM___HAVE_FLOAT16 = 0;






    enum DPP_ENUM__BITS_ERRNO_H = 1;
    enum DPP_ENUM_R_OK = 4;


    enum DPP_ENUM_W_OK = 2;


    enum DPP_ENUM_X_OK = 1;


    enum DPP_ENUM_F_OK = 0;






    enum DPP_ENUM__XBS5_LP64_OFF64 = 1;


    enum DPP_ENUM__POSIX_V6_LP64_OFF64 = 1;


    enum DPP_ENUM__POSIX_V7_LP64_OFF64 = 1;


    enum DPP_ENUM__XBS5_LPBIG_OFFBIG = -1;


    enum DPP_ENUM__POSIX_V6_LPBIG_OFFBIG = -1;


    enum DPP_ENUM__POSIX_V7_LPBIG_OFFBIG = -1;
    enum DPP_ENUM___CPU_SETSIZE = 1024;


    enum DPP_ENUM__BITS_CPU_SET_H = 1;
    enum DPP_ENUM__BITS_BYTESWAP_H = 1;
    enum DPP_ENUM__ASSERT_H = 1;


    enum DPP_ENUM_EHWPOISON = 133;


    enum DPP_ENUM_ERFKILL = 132;


    enum DPP_ENUM_ENOTRECOVERABLE = 131;


    enum DPP_ENUM_EOWNERDEAD = 130;


    enum DPP_ENUM_EKEYREJECTED = 129;


    enum DPP_ENUM_EKEYREVOKED = 128;


    enum DPP_ENUM_EKEYEXPIRED = 127;


    enum DPP_ENUM_ENOKEY = 126;


    enum DPP_ENUM_ECANCELED = 125;


    enum DPP_ENUM_EMEDIUMTYPE = 124;


    enum DPP_ENUM_ENOMEDIUM = 123;


    enum DPP_ENUM_EDQUOT = 122;


    enum DPP_ENUM_EREMOTEIO = 121;


    enum DPP_ENUM_EISNAM = 120;


    enum DPP_ENUM_ENAVAIL = 119;


    enum DPP_ENUM_ENOTNAM = 118;


    enum DPP_ENUM_EUCLEAN = 117;


    enum DPP_ENUM_ESTALE = 116;


    enum DPP_ENUM_EINPROGRESS = 115;


    enum DPP_ENUM_EALREADY = 114;


    enum DPP_ENUM_EHOSTUNREACH = 113;


    enum DPP_ENUM_EHOSTDOWN = 112;


    enum DPP_ENUM_ECONNREFUSED = 111;


    enum DPP_ENUM_ETIMEDOUT = 110;


    enum DPP_ENUM_ETOOMANYREFS = 109;


    enum DPP_ENUM_ESHUTDOWN = 108;


    enum DPP_ENUM_ENOTCONN = 107;


    enum DPP_ENUM_EISCONN = 106;


    enum DPP_ENUM_ENOBUFS = 105;


    enum DPP_ENUM_ECONNRESET = 104;


    enum DPP_ENUM_ECONNABORTED = 103;


    enum DPP_ENUM_ENETRESET = 102;


    enum DPP_ENUM_ENETUNREACH = 101;


    enum DPP_ENUM_ENETDOWN = 100;


    enum DPP_ENUM_EADDRNOTAVAIL = 99;


    enum DPP_ENUM_EADDRINUSE = 98;


    enum DPP_ENUM_EAFNOSUPPORT = 97;


    enum DPP_ENUM_EPFNOSUPPORT = 96;


    enum DPP_ENUM_EOPNOTSUPP = 95;


    enum DPP_ENUM_ESOCKTNOSUPPORT = 94;


    enum DPP_ENUM_EPROTONOSUPPORT = 93;


    enum DPP_ENUM_ENOPROTOOPT = 92;


    enum DPP_ENUM_EPROTOTYPE = 91;


    enum DPP_ENUM_EMSGSIZE = 90;


    enum DPP_ENUM_EDESTADDRREQ = 89;


    enum DPP_ENUM_ENOTSOCK = 88;


    enum DPP_ENUM_EUSERS = 87;


    enum DPP_ENUM_ESTRPIPE = 86;


    enum DPP_ENUM_ERESTART = 85;


    enum DPP_ENUM_EILSEQ = 84;


    enum DPP_ENUM_ELIBEXEC = 83;


    enum DPP_ENUM_ELIBMAX = 82;


    enum DPP_ENUM_ELIBSCN = 81;


    enum DPP_ENUM_ELIBBAD = 80;


    enum DPP_ENUM_ELIBACC = 79;


    enum DPP_ENUM_EREMCHG = 78;


    enum DPP_ENUM_EBADFD = 77;


    enum DPP_ENUM_ENOTUNIQ = 76;


    enum DPP_ENUM_EOVERFLOW = 75;


    enum DPP_ENUM_EBADMSG = 74;


    enum DPP_ENUM_EDOTDOT = 73;


    enum DPP_ENUM_EMULTIHOP = 72;


    enum DPP_ENUM_EPROTO = 71;


    enum DPP_ENUM_ECOMM = 70;


    enum DPP_ENUM_F_ULOCK = 0;


    enum DPP_ENUM_F_LOCK = 1;


    enum DPP_ENUM_F_TLOCK = 2;


    enum DPP_ENUM_F_TEST = 3;


    enum DPP_ENUM_ESRMNT = 69;


    enum DPP_ENUM_EADV = 68;


    enum DPP_ENUM_ENOLINK = 67;


    enum DPP_ENUM_EREMOTE = 66;


    enum DPP_ENUM_ENOPKG = 65;


    enum DPP_ENUM_ENONET = 64;


    enum DPP_ENUM_ENOSR = 63;


    enum DPP_ENUM_ETIME = 62;


    enum DPP_ENUM_ENODATA = 61;
    enum DPP_ENUM_ENOSTR = 60;


    enum DPP_ENUM_EBFONT = 59;




    enum DPP_ENUM_EBADSLT = 57;


    enum DPP_ENUM_EBADRQC = 56;


    enum DPP_ENUM_ENOANO = 55;


    enum DPP_ENUM_EXFULL = 54;


    enum DPP_ENUM_EBADR = 53;


    enum DPP_ENUM_EBADE = 52;


    enum DPP_ENUM_EL2HLT = 51;


    enum DPP_ENUM_ENOCSI = 50;


    enum DPP_ENUM_EUNATCH = 49;


    enum DPP_ENUM_ELNRNG = 48;


    enum DPP_ENUM_EL3RST = 47;


    enum DPP_ENUM_EL3HLT = 46;


    enum DPP_ENUM_EL2NSYNC = 45;


    enum DPP_ENUM_ECHRNG = 44;


    enum DPP_ENUM_EIDRM = 43;


    enum DPP_ENUM_ENOMSG = 42;




    enum DPP_ENUM_ELOOP = 40;


    enum DPP_ENUM_ENOTEMPTY = 39;


    enum DPP_ENUM__WCHAR_H = 1;


    enum DPP_ENUM_ENOSYS = 38;


    enum DPP_ENUM_ENOLCK = 37;


    enum DPP_ENUM_ENAMETOOLONG = 36;


    enum DPP_ENUM_EDEADLK = 35;




    enum DPP_ENUM_ERANGE = 34;


    enum DPP_ENUM_EDOM = 33;


    enum DPP_ENUM_EPIPE = 32;


    enum DPP_ENUM_EMLINK = 31;


    enum DPP_ENUM_EROFS = 30;


    enum DPP_ENUM_ESPIPE = 29;


    enum DPP_ENUM_ENOSPC = 28;


    enum DPP_ENUM_EFBIG = 27;


    enum DPP_ENUM_ETXTBSY = 26;


    enum DPP_ENUM_ENOTTY = 25;




    enum DPP_ENUM_EMFILE = 24;


    enum DPP_ENUM_ENFILE = 23;


    enum DPP_ENUM_EINVAL = 22;


    enum DPP_ENUM_EISDIR = 21;


    enum DPP_ENUM_ENOTDIR = 20;


    enum DPP_ENUM_ENODEV = 19;


    enum DPP_ENUM_EXDEV = 18;


    enum DPP_ENUM_EEXIST = 17;


    enum DPP_ENUM_EBUSY = 16;


    enum DPP_ENUM_ENOTBLK = 15;


    enum DPP_ENUM_EFAULT = 14;


    enum DPP_ENUM_EACCES = 13;


    enum DPP_ENUM_ENOMEM = 12;


    enum DPP_ENUM_EAGAIN = 11;


    enum DPP_ENUM_ECHILD = 10;


    enum DPP_ENUM_EBADF = 9;


    enum DPP_ENUM_ENOEXEC = 8;


    enum DPP_ENUM_E2BIG = 7;


    enum DPP_ENUM_ENXIO = 6;


    enum DPP_ENUM_EIO = 5;


    enum DPP_ENUM_EINTR = 4;


    enum DPP_ENUM_ESRCH = 3;


    enum DPP_ENUM_ENOENT = 2;


    enum DPP_ENUM_EPERM = 1;






    enum DPP_ENUM__ALLOCA_H = 1;
    enum DPP_ENUM___GNUC_VA_LIST = 1;
}


struct _dictkeysobject;







enum isPython3 = is(PyModuleDef);
enum isPython2 = !isPython3;






enum MethodArgs {
    Var = 0x0001,
    Keywords = 0x0002,
    None = 0x0004,
    O = 0x0008,
}

enum MemberType {
    Short = 0,
    Int = 1,
    Long = 2,
    Float = 3,
    Double = 4,
    String = 5,
    Object = 6,
    ObjectEx = 16,
    Char = 7,
    Byte = 8,
    UByte = 9,
    UInt = 11,
    UShort = 10,
    ULong = 12,
    Bool = 14,
    LongLong = 17,
    ULongLong = 18,
    PySSizeT = 19,
}

enum TypeFlags {
    BaseType = (1UL << 10),
    Default = ( 0 | (1UL << 18) | 0),
}



mixin template PyObjectHead() {
    import python.raw: PyObject;
    PyObject ob_base;;
}


alias ModuleInitRet = PyObject*;



static if(isPython2) {

    auto pyInitModule(const(char)* name, PyMethodDef* methods) {
        return Py_InitModule(name, methods);
    }
}



static if(isPython3) {
    auto pyModuleCreate(PyModuleDef* moduleDef) @nogc nothrow {
        return PyModule_Create2(moduleDef, 1013);
    }
}


bool pyListCheck(PyObject* obj) @nogc nothrow {
    return (((((cast(PyObject*)(obj)).ob_type)).tp_flags & ((1UL << 25))) != 0);
}



bool pyTupleCheck(PyObject* obj) @nogc nothrow {
    return (((((cast(PyObject*)(obj)).ob_type)).tp_flags & ((1UL << 26))) != 0);
}



bool pyDictCheck(PyObject *obj) @nogc nothrow {
    return (((((cast(PyObject*)(obj)).ob_type)).tp_flags & ((1UL << 29))) != 0);
}


bool pyBoolCheck(PyObject *obj) @nogc nothrow {
    return (((cast(PyObject*)(obj)).ob_type) == &PyBool_Type);
}


bool pyUnicodeCheck(PyObject* obj) @nogc nothrow {
    return (((((cast(PyObject*)(obj)).ob_type)).tp_flags & ((1UL << 28))) != 0);
}

bool pyLongCheck(PyObject* obj) @nogc nothrow {
    return (((((cast(PyObject*)(obj)).ob_type)).tp_flags & ((1UL << 24))) != 0);
}

bool pyFloatCheck(PyObject* obj) @nogc nothrow {
    return (((cast(PyObject*)(obj)).ob_type) == (&PyFloat_Type) || PyType_IsSubtype(((cast(PyObject*)(obj)).ob_type), (&PyFloat_Type)));
}



auto pyTrue() {
    return (cast(PyObject *) &_Py_TrueStruct);
}


auto pyFalse() {
    return (cast(PyObject *) &_Py_FalseStruct);
}



void pyIncRef(PyObject* obj) @nogc nothrow {
    ( (cast(PyObject *)(obj)).ob_refcnt++);
}


void pyDecRef(PyObject* obj) @nogc nothrow {


}


auto pyNone() @nogc nothrow {
    return (&_Py_NoneStruct);
}

auto pyUnicodeDecodeUTF8(const(char)* str, c_long length, const(char)* errors = null) @nogc nothrow {
    return PyUnicode_DecodeUTF8(str, length, errors);
}

auto pyUnicodeAsUtf8String(PyObject* obj) @nogc nothrow {
    return PyUnicode_AsUTF8String(obj);
}

auto pyBytesAsString(PyObject* obj) @nogc nothrow {
    return PyBytes_AsString(obj);
}

auto pyObjectUnicode(PyObject* obj) @nogc nothrow {
    static if(isPython2)
        return PyObject_Unicode(obj);
    else
        return obj;
}

auto pyObjectNew(T)(PyTypeObject* typeobj) {
    return cast(T*) _PyObject_New(typeobj);
}



void pyDateTimeImport() @nogc nothrow {
    PyDateTimeAPI = cast(PyDateTime_CAPI *)PyCapsule_Import("datetime.datetime_CAPI", 0);
}

auto pyDateTimeYear(PyObject* obj) @nogc nothrow {
    return (((cast(PyDateTime_Date*)obj).data[0] << 8) | (cast(PyDateTime_Date*)obj).data[1]);
}

auto pyDateTimeMonth(PyObject* obj) @nogc nothrow {
    return ((cast(PyDateTime_Date*)obj).data[2]);
}

auto pyDateTimeDay(PyObject* obj) @nogc nothrow {
    return ((cast(PyDateTime_Date*)obj).data[3]);
}

auto pyDateTimeHour(PyObject* obj) @nogc nothrow {
    return ((cast(PyDateTime_DateTime*)obj).data[4]);
}

auto pyDateTimeMinute(PyObject* obj) @nogc nothrow {
    return ((cast(PyDateTime_DateTime*)obj).data[5]);
}

auto pyDateTimeSecond(PyObject* obj) @nogc nothrow {
    return ((cast(PyDateTime_DateTime*)obj).data[6]);
}

auto pyDateTimeUsec(PyObject* obj) @nogc nothrow {
    return (((cast(PyDateTime_DateTime*)obj).data[7] << 16) | ((cast(PyDateTime_DateTime*)obj).data[8] << 8) | (cast(PyDateTime_DateTime*)obj).data[9]);
}

auto pyDateFromDate(int year, int month, int day) {
    return PyDateTimeAPI.Date_FromDate(year, month, day, PyDateTimeAPI.DateType);
}


auto pyDateTimeFromDateAndTime(int year, int month, int day, int hour = 0, int minute = 0, int second = 0, int usec = 0) {
    return PyDateTimeAPI.DateTime_FromDateAndTime(year, month, day, hour, minute, second, usec, (&_Py_NoneStruct), PyDateTimeAPI.DateTimeType);
}
