import core.stdc.config;
import core.stdc.stdarg: va_list;
static import core.simd;
static import std.conv;

struct Int128 { long lower; long upper; }
struct UInt128 { ulong lower; ulong upper; }

struct __locale_data { int dummy; }

alias _Bool = bool;
struct dpp {
    static struct Opaque(int N) {
        void[N] bytes;
    }

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
    const(char)* ph7_lib_copyright() @nogc nothrow;
    const(char)* ph7_lib_ident() @nogc nothrow;
    const(char)* ph7_lib_signature() @nogc nothrow;
    const(char)* ph7_lib_version() @nogc nothrow;
    int ph7_lib_is_threadsafe() @nogc nothrow;
    int ph7_lib_shutdown() @nogc nothrow;
    int ph7_lib_config(int, ...) @nogc nothrow;
    int ph7_lib_init() @nogc nothrow;
    int ph7_value_is_empty(ph7_value*) @nogc nothrow;
    int ph7_value_is_resource(ph7_value*) @nogc nothrow;
    int ph7_value_is_object(ph7_value*) @nogc nothrow;
    int ph7_value_is_array(ph7_value*) @nogc nothrow;
    int ph7_value_is_scalar(ph7_value*) @nogc nothrow;
    int ph7_value_is_callable(ph7_value*) @nogc nothrow;
    int ph7_value_is_numeric(ph7_value*) @nogc nothrow;
    int ph7_value_is_null(ph7_value*) @nogc nothrow;
    int ph7_value_is_string(ph7_value*) @nogc nothrow;
    int ph7_value_is_bool(ph7_value*) @nogc nothrow;
    int ph7_value_is_float(ph7_value*) @nogc nothrow;
    int ph7_value_is_int(ph7_value*) @nogc nothrow;
    const(char)* ph7_object_get_class_name(ph7_value*, int*) @nogc nothrow;
    ph7_value* ph7_object_fetch_attr(ph7_value*, const(char)*) @nogc nothrow;
    int ph7_object_walk(ph7_value*, int function(const(char)*, ph7_value*, void*), void*) @nogc nothrow;
    uint ph7_array_count(ph7_value*) @nogc nothrow;
    int ph7_array_add_intkey_elem(ph7_value*, int, ph7_value*) @nogc nothrow;
    int ph7_array_add_strkey_elem(ph7_value*, const(char)*, ph7_value*) @nogc nothrow;
    int ph7_array_add_elem(ph7_value*, ph7_value*, ph7_value*) @nogc nothrow;
    int ph7_array_walk(ph7_value*, int function(ph7_value*, ph7_value*, void*), void*) @nogc nothrow;
    ph7_value* ph7_array_fetch(ph7_value*, const(char)*, int) @nogc nothrow;
    int ph7_value_release(ph7_value*) @nogc nothrow;
    int ph7_value_resource(ph7_value*, void*) @nogc nothrow;
    int ph7_value_reset_string_cursor(ph7_value*) @nogc nothrow;
    int ph7_value_string_format(ph7_value*, const(char)*, ...) @nogc nothrow;
    int ph7_value_string(ph7_value*, const(char)*, int) @nogc nothrow;
    int ph7_value_double(ph7_value*, double) @nogc nothrow;
    int ph7_value_null(ph7_value*) @nogc nothrow;
    int ph7_value_bool(ph7_value*, int) @nogc nothrow;
    int ph7_value_int64(ph7_value*, long) @nogc nothrow;
    int ph7_value_int(ph7_value*, int) @nogc nothrow;
    void ph7_context_release_value(ph7_context*, ph7_value*) @nogc nothrow;
    ph7_value* ph7_context_new_array(ph7_context*) @nogc nothrow;
    ph7_value* ph7_context_new_scalar(ph7_context*) @nogc nothrow;
    int ph7_release_value(ph7_vm*, ph7_value*) @nogc nothrow;
    ph7_value* ph7_new_array(ph7_vm*) @nogc nothrow;
    ph7_value* ph7_new_scalar(ph7_vm*) @nogc nothrow;
    void ph7_context_free_chunk(ph7_context*, void*) @nogc nothrow;
    void* ph7_context_realloc_chunk(ph7_context*, void*, uint) @nogc nothrow;
    void* ph7_context_alloc_chunk(ph7_context*, uint, int, int) @nogc nothrow;
    const(char)* ph7_function_name(ph7_context*) @nogc nothrow;
    uint ph7_context_result_buf_length(ph7_context*) @nogc nothrow;
    void* ph7_context_pop_aux_data(ph7_context*) @nogc nothrow;
    void* ph7_context_peek_aux_data(ph7_context*) @nogc nothrow;
    int ph7_context_push_aux_data(ph7_context*, void*) @nogc nothrow;
    void* ph7_context_user_data(ph7_context*) @nogc nothrow;
    int ph7_context_random_string(ph7_context*, char*, int) @nogc nothrow;
    uint ph7_context_random_num(ph7_context*) @nogc nothrow;
    int ph7_context_throw_error_format(ph7_context*, int, const(char)*, ...) @nogc nothrow;
    int ph7_context_throw_error(ph7_context*, int, const(char)*) @nogc nothrow;
    int ph7_context_output_format(ph7_context*, const(char)*, ...) @nogc nothrow;
    int ph7_context_output(ph7_context*, const(char)*, int) @nogc nothrow;
    int ph7_result_resource(ph7_context*, void*) @nogc nothrow;
    int ph7_result_value(ph7_context*, ph7_value*) @nogc nothrow;
    int ph7_result_string_format(ph7_context*, const(char)*, ...) @nogc nothrow;
    int ph7_result_string(ph7_context*, const(char)*, int) @nogc nothrow;
    int ph7_result_null(ph7_context*) @nogc nothrow;
    int ph7_result_double(ph7_context*, double) @nogc nothrow;
    int ph7_result_bool(ph7_context*, int) @nogc nothrow;
    int ph7_result_int64(ph7_context*, long) @nogc nothrow;
    int ph7_result_int(ph7_context*, int) @nogc nothrow;
    int ph7_value_compare(ph7_value*, ph7_value*, int) @nogc nothrow;
    void* ph7_value_to_resource(ph7_value*) @nogc nothrow;
    const(char)* ph7_value_to_string(ph7_value*, int*) @nogc nothrow;
    double ph7_value_to_double(ph7_value*) @nogc nothrow;
    long ph7_value_to_int64(ph7_value*) @nogc nothrow;
    int ph7_value_to_bool(ph7_value*) @nogc nothrow;
    int ph7_value_to_int(ph7_value*) @nogc nothrow;
    int ph7_delete_constant(ph7_vm*, const(char)*) @nogc nothrow;
    int ph7_create_constant(ph7_vm*, const(char)*, void function(ph7_value*, void*), void*) @nogc nothrow;
    int ph7_delete_function(ph7_vm*, const(char)*) @nogc nothrow;
    int ph7_create_function(ph7_vm*, const(char)*, int function(ph7_context*, int, ph7_value**), void*) @nogc nothrow;
    int ph7_vm_dump_v2(ph7_vm*, int function(const(void)*, uint, void*), void*) @nogc nothrow;
    int ph7_vm_release(ph7_vm*) @nogc nothrow;
    int ph7_vm_reset(ph7_vm*) @nogc nothrow;
    int ph7_vm_exec(ph7_vm*, int*) @nogc nothrow;
    int ph7_vm_config(ph7_vm*, int, ...) @nogc nothrow;
    int ph7_compile_file(ph7*, const(char)*, ph7_vm**, int) @nogc nothrow;
    int ph7_compile_v2(ph7*, const(char)*, int, ph7_vm**, int) @nogc nothrow;
    int ph7_compile(ph7*, const(char)*, int, ph7_vm**) @nogc nothrow;
    int ph7_release(ph7*) @nogc nothrow;
    int ph7_config(ph7*, int, ...) @nogc nothrow;
    int ph7_init(ph7**) @nogc nothrow;
    alias ph7_int64 = long;
    alias ph7_real = double;
    alias ProcMemError = int function(void*);
    struct Sytm
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
        char* tm_zone;
        c_long tm_gmtoff;
    }
    struct SyMutex;
    struct syiovec
    {
        c_ulong nLen;
        char* pBase;
    }
    struct SyString
    {
        const(char)* zString;
        uint nByte;
    }
    struct SyMemMethods
    {
        void* function(uint) xAlloc;
        void* function(void*, uint) xRealloc;
        void function(void*) xFree;
        uint function(void*) xChunkSize;
        int function(void*) xInit;
        void function(void*) xRelease;
        void* pUserData;
    }
    struct SyMutexMethods
    {
        int function() xGlobalInit;
        void function() xGlobalRelease;
        SyMutex* function(int) xNew;
        void function(SyMutex*) xRelease;
        void function(SyMutex*) xEnter;
        int function(SyMutex*) xTryEnter;
        void function(SyMutex*) xLeave;
    }
    alias ProcConsumer = int function(const(void)*, uint, void*);
    alias sxu64 = ulong;
    alias sxi64 = long;
    alias sxu32 = uint;
    struct ph7;
    struct ph7_vm;
    struct ph7_vfs
    {
        const(char)* zName;
        int iVersion;
        int function(const(char)*) xChdir;
        int function(const(char)*) xChroot;
        int function(ph7_context*) xGetcwd;
        int function(const(char)*, int, int) xMkdir;
        int function(const(char)*) xRmdir;
        int function(const(char)*) xIsdir;
        int function(const(char)*, const(char)*) xRename;
        int function(const(char)*, ph7_context*) xRealpath;
        int function(uint) xSleep;
        int function(const(char)*) xUnlink;
        int function(const(char)*) xFileExists;
        int function(const(char)*, int) xChmod;
        int function(const(char)*, const(char)*) xChown;
        int function(const(char)*, const(char)*) xChgrp;
        long function(const(char)*) xFreeSpace;
        long function(const(char)*) xTotalSpace;
        long function(const(char)*) xFileSize;
        long function(const(char)*) xFileAtime;
        long function(const(char)*) xFileMtime;
        long function(const(char)*) xFileCtime;
        int function(const(char)*, ph7_value*, ph7_value*) xStat;
        int function(const(char)*, ph7_value*, ph7_value*) xlStat;
        int function(const(char)*) xIsfile;
        int function(const(char)*) xIslink;
        int function(const(char)*) xReadable;
        int function(const(char)*) xWritable;
        int function(const(char)*) xExecutable;
        int function(const(char)*, ph7_context*) xFiletype;
        int function(const(char)*, ph7_context*) xGetenv;
        int function(const(char)*, const(char)*) xSetenv;
        int function(const(char)*, long, long) xTouch;
        int function(const(char)*, void**, long*) xMmap;
        void function(void*, long) xUnmap;
        int function(const(char)*, const(char)*, int) xLink;
        int function(int) xUmask;
        void function(ph7_context*) xTempDir;
        uint function() xProcessId;
        int function() xUid;
        int function() xGid;
        void function(ph7_context*) xUsername;
        int function(const(char)*, ph7_context*) xExec;
    }
    //struct ph7_value;
    struct ph7_context;
    struct ph7_io_stream
    {
        const(char)* zName;
        int iVersion;
        int function(const(char)*, int, ph7_value*, void**) xOpen;
        int function(const(char)*, ph7_value*, void**) xOpenDir;
        void function(void*) xClose;
        void function(void*) xCloseDir;
        long function(void*, void*, long) xRead;
        int function(void*, ph7_context*) xReadDir;
        long function(void*, const(void)*, long) xWrite;
        int function(void*, long, int) xSeek;
        int function(void*, int) xLock;
        void function(void*) xRewindDir;
        long function(void*) xTell;
        int function(void*, long) xTrunc;
        int function(void*) xSync;
        int function(void*, ph7_value*, ph7_value*) xStat;
    }
    struct ph7_value
    {
        ph7_real rVal;      /* Real value */
        union x{              
            sxi64 iVal;     /* Integer value */
            void *pOther;   /* Other values (Object, Array, Resource, Namespace, etc.) */
        };
        int iFlags;       /* Control flags (see below) */
        ph7_vm *pVm;        /* Virtual machine that own this instance */
        SyBlob sBlob;       /* String values */
        uint nIdx;         /* Index number of this entry in the global object allocator */
    }
    struct SyBlob
    {
        //SyMemBackend *pAllocator; /* Memory backend */
        int *unused;
        void   *pBlob;            /* Base pointer */
        sxu32  nByte;             /* Total number of used bytes */
        sxu32  mByte;             /* Total number of available bytes */
        sxu32  nFlags;            /* Blob internal flags,see below */
    }
    enum DPP_ENUM___GNUC_VA_LIST = 1;
    enum DPP_ENUM_PH7_VERSION_NUMBER = 2001004;
    enum DPP_ENUM_SXRET_OK = 0;
    enum DPP_ENUM_PH7_CONFIG_ERR_OUTPUT = 1;
    enum DPP_ENUM_PH7_CONFIG_ERR_ABORT = 2;
    enum DPP_ENUM_PH7_CONFIG_ERR_LOG = 3;
    enum DPP_ENUM_PH7_VM_CONFIG_OUTPUT = 1;
    enum DPP_ENUM_PH7_VM_CONFIG_IMPORT_PATH = 3;
    enum DPP_ENUM_PH7_VM_CONFIG_ERR_REPORT = 4;
    enum DPP_ENUM_PH7_VM_CONFIG_RECURSION_DEPTH = 5;
    enum DPP_ENUM_PH7_VM_OUTPUT_LENGTH = 6;
    enum DPP_ENUM_PH7_VM_CONFIG_CREATE_SUPER = 7;
    enum DPP_ENUM_PH7_VM_CONFIG_CREATE_VAR = 8;
    enum DPP_ENUM_PH7_VM_CONFIG_HTTP_REQUEST = 9;
    enum DPP_ENUM_PH7_VM_CONFIG_SERVER_ATTR = 10;
    enum DPP_ENUM_PH7_VM_CONFIG_ENV_ATTR = 11;
    enum DPP_ENUM_PH7_VM_CONFIG_SESSION_ATTR = 12;
    enum DPP_ENUM_PH7_VM_CONFIG_POST_ATTR = 13;
    enum DPP_ENUM_PH7_VM_CONFIG_GET_ATTR = 14;
    enum DPP_ENUM_PH7_VM_CONFIG_COOKIE_ATTR = 15;
    enum DPP_ENUM_PH7_VM_CONFIG_HEADER_ATTR = 16;
    enum DPP_ENUM_PH7_VM_CONFIG_EXEC_VALUE = 17;
    enum DPP_ENUM_PH7_VM_CONFIG_IO_STREAM = 18;
    enum DPP_ENUM_PH7_VM_CONFIG_ARGV_ENTRY = 19;
    enum DPP_ENUM_PH7_VM_CONFIG_EXTRACT_OUTPUT = 20;
    enum DPP_ENUM_PH7_VM_CONFIG_ERR_LOG_HANDLER = 21;
    enum DPP_ENUM_PH7_LIB_CONFIG_USER_MALLOC = 1;
    enum DPP_ENUM_PH7_LIB_CONFIG_MEM_ERR_CALLBACK = 2;
    enum DPP_ENUM_PH7_LIB_CONFIG_USER_MUTEX = 3;
    enum DPP_ENUM_PH7_LIB_CONFIG_THREAD_LEVEL_SINGLE = 4;
    enum DPP_ENUM_PH7_LIB_CONFIG_THREAD_LEVEL_MULTI = 5;
    enum DPP_ENUM_PH7_LIB_CONFIG_VFS = 6;
    enum DPP_ENUM_PH7_CTX_ERR = 1;
    enum DPP_ENUM_PH7_CTX_WARNING = 2;
    enum DPP_ENUM_PH7_CTX_NOTICE = 3;
    enum DPP_ENUM_PH7_VFS_VERSION = 2;
    enum DPP_ENUM_PH7_IO_STREAM_VERSION = 1;

enum MEMOBJ_STRING    = 0x001;  /* Memory value is a UTF-8 string */
enum MEMOBJ_INT       = 0x002;  /* Memory value is an integer */
enum MEMOBJ_REAL      = 0x004;  /* Memory value is a real number */
enum MEMOBJ_BOOL      = 0x008;  /* Memory value is a boolean */
enum MEMOBJ_NULL      = 0x020;  /* Memory value is NULL */
enum MEMOBJ_HASHMAP   = 0x040;  /* Memory value is a hashmap aka 'array' in the PHP jargon */
enum MEMOBJ_OBJ       = 0x080;  /* Memory value is an object [i.e: class instance] */
enum MEMOBJ_RES       = 0x100;  /* Memory value is a resource [User private data] */ 
enum MEMOBJ_REFERENCE = 0x400;  /* Memory value hold a reference (64-bit index) of another ph7_value */

}
