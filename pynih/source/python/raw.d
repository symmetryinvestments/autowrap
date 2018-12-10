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
    int wcsncmp(const(int)*, const(int)*, c_ulong) @nogc nothrow;
    pragma(mangle, "alloca") void* alloca_(c_ulong) @nogc nothrow;
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
    void setusershell() @nogc nothrow;
    void endusershell() @nogc nothrow;
    char* getusershell() @nogc nothrow;
    int acct(const(char)*) @nogc nothrow;
    void __assert_fail(const(char)*, const(char)*, uint, const(char)*) @nogc nothrow;
    void __assert_perror_fail(int, const(char)*, uint, const(char)*) @nogc nothrow;
    void __assert(const(char)*, const(char)*, int) @nogc nothrow;
    int profil(ushort*, c_ulong, c_ulong, uint) @nogc nothrow;
    int revoke(const(char)*) @nogc nothrow;
    static ushort __bswap_16(ushort) @nogc nothrow;
    static uint __bswap_32(uint) @nogc nothrow;
    int vhangup() @nogc nothrow;
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
    int setdomainname(const(char)*, c_ulong) @nogc nothrow;
    int getdomainname(char*, c_ulong) @nogc nothrow;
    int sethostid(c_long) @nogc nothrow;
    int sethostname(const(char)*, c_ulong) @nogc nothrow;
    int gethostname(char*, c_ulong) @nogc nothrow;
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
    char* getcwd(char*, c_ulong) @nogc nothrow;
    int fchdir(int) @nogc nothrow;
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
    c_long lseek(int, c_long, int) @nogc nothrow;
    int faccessat(int, const(char)*, int, int) @nogc nothrow;
    int eaccess(const(char)*, int) @nogc nothrow;
    int euidaccess(const(char)*, int) @nogc nothrow;
    int access(const(char)*, int) @nogc nothrow;
    alias socklen_t = uint;
    alias intptr_t = c_long;
    alias _Float32 = float;
    alias _Float64 = double;
    int getdate_r(const(char)*, tm*) @nogc nothrow;
    alias _Float32x = double;
    tm* getdate(const(char)*) @nogc nothrow;
    extern __gshared int getdate_err;
    alias _Float64x = real;
    int timespec_get(timespec*, int) @nogc nothrow;
    int timer_getoverrun(void*) @nogc nothrow;
    int timer_gettime(void*, itimerspec*) @nogc nothrow;
    int timer_settime(void*, int, const(itimerspec)*, itimerspec*) @nogc nothrow;
    int timer_delete(void*) @nogc nothrow;
    extern __gshared char* optarg;
    extern __gshared int optind;
    extern __gshared int opterr;
    extern __gshared int optopt;
    int getopt(int, char**, const(char)*) @nogc nothrow;
    int timer_create(int, sigevent*, void**) @nogc nothrow;
    int __iscanonicall(real) @nogc nothrow;
    int clock_getcpuclockid(int, int*) @nogc nothrow;
    int clock_nanosleep(int, int, const(timespec)*, timespec*) @nogc nothrow;
    int clock_settime(int, const(timespec)*) @nogc nothrow;
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
    int __fpclassifyf(float) @nogc nothrow;
    int __fpclassify(double) @nogc nothrow;
    int __fpclassifyl(real) @nogc nothrow;
    int __signbitf(float) @nogc nothrow;
    int __signbit(double) @nogc nothrow;
    int __signbitl(real) @nogc nothrow;
    int __isinf(double) @nogc nothrow;
    int __isinff(float) @nogc nothrow;
    int __isinfl(real) @nogc nothrow;
    int __finitel(real) @nogc nothrow;
    int __finitef(float) @nogc nothrow;
    int __finite(double) @nogc nothrow;
    int __isnanl(real) @nogc nothrow;
    int __isnanf(float) @nogc nothrow;
    int __isnan(double) @nogc nothrow;
    int __iseqsig(double, double) @nogc nothrow;
    int __iseqsigl(real, real) @nogc nothrow;
    int __iseqsigf(float, float) @nogc nothrow;
    int __issignalingl(real) @nogc nothrow;
    int __issignaling(double) @nogc nothrow;
    int __issignalingf(float) @nogc nothrow;
    float fadd(double, double) @nogc nothrow;
    float faddl(real, real) @nogc nothrow;
    double daddl(real, real) @nogc nothrow;
    float f32addf32x(double, double) @nogc nothrow;
    float f32addf64(double, double) @nogc nothrow;
    float f32addf64x(real, real) @nogc nothrow;
    double f32xaddf64(double, double) @nogc nothrow;
    double f32xaddf64x(real, real) @nogc nothrow;
    double f64addf64x(real, real) @nogc nothrow;
    float fdivl(real, real) @nogc nothrow;
    double f32xdivf64x(real, real) @nogc nothrow;
    double f64divf64x(real, real) @nogc nothrow;
    float fdiv(double, double) @nogc nothrow;
    double f32xdivf64(double, double) @nogc nothrow;
    float f32divf64x(real, real) @nogc nothrow;
    double ddivl(real, real) @nogc nothrow;
    float f32divf64(double, double) @nogc nothrow;
    float f32divf32x(double, double) @nogc nothrow;
    float f32mulf32x(double, double) @nogc nothrow;
    double dmull(real, real) @nogc nothrow;
    float f32mulf64x(real, real) @nogc nothrow;
    double f32xmulf64(double, double) @nogc nothrow;
    double f64mulf64x(real, real) @nogc nothrow;
    float fmul(double, double) @nogc nothrow;
    float fmull(real, real) @nogc nothrow;
    double f32xmulf64x(real, real) @nogc nothrow;
    float f32mulf64(double, double) @nogc nothrow;
    float fsubl(real, real) @nogc nothrow;
    double dsubl(real, real) @nogc nothrow;
    float f32subf32x(double, double) @nogc nothrow;
    float f32subf64(double, double) @nogc nothrow;
    float f32subf64x(real, real) @nogc nothrow;
    double f32xsubf64(double, double) @nogc nothrow;
    double f32xsubf64x(real, real) @nogc nothrow;
    float fsub(double, double) @nogc nothrow;
    double f64subf64x(real, real) @nogc nothrow;
    float acosf32(float) @nogc nothrow;
    double acosf32x(double) @nogc nothrow;
    double __acosf32x(double) @nogc nothrow;
    double __acos(double) @nogc nothrow;
    real acosl(real) @nogc nothrow;
    real __acosl(real) @nogc nothrow;
    float __acosf(float) @nogc nothrow;
    double __acosf64(double) @nogc nothrow;
    real __acosf64x(real) @nogc nothrow;
    real acosf64x(real) @nogc nothrow;
    double acosf64(double) @nogc nothrow;
    float __acosf32(float) @nogc nothrow;
    float acosf(float) @nogc nothrow;
    double acos(double) @nogc nothrow;
    double __asinf64(double) @nogc nothrow;
    double asinf64(double) @nogc nothrow;
    double asinf32x(double) @nogc nothrow;
    double __asinf32x(double) @nogc nothrow;
    float asinf32(float) @nogc nothrow;
    real asinf64x(real) @nogc nothrow;
    double __asin(double) @nogc nothrow;
    real __asinl(real) @nogc nothrow;
    real asinl(real) @nogc nothrow;
    float asinf(float) @nogc nothrow;
    real __asinf64x(real) @nogc nothrow;
    float __asinf(float) @nogc nothrow;
    float __asinf32(float) @nogc nothrow;
    double asin(double) @nogc nothrow;
    real __atanl(real) @nogc nothrow;
    real atanl(real) @nogc nothrow;
    float __atanf(float) @nogc nothrow;
    double __atanf32x(double) @nogc nothrow;
    double atanf64(double) @nogc nothrow;
    double __atanf64(double) @nogc nothrow;
    double atanf32x(double) @nogc nothrow;
    real __atanf64x(real) @nogc nothrow;
    real atanf64x(real) @nogc nothrow;
    float atanf32(float) @nogc nothrow;
    double __atan(double) @nogc nothrow;
    float __atanf32(float) @nogc nothrow;
    float atanf(float) @nogc nothrow;
    double atan(double) @nogc nothrow;
    double __atan2f32x(double, double) @nogc nothrow;
    real __atan2l(real, real) @nogc nothrow;
    real atan2l(real, real) @nogc nothrow;
    double __atan2(double, double) @nogc nothrow;
    float __atan2f32(float, float) @nogc nothrow;
    float atan2f32(float, float) @nogc nothrow;
    float __atan2f(float, float) @nogc nothrow;
    float atan2f(float, float) @nogc nothrow;
    double atan2f32x(double, double) @nogc nothrow;
    real atan2f64x(real, real) @nogc nothrow;
    real __atan2f64x(real, real) @nogc nothrow;
    double __atan2f64(double, double) @nogc nothrow;
    double atan2f64(double, double) @nogc nothrow;
    double atan2(double, double) @nogc nothrow;
    real __cosl(real) @nogc nothrow;
    real cosl(real) @nogc nothrow;
    float cosf32(float) @nogc nothrow;
    float __cosf32(float) @nogc nothrow;
    double __cos(double) @nogc nothrow;
    float cosf(float) @nogc nothrow;
    float __cosf(float) @nogc nothrow;
    double cosf64(double) @nogc nothrow;
    double __cosf64(double) @nogc nothrow;
    double __cosf32x(double) @nogc nothrow;
    double cosf32x(double) @nogc nothrow;
    real __cosf64x(real) @nogc nothrow;
    real cosf64x(real) @nogc nothrow;
    double cos(double) @nogc nothrow;
    float __sinf(float) @nogc nothrow;
    float sinf(float) @nogc nothrow;
    real sinl(real) @nogc nothrow;
    real __sinl(real) @nogc nothrow;
    double __sinf64(double) @nogc nothrow;
    real sinf64x(real) @nogc nothrow;
    real __sinf64x(real) @nogc nothrow;
    double __sin(double) @nogc nothrow;
    double sinf32x(double) @nogc nothrow;
    float sinf32(float) @nogc nothrow;
    float __sinf32(float) @nogc nothrow;
    double __sinf32x(double) @nogc nothrow;
    double sinf64(double) @nogc nothrow;
    double sin(double) @nogc nothrow;
    double tanf32x(double) @nogc nothrow;
    double __tanf32x(double) @nogc nothrow;
    float __tanf32(float) @nogc nothrow;
    float tanf32(float) @nogc nothrow;
    real tanf64x(real) @nogc nothrow;
    double __tan(double) @nogc nothrow;
    real __tanf64x(real) @nogc nothrow;
    double tanf64(double) @nogc nothrow;
    double __tanf64(double) @nogc nothrow;
    real __tanl(real) @nogc nothrow;
    real tanl(real) @nogc nothrow;
    float tanf(float) @nogc nothrow;
    float __tanf(float) @nogc nothrow;
    double tan(double) @nogc nothrow;
    float __coshf32(float) @nogc nothrow;
    float coshf32(float) @nogc nothrow;
    double __cosh(double) @nogc nothrow;
    double coshf32x(double) @nogc nothrow;
    double __coshf32x(double) @nogc nothrow;
    real __coshf64x(real) @nogc nothrow;
    real coshf64x(real) @nogc nothrow;
    double coshf64(double) @nogc nothrow;
    double __coshf64(double) @nogc nothrow;
    real __coshl(real) @nogc nothrow;
    real coshl(real) @nogc nothrow;
    float coshf(float) @nogc nothrow;
    float __coshf(float) @nogc nothrow;
    double cosh(double) @nogc nothrow;
    real __sinhf64x(real) @nogc nothrow;
    real sinhf64x(real) @nogc nothrow;
    double sinhf64(double) @nogc nothrow;
    double __sinhf64(double) @nogc nothrow;
    float sinhf32(float) @nogc nothrow;
    float __sinhf32(float) @nogc nothrow;
    float sinhf(float) @nogc nothrow;
    real sinhl(real) @nogc nothrow;
    real __sinhl(real) @nogc nothrow;
    double __sinh(double) @nogc nothrow;
    double __sinhf32x(double) @nogc nothrow;
    double sinhf32x(double) @nogc nothrow;
    float __sinhf(float) @nogc nothrow;
    double sinh(double) @nogc nothrow;
    float tanhf(float) @nogc nothrow;
    float __tanhf(float) @nogc nothrow;
    double __tanhf64(double) @nogc nothrow;
    double tanhf64(double) @nogc nothrow;
    real tanhl(real) @nogc nothrow;
    real __tanhl(real) @nogc nothrow;
    real tanhf64x(real) @nogc nothrow;
    real __tanhf64x(real) @nogc nothrow;
    double __tanhf32x(double) @nogc nothrow;
    double tanhf32x(double) @nogc nothrow;
    float __tanhf32(float) @nogc nothrow;
    float tanhf32(float) @nogc nothrow;
    double __tanh(double) @nogc nothrow;
    double tanh(double) @nogc nothrow;
    void sincosf(float, float*, float*) @nogc nothrow;
    void sincosf64(double, double*, double*) @nogc nothrow;
    void __sincosf64(double, double*, double*) @nogc nothrow;
    void sincosf32x(double, double*, double*) @nogc nothrow;
    void sincosf32(float, float*, float*) @nogc nothrow;
    void __sincosf32(float, float*, float*) @nogc nothrow;
    void sincos(double, double*, double*) @nogc nothrow;
    void __sincos(double, double*, double*) @nogc nothrow;
    void sincosl(real, real*, real*) @nogc nothrow;
    void __sincosl(real, real*, real*) @nogc nothrow;
    void sincosf64x(real, real*, real*) @nogc nothrow;
    void __sincosf64x(real, real*, real*) @nogc nothrow;
    void __sincosf(float, float*, float*) @nogc nothrow;
    void __sincosf32x(double, double*, double*) @nogc nothrow;
    double __acoshf64(double) @nogc nothrow;
    real __acoshl(real) @nogc nothrow;
    double acoshf32x(double) @nogc nothrow;
    double __acoshf32x(double) @nogc nothrow;
    real acoshl(real) @nogc nothrow;
    double acoshf64(double) @nogc nothrow;
    float __acoshf32(float) @nogc nothrow;
    real __acoshf64x(real) @nogc nothrow;
    float acoshf32(float) @nogc nothrow;
    double __acosh(double) @nogc nothrow;
    real acoshf64x(real) @nogc nothrow;
    float acoshf(float) @nogc nothrow;
    float __acoshf(float) @nogc nothrow;
    double acosh(double) @nogc nothrow;
    double __asinhf32x(double) @nogc nothrow;
    double asinhf32x(double) @nogc nothrow;
    float asinhf(float) @nogc nothrow;
    real __asinhf64x(real) @nogc nothrow;
    real asinhl(real) @nogc nothrow;
    real __asinhl(real) @nogc nothrow;
    double asinhf64(double) @nogc nothrow;
    double __asinhf64(double) @nogc nothrow;
    real asinhf64x(real) @nogc nothrow;
    float __asinhf32(float) @nogc nothrow;
    float __asinhf(float) @nogc nothrow;
    float asinhf32(float) @nogc nothrow;
    double __asinh(double) @nogc nothrow;
    double asinh(double) @nogc nothrow;
    float __atanhf(float) @nogc nothrow;
    double __atanhf32x(double) @nogc nothrow;
    double atanhf32x(double) @nogc nothrow;
    real atanhl(real) @nogc nothrow;
    real __atanhl(real) @nogc nothrow;
    double atanhf64(double) @nogc nothrow;
    double __atanhf64(double) @nogc nothrow;
    real atanhf64x(real) @nogc nothrow;
    float __atanhf32(float) @nogc nothrow;
    float atanhf32(float) @nogc nothrow;
    double __atanh(double) @nogc nothrow;
    real __atanhf64x(real) @nogc nothrow;
    float atanhf(float) @nogc nothrow;
    double atanh(double) @nogc nothrow;
    double expf64(double) @nogc nothrow;
    double __expf64(double) @nogc nothrow;
    real __expf64x(real) @nogc nothrow;
    real expf64x(real) @nogc nothrow;
    double __expf32x(double) @nogc nothrow;
    double __exp(double) @nogc nothrow;
    float expf32(float) @nogc nothrow;
    float __expf32(float) @nogc nothrow;
    double expf32x(double) @nogc nothrow;
    real __expl(real) @nogc nothrow;
    float __expf(float) @nogc nothrow;
    float expf(float) @nogc nothrow;
    real expl(real) @nogc nothrow;
    double exp(double) @nogc nothrow;
    double __frexp(double, int*) @nogc nothrow;
    real frexpf64x(real, int*) @nogc nothrow;
    float frexpf32(float, int*) @nogc nothrow;
    float __frexpf32(float, int*) @nogc nothrow;
    float frexpf(float, int*) @nogc nothrow;
    real __frexpf64x(real, int*) @nogc nothrow;
    double frexpf32x(double, int*) @nogc nothrow;
    double __frexpf32x(double, int*) @nogc nothrow;
    real frexpl(real, int*) @nogc nothrow;
    real __frexpl(real, int*) @nogc nothrow;
    float __frexpf(float, int*) @nogc nothrow;
    double frexpf64(double, int*) @nogc nothrow;
    double __frexpf64(double, int*) @nogc nothrow;
    double frexp(double, int*) @nogc nothrow;
    real ldexpl(real, int) @nogc nothrow;
    double __ldexp(double, int) @nogc nothrow;
    real __ldexpl(real, int) @nogc nothrow;
    float ldexpf32(float, int) @nogc nothrow;
    float __ldexpf32(float, int) @nogc nothrow;
    float __ldexpf(float, int) @nogc nothrow;
    double ldexpf64(double, int) @nogc nothrow;
    double __ldexpf64(double, int) @nogc nothrow;
    float ldexpf(float, int) @nogc nothrow;
    double __ldexpf32x(double, int) @nogc nothrow;
    real ldexpf64x(real, int) @nogc nothrow;
    real __ldexpf64x(real, int) @nogc nothrow;
    double ldexpf32x(double, int) @nogc nothrow;
    double ldexp(double, int) @nogc nothrow;
    double __log(double) @nogc nothrow;
    float __logf(float) @nogc nothrow;
    float logf(float) @nogc nothrow;
    real logl(real) @nogc nothrow;
    float logf32(float) @nogc nothrow;
    float __logf32(float) @nogc nothrow;
    real __logl(real) @nogc nothrow;
    double logf64(double) @nogc nothrow;
    double __logf32x(double) @nogc nothrow;
    real logf64x(real) @nogc nothrow;
    real __logf64x(real) @nogc nothrow;
    double logf32x(double) @nogc nothrow;
    double __logf64(double) @nogc nothrow;
    double log(double) @nogc nothrow;
    real log10f64x(real) @nogc nothrow;
    double log10f32x(double) @nogc nothrow;
    double __log10f32x(double) @nogc nothrow;
    double __log10(double) @nogc nothrow;
    float log10f(float) @nogc nothrow;
    float __log10f(float) @nogc nothrow;
    real __log10f64x(real) @nogc nothrow;
    float log10f32(float) @nogc nothrow;
    float __log10f32(float) @nogc nothrow;
    double __log10f64(double) @nogc nothrow;
    double log10f64(double) @nogc nothrow;
    real log10l(real) @nogc nothrow;
    real __log10l(real) @nogc nothrow;
    double log10(double) @nogc nothrow;
    double modff32x(double, double*) @nogc nothrow;
    double modff64(double, double*) @nogc nothrow;
    double __modff64(double, double*) @nogc nothrow;
    float __modff32(float, float*) @nogc nothrow;
    float modff32(float, float*) @nogc nothrow;
    float __modff(float, float*) @nogc nothrow;
    float modff(float, float*) @nogc nothrow;
    real modff64x(real, real*) @nogc nothrow;
    real __modff64x(real, real*) @nogc nothrow;
    real modfl(real, real*) @nogc nothrow;
    real __modfl(real, real*) @nogc nothrow;
    double __modf(double, double*) @nogc nothrow;
    double __modff32x(double, double*) @nogc nothrow;
    double modf(double, double*) @nogc nothrow;
    real __exp10l(real) @nogc nothrow;
    double exp10(double) @nogc nothrow;
    double __exp10(double) @nogc nothrow;
    real __exp10f64x(real) @nogc nothrow;
    real exp10f64x(real) @nogc nothrow;
    float exp10f(float) @nogc nothrow;
    float __exp10f(float) @nogc nothrow;
    float exp10f32(float) @nogc nothrow;
    float __exp10f32(float) @nogc nothrow;
    real exp10l(real) @nogc nothrow;
    double __exp10f64(double) @nogc nothrow;
    double exp10f64(double) @nogc nothrow;
    double exp10f32x(double) @nogc nothrow;
    double __exp10f32x(double) @nogc nothrow;
    real __expm1f64x(real) @nogc nothrow;
    real expm1f64x(real) @nogc nothrow;
    float expm1f(float) @nogc nothrow;
    float __expm1f(float) @nogc nothrow;
    real __expm1l(real) @nogc nothrow;
    double __expm1f64(double) @nogc nothrow;
    double expm1f64(double) @nogc nothrow;
    real expm1l(real) @nogc nothrow;
    double __expm1f32x(double) @nogc nothrow;
    double expm1f32x(double) @nogc nothrow;
    double __expm1(double) @nogc nothrow;
    float expm1f32(float) @nogc nothrow;
    float __expm1f32(float) @nogc nothrow;
    double expm1(double) @nogc nothrow;
    double __log1pf32x(double) @nogc nothrow;
    real log1pf64x(real) @nogc nothrow;
    double __log1p(double) @nogc nothrow;
    real __log1pf64x(real) @nogc nothrow;
    double log1pf32x(double) @nogc nothrow;
    double log1pf64(double) @nogc nothrow;
    float __log1pf(float) @nogc nothrow;
    float log1pf(float) @nogc nothrow;
    real log1pl(real) @nogc nothrow;
    real __log1pl(real) @nogc nothrow;
    float log1pf32(float) @nogc nothrow;
    float __log1pf32(float) @nogc nothrow;
    double __log1pf64(double) @nogc nothrow;
    double log1p(double) @nogc nothrow;
    float logbf32(float) @nogc nothrow;
    float __logbf32(float) @nogc nothrow;
    double logbf64(double) @nogc nothrow;
    double __logbf32x(double) @nogc nothrow;
    double __logbf64(double) @nogc nothrow;
    float __logbf(float) @nogc nothrow;
    float logbf(float) @nogc nothrow;
    real logbl(real) @nogc nothrow;
    real __logbl(real) @nogc nothrow;
    double logbf32x(double) @nogc nothrow;
    real __logbf64x(real) @nogc nothrow;
    real logbf64x(real) @nogc nothrow;
    double __logb(double) @nogc nothrow;
    double logb(double) @nogc nothrow;
    float exp2f(float) @nogc nothrow;
    real __exp2f64x(real) @nogc nothrow;
    real exp2f64x(real) @nogc nothrow;
    double __exp2(double) @nogc nothrow;
    real __exp2l(real) @nogc nothrow;
    real exp2l(real) @nogc nothrow;
    double __exp2f32x(double) @nogc nothrow;
    double exp2f32x(double) @nogc nothrow;
    float __exp2f(float) @nogc nothrow;
    float __exp2f32(float) @nogc nothrow;
    float exp2f32(float) @nogc nothrow;
    double __exp2f64(double) @nogc nothrow;
    double exp2f64(double) @nogc nothrow;
    double exp2(double) @nogc nothrow;
    float log2f(float) @nogc nothrow;
    float __log2f(float) @nogc nothrow;
    real log2f64x(real) @nogc nothrow;
    real __log2f64x(real) @nogc nothrow;
    double __log2f32x(double) @nogc nothrow;
    double log2f32x(double) @nogc nothrow;
    double __log2f64(double) @nogc nothrow;
    double log2f64(double) @nogc nothrow;
    double __log2(double) @nogc nothrow;
    real __log2l(real) @nogc nothrow;
    real log2l(real) @nogc nothrow;
    float log2f32(float) @nogc nothrow;
    float __log2f32(float) @nogc nothrow;
    double log2(double) @nogc nothrow;
    real __powf64x(real, real) @nogc nothrow;
    real powf64x(real, real) @nogc nothrow;
    float __powf(float, float) @nogc nothrow;
    double __powf32x(double, double) @nogc nothrow;
    double powf32x(double, double) @nogc nothrow;
    real __powl(real, real) @nogc nothrow;
    real powl(real, real) @nogc nothrow;
    float powf32(float, float) @nogc nothrow;
    float __powf32(float, float) @nogc nothrow;
    double powf64(double, double) @nogc nothrow;
    double __powf64(double, double) @nogc nothrow;
    double __pow(double, double) @nogc nothrow;
    float powf(float, float) @nogc nothrow;
    double pow(double, double) @nogc nothrow;
    double __sqrtf64(double) @nogc nothrow;
    double sqrtf64(double) @nogc nothrow;
    real sqrtl(real) @nogc nothrow;
    real __sqrtl(real) @nogc nothrow;
    double __sqrt(double) @nogc nothrow;
    float __sqrtf(float) @nogc nothrow;
    float sqrtf(float) @nogc nothrow;
    real sqrtf64x(real) @nogc nothrow;
    real __sqrtf64x(real) @nogc nothrow;
    double sqrtf32x(double) @nogc nothrow;
    float sqrtf32(float) @nogc nothrow;
    double __sqrtf32x(double) @nogc nothrow;
    float __sqrtf32(float) @nogc nothrow;
    double sqrt(double) @nogc nothrow;
    float hypotf(float, float) @nogc nothrow;
    float __hypotf(float, float) @nogc nothrow;
    double __hypotf32x(double, double) @nogc nothrow;
    real __hypotl(real, real) @nogc nothrow;
    real hypotl(real, real) @nogc nothrow;
    real __hypotf64x(real, real) @nogc nothrow;
    real hypotf64x(real, real) @nogc nothrow;
    float hypotf32(float, float) @nogc nothrow;
    float __hypotf32(float, float) @nogc nothrow;
    double __hypotf64(double, double) @nogc nothrow;
    double hypotf64(double, double) @nogc nothrow;
    double hypotf32x(double, double) @nogc nothrow;
    double __hypot(double, double) @nogc nothrow;
    double hypot(double, double) @nogc nothrow;
    double __cbrt(double) @nogc nothrow;
    float __cbrtf32(float) @nogc nothrow;
    double cbrtf64(double) @nogc nothrow;
    double __cbrtf64(double) @nogc nothrow;
    float cbrtf32(float) @nogc nothrow;
    real cbrtf64x(real) @nogc nothrow;
    real __cbrtf64x(real) @nogc nothrow;
    double __cbrtf32x(double) @nogc nothrow;
    float cbrtf(float) @nogc nothrow;
    real cbrtl(real) @nogc nothrow;
    real __cbrtl(real) @nogc nothrow;
    float __cbrtf(float) @nogc nothrow;
    double cbrtf32x(double) @nogc nothrow;
    double cbrt(double) @nogc nothrow;
    double __ceil(double) @nogc nothrow;
    float ceilf(float) @nogc nothrow;
    float __ceilf32(float) @nogc nothrow;
    float ceilf32(float) @nogc nothrow;
    double ceilf64(double) @nogc nothrow;
    double ceilf32x(double) @nogc nothrow;
    real __ceill(real) @nogc nothrow;
    real ceill(real) @nogc nothrow;
    double __ceilf32x(double) @nogc nothrow;
    double __ceilf64(double) @nogc nothrow;
    real __ceilf64x(real) @nogc nothrow;
    real ceilf64x(real) @nogc nothrow;
    float __ceilf(float) @nogc nothrow;
    double ceil(double) @nogc nothrow;
    double __fabs(double) @nogc nothrow;
    double __fabsf64(double) @nogc nothrow;
    double fabsf64(double) @nogc nothrow;
    real fabsf64x(real) @nogc nothrow;
    real __fabsf64x(real) @nogc nothrow;
    real __fabsl(real) @nogc nothrow;
    real fabsl(real) @nogc nothrow;
    float __fabsf32(float) @nogc nothrow;
    float fabsf32(float) @nogc nothrow;
    double fabsf32x(double) @nogc nothrow;
    double __fabsf32x(double) @nogc nothrow;
    float __fabsf(float) @nogc nothrow;
    float fabsf(float) @nogc nothrow;
    double fabs(double) @nogc nothrow;
    real floorf64x(real) @nogc nothrow;
    real __floorf64x(real) @nogc nothrow;
    float __floorf(float) @nogc nothrow;
    float floorf(float) @nogc nothrow;
    real __floorl(real) @nogc nothrow;
    double __floorf32x(double) @nogc nothrow;
    double floorf32x(double) @nogc nothrow;
    double floorf64(double) @nogc nothrow;
    double __floorf64(double) @nogc nothrow;
    real floorl(real) @nogc nothrow;
    float floorf32(float) @nogc nothrow;
    float __floorf32(float) @nogc nothrow;
    double __floor(double) @nogc nothrow;
    double floor(double) @nogc nothrow;
    real fmodf64x(real, real) @nogc nothrow;
    real __fmodf64x(real, real) @nogc nothrow;
    real fmodl(real, real) @nogc nothrow;
    float __fmodf(float, float) @nogc nothrow;
    float __fmodf32(float, float) @nogc nothrow;
    float fmodf(float, float) @nogc nothrow;
    double __fmod(double, double) @nogc nothrow;
    double __fmodf32x(double, double) @nogc nothrow;
    double fmodf32x(double, double) @nogc nothrow;
    double fmodf64(double, double) @nogc nothrow;
    double __fmodf64(double, double) @nogc nothrow;
    real __fmodl(real, real) @nogc nothrow;
    float fmodf32(float, float) @nogc nothrow;
    double fmod(double, double) @nogc nothrow;
    int isinfl(real) @nogc nothrow;
    int isinff(float) @nogc nothrow;
    pragma(mangle, "isinf") int isinf_(double) @nogc nothrow;
    int finitef(float) @nogc nothrow;
    int finitel(real) @nogc nothrow;
    int finite(double) @nogc nothrow;
    float __dremf(float, float) @nogc nothrow;
    float dremf(float, float) @nogc nothrow;
    double __drem(double, double) @nogc nothrow;
    double drem(double, double) @nogc nothrow;
    real __dreml(real, real) @nogc nothrow;
    real dreml(real, real) @nogc nothrow;
    real __significandl(real) @nogc nothrow;
    float significandf(float) @nogc nothrow;
    float __significandf(float) @nogc nothrow;
    double significand(double) @nogc nothrow;
    double __significand(double) @nogc nothrow;
    real significandl(real) @nogc nothrow;
    double __copysignf64(double, double) @nogc nothrow;
    double copysignf64(double, double) @nogc nothrow;
    real copysignf64x(real, real) @nogc nothrow;
    double copysignf32x(double, double) @nogc nothrow;
    real __copysignf64x(real, real) @nogc nothrow;
    float __copysignf(float, float) @nogc nothrow;
    float copysignf(float, float) @nogc nothrow;
    real __copysignl(real, real) @nogc nothrow;
    real copysignl(real, real) @nogc nothrow;
    double __copysign(double, double) @nogc nothrow;
    float copysignf32(float, float) @nogc nothrow;
    float __copysignf32(float, float) @nogc nothrow;
    double __copysignf32x(double, double) @nogc nothrow;
    double copysign(double, double) @nogc nothrow;
    double nanf64(const(char)*) @nogc nothrow;
    real nanl(const(char)*) @nogc nothrow;
    real __nanl(const(char)*) @nogc nothrow;
    real nanf64x(const(char)*) @nogc nothrow;
    float nanf(const(char)*) @nogc nothrow;
    double __nanf64(const(char)*) @nogc nothrow;
    float nanf32(const(char)*) @nogc nothrow;
    float __nanf32(const(char)*) @nogc nothrow;
    real __nanf64x(const(char)*) @nogc nothrow;
    double nanf32x(const(char)*) @nogc nothrow;
    double __nanf32x(const(char)*) @nogc nothrow;
    double __nan(const(char)*) @nogc nothrow;
    float __nanf(const(char)*) @nogc nothrow;
    double nan(const(char)*) @nogc nothrow;
    int isnanl(real) @nogc nothrow;
    pragma(mangle, "isnan") int isnan_(double) @nogc nothrow;
    int isnanf(float) @nogc nothrow;
    double __j0(double) @nogc nothrow;
    float j0f32(float) @nogc nothrow;
    float __j0f32(float) @nogc nothrow;
    float __j0f(float) @nogc nothrow;
    double j0(double) @nogc nothrow;
    float j0f(float) @nogc nothrow;
    double j0f32x(double) @nogc nothrow;
    double __j0f64(double) @nogc nothrow;
    double __j0f32x(double) @nogc nothrow;
    double j0f64(double) @nogc nothrow;
    real j0l(real) @nogc nothrow;
    real __j0l(real) @nogc nothrow;
    real __j0f64x(real) @nogc nothrow;
    real j0f64x(real) @nogc nothrow;
    real j1f64x(real) @nogc nothrow;
    real __j1f64x(real) @nogc nothrow;
    double __j1f32x(double) @nogc nothrow;
    double j1f64(double) @nogc nothrow;
    float __j1f(float) @nogc nothrow;
    float j1f(float) @nogc nothrow;
    real j1l(real) @nogc nothrow;
    real __j1l(real) @nogc nothrow;
    float j1f32(float) @nogc nothrow;
    float __j1f32(float) @nogc nothrow;
    double __j1(double) @nogc nothrow;
    double j1(double) @nogc nothrow;
    double j1f32x(double) @nogc nothrow;
    double __j1f64(double) @nogc nothrow;
    real jnf64x(int, real) @nogc nothrow;
    float __jnf(int, float) @nogc nothrow;
    float jnf(int, float) @nogc nothrow;
    real __jnf64x(int, real) @nogc nothrow;
    double __jnf64(int, double) @nogc nothrow;
    float jnf32(int, float) @nogc nothrow;
    float __jnf32(int, float) @nogc nothrow;
    double jnf64(int, double) @nogc nothrow;
    double __jnf32x(int, double) @nogc nothrow;
    double jnf32x(int, double) @nogc nothrow;
    real jnl(int, real) @nogc nothrow;
    real __jnl(int, real) @nogc nothrow;
    double jn(int, double) @nogc nothrow;
    double __jn(int, double) @nogc nothrow;
    real __y0l(real) @nogc nothrow;
    real __y0f64x(real) @nogc nothrow;
    double y0f64(double) @nogc nothrow;
    real y0f64x(real) @nogc nothrow;
    double __y0f64(double) @nogc nothrow;
    float y0f(float) @nogc nothrow;
    float __y0f(float) @nogc nothrow;
    double y0(double) @nogc nothrow;
    real y0l(real) @nogc nothrow;
    double __y0f32x(double) @nogc nothrow;
    double __y0(double) @nogc nothrow;
    double y0f32x(double) @nogc nothrow;
    float y0f32(float) @nogc nothrow;
    float __y0f32(float) @nogc nothrow;
    float __y1f(float) @nogc nothrow;
    float y1f(float) @nogc nothrow;
    double __y1f64(double) @nogc nothrow;
    double y1f64(double) @nogc nothrow;
    double __y1f32x(double) @nogc nothrow;
    double y1f32x(double) @nogc nothrow;
    real __y1f64x(real) @nogc nothrow;
    float __y1f32(float) @nogc nothrow;
    float y1f32(float) @nogc nothrow;
    real y1l(real) @nogc nothrow;
    real __y1l(real) @nogc nothrow;
    real y1f64x(real) @nogc nothrow;
    double y1(double) @nogc nothrow;
    double __y1(double) @nogc nothrow;
    float __ynf(int, float) @nogc nothrow;
    float ynf(int, float) @nogc nothrow;
    double yn(int, double) @nogc nothrow;
    double __ynf64(int, double) @nogc nothrow;
    double __yn(int, double) @nogc nothrow;
    real __ynl(int, real) @nogc nothrow;
    double ynf32x(int, double) @nogc nothrow;
    float ynf32(int, float) @nogc nothrow;
    real ynl(int, real) @nogc nothrow;
    float __ynf32(int, float) @nogc nothrow;
    real __ynf64x(int, real) @nogc nothrow;
    real ynf64x(int, real) @nogc nothrow;
    double ynf64(int, double) @nogc nothrow;
    double __ynf32x(int, double) @nogc nothrow;
    double __erff32x(double) @nogc nothrow;
    double erff32x(double) @nogc nothrow;
    float erff32(float) @nogc nothrow;
    real __erfl(real) @nogc nothrow;
    real erfl(real) @nogc nothrow;
    double __erf(double) @nogc nothrow;
    real erff64x(real) @nogc nothrow;
    float __erff32(float) @nogc nothrow;
    float erff(float) @nogc nothrow;
    float __erff(float) @nogc nothrow;
    double erff64(double) @nogc nothrow;
    double __erff64(double) @nogc nothrow;
    real __erff64x(real) @nogc nothrow;
    double erf(double) @nogc nothrow;
    real erfcf64x(real) @nogc nothrow;
    real __erfcf64x(real) @nogc nothrow;
    real erfcl(real) @nogc nothrow;
    real __erfcl(real) @nogc nothrow;
    float __erfcf32(float) @nogc nothrow;
    float erfcf32(float) @nogc nothrow;
    double erfcf32x(double) @nogc nothrow;
    double __erfcf32x(double) @nogc nothrow;
    double __erfc(double) @nogc nothrow;
    float erfcf(float) @nogc nothrow;
    float __erfcf(float) @nogc nothrow;
    double erfcf64(double) @nogc nothrow;
    double __erfcf64(double) @nogc nothrow;
    double erfc(double) @nogc nothrow;
    double __lgamma(double) @nogc nothrow;
    float lgammaf(float) @nogc nothrow;
    real lgammaf64x(real) @nogc nothrow;
    real __lgammaf64x(real) @nogc nothrow;
    float __lgammaf32(float) @nogc nothrow;
    real __lgammal(real) @nogc nothrow;
    float __lgammaf(float) @nogc nothrow;
    real lgammal(real) @nogc nothrow;
    double lgammaf32x(double) @nogc nothrow;
    double __lgammaf32x(double) @nogc nothrow;
    double __lgammaf64(double) @nogc nothrow;
    double lgammaf64(double) @nogc nothrow;
    float lgammaf32(float) @nogc nothrow;
    double lgamma(double) @nogc nothrow;
    real tgammal(real) @nogc nothrow;
    real __tgammal(real) @nogc nothrow;
    float __tgammaf32(float) @nogc nothrow;
    float tgammaf32(float) @nogc nothrow;
    double tgammaf32x(double) @nogc nothrow;
    double __tgamma(double) @nogc nothrow;
    double __tgammaf32x(double) @nogc nothrow;
    real tgammaf64x(real) @nogc nothrow;
    float tgammaf(float) @nogc nothrow;
    float __tgammaf(float) @nogc nothrow;
    double tgammaf64(double) @nogc nothrow;
    real __tgammaf64x(real) @nogc nothrow;
    double __tgammaf64(double) @nogc nothrow;
    double tgamma(double) @nogc nothrow;
    double gamma(double) @nogc nothrow;
    double __gamma(double) @nogc nothrow;
    real __gammal(real) @nogc nothrow;
    real gammal(real) @nogc nothrow;
    float gammaf(float) @nogc nothrow;
    float __gammaf(float) @nogc nothrow;
    float __lgammaf32_r(float, int*) @nogc nothrow;
    real lgammaf64x_r(real, int*) @nogc nothrow;
    real __lgammal_r(real, int*) @nogc nothrow;
    real lgammal_r(real, int*) @nogc nothrow;
    real __lgammaf64x_r(real, int*) @nogc nothrow;
    float __lgammaf_r(float, int*) @nogc nothrow;
    float lgammaf_r(float, int*) @nogc nothrow;
    double __lgammaf32x_r(double, int*) @nogc nothrow;
    double lgammaf32x_r(double, int*) @nogc nothrow;
    double lgammaf64_r(double, int*) @nogc nothrow;
    double __lgammaf64_r(double, int*) @nogc nothrow;
    float lgammaf32_r(float, int*) @nogc nothrow;
    double lgamma_r(double, int*) @nogc nothrow;
    double __lgamma_r(double, int*) @nogc nothrow;
    real __rintl(real) @nogc nothrow;
    real rintl(real) @nogc nothrow;
    real __rintf64x(real) @nogc nothrow;
    real rintf64x(real) @nogc nothrow;
    double __rint(double) @nogc nothrow;
    float rintf32(float) @nogc nothrow;
    double __rintf64(double) @nogc nothrow;
    float __rintf(float) @nogc nothrow;
    float rintf(float) @nogc nothrow;
    double __rintf32x(double) @nogc nothrow;
    double rintf32x(double) @nogc nothrow;
    double rintf64(double) @nogc nothrow;
    float __rintf32(float) @nogc nothrow;
    double rint(double) @nogc nothrow;
    double __nextafterf64(double, double) @nogc nothrow;
    real __nextafterl(real, real) @nogc nothrow;
    double nextafterf64(double, double) @nogc nothrow;
    real nextafterl(real, real) @nogc nothrow;
    real __nextafterf64x(real, real) @nogc nothrow;
    float __nextafterf32(float, float) @nogc nothrow;
    double __nextafter(double, double) @nogc nothrow;
    float nextafterf32(float, float) @nogc nothrow;
    double __nextafterf32x(double, double) @nogc nothrow;
    float nextafterf(float, float) @nogc nothrow;
    float __nextafterf(float, float) @nogc nothrow;
    real nextafterf64x(real, real) @nogc nothrow;
    double nextafterf32x(double, double) @nogc nothrow;
    double nextafter(double, double) @nogc nothrow;
    real __nexttowardl(real, real) @nogc nothrow;
    real nexttowardl(real, real) @nogc nothrow;
    double __nexttoward(double, real) @nogc nothrow;
    float nexttowardf(float, real) @nogc nothrow;
    float __nexttowardf(float, real) @nogc nothrow;
    double nexttoward(double, real) @nogc nothrow;
    double __nextdownf64(double) @nogc nothrow;
    double nextdownf64(double) @nogc nothrow;
    float nextdownf32(float) @nogc nothrow;
    float __nextdownf32(float) @nogc nothrow;
    real nextdownl(real) @nogc nothrow;
    float nextdownf(float) @nogc nothrow;
    float __nextdownf(float) @nogc nothrow;
    real __nextdownf64x(real) @nogc nothrow;
    real nextdownf64x(real) @nogc nothrow;
    real __nextdownl(real) @nogc nothrow;
    double nextdownf32x(double) @nogc nothrow;
    double __nextdownf32x(double) @nogc nothrow;
    double nextdown(double) @nogc nothrow;
    double __nextdown(double) @nogc nothrow;
    double nextupf32x(double) @nogc nothrow;
    float __nextupf(float) @nogc nothrow;
    double __nextupf32x(double) @nogc nothrow;
    float nextupf(float) @nogc nothrow;
    float __nextupf32(float) @nogc nothrow;
    float nextupf32(float) @nogc nothrow;
    double nextupf64(double) @nogc nothrow;
    double __nextupf64(double) @nogc nothrow;
    double __nextup(double) @nogc nothrow;
    double nextup(double) @nogc nothrow;
    real __nextupf64x(real) @nogc nothrow;
    real nextupf64x(real) @nogc nothrow;
    real __nextupl(real) @nogc nothrow;
    real nextupl(real) @nogc nothrow;
    float __remainderf(float, float) @nogc nothrow;
    float remainderf(float, float) @nogc nothrow;
    real __remainderl(real, real) @nogc nothrow;
    double remainderf32x(double, double) @nogc nothrow;
    double __remainderf32x(double, double) @nogc nothrow;
    real remainderl(real, real) @nogc nothrow;
    float __remainderf32(float, float) @nogc nothrow;
    float remainderf32(float, float) @nogc nothrow;
    real remainderf64x(real, real) @nogc nothrow;
    real __remainderf64x(real, real) @nogc nothrow;
    double remainderf64(double, double) @nogc nothrow;
    double __remainderf64(double, double) @nogc nothrow;
    double __remainder(double, double) @nogc nothrow;
    double remainder(double, double) @nogc nothrow;
    double scalbnf64(double, int) @nogc nothrow;
    real __scalbnf64x(real, int) @nogc nothrow;
    real scalbnf64x(real, int) @nogc nothrow;
    float scalbnf32(float, int) @nogc nothrow;
    double __scalbn(double, int) @nogc nothrow;
    double __scalbnf32x(double, int) @nogc nothrow;
    double scalbnf32x(double, int) @nogc nothrow;
    float scalbnf(float, int) @nogc nothrow;
    float __scalbnf(float, int) @nogc nothrow;
    float __scalbnf32(float, int) @nogc nothrow;
    double __scalbnf64(double, int) @nogc nothrow;
    real __scalbnl(real, int) @nogc nothrow;
    real scalbnl(real, int) @nogc nothrow;
    double scalbn(double, int) @nogc nothrow;
    int __ilogbf64x(real) @nogc nothrow;
    int ilogbf64x(real) @nogc nothrow;
    int __ilogbf32(float) @nogc nothrow;
    int ilogbf64(double) @nogc nothrow;
    int __ilogb(double) @nogc nothrow;
    int __ilogbl(real) @nogc nothrow;
    int __ilogbf64(double) @nogc nothrow;
    int ilogbl(real) @nogc nothrow;
    int __ilogbf(float) @nogc nothrow;
    int ilogbf(float) @nogc nothrow;
    int __ilogbf32x(double) @nogc nothrow;
    int ilogbf32(float) @nogc nothrow;
    int ilogbf32x(double) @nogc nothrow;
    int ilogb(double) @nogc nothrow;
    c_long __llogb(double) @nogc nothrow;
    c_long __llogbf64(double) @nogc nothrow;
    c_long llogbf64(double) @nogc nothrow;
    c_long llogb(double) @nogc nothrow;
    c_long __llogbf64x(real) @nogc nothrow;
    c_long llogbf64x(real) @nogc nothrow;
    c_long llogbf32(float) @nogc nothrow;
    c_long __llogbf32(float) @nogc nothrow;
    c_long llogbl(real) @nogc nothrow;
    c_long __llogbl(real) @nogc nothrow;
    c_long llogbf(float) @nogc nothrow;
    c_long __llogbf(float) @nogc nothrow;
    c_long __llogbf32x(double) @nogc nothrow;
    c_long llogbf32x(double) @nogc nothrow;
    float __scalblnf32(float, c_long) @nogc nothrow;
    double __scalblnf32x(double, c_long) @nogc nothrow;
    double __scalbln(double, c_long) @nogc nothrow;
    float scalblnf32(float, c_long) @nogc nothrow;
    double scalblnf64(double, c_long) @nogc nothrow;
    double __scalblnf64(double, c_long) @nogc nothrow;
    double scalblnf32x(double, c_long) @nogc nothrow;
    real __scalblnl(real, c_long) @nogc nothrow;
    float scalblnf(float, c_long) @nogc nothrow;
    float __scalblnf(float, c_long) @nogc nothrow;
    real __scalblnf64x(real, c_long) @nogc nothrow;
    real scalblnf64x(real, c_long) @nogc nothrow;
    real scalblnl(real, c_long) @nogc nothrow;
    double scalbln(double, c_long) @nogc nothrow;
    float nearbyintf(float) @nogc nothrow;
    float __nearbyintf(float) @nogc nothrow;
    float nearbyintf32(float) @nogc nothrow;
    real nearbyintl(real) @nogc nothrow;
    real __nearbyintl(real) @nogc nothrow;
    real nearbyintf64x(real) @nogc nothrow;
    real __nearbyintf64x(real) @nogc nothrow;
    double __nearbyintf64(double) @nogc nothrow;
    double nearbyintf64(double) @nogc nothrow;
    float __nearbyintf32(float) @nogc nothrow;
    double __nearbyint(double) @nogc nothrow;
    double nearbyintf32x(double) @nogc nothrow;
    double __nearbyintf32x(double) @nogc nothrow;
    double nearbyint(double) @nogc nothrow;
    real __roundl(real) @nogc nothrow;
    double __round(double) @nogc nothrow;
    double roundf64(double) @nogc nothrow;
    double __roundf64(double) @nogc nothrow;
    real __roundf64x(real) @nogc nothrow;
    real roundf64x(real) @nogc nothrow;
    float __roundf(float) @nogc nothrow;
    float roundf(float) @nogc nothrow;
    double roundf32x(double) @nogc nothrow;
    real roundl(real) @nogc nothrow;
    double __roundf32x(double) @nogc nothrow;
    float __roundf32(float) @nogc nothrow;
    float roundf32(float) @nogc nothrow;
    double round(double) @nogc nothrow;
    real __truncf64x(real) @nogc nothrow;
    double truncf32x(double) @nogc nothrow;
    real truncf64x(real) @nogc nothrow;
    float __truncf32(float) @nogc nothrow;
    float truncf32(float) @nogc nothrow;
    double __trunc(double) @nogc nothrow;
    real __truncl(real) @nogc nothrow;
    double __truncf32x(double) @nogc nothrow;
    float truncf(float) @nogc nothrow;
    float __truncf(float) @nogc nothrow;
    double truncf64(double) @nogc nothrow;
    real truncl(real) @nogc nothrow;
    double __truncf64(double) @nogc nothrow;
    double trunc(double) @nogc nothrow;
    float __remquof32(float, float, int*) @nogc nothrow;
    float remquof32(float, float, int*) @nogc nothrow;
    float __remquof(float, float, int*) @nogc nothrow;
    real remquol(real, real, int*) @nogc nothrow;
    double remquof32x(double, double, int*) @nogc nothrow;
    double __remquof32x(double, double, int*) @nogc nothrow;
    float remquof(float, float, int*) @nogc nothrow;
    real __remquof64x(real, real, int*) @nogc nothrow;
    double remquof64(double, double, int*) @nogc nothrow;
    double __remquof64(double, double, int*) @nogc nothrow;
    double __remquo(double, double, int*) @nogc nothrow;
    real remquof64x(real, real, int*) @nogc nothrow;
    real __remquol(real, real, int*) @nogc nothrow;
    double remquo(double, double, int*) @nogc nothrow;
    c_long __lrintf(float) @nogc nothrow;
    c_long lrintf64x(real) @nogc nothrow;
    c_long __lrintf64x(real) @nogc nothrow;
    c_long lrintf64(double) @nogc nothrow;
    c_long __lrintf64(double) @nogc nothrow;
    c_long __lrintf32(float) @nogc nothrow;
    c_long lrintf32(float) @nogc nothrow;
    c_long __lrintf32x(double) @nogc nothrow;
    c_long __lrint(double) @nogc nothrow;
    c_long lrintf(float) @nogc nothrow;
    c_long lrintf32x(double) @nogc nothrow;
    c_long lrintl(real) @nogc nothrow;
    c_long __lrintl(real) @nogc nothrow;
    c_long lrint(double) @nogc nothrow;
    long __llrint(double) @nogc nothrow;
    long __llrintf64x(real) @nogc nothrow;
    long llrintf64x(real) @nogc nothrow;
    long __llrintf32x(double) @nogc nothrow;
    long llrintf64(double) @nogc nothrow;
    long __llrintf64(double) @nogc nothrow;
    long llrintf(float) @nogc nothrow;
    long llrintf32(float) @nogc nothrow;
    long __llrintf32(float) @nogc nothrow;
    long __llrintl(real) @nogc nothrow;
    long __llrintf(float) @nogc nothrow;
    long llrintl(real) @nogc nothrow;
    long llrintf32x(double) @nogc nothrow;
    long llrint(double) @nogc nothrow;
    c_long __lroundl(real) @nogc nothrow;
    c_long __lroundf64x(real) @nogc nothrow;
    c_long lroundf64x(real) @nogc nothrow;
    c_long lroundl(real) @nogc nothrow;
    c_long lroundf32(float) @nogc nothrow;
    c_long __lroundf32(float) @nogc nothrow;
    c_long __lroundf(float) @nogc nothrow;
    c_long lroundf(float) @nogc nothrow;
    c_long __lroundf32x(double) @nogc nothrow;
    c_long lroundf32x(double) @nogc nothrow;
    c_long lroundf64(double) @nogc nothrow;
    c_long __lroundf64(double) @nogc nothrow;
    c_long __lround(double) @nogc nothrow;
    c_long lround(double) @nogc nothrow;
    long __llroundf(float) @nogc nothrow;
    long __llroundf64x(real) @nogc nothrow;
    long llroundf64x(real) @nogc nothrow;
    long __llround(double) @nogc nothrow;
    long __llroundf64(double) @nogc nothrow;
    long llroundf64(double) @nogc nothrow;
    long __llroundf32x(double) @nogc nothrow;
    long llroundf32x(double) @nogc nothrow;
    long llroundf(float) @nogc nothrow;
    long __llroundf32(float) @nogc nothrow;
    long llroundf32(float) @nogc nothrow;
    long __llroundl(real) @nogc nothrow;
    long llroundl(real) @nogc nothrow;
    long llround(double) @nogc nothrow;
    double __fdim(double, double) @nogc nothrow;
    real __fdiml(real, real) @nogc nothrow;
    real fdiml(real, real) @nogc nothrow;
    double fdimf64(double, double) @nogc nothrow;
    double __fdimf64(double, double) @nogc nothrow;
    real fdimf64x(real, real) @nogc nothrow;
    real __fdimf64x(real, real) @nogc nothrow;
    float __fdimf32(float, float) @nogc nothrow;
    double fdimf32x(double, double) @nogc nothrow;
    float fdimf32(float, float) @nogc nothrow;
    double __fdimf32x(double, double) @nogc nothrow;
    float __fdimf(float, float) @nogc nothrow;
    float fdimf(float, float) @nogc nothrow;
    double fdim(double, double) @nogc nothrow;
    double fmaxf32x(double, double) @nogc nothrow;
    double __fmaxf32x(double, double) @nogc nothrow;
    real fmaxl(real, real) @nogc nothrow;
    real fmaxf64x(real, real) @nogc nothrow;
    real __fmaxf64x(real, real) @nogc nothrow;
    double fmaxf64(double, double) @nogc nothrow;
    float __fmaxf(float, float) @nogc nothrow;
    double __fmax(double, double) @nogc nothrow;
    float fmaxf(float, float) @nogc nothrow;
    real __fmaxl(real, real) @nogc nothrow;
    float __fmaxf32(float, float) @nogc nothrow;
    double __fmaxf64(double, double) @nogc nothrow;
    float fmaxf32(float, float) @nogc nothrow;
    double fmax(double, double) @nogc nothrow;
    double __fmin(double, double) @nogc nothrow;
    double fminf64(double, double) @nogc nothrow;
    double fminf32x(double, double) @nogc nothrow;
    double __fminf32x(double, double) @nogc nothrow;
    float fminf32(float, float) @nogc nothrow;
    float __fminf32(float, float) @nogc nothrow;
    real __fminf64x(real, real) @nogc nothrow;
    real fminf64x(real, real) @nogc nothrow;
    double __fminf64(double, double) @nogc nothrow;
    float __fminf(float, float) @nogc nothrow;
    real __fminl(real, real) @nogc nothrow;
    real fminl(real, real) @nogc nothrow;
    float fminf(float, float) @nogc nothrow;
    double fmin(double, double) @nogc nothrow;
    double fmaf64(double, double, double) @nogc nothrow;
    double __fmaf64(double, double, double) @nogc nothrow;
    real fmal(real, real, real) @nogc nothrow;
    double __fma(double, double, double) @nogc nothrow;
    real __fmal(real, real, real) @nogc nothrow;
    double fmaf32x(double, double, double) @nogc nothrow;
    double __fmaf32x(double, double, double) @nogc nothrow;
    real __fmaf64x(real, real, real) @nogc nothrow;
    float __fmaf32(float, float, float) @nogc nothrow;
    float fmaf32(float, float, float) @nogc nothrow;
    real fmaf64x(real, real, real) @nogc nothrow;
    float fmaf(float, float, float) @nogc nothrow;
    float __fmaf(float, float, float) @nogc nothrow;
    double fma(double, double, double) @nogc nothrow;
    float roundevenf32(float) @nogc nothrow;
    real roundevenl(real) @nogc nothrow;
    real __roundevenl(real) @nogc nothrow;
    double __roundeven(double) @nogc nothrow;
    double roundeven(double) @nogc nothrow;
    float roundevenf(float) @nogc nothrow;
    float __roundevenf(float) @nogc nothrow;
    float __roundevenf32(float) @nogc nothrow;
    double roundevenf64(double) @nogc nothrow;
    double __roundevenf64(double) @nogc nothrow;
    double roundevenf32x(double) @nogc nothrow;
    double __roundevenf32x(double) @nogc nothrow;
    real __roundevenf64x(real) @nogc nothrow;
    real roundevenf64x(real) @nogc nothrow;
    c_long __fromfpf32(float, int, uint) @nogc nothrow;
    c_long fromfpf32(float, int, uint) @nogc nothrow;
    c_long fromfpl(real, int, uint) @nogc nothrow;
    c_long fromfpf64(double, int, uint) @nogc nothrow;
    c_long __fromfpf64(double, int, uint) @nogc nothrow;
    c_long __fromfpl(real, int, uint) @nogc nothrow;
    c_long __fromfpf(float, int, uint) @nogc nothrow;
    c_long fromfpf(float, int, uint) @nogc nothrow;
    c_long __fromfpf32x(double, int, uint) @nogc nothrow;
    c_long __fromfpf64x(real, int, uint) @nogc nothrow;
    c_long fromfpf64x(real, int, uint) @nogc nothrow;
    c_long fromfp(double, int, uint) @nogc nothrow;
    c_long fromfpf32x(double, int, uint) @nogc nothrow;
    c_long __fromfp(double, int, uint) @nogc nothrow;
    c_ulong ufromfpf64(double, int, uint) @nogc nothrow;
    c_ulong __ufromfpf64(double, int, uint) @nogc nothrow;
    c_ulong __ufromfpf32x(double, int, uint) @nogc nothrow;
    c_ulong __ufromfp(double, int, uint) @nogc nothrow;
    c_ulong ufromfp(double, int, uint) @nogc nothrow;
    c_ulong ufromfpf(float, int, uint) @nogc nothrow;
    c_ulong ufromfpf32(float, int, uint) @nogc nothrow;
    c_ulong ufromfpl(real, int, uint) @nogc nothrow;
    c_ulong __ufromfpl(real, int, uint) @nogc nothrow;
    c_ulong __ufromfpf32(float, int, uint) @nogc nothrow;
    c_ulong __ufromfpf64x(real, int, uint) @nogc nothrow;
    c_ulong ufromfpf32x(double, int, uint) @nogc nothrow;
    c_ulong ufromfpf64x(real, int, uint) @nogc nothrow;
    c_ulong __ufromfpf(float, int, uint) @nogc nothrow;
    c_long __fromfpxf32x(double, int, uint) @nogc nothrow;
    c_long fromfpxf32x(double, int, uint) @nogc nothrow;
    c_long fromfpxf32(float, int, uint) @nogc nothrow;
    c_long fromfpxf64(double, int, uint) @nogc nothrow;
    c_long __fromfpxf64(double, int, uint) @nogc nothrow;
    c_long __fromfpxf(float, int, uint) @nogc nothrow;
    c_long fromfpxf(float, int, uint) @nogc nothrow;
    c_long __fromfpxf64x(real, int, uint) @nogc nothrow;
    c_long fromfpxf64x(real, int, uint) @nogc nothrow;
    c_long fromfpxl(real, int, uint) @nogc nothrow;
    c_long __fromfpxl(real, int, uint) @nogc nothrow;
    c_long fromfpx(double, int, uint) @nogc nothrow;
    c_long __fromfpx(double, int, uint) @nogc nothrow;
    c_long __fromfpxf32(float, int, uint) @nogc nothrow;
    c_ulong __ufromfpxf(float, int, uint) @nogc nothrow;
    c_ulong ufromfpxf(float, int, uint) @nogc nothrow;
    c_ulong __ufromfpxf64(double, int, uint) @nogc nothrow;
    c_ulong __ufromfpxf32(float, int, uint) @nogc nothrow;
    c_ulong ufromfpxf32(float, int, uint) @nogc nothrow;
    c_ulong ufromfpxf64(double, int, uint) @nogc nothrow;
    c_ulong __ufromfpxl(real, int, uint) @nogc nothrow;
    c_ulong ufromfpxl(real, int, uint) @nogc nothrow;
    c_ulong __ufromfpxf64x(real, int, uint) @nogc nothrow;
    c_ulong ufromfpxf64x(real, int, uint) @nogc nothrow;
    c_ulong ufromfpx(double, int, uint) @nogc nothrow;
    c_ulong __ufromfpx(double, int, uint) @nogc nothrow;
    c_ulong ufromfpxf32x(double, int, uint) @nogc nothrow;
    c_ulong __ufromfpxf32x(double, int, uint) @nogc nothrow;
    float fmaxmagf(float, float) @nogc nothrow;
    float __fmaxmagf(float, float) @nogc nothrow;
    real __fmaxmagf64x(real, real) @nogc nothrow;
    real fmaxmagf64x(real, real) @nogc nothrow;
    double fmaxmagf32x(double, double) @nogc nothrow;
    double __fmaxmagf64(double, double) @nogc nothrow;
    double fmaxmagf64(double, double) @nogc nothrow;
    float fmaxmagf32(float, float) @nogc nothrow;
    float __fmaxmagf32(float, float) @nogc nothrow;
    double __fmaxmagf32x(double, double) @nogc nothrow;
    double fmaxmag(double, double) @nogc nothrow;
    double __fmaxmag(double, double) @nogc nothrow;
    real __fmaxmagl(real, real) @nogc nothrow;
    real fmaxmagl(real, real) @nogc nothrow;
    double __fminmag(double, double) @nogc nothrow;
    double fminmag(double, double) @nogc nothrow;
    real fminmagl(real, real) @nogc nothrow;
    float __fminmagf32(float, float) @nogc nothrow;
    float fminmagf32(float, float) @nogc nothrow;
    double fminmagf64(double, double) @nogc nothrow;
    float __fminmagf(float, float) @nogc nothrow;
    float fminmagf(float, float) @nogc nothrow;
    double __fminmagf64(double, double) @nogc nothrow;
    real fminmagf64x(real, real) @nogc nothrow;
    real __fminmagf64x(real, real) @nogc nothrow;
    real __fminmagl(real, real) @nogc nothrow;
    double fminmagf32x(double, double) @nogc nothrow;
    double __fminmagf32x(double, double) @nogc nothrow;
    int totalorderl(real, real) @nogc nothrow;
    int totalorderf32(float, float) @nogc nothrow;
    int totalorderf64(double, double) @nogc nothrow;
    int totalorderf32x(double, double) @nogc nothrow;
    int totalorderf64x(real, real) @nogc nothrow;
    int totalorderf(float, float) @nogc nothrow;
    int totalorder(double, double) @nogc nothrow;
    int totalordermagf(float, float) @nogc nothrow;
    int totalordermagl(real, real) @nogc nothrow;
    int totalordermagf32(float, float) @nogc nothrow;
    int totalordermagf64(double, double) @nogc nothrow;
    int totalordermagf32x(double, double) @nogc nothrow;
    int totalordermag(double, double) @nogc nothrow;
    int totalordermagf64x(real, real) @nogc nothrow;
    int canonicalizef32(float*, const(float)*) @nogc nothrow;
    int canonicalizel(real*, const(real)*) @nogc nothrow;
    int canonicalizef64x(real*, const(real)*) @nogc nothrow;
    int canonicalizef(float*, const(float)*) @nogc nothrow;
    int canonicalize(double*, const(double)*) @nogc nothrow;
    int canonicalizef64(double*, const(double)*) @nogc nothrow;
    int canonicalizef32x(double*, const(double)*) @nogc nothrow;
    double __getpayloadf64(const(double)*) @nogc nothrow;
    float __getpayloadf32(const(float)*) @nogc nothrow;
    float getpayloadf32(const(float)*) @nogc nothrow;
    real __getpayloadf64x(const(real)*) @nogc nothrow;
    double getpayload(const(double)*) @nogc nothrow;
    real getpayloadl(const(real)*) @nogc nothrow;
    real __getpayloadl(const(real)*) @nogc nothrow;
    real getpayloadf64x(const(real)*) @nogc nothrow;
    float getpayloadf(const(float)*) @nogc nothrow;
    float __getpayloadf(const(float)*) @nogc nothrow;
    double getpayloadf32x(const(double)*) @nogc nothrow;
    double __getpayloadf32x(const(double)*) @nogc nothrow;
    double __getpayload(const(double)*) @nogc nothrow;
    double getpayloadf64(const(double)*) @nogc nothrow;
    int setpayloadl(real*, real) @nogc nothrow;
    int setpayload(double*, double) @nogc nothrow;
    int setpayloadf64x(real*, real) @nogc nothrow;
    int setpayloadf64(double*, double) @nogc nothrow;
    int setpayloadf32x(double*, double) @nogc nothrow;
    int setpayloadf(float*, float) @nogc nothrow;
    int setpayloadf32(float*, float) @nogc nothrow;
    int setpayloadsigf(float*, float) @nogc nothrow;
    int setpayloadsigl(real*, real) @nogc nothrow;
    int setpayloadsig(double*, double) @nogc nothrow;
    int setpayloadsigf64x(real*, real) @nogc nothrow;
    int setpayloadsigf32x(double*, double) @nogc nothrow;
    int setpayloadsigf32(float*, float) @nogc nothrow;
    int setpayloadsigf64(double*, double) @nogc nothrow;
    real scalbl(real, real) @nogc nothrow;
    real __scalbl(real, real) @nogc nothrow;
    float __scalbf(float, float) @nogc nothrow;
    float scalbf(float, float) @nogc nothrow;
    double __scalb(double, double) @nogc nothrow;
    double scalb(double, double) @nogc nothrow;
    alias u_int64_t = c_ulong;
    alias u_int32_t = uint;
    alias u_int16_t = ushort;
    alias u_int8_t = ubyte;
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
    int futimens(int, const(timespec)*) @nogc nothrow;
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
    int utimensat(int, const(char)*, const(timespec)*, int) @nogc nothrow;
    int mkfifoat(int, const(char)*, uint) @nogc nothrow;
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
    int mkfifo(const(char)*, uint) @nogc nothrow;
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
    int mknodat(int, const(char)*, uint, c_ulong) @nogc nothrow;
    int mknod(const(char)*, uint, c_ulong) @nogc nothrow;
    int mkdirat(int, const(char)*, uint) @nogc nothrow;
    int mkdir(const(char)*, uint) @nogc nothrow;
    uint getumask() @nogc nothrow;
    uint umask(uint) @nogc nothrow;
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
    int fchmodat(int, const(char)*, uint, int) @nogc nothrow;
    int fchmod(int, uint) @nogc nothrow;
    int lchmod(const(char)*, uint) @nogc nothrow;
    int chmod(const(char)*, uint) @nogc nothrow;
    int lstat64(const(char)*, stat64*) @nogc nothrow;
    int lstat(const(char)*, stat*) @nogc nothrow;
    pragma(mangle, "statx") int statx_(int, const(char)*, int, uint, statx*) @nogc nothrow;
    alias int8_t = byte;
    alias int16_t = short;
    alias int32_t = int;
    alias int64_t = c_long;
    alias uint8_t = ubyte;
    alias uint16_t = ushort;
    alias uint32_t = uint;
    alias uint64_t = ulong;
    int fstatat64(int, const(char)*, stat64*, int) @nogc nothrow;
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
    int fstatat(int, const(char)*, stat*, int) @nogc nothrow;
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
    int fstat64(int, stat64*) @nogc nothrow;
    pragma(mangle, "stat64") int stat64_(const(char)*, stat64*) @nogc nothrow;
    int fstat(int, stat*) @nogc nothrow;
    pragma(mangle, "stat64") int stat_(const(char)*, stat*) @nogc nothrow;
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
    int pselect(int, fd_set*, fd_set*, fd_set*, const(timespec)*, const(__sigset_t)*) @nogc nothrow;
    int select(int, fd_set*, fd_set*, fd_set*, timeval*) @nogc nothrow;
    alias fd_mask = c_long;
    struct fd_set
    {
        c_long[16] fds_bits;
    }
    alias __fd_mask = c_long;
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
    alias wint_t = uint;
    static ushort __uint16_identity(ushort) @nogc nothrow;
    static uint __uint32_identity(uint) @nogc nothrow;
    static c_ulong __uint64_identity(c_ulong) @nogc nothrow;
    int strncasecmp_l(const(char)*, const(char)*, c_ulong, __locale_struct*) @nogc nothrow;
    int strcasecmp_l(const(char)*, const(char)*, __locale_struct*) @nogc nothrow;
    int strncasecmp(const(char)*, const(char)*, c_ulong) @nogc nothrow;
    int strcasecmp(const(char)*, const(char)*) @nogc nothrow;
    int ffsll(long) @nogc nothrow;
    int ffsl(c_long) @nogc nothrow;
    int ffs(int) @nogc nothrow;
    char* rindex(const(char)*, int) @nogc nothrow;
    char* index(const(char)*, int) @nogc nothrow;
    void bzero(void*, c_ulong) @nogc nothrow;
    void bcopy(const(void)*, void*, c_ulong) @nogc nothrow;
    int bcmp(const(void)*, const(void)*, c_ulong) @nogc nothrow;
    char* basename(const(char)*) @nogc nothrow;
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
    void* memfrob(void*, c_ulong) @nogc nothrow;
    char* strfry(char*) @nogc nothrow;
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
    int strverscmp(const(char)*, const(char)*) @nogc nothrow;
    char* stpncpy(char*, const(char)*, c_ulong) @nogc nothrow;
    char* __stpncpy(char*, const(char)*, c_ulong) @nogc nothrow;
    char* stpcpy(char*, const(char)*) @nogc nothrow;
    char* __stpcpy(char*, const(char)*) @nogc nothrow;
    char* strsignal(int) @nogc nothrow;
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
    char* strsep(char**, const(char)*) @nogc nothrow;
    void explicit_bzero(void*, c_ulong) @nogc nothrow;
    char* strerror_l(int, __locale_struct*) @nogc nothrow;
    char* strerror_r(int, char*, c_ulong) @nogc nothrow;
    char* strerror(int) @nogc nothrow;
    c_ulong strnlen(const(char)*, c_ulong) @nogc nothrow;
    c_ulong strlen(const(char)*) @nogc nothrow;
    void* mempcpy(void*, const(void)*, c_ulong) @nogc nothrow;
    void* __mempcpy(void*, const(void)*, c_ulong) @nogc nothrow;
    void* memmem(const(void)*, c_ulong, const(void)*, c_ulong) @nogc nothrow;
    char* strcasestr(const(char)*, const(char)*) @nogc nothrow;
    char* strtok_r(char*, const(char)*, char**) @nogc nothrow;
    int* __errno_location() @nogc nothrow;
    extern __gshared char* program_invocation_name;
    extern __gshared char* program_invocation_short_name;
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
    c_ulong strxfrm_l(char*, const(char)*, c_ulong, __locale_struct*) @nogc nothrow;
    int strcoll_l(const(char)*, const(char)*, __locale_struct*) @nogc nothrow;
    c_ulong strxfrm(char*, const(char)*, c_ulong) @nogc nothrow;
    int strcoll(const(char)*, const(char)*) @nogc nothrow;
    alias __gwchar_t = int;
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
    alias float_t = float;
    alias double_t = double;
    char* mkdtemp(char*) @nogc nothrow;
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
    int mkstemps64(char*, int) @nogc nothrow;
    int mkstemps(char*, int) @nogc nothrow;
    int mkstemp64(char*) @nogc nothrow;
    int mkstemp(char*) @nogc nothrow;
    char* mktemp(char*) @nogc nothrow;
    int clearenv() @nogc nothrow;
    int unsetenv(const(char)*) @nogc nothrow;
    int setenv(const(char)*, const(char)*, int) @nogc nothrow;
    int putenv(char*) @nogc nothrow;
    char* secure_getenv(const(char)*) @nogc nothrow;
    char* getenv(const(char)*) @nogc nothrow;
    void _Exit(int) @nogc nothrow;
    void quick_exit(int) @nogc nothrow;
    void exit(int) @nogc nothrow;
    int on_exit(void function(int, void*), void*) @nogc nothrow;
    int at_quick_exit(void function()) @nogc nothrow;
    int atexit(void function()) @nogc nothrow;
    void abort() @nogc nothrow;
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
    _object* _Py_Mangle(_object*, _object*) @nogc nothrow;
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
    int PyObject_Cmp(_object*, _object*, int*) @nogc nothrow;
    _object* PyObject_Call(_object*, _object*, _object*) @nogc nothrow;
    _object* PyObject_CallObject(_object*, _object*) @nogc nothrow;
    _object* PyObject_CallFunction(_object*, char*, ...) @nogc nothrow;
    _object* PyObject_CallMethod(_object*, char*, char*, ...) @nogc nothrow;
    _object* _PyObject_CallFunction_SizeT(_object*, char*, ...) @nogc nothrow;
    _object* _PyObject_CallMethod_SizeT(_object*, char*, char*, ...) @nogc nothrow;
    _object* PyObject_CallFunctionObjArgs(_object*, ...) @nogc nothrow;
    _object* PyObject_CallMethodObjArgs(_object*, _object*, ...) @nogc nothrow;
    _object* PyObject_Type(_object*) @nogc nothrow;
    c_long PyObject_Size(_object*) @nogc nothrow;
    c_long PyObject_Length(_object*) @nogc nothrow;
    c_long random() @nogc nothrow;
    c_long _PyObject_LengthHint(_object*, c_long) @nogc nothrow;
    _object* PyObject_GetItem(_object*, _object*) @nogc nothrow;
    int PyObject_SetItem(_object*, _object*, _object*) @nogc nothrow;
    int PyObject_DelItemString(_object*, char*) @nogc nothrow;
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
    int PyBuffer_IsContiguous(bufferinfo*, char) @nogc nothrow;
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
    _object* PyNumber_Divide(_object*, _object*) @nogc nothrow;
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
    _object* PyNumber_Index(_object*) @nogc nothrow;
    c_long PyNumber_AsSsize_t(_object*, _object*) @nogc nothrow;
    _object* _PyNumber_ConvertIntegralToInt(_object*, const(char)*) @nogc nothrow;
    _object* PyNumber_Int(_object*) @nogc nothrow;
    _object* PyNumber_Long(_object*) @nogc nothrow;
    _object* PyNumber_Float(_object*) @nogc nothrow;
    _object* PyNumber_InPlaceAdd(_object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlaceSubtract(_object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlaceMultiply(_object*, _object*) @nogc nothrow;
    _object* PyNumber_InPlaceDivide(_object*, _object*) @nogc nothrow;
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
    c_long a64l(const(char)*) @nogc nothrow;
    c_long PySequence_Count(_object*, _object*) @nogc nothrow;
    int PySequence_Contains(_object*, _object*) @nogc nothrow;
    char* l64a(c_long) @nogc nothrow;
    c_long _PySequence_IterSearch(_object*, _object*, int) @nogc nothrow;
    int PySequence_In(_object*, _object*) @nogc nothrow;
    c_long PySequence_Index(_object*, _object*) @nogc nothrow;
    _object* PySequence_InPlaceConcat(_object*, _object*) @nogc nothrow;
    _object* PySequence_InPlaceRepeat(_object*, c_long) @nogc nothrow;
    int PyMapping_Check(_object*) @nogc nothrow;
    c_long PyMapping_Size(_object*) @nogc nothrow;
    c_long PyMapping_Length(_object*) @nogc nothrow;
    int PyMapping_HasKeyString(_object*, char*) @nogc nothrow;
    int PyMapping_HasKey(_object*, _object*) @nogc nothrow;
    real strtof64x_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    _object* PyMapping_GetItemString(_object*, char*) @nogc nothrow;
    int PyMapping_SetItemString(_object*, char*, _object*) @nogc nothrow;
    int PyObject_IsInstance(_object*, _object*) @nogc nothrow;
    int PyObject_IsSubclass(_object*, _object*) @nogc nothrow;
    int _PyObject_RealIsInstance(_object*, _object*) @nogc nothrow;
    int _PyObject_RealIsSubclass(_object*, _object*) @nogc nothrow;
    void _Py_add_one_to_index_F(int, c_long*, const(c_long)*) @nogc nothrow;
    void _Py_add_one_to_index_C(int, c_long*, const(c_long)*) @nogc nothrow;
    alias PyBoolObject = PyIntObject;
    extern __gshared _typeobject PyBool_Type;
    extern __gshared PyIntObject _Py_ZeroStruct;
    extern __gshared PyIntObject _Py_TrueStruct;
    double strtof32x_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    _object* PyBool_FromLong(c_long) @nogc nothrow;
    extern __gshared _typeobject PyBuffer_Type;
    double strtof64_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    _object* PyBuffer_FromObject(_object*, c_long, c_long) @nogc nothrow;
    _object* PyBuffer_FromReadWriteObject(_object*, c_long, c_long) @nogc nothrow;
    _object* PyBuffer_FromMemory(void*, c_long) @nogc nothrow;
    _object* PyBuffer_FromReadWriteMemory(void*, c_long) @nogc nothrow;
    _object* PyBuffer_New(c_long) @nogc nothrow;
    struct PyByteArrayObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long ob_size;
        int ob_exports;
        c_long ob_alloc;
        char* ob_bytes;
    }
    extern __gshared _typeobject PyByteArray_Type;
    extern __gshared _typeobject PyByteArrayIter_Type;
    float strtof32_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    _object* PyByteArray_FromObject(_object*) @nogc nothrow;
    _object* PyByteArray_Concat(_object*, _object*) @nogc nothrow;
    _object* PyByteArray_FromStringAndSize(const(char)*, c_long) @nogc nothrow;
    c_long PyByteArray_Size(_object*) @nogc nothrow;
    char* PyByteArray_AsString(_object*) @nogc nothrow;
    int PyByteArray_Resize(_object*, c_long) @nogc nothrow;
    extern __gshared char[0] _PyByteArray_empty_string;
    real strtold_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    float strtof_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    double strtod_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    ulong strtoull_l(const(char)*, char**, int, __locale_struct*) @nogc nothrow;
    long strtoll_l(const(char)*, char**, int, __locale_struct*) @nogc nothrow;
    c_ulong strtoul_l(const(char)*, char**, int, __locale_struct*) @nogc nothrow;
    c_long strtol_l(const(char)*, char**, int, __locale_struct*) @nogc nothrow;
    struct PyCellObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _object* ob_ref;
    }
    extern __gshared _typeobject PyCell_Type;
    _object* PyCell_New(_object*) @nogc nothrow;
    _object* PyCell_Get(_object*) @nogc nothrow;
    int PyCell_Set(_object*, _object*) @nogc nothrow;
    int strfromf64x(char*, c_ulong, const(char)*, real) @nogc nothrow;
    _object* PyEval_CallObjectWithKeywords(_object*, _object*, _object*) @nogc nothrow;
    _object* PyEval_CallFunction(_object*, const(char)*, ...) @nogc nothrow;
    _object* PyEval_CallMethod(_object*, const(char)*, const(char)*, ...) @nogc nothrow;
    void PyEval_SetProfile(int function(_object*, _frame*, int, _object*), _object*) @nogc nothrow;
    void PyEval_SetTrace(int function(_object*, _frame*, int, _object*), _object*) @nogc nothrow;
    _object* PyEval_GetBuiltins() @nogc nothrow;
    _object* PyEval_GetGlobals() @nogc nothrow;
    _object* PyEval_GetLocals() @nogc nothrow;
    _frame* PyEval_GetFrame() @nogc nothrow;
    int PyEval_GetRestricted() @nogc nothrow;
    int PyEval_MergeCompilerFlags(PyCompilerFlags*) @nogc nothrow;
    int Py_FlushLine() @nogc nothrow;
    int Py_AddPendingCall(int function(void*), void*) @nogc nothrow;
    int Py_MakePendingCalls() @nogc nothrow;
    void Py_SetRecursionLimit(int) @nogc nothrow;
    int Py_GetRecursionLimit() @nogc nothrow;
    int strfromf32x(char*, c_ulong, const(char)*, double) @nogc nothrow;
    int _Py_CheckRecursiveCall(const(char)*) @nogc nothrow;
    extern __gshared int _Py_CheckRecursionLimit;
    const(char)* PyEval_GetFuncName(_object*) @nogc nothrow;
    const(char)* PyEval_GetFuncDesc(_object*) @nogc nothrow;
    _object* PyEval_GetCallStats(_object*) @nogc nothrow;
    _object* PyEval_EvalFrame(_frame*) @nogc nothrow;
    _object* PyEval_EvalFrameEx(_frame*, int) @nogc nothrow;
    extern __gshared int _Py_Ticker;
    extern __gshared int _Py_CheckInterval;
    _ts* PyEval_SaveThread() @nogc nothrow;
    void PyEval_RestoreThread(_ts*) @nogc nothrow;
    int PyEval_ThreadsInitialized() @nogc nothrow;
    void PyEval_InitThreads() @nogc nothrow;
    void PyEval_AcquireLock() @nogc nothrow;
    void PyEval_ReleaseLock() @nogc nothrow;
    void PyEval_AcquireThread(_ts*) @nogc nothrow;
    void PyEval_ReleaseThread(_ts*) @nogc nothrow;
    void PyEval_ReInitThreads() @nogc nothrow;
    int _PyEval_SliceIndex(_object*, c_long*) @nogc nothrow;
    int _PyEval_SliceIndexNotNone(_object*, c_long*) @nogc nothrow;
    struct PyClassObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _object* cl_bases;
        _object* cl_dict;
        _object* cl_name;
        _object* cl_getattr;
        _object* cl_setattr;
        _object* cl_delattr;
        _object* cl_weakreflist;
    }
    struct PyInstanceObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        PyClassObject* in_class;
        _object* in_dict;
        _object* in_weakreflist;
    }
    struct PyMethodObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _object* im_func;
        _object* im_self;
        _object* im_class;
        _object* im_weakreflist;
    }
    extern __gshared _typeobject PyMethod_Type;
    extern __gshared _typeobject PyInstance_Type;
    extern __gshared _typeobject PyClass_Type;
    int strfromf64(char*, c_ulong, const(char)*, double) @nogc nothrow;
    _object* PyClass_New(_object*, _object*, _object*) @nogc nothrow;
    _object* PyInstance_New(_object*, _object*, _object*) @nogc nothrow;
    _object* PyInstance_NewRaw(_object*, _object*) @nogc nothrow;
    _object* PyMethod_New(_object*, _object*, _object*) @nogc nothrow;
    _object* PyMethod_Function(_object*) @nogc nothrow;
    _object* PyMethod_Self(_object*) @nogc nothrow;
    _object* PyMethod_Class(_object*) @nogc nothrow;
    _object* _PyInstance_Lookup(_object*, _object*) @nogc nothrow;
    int strfromf32(char*, c_ulong, const(char)*, float) @nogc nothrow;
    int PyClass_IsSubclass(_object*, _object*) @nogc nothrow;
    int PyMethod_ClearFreeList() @nogc nothrow;
    extern __gshared _typeobject PyCObject_Type;
    _object* PyCObject_FromVoidPtr(void*, void function(void*)) @nogc nothrow;
    _object* PyCObject_FromVoidPtrAndDesc(void*, void*, void function(void*, void*)) @nogc nothrow;
    void* PyCObject_AsVoidPtr(_object*) @nogc nothrow;
    void* PyCObject_GetDesc(_object*) @nogc nothrow;
    void* PyCObject_Import(char*, char*) @nogc nothrow;
    int PyCObject_SetVoidPtr(_object*, void*) @nogc nothrow;
    struct PyCObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        void* cobject;
        void* desc;
        void function(void*) destructor;
    }
    struct PyCodeObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        int co_argcount;
        int co_nlocals;
        int co_stacksize;
        int co_flags;
        _object* co_code;
        _object* co_consts;
        _object* co_names;
        _object* co_varnames;
        _object* co_freevars;
        _object* co_cellvars;
        _object* co_filename;
        _object* co_name;
        int co_firstlineno;
        _object* co_lnotab;
        void* co_zombieframe;
        _object* co_weakreflist;
    }
    int strfroml(char*, c_ulong, const(char)*, real) @nogc nothrow;
    int strfromf(char*, c_ulong, const(char)*, float) @nogc nothrow;
    int strfromd(char*, c_ulong, const(char)*, double) @nogc nothrow;
    ulong strtoull(const(char)*, char**, int) @nogc nothrow;
    extern __gshared _typeobject PyCode_Type;
    PyCodeObject* PyCode_New(int, int, int, int, _object*, _object*, _object*, _object*, _object*, _object*, _object*, _object*, int, _object*) @nogc nothrow;
    PyCodeObject* PyCode_NewEmpty(const(char)*, const(char)*, int) @nogc nothrow;
    int PyCode_Addr2Line(PyCodeObject*, int) @nogc nothrow;
    long strtoll(const(char)*, char**, int) @nogc nothrow;
    alias PyAddrPair = _addr_pair;
    struct _addr_pair
    {
        int ap_lower;
        int ap_upper;
    }
    int _PyCode_CheckLineNumber(PyCodeObject*, int, _addr_pair*) @nogc nothrow;
    _object* _PyCode_ConstantKey(_object*) @nogc nothrow;
    _object* PyCode_Optimize(_object*, _object*, _object*, _object*) @nogc nothrow;
    int PyCodec_Register(_object*) @nogc nothrow;
    _object* _PyCodec_Lookup(const(char)*) @nogc nothrow;
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
    PyCodeObject* PyNode_Compile(_node*, const(char)*) @nogc nothrow;
    struct PyFutureFeatures
    {
        int ff_features;
        int ff_lineno;
    }
    ulong strtouq(const(char)*, char**, int) @nogc nothrow;
    long strtoq(const(char)*, char**, int) @nogc nothrow;
    PyCodeObject* PyAST_Compile(_mod*, const(char)*, PyCompilerFlags*, _arena*) @nogc nothrow;
    PyFutureFeatures* PyFuture_FromAST(_mod*, const(char)*) @nogc nothrow;
    struct Py_complex
    {
        double real_;
        double imag;
    }
    c_ulong strtoul(const(char)*, char**, int) @nogc nothrow;
    c_long strtol(const(char)*, char**, int) @nogc nothrow;
    Py_complex _Py_c_sum(Py_complex, Py_complex) @nogc nothrow;
    Py_complex _Py_c_diff(Py_complex, Py_complex) @nogc nothrow;
    Py_complex _Py_c_neg(Py_complex) @nogc nothrow;
    Py_complex _Py_c_prod(Py_complex, Py_complex) @nogc nothrow;
    Py_complex _Py_c_quot(Py_complex, Py_complex) @nogc nothrow;
    Py_complex _Py_c_pow(Py_complex, Py_complex) @nogc nothrow;
    double _Py_c_abs(Py_complex) @nogc nothrow;
    struct PyComplexObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        Py_complex cval;
    }
    extern __gshared _typeobject PyComplex_Type;
    real strtof64x(const(char)*, char**) @nogc nothrow;
    _object* PyComplex_FromCComplex(Py_complex) @nogc nothrow;
    _object* PyComplex_FromDoubles(double, double) @nogc nothrow;
    double PyComplex_RealAsDouble(_object*) @nogc nothrow;
    double PyComplex_ImagAsDouble(_object*) @nogc nothrow;
    Py_complex PyComplex_AsCComplex(_object*) @nogc nothrow;
    _object* _PyComplex_FormatAdvanced(_object*, char*, c_long) @nogc nothrow;
    struct PyDateTime_Delta
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long hashcode;
        int days;
        int seconds;
        int microseconds;
    }
    struct PyDateTime_TZInfo
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
    }
    double strtof32x(const(char)*, char**) @nogc nothrow;
    struct _PyDateTime_BaseTZInfo
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long hashcode;
        char hastzinfo;
    }
    struct _PyDateTime_BaseTime
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long hashcode;
        char hastzinfo;
        ubyte[6] data;
    }
    struct PyDateTime_Time
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long hashcode;
        char hastzinfo;
        ubyte[6] data;
        _object* tzinfo;
    }
    struct PyDateTime_Date
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long hashcode;
        char hastzinfo;
        ubyte[4] data;
    }
    struct _PyDateTime_BaseDateTime
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long hashcode;
        char hastzinfo;
        ubyte[10] data;
    }
    struct PyDateTime_DateTime
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long hashcode;
        char hastzinfo;
        ubyte[10] data;
        _object* tzinfo;
    }
    double strtof64(const(char)*, char**) @nogc nothrow;
    float strtof32(const(char)*, char**) @nogc nothrow;
    struct PyDateTime_CAPI
    {
        _typeobject* DateType;
        _typeobject* DateTimeType;
        _typeobject* TimeType;
        _typeobject* DeltaType;
        _typeobject* TZInfoType;
        _object* function(int, int, int, _typeobject*) Date_FromDate;
        _object* function(int, int, int, int, int, int, int, _object*, _typeobject*) DateTime_FromDateAndTime;
        _object* function(int, int, int, int, _object*, _typeobject*) Time_FromTime;
        _object* function(int, int, int, int, _typeobject*) Delta_FromDelta;
        _object* function(_object*, _object*, _object*) DateTime_FromTimestamp;
        _object* function(_object*, _object*) Date_FromTimestamp;
    }
    extern __gshared PyDateTime_CAPI* PyDateTimeAPI;
    real strtold(const(char)*, char**) @nogc nothrow;
    float strtof(const(char)*, char**) @nogc nothrow;
    double strtod(const(char)*, char**) @nogc nothrow;
    long atoll(const(char)*) @nogc nothrow;
    alias getter = _object* function(_object*, void*);
    alias setter = int function(_object*, _object*, void*);
    alias wrapperfunc = _object* function(_object*, _object*, void*);
    alias wrapperfunc_kwds = _object* function(_object*, _object*, void*, _object*);
    struct wrapperbase
    {
        char* name;
        int offset;
        void* function_;
        _object* function(_object*, _object*, void*) wrapper;
        char* doc;
        int flags;
        _object* name_strobj;
    }
    struct PyDescrObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _typeobject* d_type;
        _object* d_name;
    }
    struct PyMethodDescrObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _typeobject* d_type;
        _object* d_name;
        PyMethodDef* d_method;
    }
    struct PyMemberDescrObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _typeobject* d_type;
        _object* d_name;
        PyMemberDef* d_member;
    }
    struct PyGetSetDescrObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _typeobject* d_type;
        _object* d_name;
        PyGetSetDef* d_getset;
    }
    struct PyWrapperDescrObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _typeobject* d_type;
        _object* d_name;
        wrapperbase* d_base;
        void* d_wrapped;
    }
    extern __gshared _typeobject PyWrapperDescr_Type;
    extern __gshared _typeobject PyDictProxy_Type;
    extern __gshared _typeobject PyGetSetDescr_Type;
    extern __gshared _typeobject PyMemberDescr_Type;
    _object* PyDescr_NewMethod(_typeobject*, PyMethodDef*) @nogc nothrow;
    _object* PyDescr_NewClassMethod(_typeobject*, PyMethodDef*) @nogc nothrow;
    _object* PyDescr_NewMember(_typeobject*, PyMemberDef*) @nogc nothrow;
    _object* PyDescr_NewGetSet(_typeobject*, PyGetSetDef*) @nogc nothrow;
    _object* PyDescr_NewWrapper(_typeobject*, wrapperbase*, void*) @nogc nothrow;
    _object* PyDictProxy_New(_object*) @nogc nothrow;
    _object* PyWrapper_New(_object*, _object*) @nogc nothrow;
    extern __gshared _typeobject PyProperty_Type;
    c_long atol(const(char)*) @nogc nothrow;
    struct PyDictEntry
    {
        c_long me_hash;
        _object* me_key;
        _object* me_value;
    }
    alias PyDictObject = _dictobject;
    struct _dictobject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long ma_fill;
        c_long ma_used;
        c_long ma_mask;
        PyDictEntry* ma_table;
        PyDictEntry* function(_dictobject*, _object*, c_long) ma_lookup;
        PyDictEntry[8] ma_smalltable;
    }
    extern __gshared _typeobject PyDict_Type;
    extern __gshared _typeobject PyDictIterKey_Type;
    extern __gshared _typeobject PyDictIterValue_Type;
    extern __gshared _typeobject PyDictIterItem_Type;
    extern __gshared _typeobject PyDictKeys_Type;
    extern __gshared _typeobject PyDictItems_Type;
    extern __gshared _typeobject PyDictValues_Type;
    int atoi(const(char)*) @nogc nothrow;
    _object* PyDict_New() @nogc nothrow;
    _object* PyDict_GetItem(_object*, _object*) @nogc nothrow;
    _object* _PyDict_GetItemWithError(_object*, _object*) @nogc nothrow;
    int PyDict_SetItem(_object*, _object*, _object*) @nogc nothrow;
    int PyDict_DelItem(_object*, _object*) @nogc nothrow;
    int _PyDict_DelItemIf(_object*, _object*, int function(_object*)) @nogc nothrow;
    void PyDict_Clear(_object*) @nogc nothrow;
    int PyDict_Next(_object*, c_long*, _object**, _object**) @nogc nothrow;
    int _PyDict_Next(_object*, c_long*, _object**, _object**, c_long*) @nogc nothrow;
    _object* PyDict_Keys(_object*) @nogc nothrow;
    _object* PyDict_Values(_object*) @nogc nothrow;
    _object* PyDict_Items(_object*) @nogc nothrow;
    c_long PyDict_Size(_object*) @nogc nothrow;
    _object* PyDict_Copy(_object*) @nogc nothrow;
    int PyDict_Contains(_object*, _object*) @nogc nothrow;
    int _PyDict_Contains(_object*, _object*, c_long) @nogc nothrow;
    _object* _PyDict_NewPresized(c_long) @nogc nothrow;
    void _PyDict_MaybeUntrack(_object*) @nogc nothrow;
    int PyDict_Update(_object*, _object*) @nogc nothrow;
    int PyDict_Merge(_object*, _object*, int) @nogc nothrow;
    int PyDict_MergeFromSeq2(_object*, _object*, int) @nogc nothrow;
    _object* PyDict_GetItemString(_object*, const(char)*) @nogc nothrow;
    int PyDict_SetItemString(_object*, const(char)*, _object*) @nogc nothrow;
    int PyDict_DelItemString(_object*, const(char)*) @nogc nothrow;
    double _Py_dg_strtod(const(char)*, char**) @nogc nothrow;
    char* _Py_dg_dtoa(double, int, int, int*, int*, char**) @nogc nothrow;
    void _Py_dg_freedtoa(char*) @nogc nothrow;
    extern __gshared _typeobject PyEnum_Type;
    extern __gshared _typeobject PyReversed_Type;
    _object* PyEval_EvalCode(PyCodeObject*, _object*, _object*) @nogc nothrow;
    _object* PyEval_EvalCodeEx(PyCodeObject*, _object*, _object*, _object**, int, _object**, int, _object**, int, _object*) @nogc nothrow;
    _object* _PyEval_CallTracing(_object*, _object*) @nogc nothrow;
    double atof(const(char)*) @nogc nothrow;
    struct PyFileObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _IO_FILE* f_fp;
        _object* f_name;
        _object* f_mode;
        int function(_IO_FILE*) f_close;
        int f_softspace;
        int f_binary;
        char* f_buf;
        char* f_bufend;
        char* f_bufptr;
        char* f_setbuf;
        int f_univ_newline;
        int f_newlinetypes;
        int f_skipnextlf;
        _object* f_encoding;
        _object* f_errors;
        _object* weakreflist;
        int unlocked_count;
        int readable;
        int writable;
    }
    extern __gshared _typeobject PyFile_Type;
    _object* PyFile_FromString(char*, char*) @nogc nothrow;
    void PyFile_SetBufSize(_object*, int) @nogc nothrow;
    int PyFile_SetEncoding(_object*, const(char)*) @nogc nothrow;
    int PyFile_SetEncodingAndErrors(_object*, const(char)*, char*) @nogc nothrow;
    _object* PyFile_FromFile(_IO_FILE*, char*, char*, int function(_IO_FILE*)) @nogc nothrow;
    _IO_FILE* PyFile_AsFile(_object*) @nogc nothrow;
    void PyFile_IncUseCount(PyFileObject*) @nogc nothrow;
    void PyFile_DecUseCount(PyFileObject*) @nogc nothrow;
    _object* PyFile_Name(_object*) @nogc nothrow;
    _object* PyFile_GetLine(_object*, int) @nogc nothrow;
    int PyFile_WriteObject(_object*, _object*, int) @nogc nothrow;
    int PyFile_SoftSpace(_object*, int) @nogc nothrow;
    int PyFile_WriteString(const(char)*, _object*) @nogc nothrow;
    int PyObject_AsFileDescriptor(_object*) @nogc nothrow;
    extern __gshared const(char)* Py_FileSystemDefaultEncoding;
    c_ulong __ctype_get_mb_cur_max() @nogc nothrow;
    char* Py_UniversalNewlineFgets(char*, int, _IO_FILE*, _object*) @nogc nothrow;
    c_ulong Py_UniversalNewlineFread(char*, c_ulong, _IO_FILE*, _object*) @nogc nothrow;
    int _PyFile_SanitizeMode(char*) @nogc nothrow;
    struct lldiv_t
    {
        long quot;
        long rem;
    }
    struct PyFloatObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        double ob_fval;
    }
    extern __gshared _typeobject PyFloat_Type;
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
    double PyFloat_GetMax() @nogc nothrow;
    double PyFloat_GetMin() @nogc nothrow;
    _object* PyFloat_GetInfo() @nogc nothrow;
    _object* PyFloat_FromString(_object*, char**) @nogc nothrow;
    _object* PyFloat_FromDouble(double) @nogc nothrow;
    double PyFloat_AsDouble(_object*) @nogc nothrow;
    void PyFloat_AsReprString(char*, PyFloatObject*) @nogc nothrow;
    void PyFloat_AsString(char*, PyFloatObject*) @nogc nothrow;
    int _PyFloat_Pack4(double, ubyte*, int) @nogc nothrow;
    int _PyFloat_Pack8(double, ubyte*, int) @nogc nothrow;
    int _PyFloat_Digits(char*, double, int*) @nogc nothrow;
    void _PyFloat_DigitsInit() @nogc nothrow;
    double _PyFloat_Unpack4(const(ubyte)*, int) @nogc nothrow;
    double _PyFloat_Unpack8(const(ubyte)*, int) @nogc nothrow;
    int PyFloat_ClearFreeList() @nogc nothrow;
    _object* _PyFloat_FormatAdvanced(_object*, char*, c_long) @nogc nothrow;
    _object* _Py_double_round(double, int) @nogc nothrow;
    struct PyFunctionObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _object* func_code;
        _object* func_globals;
        _object* func_defaults;
        _object* func_closure;
        _object* func_doc;
        _object* func_name;
        _object* func_dict;
        _object* func_weakreflist;
        _object* func_module;
    }
    extern __gshared _typeobject PyFunction_Type;
    _object* PyFunction_New(_object*, _object*) @nogc nothrow;
    _object* PyFunction_GetCode(_object*) @nogc nothrow;
    _object* PyFunction_GetGlobals(_object*) @nogc nothrow;
    _object* PyFunction_GetModule(_object*) @nogc nothrow;
    _object* PyFunction_GetDefaults(_object*) @nogc nothrow;
    int PyFunction_SetDefaults(_object*, _object*) @nogc nothrow;
    _object* PyFunction_GetClosure(_object*) @nogc nothrow;
    int PyFunction_SetClosure(_object*, _object*) @nogc nothrow;
    extern __gshared _typeobject PyClassMethod_Type;
    extern __gshared _typeobject PyStaticMethod_Type;
    _object* PyClassMethod_New(_object*) @nogc nothrow;
    _object* PyStaticMethod_New(_object*) @nogc nothrow;
    struct PyGenObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _frame* gi_frame;
        int gi_running;
        _object* gi_code;
        _object* gi_weakreflist;
    }
    extern __gshared _typeobject PyGen_Type;
    _object* PyGen_New(_frame*) @nogc nothrow;
    int PyGen_NeedsFinalizing(PyGenObject*) @nogc nothrow;
    int __overflow(_IO_FILE*, int) @nogc nothrow;
    c_long PyImport_GetMagicNumber() @nogc nothrow;
    _object* PyImport_ExecCodeModule(char*, _object*) @nogc nothrow;
    _object* PyImport_ExecCodeModuleEx(char*, _object*, char*) @nogc nothrow;
    _object* PyImport_GetModuleDict() @nogc nothrow;
    _object* PyImport_AddModule(const(char)*) @nogc nothrow;
    _object* PyImport_ImportModule(const(char)*) @nogc nothrow;
    _object* PyImport_ImportModuleNoBlock(const(char)*) @nogc nothrow;
    _object* PyImport_ImportModuleLevel(char*, _object*, _object*, _object*, int) @nogc nothrow;
    int __uflow(_IO_FILE*) @nogc nothrow;
    _object* PyImport_GetImporter(_object*) @nogc nothrow;
    _object* PyImport_Import(_object*) @nogc nothrow;
    _object* PyImport_ReloadModule(_object*) @nogc nothrow;
    void PyImport_Cleanup() @nogc nothrow;
    int PyImport_ImportFrozenModule(char*) @nogc nothrow;
    void _PyImport_AcquireLock() @nogc nothrow;
    int _PyImport_ReleaseLock() @nogc nothrow;
    struct filedescr;
    filedescr* _PyImport_FindModule(const(char)*, _object*, char*, c_ulong, _IO_FILE**, _object**) @nogc nothrow;
    int _PyImport_IsScript(filedescr*) @nogc nothrow;
    void _PyImport_ReInitLock() @nogc nothrow;
    _object* _PyImport_FindExtension(char*, char*) @nogc nothrow;
    _object* _PyImport_FixupExtension(char*, char*) @nogc nothrow;
    struct _inittab
    {
        char* name;
        void function() initfunc;
    }
    extern __gshared _typeobject PyNullImporter_Type;
    extern __gshared _inittab* PyImport_Inittab;
    int PyImport_AppendInittab(const(char)*, void function()) @nogc nothrow;
    int PyImport_ExtendInittab(_inittab*) @nogc nothrow;
    struct _frozen
    {
        char* name;
        ubyte* code;
        int size;
    }
    extern __gshared _frozen* PyImport_FrozenModules;
    struct PyIntObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long ob_ival;
    }
    extern __gshared _typeobject PyInt_Type;
    _object* PyInt_FromString(char*, char**, int) @nogc nothrow;
    _object* PyInt_FromUnicode(uint*, c_long, int) @nogc nothrow;
    _object* PyInt_FromLong(c_long) @nogc nothrow;
    _object* PyInt_FromSize_t(c_ulong) @nogc nothrow;
    _object* PyInt_FromSsize_t(c_long) @nogc nothrow;
    c_long PyInt_AsLong(_object*) @nogc nothrow;
    c_long PyInt_AsSsize_t(_object*) @nogc nothrow;
    int _PyInt_AsInt(_object*) @nogc nothrow;
    c_ulong PyInt_AsUnsignedLongMask(_object*) @nogc nothrow;
    ulong PyInt_AsUnsignedLongLongMask(_object*) @nogc nothrow;
    c_long PyInt_GetMax() @nogc nothrow;
    c_ulong PyOS_strtoul(char*, char**, int) @nogc nothrow;
    c_long PyOS_strtol(char*, char**, int) @nogc nothrow;
    int PyInt_ClearFreeList() @nogc nothrow;
    _object* _PyInt_Format(PyIntObject*, int, int) @nogc nothrow;
    _object* _PyInt_FormatAdvanced(_object*, char*, c_long) @nogc nothrow;
    void funlockfile(_IO_FILE*) @nogc nothrow;
    int PyOS_InterruptOccurred() @nogc nothrow;
    void PyOS_InitInterrupts() @nogc nothrow;
    void PyOS_AfterFork() @nogc nothrow;
    extern __gshared _typeobject PySeqIter_Type;
    _object* PySeqIter_New(_object*) @nogc nothrow;
    extern __gshared _typeobject PyCallIter_Type;
    int ftrylockfile(_IO_FILE*) @nogc nothrow;
    _object* PyCallIter_New(_object*, _object*) @nogc nothrow;
    struct PyListObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long ob_size;
        _object** ob_item;
        c_long allocated;
    }
    extern __gshared _typeobject PyList_Type;
    void flockfile(_IO_FILE*) @nogc nothrow;
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
    int obstack_vprintf(obstack*, const(char)*, va_list*) @nogc nothrow;
    int obstack_printf(obstack*, const(char)*, ...) @nogc nothrow;
    alias PyLongObject = _longobject;
    struct _longobject;
    extern __gshared _typeobject PyLong_Type;
    struct obstack;
    _object* PyLong_FromLong(c_long) @nogc nothrow;
    _object* PyLong_FromUnsignedLong(c_ulong) @nogc nothrow;
    _object* PyLong_FromDouble(double) @nogc nothrow;
    _object* PyLong_FromSize_t(c_ulong) @nogc nothrow;
    _object* PyLong_FromSsize_t(c_long) @nogc nothrow;
    c_long PyLong_AsLong(_object*) @nogc nothrow;
    c_long PyLong_AsLongAndOverflow(_object*, int*) @nogc nothrow;
    c_ulong PyLong_AsUnsignedLong(_object*) @nogc nothrow;
    c_ulong PyLong_AsUnsignedLongMask(_object*) @nogc nothrow;
    c_long PyLong_AsSsize_t(_object*) @nogc nothrow;
    int _PyLong_AsInt(_object*) @nogc nothrow;
    _object* PyLong_GetInfo() @nogc nothrow;
    char* cuserid(char*) @nogc nothrow;
    extern __gshared int[256] _PyLong_DigitValue;
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
    _object* PyLong_FromString(char*, char**, int) @nogc nothrow;
    _object* PyLong_FromUnicode(uint*, c_long, int) @nogc nothrow;
    int _PyLong_Sign(_object*) @nogc nothrow;
    c_ulong _PyLong_NumBits(_object*) @nogc nothrow;
    _object* _PyLong_FromByteArray(const(ubyte)*, c_ulong, int, int) @nogc nothrow;
    int _PyLong_AsByteArray(_longobject*, ubyte*, c_ulong, int, int) @nogc nothrow;
    _object* _PyLong_Format(_object*, int, int, int) @nogc nothrow;
    _object* _PyLong_FormatAdvanced(_object*, char*, c_long) @nogc nothrow;
    extern __gshared _typeobject PyMemoryView_Type;
    char* ctermid(char*) @nogc nothrow;
    _object* PyMemoryView_GetContiguous(_object*, int, char) @nogc nothrow;
    _object* PyMemoryView_FromObject(_object*) @nogc nothrow;
    _object* PyMemoryView_FromBuffer(bufferinfo*) @nogc nothrow;
    struct PyMemoryViewObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _object* base;
        bufferinfo view;
    }
    int pclose(_IO_FILE*) @nogc nothrow;
    extern __gshared _typeobject PyCFunction_Type;
    alias PyCFunction = _object* function(_object*, _object*);
    alias PyCFunctionWithKeywords = _object* function(_object*, _object*, _object*);
    alias PyNoArgsFunction = _object* function(_object*);
    _object* function(_object*, _object*) PyCFunction_GetFunction(_object*) @nogc nothrow;
    _object* PyCFunction_GetSelf(_object*) @nogc nothrow;
    int PyCFunction_GetFlags(_object*) @nogc nothrow;
    _IO_FILE* popen(const(char)*, const(char)*) @nogc nothrow;
    _object* PyCFunction_Call(_object*, _object*, _object*) @nogc nothrow;
    _object* Py_FindMethod(PyMethodDef*, _object*, const(char)*) @nogc nothrow;
    _object* PyCFunction_NewEx(PyMethodDef*, _object*, _object*) @nogc nothrow;
    int fileno_unlocked(_IO_FILE*) @nogc nothrow;
    int fileno(_IO_FILE*) @nogc nothrow;
    void perror(const(char)*) @nogc nothrow;
    struct PyMethodChain
    {
        PyMethodDef* methods;
        PyMethodChain* link;
    }
    _object* Py_FindMethodInChain(PyMethodChain*, _object*, const(char)*) @nogc nothrow;
    struct PyCFunctionObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        PyMethodDef* m_ml;
        _object* m_self;
        _object* m_module;
    }
    int PyCFunction_ClearFreeList() @nogc nothrow;
    _object* _Py_VaBuildValue_SizeT(const(char)*, va_list*) @nogc nothrow;
    int PyArg_Parse(_object*, const(char)*, ...) @nogc nothrow;
    int PyArg_ParseTuple(_object*, const(char)*, ...) @nogc nothrow;
    int PyArg_ParseTupleAndKeywords(_object*, _object*, const(char)*, char**, ...) @nogc nothrow;
    int PyArg_UnpackTuple(_object*, const(char)*, c_long, c_long, ...) @nogc nothrow;
    _object* Py_BuildValue(const(char)*, ...) @nogc nothrow;
    _object* _Py_BuildValue_SizeT(const(char)*, ...) @nogc nothrow;
    int _PyArg_NoKeywords(const(char)*, _object*) @nogc nothrow;
    int PyArg_VaParse(_object*, const(char)*, va_list*) @nogc nothrow;
    int PyArg_VaParseTupleAndKeywords(_object*, _object*, const(char)*, char**, va_list*) @nogc nothrow;
    _object* Py_VaBuildValue(const(char)*, va_list*) @nogc nothrow;
    int PyModule_AddObject(_object*, const(char)*, _object*) @nogc nothrow;
    int PyModule_AddIntConstant(_object*, const(char)*, c_long) @nogc nothrow;
    int PyModule_AddStringConstant(_object*, const(char)*, const(char)*) @nogc nothrow;
    int ferror_unlocked(_IO_FILE*) @nogc nothrow;
    int feof_unlocked(_IO_FILE*) @nogc nothrow;
    _object* Py_InitModule4_64(const(char)*, PyMethodDef*, const(char)*, _object*, int) @nogc nothrow;
    void clearerr_unlocked(_IO_FILE*) @nogc nothrow;
    extern __gshared char* _Py_PackageContext;
    extern __gshared _typeobject PyModule_Type;
    _object* PyModule_New(const(char)*) @nogc nothrow;
    _object* PyModule_GetDict(_object*) @nogc nothrow;
    char* PyModule_GetName(_object*) @nogc nothrow;
    char* PyModule_GetFilename(_object*) @nogc nothrow;
    void _PyModule_Clear(_object*) @nogc nothrow;
    int ferror(_IO_FILE*) @nogc nothrow;
    int feof(_IO_FILE*) @nogc nothrow;
    void clearerr(_IO_FILE*) @nogc nothrow;
    int fsetpos64(_IO_FILE*, const(_G_fpos64_t)*) @nogc nothrow;
    int fgetpos64(_IO_FILE*, _G_fpos64_t*) @nogc nothrow;
    alias PyObject = _object;
    struct _object
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
    }
    struct _typeobject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long ob_size;
        const(char)* tp_name;
        c_long tp_basicsize;
        c_long tp_itemsize;
        void function(_object*) tp_dealloc;
        int function(_object*, _IO_FILE*, int) tp_print;
        _object* function(_object*, char*) tp_getattr;
        int function(_object*, char*, _object*) tp_setattr;
        int function(_object*, _object*) tp_compare;
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
        c_long tp_flags;
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
    }
    struct PyVarObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long ob_size;
    }
    c_long ftello64(_IO_FILE*) @nogc nothrow;
    int fseeko64(_IO_FILE*, c_long, int) @nogc nothrow;
    alias unaryfunc = _object* function(_object*);
    alias binaryfunc = _object* function(_object*, _object*);
    alias ternaryfunc = _object* function(_object*, _object*, _object*);
    alias inquiry = int function(_object*);
    alias lenfunc = c_long function(_object*);
    alias coercion = int function(_object**, _object**);
    alias intargfunc = _object* function(_object*, int);
    alias intintargfunc = _object* function(_object*, int, int);
    alias ssizeargfunc = _object* function(_object*, c_long);
    alias ssizessizeargfunc = _object* function(_object*, c_long, c_long);
    alias intobjargproc = int function(_object*, int, _object*);
    alias intintobjargproc = int function(_object*, int, int, _object*);
    alias ssizeobjargproc = int function(_object*, c_long, _object*);
    alias ssizessizeobjargproc = int function(_object*, c_long, c_long, _object*);
    alias objobjargproc = int function(_object*, _object*, _object*);
    alias getreadbufferproc = int function(_object*, int, void**);
    alias getwritebufferproc = int function(_object*, int, void**);
    alias getsegcountproc = int function(_object*, int*);
    alias getcharbufferproc = int function(_object*, int, char**);
    alias readbufferproc = c_long function(_object*, c_long, void**);
    alias writebufferproc = c_long function(_object*, c_long, void**);
    alias segcountproc = c_long function(_object*, c_long*);
    alias charbufferproc = c_long function(_object*, c_long, char**);
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
        c_long[2] smalltable;
        void* internal;
    }
    alias getbufferproc = int function(_object*, bufferinfo*, int);
    alias releasebufferproc = void function(_object*, bufferinfo*);
    int fsetpos(_IO_FILE*, const(_G_fpos64_t)*) @nogc nothrow;
    int fgetpos(_IO_FILE*, _G_fpos64_t*) @nogc nothrow;
    c_long ftello(_IO_FILE*) @nogc nothrow;
    int fseeko(_IO_FILE*, c_long, int) @nogc nothrow;
    void rewind(_IO_FILE*) @nogc nothrow;
    c_long ftell(_IO_FILE*) @nogc nothrow;
    int fseek(_IO_FILE*, c_long, int) @nogc nothrow;
    c_ulong fwrite_unlocked(const(void)*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;
    alias objobjproc = int function(_object*, _object*);
    alias visitproc = int function(_object*, void*);
    alias traverseproc = int function(_object*, int function(_object*, void*), void*);
    struct PyNumberMethods
    {
        _object* function(_object*, _object*) nb_add;
        _object* function(_object*, _object*) nb_subtract;
        _object* function(_object*, _object*) nb_multiply;
        _object* function(_object*, _object*) nb_divide;
        _object* function(_object*, _object*) nb_remainder;
        _object* function(_object*, _object*) nb_divmod;
        _object* function(_object*, _object*, _object*) nb_power;
        _object* function(_object*) nb_negative;
        _object* function(_object*) nb_positive;
        _object* function(_object*) nb_absolute;
        int function(_object*) nb_nonzero;
        _object* function(_object*) nb_invert;
        _object* function(_object*, _object*) nb_lshift;
        _object* function(_object*, _object*) nb_rshift;
        _object* function(_object*, _object*) nb_and;
        _object* function(_object*, _object*) nb_xor;
        _object* function(_object*, _object*) nb_or;
        int function(_object**, _object**) nb_coerce;
        _object* function(_object*) nb_int;
        _object* function(_object*) nb_long;
        _object* function(_object*) nb_float;
        _object* function(_object*) nb_oct;
        _object* function(_object*) nb_hex;
        _object* function(_object*, _object*) nb_inplace_add;
        _object* function(_object*, _object*) nb_inplace_subtract;
        _object* function(_object*, _object*) nb_inplace_multiply;
        _object* function(_object*, _object*) nb_inplace_divide;
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
    }
    struct PySequenceMethods
    {
        c_long function(_object*) sq_length;
        _object* function(_object*, _object*) sq_concat;
        _object* function(_object*, c_long) sq_repeat;
        _object* function(_object*, c_long) sq_item;
        _object* function(_object*, c_long, c_long) sq_slice;
        int function(_object*, c_long, _object*) sq_ass_item;
        int function(_object*, c_long, c_long, _object*) sq_ass_slice;
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
    struct PyBufferProcs
    {
        c_long function(_object*, c_long, void**) bf_getreadbuffer;
        c_long function(_object*, c_long, void**) bf_getwritebuffer;
        c_long function(_object*, c_long*) bf_getsegcount;
        c_long function(_object*, c_long, char**) bf_getcharbuffer;
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
    alias cmpfunc = int function(_object*, _object*);
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
        char* name;
        int type;
        c_long offset;
        int flags;
        char* doc;
    }
    struct PyGetSetDef
    {
        char* name;
        _object* function(_object*, void*) get;
        int function(_object*, _object*, void*) set;
        char* doc;
        void* closure;
    }
    alias PyHeapTypeObject = _heaptypeobject;
    struct _heaptypeobject
    {
        _typeobject ht_type;
        PyNumberMethods as_number;
        PyMappingMethods as_mapping;
        PySequenceMethods as_sequence;
        PyBufferProcs as_buffer;
        _object* ht_name;
        _object* ht_slots;
    }
    c_ulong fread_unlocked(void*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;
    int PyType_IsSubtype(_typeobject*, _typeobject*) @nogc nothrow;
    extern __gshared _typeobject PyType_Type;
    extern __gshared _typeobject PyBaseObject_Type;
    extern __gshared _typeobject PySuper_Type;
    int fputs_unlocked(const(char)*, _IO_FILE*) @nogc nothrow;
    int PyType_Ready(_typeobject*) @nogc nothrow;
    _object* PyType_GenericAlloc(_typeobject*, c_long) @nogc nothrow;
    _object* PyType_GenericNew(_typeobject*, _object*, _object*) @nogc nothrow;
    _object* _PyType_Lookup(_typeobject*, _object*) @nogc nothrow;
    _object* _PyObject_LookupSpecial(_object*, char*, _object**) @nogc nothrow;
    uint PyType_ClearCache() @nogc nothrow;
    void PyType_Modified(_typeobject*) @nogc nothrow;
    int PyObject_Print(_object*, _IO_FILE*, int) @nogc nothrow;
    void _PyObject_Dump(_object*) @nogc nothrow;
    _object* PyObject_Repr(_object*) @nogc nothrow;
    _object* _PyObject_Str(_object*) @nogc nothrow;
    _object* PyObject_Str(_object*) @nogc nothrow;
    c_ulong fwrite(const(void)*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;
    _object* PyObject_Unicode(_object*) @nogc nothrow;
    int PyObject_Compare(_object*, _object*) @nogc nothrow;
    _object* PyObject_RichCompare(_object*, _object*, int) @nogc nothrow;
    int PyObject_RichCompareBool(_object*, _object*, int) @nogc nothrow;
    _object* PyObject_GetAttrString(_object*, const(char)*) @nogc nothrow;
    int PyObject_SetAttrString(_object*, const(char)*, _object*) @nogc nothrow;
    int PyObject_HasAttrString(_object*, const(char)*) @nogc nothrow;
    _object* PyObject_GetAttr(_object*, _object*) @nogc nothrow;
    int PyObject_SetAttr(_object*, _object*, _object*) @nogc nothrow;
    int PyObject_HasAttr(_object*, _object*) @nogc nothrow;
    _object** _PyObject_GetDictPtr(_object*) @nogc nothrow;
    _object* PyObject_SelfIter(_object*) @nogc nothrow;
    _object* _PyObject_NextNotImplemented(_object*) @nogc nothrow;
    _object* PyObject_GenericGetAttr(_object*, _object*) @nogc nothrow;
    int PyObject_GenericSetAttr(_object*, _object*, _object*) @nogc nothrow;
    c_long PyObject_Hash(_object*) @nogc nothrow;
    c_long PyObject_HashNotImplemented(_object*) @nogc nothrow;
    int PyObject_IsTrue(_object*) @nogc nothrow;
    int PyObject_Not(_object*) @nogc nothrow;
    int PyCallable_Check(_object*) @nogc nothrow;
    int PyNumber_Coerce(_object**, _object**) @nogc nothrow;
    int PyNumber_CoerceEx(_object**, _object**) @nogc nothrow;
    void PyObject_ClearWeakRefs(_object*) @nogc nothrow;
    int _PyObject_SlotCompare(_object*, _object*) @nogc nothrow;
    _object* _PyObject_GenericGetAttrWithDict(_object*, _object*, _object*) @nogc nothrow;
    int _PyObject_GenericSetAttrWithDict(_object*, _object*, _object*, _object*) @nogc nothrow;
    _object* PyObject_Dir(_object*) @nogc nothrow;
    int Py_ReprEnter(_object*) @nogc nothrow;
    void Py_ReprLeave(_object*) @nogc nothrow;
    c_long _Py_HashDouble(double) @nogc nothrow;
    c_long _Py_HashPointer(void*) @nogc nothrow;
    struct _Py_HashSecret_t
    {
        c_long prefix;
        c_long suffix;
    }
    extern __gshared _Py_HashSecret_t _Py_HashSecret;
    c_ulong fread(void*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;
    int ungetc(int, _IO_FILE*) @nogc nothrow;
    int puts(const(char)*) @nogc nothrow;
    int fputs(const(char)*, _IO_FILE*) @nogc nothrow;
    c_long getline(char**, c_ulong*, _IO_FILE*) @nogc nothrow;
    c_long getdelim(char**, c_ulong*, int, _IO_FILE*) @nogc nothrow;
    c_long __getdelim(char**, c_ulong*, int, _IO_FILE*) @nogc nothrow;
    char* fgets_unlocked(char*, int, _IO_FILE*) @nogc nothrow;
    char* fgets(char*, int, _IO_FILE*) @nogc nothrow;
    int putw(int, _IO_FILE*) @nogc nothrow;
    int getw(_IO_FILE*) @nogc nothrow;
    int putchar_unlocked(int) @nogc nothrow;
    int putc_unlocked(int, _IO_FILE*) @nogc nothrow;
    int fputc_unlocked(int, _IO_FILE*) @nogc nothrow;
    int putchar(int) @nogc nothrow;
    int putc(int, _IO_FILE*) @nogc nothrow;
    int fputc(int, _IO_FILE*) @nogc nothrow;
    int fgetc_unlocked(_IO_FILE*) @nogc nothrow;
    int getchar_unlocked() @nogc nothrow;
    int getc_unlocked(_IO_FILE*) @nogc nothrow;
    int getchar() @nogc nothrow;
    int getc(_IO_FILE*) @nogc nothrow;
    int fgetc(_IO_FILE*) @nogc nothrow;
    int vsscanf(const(char)*, const(char)*, va_list*) @nogc nothrow;
    int vscanf(const(char)*, va_list*) @nogc nothrow;
    int vfscanf(_IO_FILE*, const(char)*, va_list*) @nogc nothrow;
    void Py_IncRef(_object*) @nogc nothrow;
    void Py_DecRef(_object*) @nogc nothrow;
    extern __gshared _object _Py_NoneStruct;
    int sscanf(const(char)*, const(char)*, ...) @nogc nothrow;
    extern __gshared _object _Py_NotImplementedStruct;
    int scanf(const(char)*, ...) @nogc nothrow;
    int fscanf(_IO_FILE*, const(char)*, ...) @nogc nothrow;
    int dprintf(int, const(char)*, ...) @nogc nothrow;
    int vdprintf(int, const(char)*, va_list*) @nogc nothrow;
    extern __gshared int[0] _Py_SwappedOp;
    void _PyTrash_deposit_object(_object*) @nogc nothrow;
    void _PyTrash_destroy_chain() @nogc nothrow;
    extern __gshared int _PyTrash_delete_nesting;
    extern __gshared _object* _PyTrash_delete_later;
    void _PyTrash_thread_deposit_object(_object*) @nogc nothrow;
    void _PyTrash_thread_destroy_chain() @nogc nothrow;
    int asprintf(char**, const(char)*, ...) @nogc nothrow;
    int __asprintf(char**, const(char)*, ...) @nogc nothrow;
    void* PyObject_Malloc(c_ulong) @nogc nothrow;
    void* PyObject_Realloc(void*, c_ulong) @nogc nothrow;
    void PyObject_Free(void*) @nogc nothrow;
    int vasprintf(char**, const(char)*, va_list*) @nogc nothrow;
    int vsnprintf(char*, c_ulong, const(char)*, va_list*) @nogc nothrow;
    _object* PyObject_Init(_object*, _typeobject*) @nogc nothrow;
    PyVarObject* PyObject_InitVar(PyVarObject*, _typeobject*, c_long) @nogc nothrow;
    _object* _PyObject_New(_typeobject*) @nogc nothrow;
    PyVarObject* _PyObject_NewVar(_typeobject*, c_long) @nogc nothrow;
    int snprintf(char*, c_ulong, const(char)*, ...) @nogc nothrow;
    int vsprintf(char*, const(char)*, va_list*) @nogc nothrow;
    int vprintf(const(char)*, va_list*) @nogc nothrow;
    int vfprintf(_IO_FILE*, const(char)*, va_list*) @nogc nothrow;
    c_long PyGC_Collect() @nogc nothrow;
    int sprintf(char*, const(char)*, ...) @nogc nothrow;
    PyVarObject* _PyObject_GC_Resize(PyVarObject*, c_long) @nogc nothrow;
    int printf(const(char)*, ...) @nogc nothrow;
    int fprintf(_IO_FILE*, const(char)*, ...) @nogc nothrow;
    union _gc_head
    {
        static struct _Anonymous_24
        {
            _gc_head* gc_next;
            _gc_head* gc_prev;
            c_long gc_refs;
        }
        _Anonymous_24 gc;
        double dummy;
        char[32] dummy_padding;
    }
    union _gc_head_old
    {
        static struct _Anonymous_25
        {
            _gc_head_old* gc_next;
            _gc_head_old* gc_prev;
            c_long gc_refs;
        }
        _Anonymous_25 gc;
        real dummy;
    }
    alias PyGC_Head = _gc_head;
    extern __gshared _gc_head* _PyGC_generation0;
    void setlinebuf(_IO_FILE*) @nogc nothrow;
    void setbuffer(_IO_FILE*, char*, c_ulong) @nogc nothrow;
    int setvbuf(_IO_FILE*, char*, int, c_ulong) @nogc nothrow;
    _object* _PyObject_GC_Malloc(c_ulong) @nogc nothrow;
    _object* _PyObject_GC_New(_typeobject*) @nogc nothrow;
    PyVarObject* _PyObject_GC_NewVar(_typeobject*, c_long) @nogc nothrow;
    void PyObject_GC_Track(void*) @nogc nothrow;
    void PyObject_GC_UnTrack(void*) @nogc nothrow;
    void PyObject_GC_Del(void*) @nogc nothrow;
    void setbuf(_IO_FILE*, char*) @nogc nothrow;
    _IO_FILE* open_memstream(char**, c_ulong*) @nogc nothrow;
    _IO_FILE* fmemopen(void*, c_ulong, const(char)*) @nogc nothrow;
    _IO_FILE* fopencookie(void*, const(char)*, _IO_cookie_io_functions_t) @nogc nothrow;
    _IO_FILE* fdopen(int, const(char)*) @nogc nothrow;
    _IO_FILE* freopen64(const(char)*, const(char)*, _IO_FILE*) @nogc nothrow;
    _IO_FILE* fopen64(const(char)*, const(char)*) @nogc nothrow;
    alias PyArena = _arena;
    struct _arena;
    _arena* PyArena_New() @nogc nothrow;
    void PyArena_Free(_arena*) @nogc nothrow;
    void* PyArena_Malloc(_arena*, c_ulong) @nogc nothrow;
    int PyArena_AddPyObject(_arena*, _object*) @nogc nothrow;
    extern __gshared _typeobject PyCapsule_Type;
    alias PyCapsule_Destructor = void function(_object*);
    _IO_FILE* freopen(const(char)*, const(char)*, _IO_FILE*) @nogc nothrow;
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
    int renameat(int, const(char)*, int, const(char)*) @nogc nothrow;
    int rename(const(char)*, const(char)*) @nogc nothrow;
    int remove(const(char)*) @nogc nothrow;
    extern __gshared _IO_FILE* stderr;
    extern __gshared _IO_FILE* stdout;
    extern __gshared _IO_FILE* stdin;
    alias fpos64_t = _G_fpos64_t;
    alias fpos_t = _G_fpos64_t;
    alias ssize_t = c_long;
    alias off64_t = c_long;
    alias off_t = c_long;
    alias uintmax_t = c_ulong;
    alias intmax_t = c_long;
    alias uintptr_t = c_ulong;
    alias uint_fast64_t = c_ulong;
    alias uint_fast32_t = c_ulong;
    alias uint_fast16_t = c_ulong;
    alias uint_fast8_t = ubyte;
    alias int_fast64_t = c_long;
    alias int_fast32_t = c_long;
    alias int_fast16_t = c_long;
    alias int_fast8_t = byte;
    alias uint_least64_t = c_ulong;
    alias uint_least32_t = uint;
    alias uint_least16_t = ushort;
    alias uint_least8_t = ubyte;
    alias int_least64_t = c_long;
    alias int_least32_t = int;
    alias int_least16_t = short;
    alias int_least8_t = byte;
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
        c_long ob_refcnt;
        _typeobject* ob_type;
        _object* wr_object;
        _object* wr_callback;
        c_long hash;
        _PyWeakReference* wr_prev;
        _PyWeakReference* wr_next;
    }
    alias PyWeakReference = _PyWeakReference;
    int PyErr_WarnExplicit(_object*, const(char)*, const(char)*, int, const(char)*, _object*) @nogc nothrow;
    int PyErr_WarnEx(_object*, const(char)*, c_long) @nogc nothrow;
    void _PyWarnings_Init() @nogc nothrow;
    int _PyUnicodeUCS4_IsAlpha(uint) @nogc nothrow;
    int _PyUnicodeUCS4_IsNumeric(uint) @nogc nothrow;
    int _PyUnicodeUCS4_IsDigit(uint) @nogc nothrow;
    int _PyUnicodeUCS4_IsDecimalDigit(uint) @nogc nothrow;
    double _PyUnicodeUCS4_ToNumeric(uint) @nogc nothrow;
    int _PyUnicodeUCS4_ToDigit(uint) @nogc nothrow;
    int _PyUnicodeUCS4_ToDecimalDigit(uint) @nogc nothrow;
    uint _PyUnicodeUCS4_ToTitlecase(uint) @nogc nothrow;
    uint _PyUnicodeUCS4_ToUppercase(uint) @nogc nothrow;
    uint _PyUnicodeUCS4_ToLowercase(uint) @nogc nothrow;
    int _PyUnicodeUCS4_IsLinebreak(const(uint)) @nogc nothrow;
    int _PyUnicodeUCS4_IsWhitespace(const(uint)) @nogc nothrow;
    int _PyUnicodeUCS4_IsTitlecase(uint) @nogc nothrow;
    int _PyUnicodeUCS4_IsUppercase(uint) @nogc nothrow;
    int _PyUnicodeUCS4_IsLowercase(uint) @nogc nothrow;
    extern __gshared const(ubyte)[0] _Py_ascii_whitespace;
    _object* _PyUnicode_XStrip(PyUnicodeObject*, int, _object*) @nogc nothrow;
    int PyUnicodeUCS4_Contains(_object*, _object*) @nogc nothrow;
    _object* PyUnicodeUCS4_Format(_object*, _object*) @nogc nothrow;
    _object* PyUnicodeUCS4_RichCompare(_object*, _object*, int) @nogc nothrow;
    int PyUnicodeUCS4_Compare(_object*, _object*) @nogc nothrow;
    _object* PyUnicodeUCS4_Replace(_object*, _object*, _object*, c_long) @nogc nothrow;
    c_long PyUnicodeUCS4_Count(_object*, _object*, c_long, c_long) @nogc nothrow;
    c_long PyUnicodeUCS4_Find(_object*, _object*, c_long, c_long, int) @nogc nothrow;
    c_long PyUnicodeUCS4_Tailmatch(_object*, _object*, c_long, c_long, int) @nogc nothrow;
    _object* PyUnicodeUCS4_Join(_object*, _object*) @nogc nothrow;
    _object* PyUnicodeUCS4_Translate(_object*, _object*, const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_RSplit(_object*, _object*, c_long) @nogc nothrow;
    _object* PyUnicodeUCS4_RPartition(_object*, _object*) @nogc nothrow;
    _object* PyUnicodeUCS4_Partition(_object*, _object*) @nogc nothrow;
    _object* PyUnicodeUCS4_Splitlines(_object*, int) @nogc nothrow;
    _object* PyUnicodeUCS4_Split(_object*, _object*, c_long) @nogc nothrow;
    _object* PyUnicodeUCS4_Concat(_object*, _object*) @nogc nothrow;
    int PyUnicodeUCS4_EncodeDecimal(uint*, c_long, char*, const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_TranslateCharmap(const(uint)*, c_long, _object*, const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_EncodeCharmap(const(uint)*, c_long, _object*, const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_AsCharmapString(_object*, _object*) @nogc nothrow;
    _object* PyUnicodeUCS4_DecodeCharmap(const(char)*, c_long, _object*, const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_EncodeASCII(const(uint)*, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_AsASCIIString(_object*) @nogc nothrow;
    _object* PyUnicodeUCS4_DecodeASCII(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_EncodeLatin1(const(uint)*, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_AsLatin1String(_object*) @nogc nothrow;
    _object* PyUnicodeUCS4_DecodeLatin1(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* _PyUnicode_DecodeUnicodeInternal(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_EncodeRawUnicodeEscape(const(uint)*, c_long) @nogc nothrow;
    _object* PyUnicodeUCS4_AsRawUnicodeEscapeString(_object*) @nogc nothrow;
    _object* PyUnicodeUCS4_DecodeRawUnicodeEscape(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_EncodeUnicodeEscape(const(uint)*, c_long) @nogc nothrow;
    _object* PyUnicodeUCS4_AsUnicodeEscapeString(_object*) @nogc nothrow;
    _object* PyUnicodeUCS4_DecodeUnicodeEscape(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_EncodeUTF16(const(uint)*, c_long, const(char)*, int) @nogc nothrow;
    _object* PyUnicodeUCS4_AsUTF16String(_object*) @nogc nothrow;
    _object* PyUnicodeUCS4_DecodeUTF16Stateful(const(char)*, c_long, const(char)*, int*, c_long*) @nogc nothrow;
    _object* PyUnicodeUCS4_DecodeUTF16(const(char)*, c_long, const(char)*, int*) @nogc nothrow;
    extern __gshared const(uint)[256] _Py_ctype_table;
    _object* PyUnicodeUCS4_EncodeUTF32(const(uint)*, c_long, const(char)*, int) @nogc nothrow;
    _object* PyUnicodeUCS4_AsUTF32String(_object*) @nogc nothrow;
    extern __gshared const(ubyte)[256] _Py_ctype_tolower;
    extern __gshared const(ubyte)[256] _Py_ctype_toupper;
    _object* PyUnicodeUCS4_DecodeUTF32Stateful(const(char)*, c_long, const(char)*, int*, c_long*) @nogc nothrow;
    extern __gshared int Py_DebugFlag;
    extern __gshared int Py_VerboseFlag;
    extern __gshared int Py_InteractiveFlag;
    extern __gshared int Py_InspectFlag;
    extern __gshared int Py_OptimizeFlag;
    extern __gshared int Py_NoSiteFlag;
    extern __gshared int Py_BytesWarningFlag;
    extern __gshared int Py_UseClassExceptionsFlag;
    extern __gshared int Py_FrozenFlag;
    extern __gshared int Py_TabcheckFlag;
    extern __gshared int Py_UnicodeFlag;
    extern __gshared int Py_IgnoreEnvironmentFlag;
    extern __gshared int Py_DivisionWarningFlag;
    extern __gshared int Py_DontWriteBytecodeFlag;
    extern __gshared int Py_NoUserSiteDirectory;
    extern __gshared int _Py_QnewFlag;
    extern __gshared int Py_Py3kWarningFlag;
    extern __gshared int Py_HashRandomizationFlag;
    void Py_FatalError(const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_DecodeUTF32(const(char)*, c_long, const(char)*, int*) @nogc nothrow;
    struct PyBaseExceptionObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _object* dict;
        _object* args;
        _object* message;
    }
    struct PySyntaxErrorObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _object* dict;
        _object* args;
        _object* message;
        _object* msg;
        _object* filename;
        _object* lineno;
        _object* offset;
        _object* text;
        _object* print_file_and_line;
    }
    struct PyUnicodeErrorObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _object* dict;
        _object* args;
        _object* message;
        _object* encoding;
        _object* object;
        c_long start;
        c_long end;
        _object* reason;
    }
    struct PySystemExitObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _object* dict;
        _object* args;
        _object* message;
        _object* code;
    }
    struct PyEnvironmentErrorObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _object* dict;
        _object* args;
        _object* message;
        _object* myerrno;
        _object* strerror;
        _object* filename;
    }
    void PyErr_SetNone(_object*) @nogc nothrow;
    void PyErr_SetObject(_object*, _object*) @nogc nothrow;
    void PyErr_SetString(_object*, const(char)*) @nogc nothrow;
    _object* PyErr_Occurred() @nogc nothrow;
    void PyErr_Clear() @nogc nothrow;
    void PyErr_Fetch(_object**, _object**, _object**) @nogc nothrow;
    void PyErr_Restore(_object*, _object*, _object*) @nogc nothrow;
    int PyErr_GivenExceptionMatches(_object*, _object*) @nogc nothrow;
    int PyErr_ExceptionMatches(_object*) @nogc nothrow;
    void PyErr_NormalizeException(_object**, _object**, _object**) @nogc nothrow;
    void _PyErr_ReplaceException(_object*, _object*, _object*) @nogc nothrow;
    _object* PyUnicodeUCS4_EncodeUTF8(const(uint)*, c_long, const(char)*) @nogc nothrow;
    extern __gshared _object* PyExc_BaseException;
    extern __gshared _object* PyExc_Exception;
    extern __gshared _object* PyExc_StopIteration;
    extern __gshared _object* PyExc_GeneratorExit;
    extern __gshared _object* PyExc_StandardError;
    extern __gshared _object* PyExc_ArithmeticError;
    extern __gshared _object* PyExc_LookupError;
    extern __gshared _object* PyExc_AssertionError;
    extern __gshared _object* PyExc_AttributeError;
    extern __gshared _object* PyExc_EOFError;
    extern __gshared _object* PyExc_FloatingPointError;
    extern __gshared _object* PyExc_EnvironmentError;
    extern __gshared _object* PyExc_IOError;
    extern __gshared _object* PyExc_OSError;
    extern __gshared _object* PyExc_ImportError;
    extern __gshared _object* PyExc_IndexError;
    extern __gshared _object* PyExc_KeyError;
    extern __gshared _object* PyExc_KeyboardInterrupt;
    extern __gshared _object* PyExc_MemoryError;
    extern __gshared _object* PyExc_NameError;
    extern __gshared _object* PyExc_OverflowError;
    extern __gshared _object* PyExc_RuntimeError;
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
    extern __gshared _object* PyExc_BufferError;
    extern __gshared _object* PyExc_MemoryErrorInst;
    extern __gshared _object* PyExc_RecursionErrorInst;
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
    int PyErr_BadArgument() @nogc nothrow;
    _object* PyErr_NoMemory() @nogc nothrow;
    _object* PyErr_SetFromErrno(_object*) @nogc nothrow;
    _object* PyErr_SetFromErrnoWithFilenameObject(_object*, _object*) @nogc nothrow;
    _object* PyErr_SetFromErrnoWithFilename(_object*, const(char)*) @nogc nothrow;
    _object* PyErr_Format(_object*, const(char)*, ...) @nogc nothrow;
    pragma(mangle, "PyErr_BadInternalCall") void PyErr_BadInternalCall_() @nogc nothrow;
    void _PyErr_BadInternalCall(const(char)*, int) @nogc nothrow;
    _object* PyUnicodeUCS4_AsUTF8String(_object*) @nogc nothrow;
    _object* PyErr_NewException(char*, _object*, _object*) @nogc nothrow;
    _object* PyErr_NewExceptionWithDoc(char*, char*, _object*, _object*) @nogc nothrow;
    void PyErr_WriteUnraisable(_object*) @nogc nothrow;
    int PyErr_CheckSignals() @nogc nothrow;
    void PyErr_SetInterrupt() @nogc nothrow;
    int PySignal_SetWakeupFd(int) @nogc nothrow;
    void PyErr_SyntaxLocation(const(char)*, int) @nogc nothrow;
    _object* PyErr_ProgramText(const(char)*, int) @nogc nothrow;
    _object* PyUnicodeDecodeError_Create(const(char)*, const(char)*, c_long, c_long, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicodeEncodeError_Create(const(char)*, const(uint)*, c_long, c_long, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicodeTranslateError_Create(const(uint)*, c_long, c_long, c_long, const(char)*) @nogc nothrow;
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
    _object* PyUnicodeUCS4_DecodeUTF8Stateful(const(char)*, c_long, const(char)*, c_long*) @nogc nothrow;
    _object* PyUnicodeUCS4_DecodeUTF8(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicode_EncodeUTF7(const(uint)*, c_long, int, int, const(char)*) @nogc nothrow;
    _object* PyUnicode_DecodeUTF7Stateful(const(char)*, c_long, const(char)*, c_long*) @nogc nothrow;
    ushort _Py_get_387controlword() @nogc nothrow;
    void _Py_set_387controlword(ushort) @nogc nothrow;
    _object* PyUnicode_DecodeUTF7(const(char)*, c_long, const(char)*) @nogc nothrow;
    _object* PyUnicode_BuildEncodingMap(_object*) @nogc nothrow;
    _object* PyUnicodeUCS4_AsEncodedString(_object*, const(char)*, const(char)*) @nogc nothrow;
    void* PyMem_Malloc(c_ulong) @nogc nothrow;
    void* PyMem_Realloc(void*, c_ulong) @nogc nothrow;
    void PyMem_Free(void*) @nogc nothrow;
    _object* PyUnicodeUCS4_AsEncodedObject(_object*, const(char)*, const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_Encode(const(uint)*, c_long, const(char)*, const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_Decode(const(char)*, c_long, const(char)*, const(char)*) @nogc nothrow;
    int PyUnicodeUCS4_SetDefaultEncoding(const(char)*) @nogc nothrow;
    const(char)* PyUnicodeUCS4_GetDefaultEncoding() @nogc nothrow;
    _object* _PyUnicodeUCS4_AsDefaultEncodedString(_object*, const(char)*) @nogc nothrow;
    int PyUnicodeUCS4_ClearFreelist() @nogc nothrow;
    alias Py_uintptr_t = c_ulong;
    alias Py_intptr_t = c_long;
    alias Py_ssize_t = c_long;
    _object* PyUnicodeUCS4_FromOrdinal(int) @nogc nothrow;
    c_long PyUnicodeUCS4_AsWideChar(PyUnicodeObject*, int*, c_long) @nogc nothrow;
    _object* PyUnicodeUCS4_FromWideChar(const(int)*, c_long) @nogc nothrow;
    _object* _PyUnicode_FormatAdvanced(_object*, uint*, c_long) @nogc nothrow;
    _object* PyUnicodeUCS4_FromFormat(const(char)*, ...) @nogc nothrow;
    _object* PyUnicodeUCS4_FromFormatV(const(char)*, va_list*) @nogc nothrow;
    _object* PyUnicodeUCS4_FromObject(_object*) @nogc nothrow;
    _object* PyUnicodeUCS4_FromEncodedObject(_object*, const(char)*, const(char)*) @nogc nothrow;
    int PyUnicodeUCS4_Resize(_object**, c_long) @nogc nothrow;
    uint PyUnicodeUCS4_GetMax() @nogc nothrow;
    struct _ts
    {
        _ts* next;
        _is* interp;
        _frame* frame;
        int recursion_depth;
        int tracing;
        int use_tracing;
        int function(_object*, _frame*, int, _object*) c_profilefunc;
        int function(_object*, _frame*, int, _object*) c_tracefunc;
        _object* c_profileobj;
        _object* c_traceobj;
        _object* curexc_type;
        _object* curexc_value;
        _object* curexc_traceback;
        _object* exc_type;
        _object* exc_value;
        _object* exc_traceback;
        _object* dict;
        int tick_counter;
        int gilstate_counter;
        _object* async_exc;
        c_long thread_id;
        int trash_delete_nesting;
        _object* trash_delete_later;
    }
    struct _is
    {
        _is* next;
        _ts* tstate_head;
        _object* modules;
        _object* sysdict;
        _object* builtins;
        _object* modules_reloading;
        _object* codec_search_path;
        _object* codec_search_cache;
        _object* codec_error_registry;
        int dlopenflags;
    }
    alias PyInterpreterState = _is;
    alias Py_tracefunc = int function(_object*, _frame*, int, _object*);
    c_long PyUnicodeUCS4_GetSize(_object*) @nogc nothrow;
    uint* PyUnicodeUCS4_AsUnicode(_object*) @nogc nothrow;
    _object* PyUnicodeUCS4_FromString(const(char)*) @nogc nothrow;
    alias PyThreadState = _ts;
    _is* PyInterpreterState_New() @nogc nothrow;
    void PyInterpreterState_Clear(_is*) @nogc nothrow;
    void PyInterpreterState_Delete(_is*) @nogc nothrow;
    _ts* PyThreadState_New(_is*) @nogc nothrow;
    _ts* _PyThreadState_Prealloc(_is*) @nogc nothrow;
    void _PyThreadState_Init(_ts*) @nogc nothrow;
    void PyThreadState_Clear(_ts*) @nogc nothrow;
    void PyThreadState_Delete(_ts*) @nogc nothrow;
    void PyThreadState_DeleteCurrent() @nogc nothrow;
    _ts* PyThreadState_Get() @nogc nothrow;
    _ts* PyThreadState_Swap(_ts*) @nogc nothrow;
    _object* PyThreadState_GetDict() @nogc nothrow;
    int PyThreadState_SetAsyncExc(c_long, _object*) @nogc nothrow;
    extern __gshared _ts* _PyThreadState_Current;
    alias PyGILState_STATE = _Anonymous_26;
    enum _Anonymous_26
    {
        PyGILState_LOCKED = 0,
        PyGILState_UNLOCKED = 1,
    }
    enum PyGILState_LOCKED = _Anonymous_26.PyGILState_LOCKED;
    enum PyGILState_UNLOCKED = _Anonymous_26.PyGILState_UNLOCKED;
    PyGILState_STATE PyGILState_Ensure() @nogc nothrow;
    void PyGILState_Release(PyGILState_STATE) @nogc nothrow;
    _ts* PyGILState_GetThisThreadState() @nogc nothrow;
    _object* _PyThread_CurrentFrames() @nogc nothrow;
    _is* PyInterpreterState_Head() @nogc nothrow;
    _is* PyInterpreterState_Next(_is*) @nogc nothrow;
    _ts* PyInterpreterState_ThreadHead(_is*) @nogc nothrow;
    _ts* PyThreadState_Next(_ts*) @nogc nothrow;
    alias PyThreadFrameGetter = _frame* function(_ts*);
    extern __gshared _frame* function(_ts*) _PyThreadState_GetFrame;
    int PyOS_mystrnicmp(const(char)*, const(char)*, c_long) @nogc nothrow;
    int PyOS_mystricmp(const(char)*, const(char)*) @nogc nothrow;
    _object* PyUnicodeUCS4_FromStringAndSize(const(char)*, c_long) @nogc nothrow;
    double PyOS_ascii_strtod(const(char)*, char**) @nogc nothrow;
    double PyOS_ascii_atof(const(char)*) @nogc nothrow;
    char* PyOS_ascii_formatd(char*, c_ulong, const(char)*, double) @nogc nothrow;
    double PyOS_string_to_double(const(char)*, char**, _object*) @nogc nothrow;
    char* PyOS_double_to_string(double, char, int, int, int*) @nogc nothrow;
    double _Py_parse_inf_or_nan(const(char)*, char**) @nogc nothrow;
    _object* PyUnicodeUCS4_FromUnicode(const(uint)*, c_long) @nogc nothrow;
    extern __gshared _typeobject PyUnicode_Type;
    struct PyUnicodeObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long length;
        uint* str;
        c_long hash;
        _object* defenc;
    }
    alias Py_UNICODE = uint;
    alias Py_UCS4 = uint;
    struct PyCompilerFlags
    {
        int cf_flags;
    }
    void Py_SetProgramName(char*) @nogc nothrow;
    char* Py_GetProgramName() @nogc nothrow;
    void Py_SetPythonHome(char*) @nogc nothrow;
    char* Py_GetPythonHome() @nogc nothrow;
    void Py_Initialize() @nogc nothrow;
    void Py_InitializeEx(int) @nogc nothrow;
    void Py_Finalize() @nogc nothrow;
    int Py_IsInitialized() @nogc nothrow;
    _ts* Py_NewInterpreter() @nogc nothrow;
    void Py_EndInterpreter(_ts*) @nogc nothrow;
    pragma(mangle, "PyRun_AnyFileFlags") int PyRun_AnyFileFlags_(_IO_FILE*, const(char)*, PyCompilerFlags*) @nogc nothrow;
    int PyRun_AnyFileExFlags(_IO_FILE*, const(char)*, int, PyCompilerFlags*) @nogc nothrow;
    int PyRun_SimpleStringFlags(const(char)*, PyCompilerFlags*) @nogc nothrow;
    int PyRun_SimpleFileExFlags(_IO_FILE*, const(char)*, int, PyCompilerFlags*) @nogc nothrow;
    int PyRun_InteractiveOneFlags(_IO_FILE*, const(char)*, PyCompilerFlags*) @nogc nothrow;
    int PyRun_InteractiveLoopFlags(_IO_FILE*, const(char)*, PyCompilerFlags*) @nogc nothrow;
    _mod* PyParser_ASTFromString(const(char)*, const(char)*, int, PyCompilerFlags*, _arena*) @nogc nothrow;
    struct _mod;
    _mod* PyParser_ASTFromFile(_IO_FILE*, const(char)*, int, char*, char*, PyCompilerFlags*, int*, _arena*) @nogc nothrow;
    _node* PyParser_SimpleParseStringFlags(const(char)*, int, int) @nogc nothrow;
    struct _node;
    _node* PyParser_SimpleParseFileFlags(_IO_FILE*, const(char)*, int, int) @nogc nothrow;
    _object* PyRun_StringFlags(const(char)*, int, _object*, _object*, PyCompilerFlags*) @nogc nothrow;
    _object* PyRun_FileExFlags(_IO_FILE*, const(char)*, int, _object*, _object*, int, PyCompilerFlags*) @nogc nothrow;
    _object* Py_CompileStringFlags(const(char)*, const(char)*, int, PyCompilerFlags*) @nogc nothrow;
    struct symtable;
    symtable* Py_SymtableString(const(char)*, const(char)*, int) @nogc nothrow;
    void PyErr_Print() @nogc nothrow;
    void PyErr_PrintEx(int) @nogc nothrow;
    void PyErr_Display(_object*, _object*, _object*) @nogc nothrow;
    int Py_AtExit(void function()) @nogc nothrow;
    void Py_Exit(int) @nogc nothrow;
    int Py_FdIsInteractive(_IO_FILE*, const(char)*) @nogc nothrow;
    int Py_Main(int, char**) @nogc nothrow;
    int PyTuple_ClearFreeList() @nogc nothrow;
    void _PyTuple_MaybeUntrack(_object*) @nogc nothrow;
    _object* PyTuple_Pack(c_long, ...) @nogc nothrow;
    char* Py_GetProgramFullPath() @nogc nothrow;
    char* Py_GetPrefix() @nogc nothrow;
    char* Py_GetExecPrefix() @nogc nothrow;
    char* Py_GetPath() @nogc nothrow;
    const(char)* Py_GetVersion() @nogc nothrow;
    const(char)* Py_GetPlatform() @nogc nothrow;
    const(char)* Py_GetCopyright() @nogc nothrow;
    const(char)* Py_GetCompiler() @nogc nothrow;
    const(char)* Py_GetBuildInfo() @nogc nothrow;
    const(char)* Py_SubversionRevision() @nogc nothrow;
    const(char)* Py_SubversionShortBranch() @nogc nothrow;
    const(char)* _Py_gitidentifier() @nogc nothrow;
    const(char)* _Py_gitversion() @nogc nothrow;
    _object* _PyBuiltin_Init() @nogc nothrow;
    _object* _PySys_Init() @nogc nothrow;
    void _PyImport_Init() @nogc nothrow;
    void _PyExc_Init() @nogc nothrow;
    void _PyImportHooks_Init() @nogc nothrow;
    int _PyFrame_Init() @nogc nothrow;
    int _PyInt_Init() @nogc nothrow;
    int _PyLong_Init() @nogc nothrow;
    void _PyFloat_Init() @nogc nothrow;
    int PyByteArray_Init() @nogc nothrow;
    void _PyRandom_Init() @nogc nothrow;
    void _PyExc_Fini() @nogc nothrow;
    void _PyImport_Fini() @nogc nothrow;
    void PyMethod_Fini() @nogc nothrow;
    void PyFrame_Fini() @nogc nothrow;
    void PyCFunction_Fini() @nogc nothrow;
    void PyDict_Fini() @nogc nothrow;
    void PyTuple_Fini() @nogc nothrow;
    void PyList_Fini() @nogc nothrow;
    void PySet_Fini() @nogc nothrow;
    void PyString_Fini() @nogc nothrow;
    void PyInt_Fini() @nogc nothrow;
    void PyFloat_Fini() @nogc nothrow;
    void PyOS_FiniInterrupts() @nogc nothrow;
    void PyByteArray_Fini() @nogc nothrow;
    void _PyRandom_Fini() @nogc nothrow;
    char* PyOS_Readline(_IO_FILE*, _IO_FILE*, char*) @nogc nothrow;
    extern __gshared int function() PyOS_InputHook;
    extern __gshared char* function(_IO_FILE*, _IO_FILE*, char*) PyOS_ReadlineFunctionPointer;
    extern __gshared _ts* _PyOS_ReadlineTState;
    int _PyTuple_Resize(_object**, c_long) @nogc nothrow;
    alias PyOS_sighandler_t = void function(int);
    void function(int) PyOS_getsig(int) @nogc nothrow;
    void function(int) PyOS_setsig(int, void function(int)) @nogc nothrow;
    int _PyOS_URandom(void*, c_long) @nogc nothrow;
    extern __gshared _typeobject PyRange_Type;
    _object* PyTuple_GetSlice(_object*, c_long, c_long) @nogc nothrow;
    int PyTuple_SetItem(_object*, c_long, _object*) @nogc nothrow;
    struct setentry
    {
        c_long hash;
        _object* key;
    }
    alias PySetObject = _setobject;
    struct _setobject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long fill;
        c_long used;
        c_long mask;
        setentry* table;
        setentry* function(_setobject*, _object*, c_long) lookup;
        setentry[8] smalltable;
        c_long hash;
        _object* weakreflist;
    }
    extern __gshared _typeobject PySet_Type;
    extern __gshared _typeobject PyFrozenSet_Type;
    _object* PyTuple_GetItem(_object*, c_long) @nogc nothrow;
    c_long PyTuple_Size(_object*) @nogc nothrow;
    _object* PySet_New(_object*) @nogc nothrow;
    _object* PyFrozenSet_New(_object*) @nogc nothrow;
    c_long PySet_Size(_object*) @nogc nothrow;
    _object* PyTuple_New(c_long) @nogc nothrow;
    int PySet_Clear(_object*) @nogc nothrow;
    int PySet_Contains(_object*, _object*) @nogc nothrow;
    int PySet_Discard(_object*, _object*) @nogc nothrow;
    int PySet_Add(_object*, _object*) @nogc nothrow;
    int _PySet_Next(_object*, c_long*, _object**) @nogc nothrow;
    int _PySet_NextEntry(_object*, c_long*, _object**, c_long*) @nogc nothrow;
    _object* PySet_Pop(_object*) @nogc nothrow;
    int _PySet_Update(_object*, _object*) @nogc nothrow;
    extern __gshared _object _Py_EllipsisObject;
    extern __gshared _typeobject PyTuple_Type;
    struct PySliceObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _object* start;
        _object* stop;
        _object* step;
    }
    extern __gshared _typeobject PySlice_Type;
    extern __gshared _typeobject PyEllipsis_Type;
    _object* PySlice_New(_object*, _object*, _object*) @nogc nothrow;
    _object* _PySlice_FromIndices(c_long, c_long) @nogc nothrow;
    int PySlice_GetIndices(PySliceObject*, c_long, c_long*, c_long*, c_long*) @nogc nothrow;
    int PySlice_GetIndicesEx(PySliceObject*, c_long, c_long*, c_long*, c_long*, c_long*) @nogc nothrow;
    int _PySlice_Unpack(_object*, c_long*, c_long*, c_long*) @nogc nothrow;
    c_long _PySlice_AdjustIndices(c_long, c_long*, c_long*, c_long) @nogc nothrow;
    struct PyStringObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long ob_size;
        c_long ob_shash;
        int ob_sstate;
        char[1] ob_sval;
    }
    struct PyTupleObject
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        c_long ob_size;
        _object*[1] ob_item;
    }
    extern __gshared _typeobject PyBaseString_Type;
    extern __gshared _typeobject PyString_Type;
    extern __gshared _typeobject PyTraceBack_Type;
    int _Py_DisplaySourceLine(_object*, const(char)*, int, int) @nogc nothrow;
    _object* PyString_FromStringAndSize(const(char)*, c_long) @nogc nothrow;
    _object* PyString_FromString(const(char)*) @nogc nothrow;
    _object* PyString_FromFormatV(const(char)*, va_list*) @nogc nothrow;
    _object* PyString_FromFormat(const(char)*, ...) @nogc nothrow;
    c_long PyString_Size(_object*) @nogc nothrow;
    char* PyString_AsString(_object*) @nogc nothrow;
    _object* PyString_Repr(_object*, int) @nogc nothrow;
    void PyString_Concat(_object**, _object*) @nogc nothrow;
    void PyString_ConcatAndDel(_object**, _object*) @nogc nothrow;
    int _PyString_Resize(_object**, c_long) @nogc nothrow;
    int _PyString_Eq(_object*, _object*) @nogc nothrow;
    _object* PyString_Format(_object*, _object*) @nogc nothrow;
    _object* _PyString_FormatLong(_object*, int, int, int, char**, int*) @nogc nothrow;
    _object* PyString_DecodeEscape(const(char)*, c_long, const(char)*, c_long, const(char)*) @nogc nothrow;
    void PyString_InternInPlace(_object**) @nogc nothrow;
    void PyString_InternImmortal(_object**) @nogc nothrow;
    _object* PyString_InternFromString(const(char)*) @nogc nothrow;
    void _Py_ReleaseInternedStrings() @nogc nothrow;
    int PyTraceBack_Print(_object*, _object*) @nogc nothrow;
    _object* _PyString_Join(_object*, _object*) @nogc nothrow;
    _object* PyString_Decode(const(char)*, c_long, const(char)*, const(char)*) @nogc nothrow;
    _object* PyString_Encode(const(char)*, c_long, const(char)*, const(char)*) @nogc nothrow;
    _object* PyString_AsEncodedObject(_object*, const(char)*, const(char)*) @nogc nothrow;
    _object* PyString_AsEncodedString(_object*, const(char)*, const(char)*) @nogc nothrow;
    _object* PyString_AsDecodedObject(_object*, const(char)*, const(char)*) @nogc nothrow;
    _object* PyString_AsDecodedString(_object*, const(char)*, const(char)*) @nogc nothrow;
    int PyString_AsStringAndSize(_object*, char**, c_long*) @nogc nothrow;
    c_long _PyString_InsertThousandsGroupingLocale(char*, c_long, char*, c_long, c_long) @nogc nothrow;
    c_long _PyString_InsertThousandsGrouping(char*, c_long, char*, c_long, c_long, const(char)*, const(char)*) @nogc nothrow;
    _object* _PyBytes_FormatAdvanced(_object*, char*, c_long) @nogc nothrow;
    int PyTraceBack_Here(_frame*) @nogc nothrow;
    struct memberlist
    {
        char* name;
        int type;
        int offset;
        int flags;
    }
    struct _traceback
    {
        c_long ob_refcnt;
        _typeobject* ob_type;
        _traceback* tb_next;
        _frame* tb_frame;
        int tb_lasti;
        int tb_lineno;
    }
    alias PyTracebackObject = _traceback;
    struct _frame;
    c_ulong _PySys_GetSizeOf(_object*) @nogc nothrow;
    int PySys_HasWarnOptions() @nogc nothrow;
    void PySys_AddWarnOption(char*) @nogc nothrow;
    void PySys_ResetWarnOptions() @nogc nothrow;
    void PySys_WriteStderr(const(char)*, ...) @nogc nothrow;
    void PySys_WriteStdout(const(char)*, ...) @nogc nothrow;
    void PySys_SetPath(char*) @nogc nothrow;
    void PySys_SetArgvEx(int, char**, int) @nogc nothrow;
    void PySys_SetArgv(int, char**) @nogc nothrow;
    _object* PyMember_Get(const(char)*, memberlist*, const(char)*) @nogc nothrow;
    int PyMember_Set(char*, memberlist*, const(char)*, _object*) @nogc nothrow;
    _object* PyMember_GetOne(const(char)*, PyMemberDef*) @nogc nothrow;
    int PyMember_SetOne(char*, PyMemberDef*, _object*) @nogc nothrow;
    _object* PySys_GetObject(char*) @nogc nothrow;
    int PySys_SetObject(char*, _object*) @nogc nothrow;
    _IO_FILE* PySys_GetFile(char*, _IO_FILE*) @nogc nothrow;






    enum DPP_ENUM_PY_WRITE_RESTRICTED = 4;


    enum DPP_ENUM_READ_RESTRICTED = 2;




    enum DPP_ENUM_READONLY = 1;


    enum DPP_ENUM_T_PYSSIZET = 19;


    enum DPP_ENUM_T_ULONGLONG = 18;


    enum DPP_ENUM_T_LONGLONG = 17;


    enum DPP_ENUM_T_OBJECT_EX = 16;


    enum DPP_ENUM_T_BOOL = 14;


    enum DPP_ENUM_T_STRING_INPLACE = 13;


    enum DPP_ENUM_T_ULONG = 12;


    enum DPP_ENUM_T_UINT = 11;


    enum DPP_ENUM_T_USHORT = 10;


    enum DPP_ENUM_T_UBYTE = 9;


    enum DPP_ENUM_T_BYTE = 8;


    enum DPP_ENUM_T_CHAR = 7;


    enum DPP_ENUM_T_OBJECT = 6;


    enum DPP_ENUM_T_STRING = 5;




    enum DPP_ENUM_T_DOUBLE = 4;


    enum DPP_ENUM_T_FLOAT = 3;


    enum DPP_ENUM_T_LONG = 2;


    enum DPP_ENUM_T_INT = 1;


    enum DPP_ENUM_T_SHORT = 0;
    enum DPP_ENUM_SSTATE_INTERNED_IMMORTAL = 2;






    enum DPP_ENUM_SSTATE_INTERNED_MORTAL = 1;


    enum DPP_ENUM_SSTATE_NOT_INTERNED = 0;
    enum DPP_ENUM_PySet_MINSIZE = 8;
    enum DPP_ENUM_PYOS_STACK_MARGIN = 2048;
    enum DPP_ENUM_Py_DTST_NAN = 2;


    enum DPP_ENUM_Py_DTST_INFINITE = 1;


    enum DPP_ENUM_Py_DTST_FINITE = 0;
    enum DPP_ENUM_PyTrace_C_RETURN = 6;


    enum DPP_ENUM_PyTrace_C_EXCEPTION = 5;


    enum DPP_ENUM_PyTrace_C_CALL = 4;


    enum DPP_ENUM_PyTrace_RETURN = 3;


    enum DPP_ENUM_PyTrace_LINE = 2;


    enum DPP_ENUM_PyTrace_EXCEPTION = 1;


    enum DPP_ENUM_PyTrace_CALL = 0;
    enum DPP_ENUM_HAVE_PY_SET_53BIT_PRECISION = 1;
    enum DPP_ENUM_PYLONG_BITS_IN_DIGIT = 30;
    enum DPP_ENUM_Py_MATH_E = 2.7182818284590452354;




    enum DPP_ENUM_Py_MATH_PI = 3.14159265358979323846;
    enum DPP_ENUM___EXTENSIONS__ = 1;


    enum DPP_ENUM___BSD_VISIBLE = 1;


    enum DPP_ENUM__XOPEN_SOURCE_EXTENDED = 1;


    enum DPP_ENUM__XOPEN_SOURCE = 600;




    enum DPP_ENUM__NETBSD_SOURCE = 1;


    enum DPP_ENUM__LARGEFILE_SOURCE = 1;


    enum DPP_ENUM__GNU_SOURCE = 1;


    enum DPP_ENUM__FILE_OFFSET_BITS = 64;


    enum DPP_ENUM__DARWIN_C_SOURCE = 1;


    enum DPP_ENUM__BSD_TYPES = 1;


    enum DPP_ENUM_WITH_THREAD = 1;


    enum DPP_ENUM_WITH_PYMALLOC = 1;


    enum DPP_ENUM_WITH_DOC_STRINGS = 1;


    enum DPP_ENUM_WINDOW_HAS_FLAGS = 1;


    enum DPP_ENUM_VA_LIST_IS_ARRAY = 1;


    enum DPP_ENUM__TANDEM_SOURCE = 1;


    enum DPP_ENUM__POSIX_PTHREAD_SEMANTICS = 1;


    enum DPP_ENUM__ALL_SOURCE = 1;


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


    enum DPP_ENUM_SIZEOF_PID_T = 4;


    enum DPP_ENUM_SIZEOF_OFF_T = 8;


    enum DPP_ENUM_SIZEOF_LONG_LONG = 8;


    enum DPP_ENUM_SIZEOF_LONG_DOUBLE = 16;


    enum DPP_ENUM_SIZEOF_LONG = 8;


    enum DPP_ENUM_SIZEOF_INT = 4;


    enum DPP_ENUM_SIZEOF_FPOS_T = 16;


    enum DPP_ENUM_SIZEOF_FLOAT = 4;


    enum DPP_ENUM_SIZEOF_DOUBLE = 8;






    enum DPP_ENUM_Py_USING_UNICODE = 1;


    enum DPP_ENUM_Py_UNICODE_SIZE = 4;


    enum DPP_ENUM_Py_ENABLE_SHARED = 1;






    enum DPP_ENUM_PTHREAD_SYSTEM_SCHED_SUPPORTED = 1;


    enum DPP_ENUM_MVWDELCH_IS_EXPRESSION = 1;


    enum DPP_ENUM_HAVE_ZLIB_COPY = 1;


    enum DPP_ENUM_HAVE_WORKING_TZSET = 1;


    enum DPP_ENUM_HAVE_WCSCOLL = 1;


    enum DPP_ENUM_HAVE_WCHAR_H = 1;


    enum DPP_ENUM_HAVE_WAITPID = 1;


    enum DPP_ENUM_HAVE_WAIT4 = 1;


    enum DPP_ENUM_HAVE_WAIT3 = 1;


    enum DPP_ENUM_HAVE_UTIME_H = 1;


    enum DPP_ENUM_HAVE_UTIMES = 1;


    enum DPP_ENUM_HAVE_UNSETENV = 1;


    enum DPP_ENUM_HAVE_UNISTD_H = 1;


    enum DPP_ENUM_HAVE_UNAME = 1;


    enum DPP_ENUM_HAVE_UINTPTR_T = 1;


    enum DPP_ENUM_HAVE_UINT64_T = 1;


    enum DPP_ENUM_HAVE_UINT32_T = 1;


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


    enum DPP_ENUM_HAVE_SYS_WAIT_H = 1;


    enum DPP_ENUM_HAVE_SYS_UTSNAME_H = 1;


    enum DPP_ENUM_HAVE_SYS_UN_H = 1;


    enum DPP_ENUM_HAVE_SYS_TYPES_H = 1;


    enum DPP_ENUM_HAVE_SYS_TIME_H = 1;


    enum DPP_ENUM_HAVE_SYS_TIMES_H = 1;


    enum DPP_ENUM_HAVE_SYS_SYSMACROS_H = 1;


    enum DPP_ENUM_HAVE_SYS_STAT_H = 1;


    enum DPP_ENUM_HAVE_SYS_STATVFS_H = 1;


    enum DPP_ENUM_HAVE_SYS_SOCKET_H = 1;


    enum DPP_ENUM_HAVE_SYS_SELECT_H = 1;


    enum DPP_ENUM_HAVE_SYS_RESOURCE_H = 1;


    enum DPP_ENUM_HAVE_SYS_RANDOM_H = 1;


    enum DPP_ENUM_HAVE_SYS_POLL_H = 1;


    enum DPP_ENUM_HAVE_SYS_PARAM_H = 1;


    enum DPP_ENUM_HAVE_SYS_FILE_H = 1;


    enum DPP_ENUM_HAVE_SYS_EPOLL_H = 1;


    enum DPP_ENUM_HAVE_SYSEXITS_H = 1;


    enum DPP_ENUM_HAVE_SYSCONF = 1;


    enum DPP_ENUM_HAVE_SYMLINK = 1;


    enum DPP_ENUM_HAVE_STRUCT_TM_TM_ZONE = 1;


    enum DPP_ENUM_HAVE_STRUCT_STAT_ST_RDEV = 1;


    enum DPP_ENUM_HAVE_STRUCT_STAT_ST_BLOCKS = 1;


    enum DPP_ENUM_HAVE_STRUCT_STAT_ST_BLKSIZE = 1;


    enum DPP_ENUM_HAVE_STROPTS_H = 1;


    enum DPP_ENUM_HAVE_STRING_H = 1;


    enum DPP_ENUM_HAVE_STRINGS_H = 1;


    enum DPP_ENUM_HAVE_STRFTIME = 1;


    enum DPP_ENUM_HAVE_STRDUP = 1;


    enum DPP_ENUM_HAVE_STDLIB_H = 1;


    enum DPP_ENUM_HAVE_STDINT_H = 1;


    enum DPP_ENUM_HAVE_STDARG_PROTOTYPES = 1;


    enum DPP_ENUM_HAVE_STAT_TV_NSEC = 1;


    enum DPP_ENUM_HAVE_STATVFS = 1;


    enum DPP_ENUM_HAVE_SSIZE_T = 1;


    enum DPP_ENUM_HAVE_SPAWN_H = 1;


    enum DPP_ENUM_HAVE_SOCKETPAIR = 1;


    enum DPP_ENUM_HAVE_SOCKADDR_STORAGE = 1;


    enum DPP_ENUM_HAVE_SNPRINTF = 1;


    enum DPP_ENUM_HAVE_SIGRELSE = 1;


    enum DPP_ENUM_HAVE_SIGNAL_H = 1;


    enum DPP_ENUM_HAVE_SIGINTERRUPT = 1;


    enum DPP_ENUM_HAVE_SIGACTION = 1;


    enum DPP_ENUM_HAVE_SHADOW_H = 1;


    enum DPP_ENUM_HAVE_SETVBUF = 1;


    enum DPP_ENUM_HAVE_SETUID = 1;


    enum DPP_ENUM_HAVE_SETSID = 1;


    enum DPP_ENUM_HAVE_SETREUID = 1;


    enum DPP_ENUM_HAVE_SETRESUID = 1;


    enum DPP_ENUM_HAVE_SETRESGID = 1;


    enum DPP_ENUM_HAVE_SETREGID = 1;


    enum DPP_ENUM_HAVE_SETPGRP = 1;


    enum DPP_ENUM_HAVE_SETPGID = 1;


    enum DPP_ENUM_HAVE_SETLOCALE = 1;


    enum DPP_ENUM_HAVE_SETITIMER = 1;


    enum DPP_ENUM_HAVE_SETGROUPS = 1;


    enum DPP_ENUM_HAVE_SETGID = 1;


    enum DPP_ENUM_HAVE_SETEUID = 1;


    enum DPP_ENUM_HAVE_SETEGID = 1;


    enum DPP_ENUM_HAVE_SEM_UNLINK = 1;


    enum DPP_ENUM_HAVE_SEM_TIMEDWAIT = 1;


    enum DPP_ENUM_HAVE_SEM_OPEN = 1;


    enum DPP_ENUM_HAVE_SEM_GETVALUE = 1;


    enum DPP_ENUM_HAVE_SELECT = 1;


    enum DPP_ENUM_HAVE_ROUND = 1;


    enum DPP_ENUM_HAVE_RL_RESIZE_TERMINAL = 1;


    enum DPP_ENUM_HAVE_RL_PRE_INPUT_HOOK = 1;


    enum DPP_ENUM_HAVE_RL_COMPLETION_SUPPRESS_APPEND = 1;


    enum DPP_ENUM_HAVE_RL_COMPLETION_MATCHES = 1;


    enum DPP_ENUM_HAVE_RL_COMPLETION_DISPLAY_MATCHES_HOOK = 1;


    enum DPP_ENUM_HAVE_RL_COMPLETION_APPEND_CHARACTER = 1;


    enum DPP_ENUM_HAVE_RL_CATCH_SIGNAL = 1;


    enum DPP_ENUM_HAVE_RL_CALLBACK = 1;




    enum DPP_ENUM_HAVE_REALPATH = 1;


    enum DPP_ENUM_HAVE_READLINK = 1;


    enum DPP_ENUM_HAVE_PUTENV = 1;


    enum DPP_ENUM_HAVE_PTY_H = 1;


    enum DPP_ENUM_HAVE_PTHREAD_SIGMASK = 1;


    enum DPP_ENUM_HAVE_PTHREAD_H = 1;
    enum DPP_ENUM_HAVE_PTHREAD_ATFORK = 1;


    enum DPP_ENUM_HAVE_PROTOTYPES = 1;


    enum DPP_ENUM_HAVE_POLL_H = 1;


    enum DPP_ENUM_HAVE_POLL = 1;


    enum DPP_ENUM_HAVE_PAUSE = 1;


    enum DPP_ENUM_HAVE_PATHCONF = 1;


    enum DPP_ENUM_HAVE_OPENPTY = 1;


    enum DPP_ENUM_HAVE_NICE = 1;


    enum DPP_ENUM_HAVE_NETPACKET_PACKET_H = 1;
    enum DPP_ENUM_HAVE_NCURSES_H = 1;


    enum DPP_ENUM_HAVE_MREMAP = 1;


    enum DPP_ENUM_HAVE_MMAP = 1;


    enum DPP_ENUM_HAVE_MKTIME = 1;


    enum DPP_ENUM_HAVE_MKNOD = 1;


    enum DPP_ENUM_HAVE_MKFIFO = 1;


    enum DPP_ENUM_HAVE_MEMORY_H = 1;


    enum DPP_ENUM_HAVE_MEMMOVE = 1;


    enum DPP_ENUM_HAVE_MAKEDEV = 1;


    enum DPP_ENUM_HAVE_LSTAT = 1;







    enum DPP_ENUM__STDC_PREDEF_H = 1;


    enum DPP_ENUM__STDINT_H = 1;




    enum DPP_ENUM_HAVE_LONG_LONG = 1;


    enum DPP_ENUM_HAVE_LONG_DOUBLE = 1;


    enum DPP_ENUM_HAVE_LOG1P = 1;


    enum DPP_ENUM_HAVE_LINUX_TIPC_H = 1;


    enum DPP_ENUM_HAVE_LINUX_NETLINK_H = 1;


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


    enum DPP_ENUM_HAVE_INT64_T = 1;


    enum DPP_ENUM_HAVE_INT32_T = 1;


    enum DPP_ENUM_HAVE_INITGROUPS = 1;


    enum DPP_ENUM_HAVE_INET_PTON = 1;


    enum DPP_ENUM_HAVE_INET_ATON = 1;


    enum DPP_ENUM_HAVE_HYPOT = 1;


    enum DPP_ENUM_HAVE_HSTRERROR = 1;


    enum DPP_ENUM_HAVE_GRP_H = 1;


    enum DPP_ENUM_HAVE_GETWD = 1;


    enum DPP_ENUM_HAVE_GETTIMEOFDAY = 1;


    enum DPP_ENUM_HAVE_GETSPNAM = 1;


    enum DPP_ENUM_HAVE_GETSPENT = 1;


    enum DPP_ENUM_HAVE_GETSID = 1;


    enum DPP_ENUM_HAVE_GETRESUID = 1;


    enum DPP_ENUM_HAVE_GETRESGID = 1;
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


    enum DPP_ENUM_HAVE_GETITIMER = 1;


    enum DPP_ENUM_HAVE_GETHOSTBYNAME_R_6_ARG = 1;






    enum DPP_ENUM_HAVE_GETHOSTBYNAME_R = 1;




    enum DPP_ENUM_HAVE_GETGROUPS = 1;


    enum DPP_ENUM_HAVE_GETENTROPY = 1;


    enum DPP_ENUM_HAVE_GETC_UNLOCKED = 1;


    enum DPP_ENUM_HAVE_GETCWD = 1;


    enum DPP_ENUM_HAVE_GETADDRINFO = 1;


    enum DPP_ENUM_HAVE_GCC_ASM_FOR_X87 = 1;


    enum DPP_ENUM_HAVE_GAMMA = 1;


    enum DPP_ENUM_HAVE_GAI_STRERROR = 1;


    enum DPP_ENUM_HAVE_FTRUNCATE = 1;


    enum DPP_ENUM_HAVE_FTIME = 1;


    enum DPP_ENUM_HAVE_FTELLO = 1;


    enum DPP_ENUM_HAVE_FSYNC = 1;




    enum DPP_ENUM_HAVE_FSTATVFS = 1;


    enum DPP_ENUM_HAVE_FSEEKO = 1;


    enum DPP_ENUM_HAVE_FPATHCONF = 1;


    enum DPP_ENUM_HAVE_FORKPTY = 1;




    enum DPP_ENUM_HAVE_FORK = 1;


    enum DPP_ENUM_HAVE_FLOCK = 1;




    enum DPP_ENUM_HAVE_FINITE = 1;


    enum DPP_ENUM_HAVE_FDATASYNC = 1;




    enum DPP_ENUM_HAVE_FCNTL_H = 1;


    enum DPP_ENUM_HAVE_FCHOWN = 1;


    enum DPP_ENUM_HAVE_FCHMOD = 1;


    enum DPP_ENUM_HAVE_FCHDIR = 1;


    enum DPP_ENUM__IOFBF = 0;


    enum DPP_ENUM__IOLBF = 1;


    enum DPP_ENUM__IONBF = 2;


    enum DPP_ENUM_BUFSIZ = 8192;




    enum DPP_ENUM_SEEK_SET = 0;


    enum DPP_ENUM_SEEK_CUR = 1;


    enum DPP_ENUM_SEEK_END = 2;


    enum DPP_ENUM_HAVE_EXPM1 = 1;


    enum DPP_ENUM_SEEK_DATA = 3;


    enum DPP_ENUM_SEEK_HOLE = 4;


    enum DPP_ENUM_HAVE_EXECV = 1;


    enum DPP_ENUM_HAVE_ERRNO_H = 1;




    enum DPP_ENUM_HAVE_ERFC = 1;


    enum DPP_ENUM_HAVE_ERF = 1;


    enum DPP_ENUM_HAVE_EPOLL = 1;


    enum DPP_ENUM_HAVE_DYNAMIC_LOADING = 1;
    enum DPP_ENUM_HAVE_DUP2 = 1;


    enum DPP_ENUM_HAVE_DLOPEN = 1;


    enum DPP_ENUM_HAVE_DLFCN_H = 1;


    enum DPP_ENUM_HAVE_DIRENT_H = 1;


    enum DPP_ENUM_HAVE_DEV_PTMX = 1;


    enum DPP_ENUM_HAVE_DEVICE_MACROS = 1;


    enum DPP_ENUM_HAVE_DECL_ISNAN = 1;


    enum DPP_ENUM_HAVE_DECL_ISINF = 1;
    enum DPP_ENUM_HAVE_DECL_ISFINITE = 1;


    enum DPP_ENUM_HAVE_CURSES_WCHGAT = 1;


    enum DPP_ENUM_HAVE_CURSES_USE_ENV = 1;


    enum DPP_ENUM_HAVE_CURSES_TYPEAHEAD = 1;


    enum DPP_ENUM_HAVE_CURSES_SYNCOK = 1;


    enum DPP_ENUM_HAVE_CURSES_RESIZE_TERM = 1;


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


    enum DPP_ENUM_HAVE_CLOCK = 1;


    enum DPP_ENUM_HAVE_CHROOT = 1;


    enum DPP_ENUM_HAVE_CHOWN = 1;


    enum DPP_ENUM_HAVE_C99_BOOL = 1;


    enum DPP_ENUM_HAVE_BLUETOOTH_BLUETOOTH_H = 1;


    enum DPP_ENUM_HAVE_BIND_TEXTDOMAIN_CODESET = 1;


    enum DPP_ENUM_HAVE_ATANH = 1;


    enum DPP_ENUM_HAVE_ASM_TYPES_H = 1;


    enum DPP_ENUM_HAVE_ASINH = 1;


    enum DPP_ENUM_HAVE_ALLOCA_H = 1;


    enum DPP_ENUM_HAVE_ALARM = 1;


    enum DPP_ENUM_HAVE_ADDRINFO = 1;


    enum DPP_ENUM_HAVE_ACOSH = 1;


    enum DPP_ENUM_ENABLE_IPV6 = 1;


    enum DPP_ENUM_DOUBLE_IS_LITTLE_ENDIAN_IEEE754 = 1;
    enum DPP_ENUM_PY_RELEASE_SERIAL = 0;




    enum DPP_ENUM_PY_MICRO_VERSION = 15;


    enum DPP_ENUM_PY_MINOR_VERSION = 7;


    enum DPP_ENUM_PY_MAJOR_VERSION = 2;
    enum DPP_ENUM_PyGC_HEAD_SIZE = 0;
    enum DPP_ENUM_PyTrash_UNWIND_LEVEL = 50;






    enum DPP_ENUM_Py_GE = 5;


    enum DPP_ENUM_Py_GT = 4;


    enum DPP_ENUM_Py_NE = 3;


    enum DPP_ENUM_Py_EQ = 2;


    enum DPP_ENUM_Py_LE = 1;


    enum DPP_ENUM_Py_LT = 0;
    enum DPP_ENUM_Py_TPFLAGS_HAVE_STACKLESS_EXTENSION = 0;
    enum DPP_ENUM_Py_TPFLAGS_GC = 0;






    enum DPP_ENUM_Py_PRINT_RAW = 1;
    enum DPP_ENUM_PyBUF_SIMPLE = 0;
    enum DPP_ENUM_PYTHON_API_VERSION = 1013;
    enum DPP_ENUM__STDLIB_H = 1;
    enum DPP_ENUM_PyFloat_STR_PRECISION = 12;






    enum DPP_ENUM___ldiv_t_defined = 1;
    enum DPP_ENUM___lldiv_t_defined = 1;


    enum DPP_ENUM_RAND_MAX = 2147483647;


    enum DPP_ENUM_EXIT_FAILURE = 1;


    enum DPP_ENUM_EXIT_SUCCESS = 0;
    enum DPP_ENUM_PyDict_MINSIZE = 8;
    enum DPP_ENUM_PyWrapperFlag_KEYWORDS = 1;
    enum DPP_ENUM__PyDateTime_DATETIME_DATASIZE = 10;


    enum DPP_ENUM__PyDateTime_TIME_DATASIZE = 6;


    enum DPP_ENUM__PyDateTime_DATE_DATASIZE = 4;
    enum DPP_ENUM_CO_MAXBLOCKS = 20;
    enum DPP_ENUM_PY_ITERSEARCH_CONTAINS = 3;


    enum DPP_ENUM_PY_ITERSEARCH_INDEX = 2;


    enum DPP_ENUM_PY_ITERSEARCH_COUNT = 1;
    enum DPP_ENUM_Py_eval_input = 258;


    enum DPP_ENUM_Py_file_input = 257;


    enum DPP_ENUM_Py_single_input = 256;
    enum DPP_ENUM_WITH_CYCLE_GC = 1;
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
    enum DPP_ENUM__STRINGS_H = 1;
    enum DPP_ENUM__XOPEN_LIM_H = 1;


    enum DPP_ENUM___SYSCALL_WORDSIZE = 64;


    enum DPP_ENUM___WORDSIZE_TIME64_COMPAT32 = 1;


    enum DPP_ENUM___WORDSIZE = 64;






    enum DPP_ENUM__BITS_WCHAR_H = 1;
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




    enum DPP_ENUM__SYS_CDEFS_H = 1;
    enum DPP_ENUM___glibc_c99_flexarr_available = 1;
    enum DPP_ENUM__BITS_TYPESIZES_H = 1;







    enum DPP_ENUM__WINT_T = 1;




    enum DPP_ENUM___wint_t_defined = 1;


    enum DPP_ENUM___timer_t_defined = 1;


    enum DPP_ENUM___time_t_defined = 1;


    enum DPP_ENUM___struct_tm_defined = 1;




    enum DPP_ENUM___timeval_defined = 1;






    enum DPP_ENUM__STRUCT_TIMESPEC = 1;




    enum DPP_ENUM___itimerspec_defined = 1;
    enum DPP_ENUM___struct_FILE_defined = 1;


    enum DPP_ENUM___sigset_t_defined = 1;
    enum DPP_ENUM___mbstate_t_defined = 1;







    enum DPP_ENUM__BITS_TYPES_LOCALE_T_H = 1;


    enum DPP_ENUM___error_t_defined = 1;







    enum DPP_ENUM___cookie_io_functions_t_defined = 1;


    enum DPP_ENUM___clockid_t_defined = 1;


    enum DPP_ENUM___clock_t_defined = 1;






    enum DPP_ENUM___HAVE_GENERIC_SELECTION = 1;


    enum DPP_ENUM__SYS_SELECT_H = 1;


    enum DPP_ENUM_____mbstate_t_defined = 1;


    enum DPP_ENUM__BITS_TYPES___LOCALE_T_H = 1;


    enum DPP_ENUM______fpos_t_defined = 1;


    enum DPP_ENUM______fpos64_t_defined = 1;


    enum DPP_ENUM_____FILE_defined = 1;


    enum DPP_ENUM___FILE_defined = 1;
    enum DPP_ENUM__BITS_TYPES_H = 1;







    enum DPP_ENUM__SYS_STAT_H = 1;
    enum DPP_ENUM_S_BLKSIZE = 512;




    enum DPP_ENUM__BITS_TIMEX_H = 1;


    enum DPP_ENUM_TIMER_ABSTIME = 1;


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
    enum DPP_ENUM___have_pthread_attr_t = 1;


    enum DPP_ENUM__BITS_PTHREADTYPES_COMMON_H = 1;


    enum DPP_ENUM___PTHREAD_RWLOCK_INT_FLAGS_SHARED = 1;


    enum DPP_ENUM__MKNOD_VER = 0;
    enum DPP_ENUM___PTHREAD_MUTEX_USE_UNION = 0;


    enum DPP_ENUM___PTHREAD_MUTEX_NUSERS_AFTER_KIND = 0;


    enum DPP_ENUM___PTHREAD_MUTEX_LOCK_ELISION = 1;






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
    enum DPP_ENUM__SYS_TIME_H = 1;
    enum DPP_ENUM__POSIX_SHELL = 1;




    enum DPP_ENUM__POSIX_REGEXP = 1;


    enum DPP_ENUM__POSIX_THREAD_CPUTIME = 0;


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
    enum DPP_ENUM__SYS_TYPES_H = 1;




    enum DPP_ENUM__POSIX_SAVED_IDS = 1;


    enum DPP_ENUM__POSIX_JOB_CONTROL = 1;


    enum DPP_ENUM__BITS_POSIX_OPT_H = 1;




    enum DPP_ENUM_CHARCLASS_NAME_MAX = 2048;






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




    enum DPP_ENUM___BIT_TYPES_DEFINED__ = 1;


    enum DPP_ENUM_MQ_PRIO_MAX = 32768;


    enum DPP_ENUM_HOST_NAME_MAX = 64;


    enum DPP_ENUM_LOGIN_NAME_MAX = 256;


    enum DPP_ENUM_TTY_NAME_MAX = 32;


    enum DPP_ENUM_DELAYTIMER_MAX = 2147483647;


    enum DPP_ENUM_PTHREAD_STACK_MIN = 16384;




    enum DPP_ENUM_AIO_PRIO_DELTA_MAX = 20;


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
    enum DPP_ENUM_STDIN_FILENO = 0;


    enum DPP_ENUM_STDOUT_FILENO = 1;


    enum DPP_ENUM_STDERR_FILENO = 2;
    enum DPP_ENUM___HAVE_FLOATN_NOT_TYPEDEF = 0;







    enum DPP_ENUM___HAVE_DISTINCT_FLOAT64X = 0;


    enum DPP_ENUM___HAVE_DISTINCT_FLOAT32X = 0;


    enum DPP_ENUM___HAVE_DISTINCT_FLOAT64 = 0;


    enum DPP_ENUM___HAVE_DISTINCT_FLOAT32 = 0;




    enum DPP_ENUM___HAVE_FLOAT128X = 0;


    enum DPP_ENUM___HAVE_FLOAT32X = 1;




    enum DPP_ENUM___HAVE_FLOAT64 = 1;


    enum DPP_ENUM___HAVE_FLOAT32 = 1;


    enum DPP_ENUM___HAVE_FLOAT16 = 0;




    enum DPP_ENUM_R_OK = 4;


    enum DPP_ENUM_W_OK = 2;


    enum DPP_ENUM_X_OK = 1;


    enum DPP_ENUM_F_OK = 0;






    enum DPP_ENUM__BITS_ERRNO_H = 1;
    enum DPP_ENUM__XBS5_LP64_OFF64 = 1;


    enum DPP_ENUM__POSIX_V6_LP64_OFF64 = 1;


    enum DPP_ENUM__POSIX_V7_LP64_OFF64 = 1;


    enum DPP_ENUM__XBS5_LPBIG_OFFBIG = -1;


    enum DPP_ENUM__POSIX_V6_LPBIG_OFFBIG = -1;


    enum DPP_ENUM__POSIX_V7_LPBIG_OFFBIG = -1;
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


    enum DPP_ENUM_ESRMNT = 69;


    enum DPP_ENUM_EADV = 68;


    enum DPP_ENUM_ENOLINK = 67;


    enum DPP_ENUM_EREMOTE = 66;


    enum DPP_ENUM_ENOPKG = 65;


    enum DPP_ENUM_ENONET = 64;


    enum DPP_ENUM_ENOSR = 63;


    enum DPP_ENUM_ETIME = 62;


    enum DPP_ENUM_F_ULOCK = 0;


    enum DPP_ENUM_F_LOCK = 1;


    enum DPP_ENUM_F_TLOCK = 2;


    enum DPP_ENUM_F_TEST = 3;


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


    enum DPP_ENUM_ENOSYS = 38;


    enum DPP_ENUM_ENOLCK = 37;


    enum DPP_ENUM_ENAMETOOLONG = 36;


    enum DPP_ENUM_EDEADLK = 35;




    enum DPP_ENUM_ERANGE = 34;


    enum DPP_ENUM_EDOM = 33;


    enum DPP_ENUM_EPIPE = 32;


    enum DPP_ENUM__WCHAR_H = 1;


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
    BaseType = (1L<<10),
    Default = ( (1L<<0) | (1L<<1) | (1L<<3) | (1L<<5) | (1L<<6) | (1L<<7) | (1L<<8) | 0 | (1L<<17) | 0),
}



mixin template PyObjectHead() {
    import python.raw: PyObject, Py_ssize_t, isPython2;
    static if(isPython2)
        import python.raw: _typeobject;
    Py_ssize_t ob_refcnt; _typeobject *ob_type;;
}


alias ModuleInitRet = void;



static if(isPython2) {

    auto pyInitModule(const(char)* name, PyMethodDef* methods) {
        return Py_InitModule4_64(name, methods, cast(char *)null, cast(PyObject *)null, 1013);
    }
}



static if(isPython3) {
    auto pyModuleCreate(PyModuleDef* moduleDef) @nogc nothrow {
        return PyModule_Create(moduleDef);
    }
}


bool pyListCheck(PyObject* obj) @nogc nothrow {
    return (((((cast(PyObject*)(obj)).ob_type)).tp_flags & ((1L<<25))) != 0);
}



bool pyTupleCheck(PyObject* obj) @nogc nothrow {
    return (((((cast(PyObject*)(obj)).ob_type)).tp_flags & ((1L<<26))) != 0);
}



bool pyDictCheck(PyObject *obj) @nogc nothrow {
    return (((((cast(PyObject*)(obj)).ob_type)).tp_flags & ((1L<<29))) != 0);
}


bool pyBoolCheck(PyObject *obj) @nogc nothrow {
    return (((cast(PyObject*)(obj)).ob_type) == &PyBool_Type);
}


bool pyUnicodeCheck(PyObject* obj) @nogc nothrow {
    return (((((cast(PyObject*)(obj)).ob_type)).tp_flags & ((1L<<28))) != 0);

}


auto pyTrue() {
    return (cast(PyObject *) &_Py_TrueStruct);
}


auto pyFalse() {
    return (cast(PyObject *) &_Py_ZeroStruct);
}



void pyIncRef(PyObject* obj) @nogc nothrow {
    ( (cast(PyObject*)(obj)).ob_refcnt++);
}


auto pyNone() @nogc nothrow {
    return (&_Py_NoneStruct);
}

auto pyUnicodeDecodeUTF8(const(char)* str, c_long length, const(char)* errors = null) @nogc nothrow {
    return PyUnicodeUCS4_DecodeUTF8(str, length, errors);
}

auto pyUnicodeAsUtf8String(PyObject* obj) @nogc nothrow {
    return PyUnicodeUCS4_AsUTF8String(obj);
}

auto pyBytesAsString(PyObject* obj) @nogc nothrow {
    return PyString_AsString(obj);
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
