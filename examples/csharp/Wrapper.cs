namespace Csharp.Library {
    using System;
    using System.CodeDom.Compiler;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.InteropServices;
    using Autowrap;

    public static class Functions {
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_FreeFunction", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_int_error dlang_FreeFunction(int value);
        public static int FreeFunction(int value) {
            var dlang_ret = dlang_FreeFunction(value);
            return dlang_ret;
        }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_StringFunction", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_slice_error dlang_StringFunction(slice value);
        public static string StringFunction(string value) {
            var dlang_ret = dlang_StringFunction(SharedFunctions.CreateString(value));
            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);
        }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_ArrayFunction", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_slice_error dlang_ArrayFunction(slice arr);
        public static Range<Csharp.Library.S2> ArrayFunction(Range<Csharp.Library.S2> arr) {
            var dlang_ret = dlang_ArrayFunction(arr.ToSlice());
            return new Range<Csharp.Library.S2>(dlang_ret);
        }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_ClassRangeFunction", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_slice_error dlang_ClassRangeFunction(slice arr);
        public static Range<Csharp.Library.C1> ClassRangeFunction(Range<Csharp.Library.C1> arr) {
            var dlang_ret = dlang_ClassRangeFunction(arr.ToSlice());
            return new Range<Csharp.Library.C1>(dlang_ret);
        }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_TestErrorMessage", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_slice_error dlang_TestErrorMessage([MarshalAs(UnmanagedType.Bool)]bool throwError);
        public static string TestErrorMessage(bool throwError) {
            var dlang_ret = dlang_TestErrorMessage(throwError);
            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);
        }

    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    public struct S2 {
        public int Value;
        private slice _Str;
        public string Str { get => SharedFunctions.SliceToString(_Str, DStringType._string); set => _Str = SharedFunctions.CreateString(value); }
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    public struct S1 {
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_S1_GetValue", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_float_error dlang_S1_GetValue(ref Csharp.Library.S1 __obj__);
        public float GetValue() {
            var dlang_ret = dlang_S1_GetValue(ref this);
            return dlang_ret;
        }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_S1_SetNestedStruct", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_void_error dlang_S1_SetNestedStruct(ref Csharp.Library.S1 __obj__, Csharp.Library.S2 nested);
        public void SetNestedStruct(Csharp.Library.S2 nested) {
            var dlang_ret = dlang_S1_SetNestedStruct(ref this, nested);
        }

        public float Value;
        public Csharp.Library.S2 NestedStruct;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    public class C1 : DLangObject {
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1___ctor", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_C1_error dlang_C1___ctor(slice s, int i);
        public C1(string s, int i) : base(dlang_C1___ctor(SharedFunctions.CreateString(s), i)) { }
        internal C1(IntPtr ptr) : base(ptr) { }

        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StructProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_Csharp_Library_S2_error dlang_C1_StructProperty(IntPtr __obj__);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StructProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_Csharp_Library_S2_error dlang_C1_StructProperty(IntPtr __obj__, Csharp.Library.S2 value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_RefProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_Csharp_Library_C1_error dlang_C1_RefProperty(IntPtr __obj__);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_RefProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_Csharp_Library_C1_error dlang_C1_RefProperty(IntPtr __obj__, IntPtr value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_ValueProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_ulong_error dlang_C1_ValueProperty(IntPtr __obj__);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_ValueProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_ulong_error dlang_C1_ValueProperty(IntPtr __obj__, ulong value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_ValueSliceProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_ValueSliceProperty(IntPtr __obj__);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_ValueSliceProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_ValueSliceProperty(IntPtr __obj__, slice value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StringSliceProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_StringSliceProperty(IntPtr __obj__);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StringSliceProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_StringSliceProperty(IntPtr __obj__, slice value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_WstringSliceProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_WstringSliceProperty(IntPtr __obj__);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_WstringSliceProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_WstringSliceProperty(IntPtr __obj__, slice value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_DstringSliceProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_DstringSliceProperty(IntPtr __obj__);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_DstringSliceProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_DstringSliceProperty(IntPtr __obj__, slice value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StructSliceProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_StructSliceProperty(IntPtr __obj__);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StructSliceProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_StructSliceProperty(IntPtr __obj__, slice value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_RefSliceProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_RefSliceProperty(IntPtr __obj__);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_RefSliceProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_RefSliceProperty(IntPtr __obj__, slice value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_TestMemberFunc", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_TestMemberFunc(IntPtr __obj__, slice test, Csharp.Library.S1 value);
        public string TestMemberFunc(string test, Csharp.Library.S1 value) {
            var dlang_ret = dlang_C1_TestMemberFunc(DLangPointer, SharedFunctions.CreateString(test), value);
            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);
        }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_ToString", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_ToString(IntPtr __obj__);
        public override string ToString() {
            var dlang_ret = dlang_C1_ToString(DLangPointer);
            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);
        }

        public Csharp.Library.S2 StructProperty { get => dlang_C1_StructProperty(DLangPointer); set => dlang_C1_StructProperty(DLangPointer, value); }
        public Csharp.Library.C1 RefProperty { get => new Csharp.Library.C1(dlang_C1_RefProperty(DLangPointer)); set => dlang_C1_RefProperty(DLangPointer, value.DLangPointer); }
        public ulong ValueProperty { get => dlang_C1_ValueProperty(DLangPointer); set => dlang_C1_ValueProperty(DLangPointer, value); }
        public Range<ulong> ValueSliceProperty { get => new Range<ulong>(dlang_C1_ValueSliceProperty(DLangPointer)); set => dlang_C1_ValueSliceProperty(DLangPointer, value.ToSlice()); }
        public Range<string> StringSliceProperty { get => new Range<string>(dlang_C1_StringSliceProperty(DLangPointer)); set => dlang_C1_StringSliceProperty(DLangPointer, value.ToSlice()); }
        public Range<string> WstringSliceProperty { get => new Range<string>(dlang_C1_WstringSliceProperty(DLangPointer)); set => dlang_C1_WstringSliceProperty(DLangPointer, value.ToSlice()); }
        public Range<string> DstringSliceProperty { get => new Range<string>(dlang_C1_DstringSliceProperty(DLangPointer)); set => dlang_C1_DstringSliceProperty(DLangPointer, value.ToSlice()); }
        public Range<Csharp.Library.S1> StructSliceProperty { get => new Range<Csharp.Library.S1>(dlang_C1_StructSliceProperty(DLangPointer)); set => dlang_C1_StructSliceProperty(DLangPointer, value.ToSlice()); }
        public Range<Csharp.Library.C1> RefSliceProperty { get => new Range<Csharp.Library.C1>(dlang_C1_RefSliceProperty(DLangPointer)); set => dlang_C1_RefSliceProperty(DLangPointer, value.ToSlice()); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_IntValue_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern int dlang_intValue_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_IntValue_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_intValue_set(IntPtr ptr, int value);
        public int IntValue { get => dlang_intValue_get(DLangPointer); set => dlang_intValue_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_BoolMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern bool dlang_boolMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_BoolMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_boolMember_set(IntPtr ptr, bool value);
        public bool BoolMember { get => dlang_boolMember_get(DLangPointer); set => dlang_boolMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_ByteMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern sbyte dlang_byteMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_ByteMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_byteMember_set(IntPtr ptr, sbyte value);
        public sbyte ByteMember { get => dlang_byteMember_get(DLangPointer); set => dlang_byteMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_UbyteMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern byte dlang_ubyteMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_UbyteMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_ubyteMember_set(IntPtr ptr, byte value);
        public byte UbyteMember { get => dlang_ubyteMember_get(DLangPointer); set => dlang_ubyteMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_ShortMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern short dlang_shortMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_ShortMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_shortMember_set(IntPtr ptr, short value);
        public short ShortMember { get => dlang_shortMember_get(DLangPointer); set => dlang_shortMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_UshortMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern ushort dlang_ushortMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_UshortMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_ushortMember_set(IntPtr ptr, ushort value);
        public ushort UshortMember { get => dlang_ushortMember_get(DLangPointer); set => dlang_ushortMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_IntMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern int dlang_intMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_IntMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_intMember_set(IntPtr ptr, int value);
        public int IntMember { get => dlang_intMember_get(DLangPointer); set => dlang_intMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_UintMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern uint dlang_uintMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_UintMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_uintMember_set(IntPtr ptr, uint value);
        public uint UintMember { get => dlang_uintMember_get(DLangPointer); set => dlang_uintMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_LongMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern long dlang_longMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_LongMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_longMember_set(IntPtr ptr, long value);
        public long LongMember { get => dlang_longMember_get(DLangPointer); set => dlang_longMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_UlongMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern ulong dlang_ulongMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_UlongMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_ulongMember_set(IntPtr ptr, ulong value);
        public ulong UlongMember { get => dlang_ulongMember_get(DLangPointer); set => dlang_ulongMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_FloatMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern float dlang_floatMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_FloatMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_floatMember_set(IntPtr ptr, float value);
        public float FloatMember { get => dlang_floatMember_get(DLangPointer); set => dlang_floatMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_DoubleMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern double dlang_doubleMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_DoubleMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_doubleMember_set(IntPtr ptr, double value);
        public double DoubleMember { get => dlang_doubleMember_get(DLangPointer); set => dlang_doubleMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StringMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern slice dlang_stringMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StringMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_stringMember_set(IntPtr ptr, slice value);
        public string StringMember { get => SharedFunctions.SliceToString(dlang_stringMember_get(DLangPointer), DStringType._string); set => dlang_stringMember_set(DLangPointer, SharedFunctions.CreateString(value)); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_WstringMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern slice dlang_wstringMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_WstringMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_wstringMember_set(IntPtr ptr, slice value);
        public string WstringMember { get => SharedFunctions.SliceToString(dlang_wstringMember_get(DLangPointer), DStringType._wstring); set => dlang_wstringMember_set(DLangPointer, SharedFunctions.CreateWstring(value)); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_DstringMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern slice dlang_dstringMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_DstringMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_dstringMember_set(IntPtr ptr, slice value);
        public string DstringMember { get => SharedFunctions.SliceToString(dlang_dstringMember_get(DLangPointer), DStringType._dstring); set => dlang_dstringMember_set(DLangPointer, SharedFunctions.CreateDstring(value)); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_ValueMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern Csharp.Library.S1 dlang_valueMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_ValueMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_valueMember_set(IntPtr ptr, Csharp.Library.S1 value);
        public Csharp.Library.S1 ValueMember { get => dlang_valueMember_get(DLangPointer); set => dlang_valueMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_RefMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern Csharp.Library.C1 dlang_refMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_RefMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_refMember_set(IntPtr ptr, Csharp.Library.C1 value);
        public Csharp.Library.C1 RefMember { get => dlang_refMember_get(DLangPointer); set => dlang_refMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_RefArray_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern slice dlang_refArray_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_RefArray_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_refArray_set(IntPtr ptr, slice value);
        public Range<Csharp.Library.C1> RefArray { get => new Range<Csharp.Library.C1>(dlang_refArray_get(DLangPointer)); set => dlang_refArray_set(DLangPointer, value.ToSlice()); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StructArray_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern slice dlang_structArray_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StructArray_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_structArray_set(IntPtr ptr, slice value);
        public Range<Csharp.Library.S1> StructArray { get => new Range<Csharp.Library.S1>(dlang_structArray_get(DLangPointer)); set => dlang_structArray_set(DLangPointer, value.ToSlice()); }
    }

}

namespace Autowrap {
    using System;
    using System.CodeDom.Compiler;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.InteropServices;
    using Mono.Unix;

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    public class DLangException : Exception {
        public string DLangExceptionText { get; }
        public DLangException(string dlang) : base() {
            DLangExceptionText = dlang;
        }
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct slice {
        internal IntPtr length;
        internal IntPtr ptr;

        public slice(IntPtr ptr, IntPtr length)
        {
            this.ptr = ptr;
            this.length = length;
        }
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    internal enum DStringType : int {
        None = 0,
        _string = 1,
        _wstring = 2,
        _dstring = 4,
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    public abstract class DLangObject {
        private readonly IntPtr _ptr;
        internal protected IntPtr DLangPointer => _ptr;

        protected DLangObject(IntPtr ptr) {
            this._ptr = ptr;
        }

        ~DLangObject() {
            SharedFunctions.ReleaseMemory(_ptr);
        }
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_void_error {
        public void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_bool_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator bool(return_bool_error ret) { ret.EnsureValid(); return ret._value; }
        [MarshalAs(UnmanagedType.Bool)] public bool _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_slice_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator slice(return_slice_error ret) { ret.EnsureValid(); return ret._value; }
        private slice _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_byte_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator byte(return_byte_error ret) { ret.EnsureValid(); return ret._value; }
        private byte _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_ushort_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator ushort(return_ushort_error ret) { ret.EnsureValid(); return ret._value; }
        private ushort _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_long_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator long(return_long_error ret) { ret.EnsureValid(); return ret._value; }
        private long _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_short_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator short(return_short_error ret) { ret.EnsureValid(); return ret._value; }
        private short _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_int_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator int(return_int_error ret) { ret.EnsureValid(); return ret._value; }
        private int _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_uint_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator uint(return_uint_error ret) { ret.EnsureValid(); return ret._value; }
        private uint _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_Csharp_Library_S1_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator Csharp.Library.S1(return_Csharp_Library_S1_error ret) { ret.EnsureValid(); return ret._value; }
        private Csharp.Library.S1 _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_double_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator double(return_double_error ret) { ret.EnsureValid(); return ret._value; }
        private double _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_C1_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator IntPtr(return_C1_error ret) { ret.EnsureValid(); return ret._value; }
        private IntPtr _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_Csharp_Library_C1_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator IntPtr(return_Csharp_Library_C1_error ret) { ret.EnsureValid(); return ret._value; }
        private IntPtr _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_ulong_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator ulong(return_ulong_error ret) { ret.EnsureValid(); return ret._value; }
        private ulong _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_sbyte_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator sbyte(return_sbyte_error ret) { ret.EnsureValid(); return ret._value; }
        private sbyte _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_Csharp_Library_S2_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator Csharp.Library.S2(return_Csharp_Library_S2_error ret) { ret.EnsureValid(); return ret._value; }
        private Csharp.Library.S2 _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_float_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator float(return_float_error ret) { ret.EnsureValid(); return ret._value; }
        private float _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    internal static class SharedFunctions {
        static SharedFunctions() {
            Stream stream = null;
            var outputName = RuntimeInformation.IsOSPlatform(OSPlatform.OSX) ? "libcsharp.dylib" : RuntimeInformation.IsOSPlatform(OSPlatform.Linux) ? "libcsharp.so" : "csharp.dll";

            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("csharp.libcsharp.dylib");
            }
            if (Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("csharp.libcsharp.x64.so");
            }
            if (!Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("csharp.libcsharp.x86.so");
            }
            if (Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Windows)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("csharp.csharp.x64.dll");
            }
            if (!Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Windows)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("csharp.csharp.x86.dll");
            }
            if (stream != null) {
                using(var file = new FileStream(outputName, FileMode.OpenOrCreate, FileAccess.Write)) {
                    stream.CopyTo(file);
                    if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                        var ufi = new UnixFileInfo(outputName);
                        ufi.FileAccessPermissions |= FileAccessPermissions.UserExecute | FileAccessPermissions.GroupExecute | FileAccessPermissions.OtherExecute; 
                    }
                }
            } else {
                throw new DllNotFoundException($"The required native assembly is unavailable for the current operating system and process architecture.");
            }

            DRuntimeInitialize();
        }

        internal static string SliceToString(slice str, DStringType type) {
            unsafe {
                var bytes = (byte*)str.ptr.ToPointer();
                if (bytes == null) {
                    return null;
                }
                if (type == DStringType._string) {
                    return System.Text.Encoding.UTF8.GetString(bytes, str.length.ToInt32()*(int)type);
                } else if (type == DStringType._wstring) {
                    return System.Text.Encoding.Unicode.GetString(bytes, str.length.ToInt32()*(int)type);
                } else if (type == DStringType._dstring) {
                    return System.Text.Encoding.UTF32.GetString(bytes, str.length.ToInt32()*(int)type);
                } else {
                    throw new UnauthorizedAccessException("Unable to convert D string to C# string: Unrecognized string type.");
                }
            }
        }

        // Support Functions
        [DllImport("csharp", EntryPoint = "autowrap_csharp_createString", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice CreateString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "autowrap_csharp_createWString", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice CreateWstring([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "autowrap_csharp_createDString", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice CreateDstring([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "autowrap_csharp_release", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void ReleaseMemory(IntPtr ptr);

        [DllImport("csharp", EntryPoint = "rt_init", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeInitialize();

        [DllImport("csharp", EntryPoint = "rt_term", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeTerminate();
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    internal class RangeFunctions {
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Bool_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Bool_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Bool_Get", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.Bool)]
        internal static extern return_bool_error Bool_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Bool_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Bool_Set(slice dslice, IntPtr index, [MarshalAs(UnmanagedType.Bool)] bool value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Bool_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Bool_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Bool_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Bool_AppendValue(slice dslice, [MarshalAs(UnmanagedType.Bool)] bool value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Bool_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Bool_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_String_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error String_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_String_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error String_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_String_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error String_Set(slice dslice, IntPtr index, slice value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_String_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error String_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_String_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error String_AppendValue(slice dslice, slice value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_String_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error String_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Wstring_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Wstring_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Wstring_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Wstring_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Wstring_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Wstring_Set(slice dslice, IntPtr index, slice value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Wstring_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Wstring_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Wstring_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Wstring_AppendValue(slice dslice, slice value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Wstring_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Wstring_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Dstring_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Dstring_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Dstring_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Dstring_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Dstring_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Dstring_Set(slice dslice, IntPtr index, slice value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Dstring_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Dstring_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Dstring_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Dstring_AppendValue(slice dslice, slice value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Dstring_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Dstring_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Byte_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Byte_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Byte_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Byte_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Byte_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Byte_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Byte_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_sbyte_error Byte_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Byte_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Byte_Set(slice dslice, IntPtr index, sbyte value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Byte_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Byte_AppendValue(slice dslice, sbyte value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ubyte_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ubyte_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ubyte_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ubyte_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ubyte_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ubyte_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ubyte_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_byte_error Ubyte_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ubyte_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Ubyte_Set(slice dslice, IntPtr index, byte value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ubyte_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ubyte_AppendValue(slice dslice, byte value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Short_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Short_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Short_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Short_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Short_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Short_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Short_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_short_error Short_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Short_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Short_Set(slice dslice, IntPtr index, short value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Short_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Short_AppendValue(slice dslice, short value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ushort_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ushort_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ushort_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ushort_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ushort_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ushort_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ushort_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_ushort_error Ushort_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ushort_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Ushort_Set(slice dslice, IntPtr index, ushort value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ushort_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ushort_AppendValue(slice dslice, ushort value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Int_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Int_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Int_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Int_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Int_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Int_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Int_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_int_error Int_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Int_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Int_Set(slice dslice, IntPtr index, int value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Int_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Int_AppendValue(slice dslice, int value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Uint_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Uint_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Uint_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Uint_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Uint_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Uint_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Uint_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_uint_error Uint_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Uint_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Uint_Set(slice dslice, IntPtr index, uint value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Uint_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Uint_AppendValue(slice dslice, uint value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Long_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Long_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Long_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Long_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Long_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Long_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Long_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_long_error Long_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Long_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Long_Set(slice dslice, IntPtr index, long value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Long_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Long_AppendValue(slice dslice, long value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ulong_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ulong_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ulong_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ulong_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ulong_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ulong_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ulong_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_ulong_error Ulong_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ulong_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Ulong_Set(slice dslice, IntPtr index, ulong value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ulong_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ulong_AppendValue(slice dslice, ulong value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Float_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Float_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Float_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Float_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Float_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Float_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Float_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_float_error Float_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Float_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Float_Set(slice dslice, IntPtr index, float value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Float_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Float_AppendValue(slice dslice, float value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Double_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Double_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Double_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Double_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Double_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Double_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Double_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_double_error Double_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Double_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Double_Set(slice dslice, IntPtr index, double value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Double_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Double_AppendValue(slice dslice, double value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S1_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Csharp_library_s1_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S1_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Csharp_library_s1_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S1_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Csharp_library_s1_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S1_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_Csharp_Library_S1_error Csharp_library_s1_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S1_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Csharp_library_s1_Set(slice dslice, IntPtr index, Csharp.Library.S1 value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S1_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Csharp_library_s1_AppendValue(slice dslice, Csharp.Library.S1 value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S2_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Csharp_library_s2_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S2_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Csharp_library_s2_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S2_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Csharp_library_s2_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S2_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_Csharp_Library_S2_error Csharp_library_s2_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S2_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Csharp_library_s2_Set(slice dslice, IntPtr index, Csharp.Library.S2 value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S2_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Csharp_library_s2_AppendValue(slice dslice, Csharp.Library.S2 value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_C1_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Csharp_library_c1_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_C1_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Csharp_library_c1_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_C1_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Csharp_library_c1_AppendSlice(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_C1_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_Csharp_Library_C1_error Csharp_library_c1_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_C1_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Csharp_library_c1_Set(slice dslice, IntPtr index, IntPtr value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_C1_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Csharp_library_c1_AppendValue(slice dslice, IntPtr value);

    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    public class Range<T> : IEnumerable<T> {
        private slice _slice;
        private DStringType _type;
        private IList<string> _strings;

        internal slice ToSlice(DStringType type = DStringType.None) {
            if (type == DStringType.None && _strings != null) {
                throw new TypeAccessException("Cannot pass a range of strings to a non-string range.");
            }

            if (_strings == null) {
                return _slice;
            } else {
                _type = type;
                if (_type == DStringType._string) {
                    _slice = RangeFunctions.String_Create(new IntPtr(_strings.Count()));
                    foreach(var s in _strings) {
                        _slice = RangeFunctions.String_AppendValue(_slice, SharedFunctions.CreateString(s));
                    }
                } else if (_type == DStringType._wstring) {
                    _slice = RangeFunctions.Wstring_Create(new IntPtr(_strings.Count()));
                    foreach(var s in _strings) {
                        _slice = RangeFunctions.Wstring_AppendValue(_slice, SharedFunctions.CreateWstring(s));
                    }
                } else if (_type == DStringType._dstring) {
                    _slice = RangeFunctions.Dstring_Create(new IntPtr(_strings.Count()));
                    foreach(var s in _strings) {
                        _slice = RangeFunctions.Dstring_AppendValue(_slice, SharedFunctions.CreateDstring(s));
                    }
                }
                _strings = null;
                return _slice;
            }
        }
        public long Length => _strings?.Count ?? _slice.length.ToInt64();

        internal Range(slice range, DStringType type = DStringType.None) {
            this._slice = range;
            this._type = type;
        }

        public Range(IEnumerable<string> strings) {
            this._strings = new List<string>(strings);
        }

        public Range(long capacity = 0) {
            if (typeof(T) == typeof(bool)) this._slice = RangeFunctions.Bool_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(sbyte)) this._slice = RangeFunctions.Byte_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(byte)) this._slice = RangeFunctions.Ubyte_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(short)) this._slice = RangeFunctions.Short_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(ushort)) this._slice = RangeFunctions.Ushort_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(int)) this._slice = RangeFunctions.Int_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(uint)) this._slice = RangeFunctions.Uint_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(long)) this._slice = RangeFunctions.Long_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(ulong)) this._slice = RangeFunctions.Ulong_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(float)) this._slice = RangeFunctions.Float_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(double)) this._slice = RangeFunctions.Double_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(Csharp.Library.S1)) this._slice = RangeFunctions.Csharp_library_s1_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(Csharp.Library.S2)) this._slice = RangeFunctions.Csharp_library_s2_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(Csharp.Library.C1)) this._slice = RangeFunctions.Csharp_library_c1_Create(new IntPtr(capacity));

            else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
        }
        ~Range() {
            SharedFunctions.ReleaseMemory(_slice.ptr);
        }
        public T this[long i] {
            get {
                if (typeof(T) == typeof(bool)) return (T)(object)RangeFunctions.Bool_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) return (T)(object)_strings[(int)i];
                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._string) return (T)(object)SharedFunctions.SliceToString(RangeFunctions.String_Get(_slice, new IntPtr(i)), DStringType._string);
                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._wstring) return (T)(object)SharedFunctions.SliceToString(RangeFunctions.Wstring_Get(_slice, new IntPtr(i)), DStringType._wstring);
                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._dstring) return (T)(object)SharedFunctions.SliceToString(RangeFunctions.Dstring_Get(_slice, new IntPtr(i)), DStringType._dstring);
                else if (typeof(T) == typeof(sbyte)) return (T)(object)(sbyte)RangeFunctions.Byte_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(byte)) return (T)(object)(byte)RangeFunctions.Ubyte_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(short)) return (T)(object)(short)RangeFunctions.Short_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(ushort)) return (T)(object)(ushort)RangeFunctions.Ushort_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(int)) return (T)(object)(int)RangeFunctions.Int_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(uint)) return (T)(object)(uint)RangeFunctions.Uint_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(long)) return (T)(object)(long)RangeFunctions.Long_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(ulong)) return (T)(object)(ulong)RangeFunctions.Ulong_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(float)) return (T)(object)(float)RangeFunctions.Float_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(double)) return (T)(object)(double)RangeFunctions.Double_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Csharp.Library.S1)) return (T)(object)(Csharp.Library.S1)RangeFunctions.Csharp_library_s1_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Csharp.Library.S2)) return (T)(object)(Csharp.Library.S2)RangeFunctions.Csharp_library_s2_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Csharp.Library.C1)) return (T)(object)new Csharp.Library.C1(RangeFunctions.Csharp_library_c1_Get(_slice, new IntPtr(i)));

                else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
            }
            set {
                if (typeof(T) == typeof(bool)) RangeFunctions.Bool_Set(_slice, new IntPtr(i), (bool)(object)value);
                else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) _strings[(int)i] = (string)(object)value;
                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._string) RangeFunctions.String_Set(_slice, new IntPtr(i), SharedFunctions.CreateString((string)(object)value));
                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._wstring) RangeFunctions.Wstring_Set(_slice, new IntPtr(i), SharedFunctions.CreateWstring((string)(object)value));
                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._dstring) RangeFunctions.Dstring_Set(_slice, new IntPtr(i), SharedFunctions.CreateDstring((string)(object)value));
                else if (typeof(T) == typeof(sbyte)) RangeFunctions.Byte_Set(_slice, new IntPtr(i), (sbyte)(object)value);
                else if (typeof(T) == typeof(byte)) RangeFunctions.Ubyte_Set(_slice, new IntPtr(i), (byte)(object)value);
                else if (typeof(T) == typeof(short)) RangeFunctions.Short_Set(_slice, new IntPtr(i), (short)(object)value);
                else if (typeof(T) == typeof(ushort)) RangeFunctions.Ushort_Set(_slice, new IntPtr(i), (ushort)(object)value);
                else if (typeof(T) == typeof(int)) RangeFunctions.Int_Set(_slice, new IntPtr(i), (int)(object)value);
                else if (typeof(T) == typeof(uint)) RangeFunctions.Uint_Set(_slice, new IntPtr(i), (uint)(object)value);
                else if (typeof(T) == typeof(long)) RangeFunctions.Long_Set(_slice, new IntPtr(i), (long)(object)value);
                else if (typeof(T) == typeof(ulong)) RangeFunctions.Ulong_Set(_slice, new IntPtr(i), (ulong)(object)value);
                else if (typeof(T) == typeof(float)) RangeFunctions.Float_Set(_slice, new IntPtr(i), (float)(object)value);
                else if (typeof(T) == typeof(double)) RangeFunctions.Double_Set(_slice, new IntPtr(i), (double)(object)value);
                else if (typeof(T) == typeof(Csharp.Library.S1)) RangeFunctions.Csharp_library_s1_Set(_slice, new IntPtr(i), (Csharp.Library.S1)(object)value);
                else if (typeof(T) == typeof(Csharp.Library.S2)) RangeFunctions.Csharp_library_s2_Set(_slice, new IntPtr(i), (Csharp.Library.S2)(object)value);
                else if (typeof(T) == typeof(Csharp.Library.C1)) RangeFunctions.Csharp_library_c1_Set(_slice, new IntPtr(i), ((DLangObject)(object)value).DLangPointer);

            }
        }
        public Range<T> Slice(long begin) {
            if (typeof(T) == typeof(bool)) return new Range<T>(RangeFunctions.Bool_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) return new Range<T>(_strings.Skip((int)begin));
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._string) return new Range<T>(RangeFunctions.String_Slice(_slice, new IntPtr(begin), _slice.length), _type);
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._wstring) return new Range<T>(RangeFunctions.Wstring_Slice(_slice, new IntPtr(begin), _slice.length), _type);
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._dstring) return new Range<T>(RangeFunctions.Dstring_Slice(_slice, new IntPtr(begin), _slice.length), _type);
            else if (typeof(T) == typeof(sbyte)) return new Range<T>(RangeFunctions.Byte_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(byte)) return new Range<T>(RangeFunctions.Ubyte_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(short)) return new Range<T>(RangeFunctions.Short_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(ushort)) return new Range<T>(RangeFunctions.Ushort_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(int)) return new Range<T>(RangeFunctions.Int_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(uint)) return new Range<T>(RangeFunctions.Uint_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(long)) return new Range<T>(RangeFunctions.Long_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(ulong)) return new Range<T>(RangeFunctions.Ulong_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(float)) return new Range<T>(RangeFunctions.Float_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(double)) return new Range<T>(RangeFunctions.Double_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(Csharp.Library.S1)) return new Range<T>(RangeFunctions.Csharp_library_s1_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(Csharp.Library.S2)) return new Range<T>(RangeFunctions.Csharp_library_s2_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(Csharp.Library.C1)) return new Range<T>(RangeFunctions.Csharp_library_c1_Slice(_slice, new IntPtr(begin), _slice.length));

            else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
        }
        public Range<T> Slice(long begin, long end) {
            if (end > _slice.length.ToInt64()) {
                throw new IndexOutOfRangeException("Value for parameter 'end' is greater than that length of the slice.");
            }
            if (typeof(T) == typeof(bool)) return new Range<T>(RangeFunctions.Bool_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) return new Range<T>(_strings.Skip((int)begin));
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._string) return new Range<T>(RangeFunctions.String_Slice(_slice, new IntPtr(begin), new IntPtr(end)), _type);
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._wstring) return new Range<T>(RangeFunctions.Wstring_Slice(_slice, new IntPtr(begin), new IntPtr(end)), _type);
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._dstring) return new Range<T>(RangeFunctions.Dstring_Slice(_slice, new IntPtr(begin), new IntPtr(end)), _type);
            else if (typeof(T) == typeof(sbyte)) return new Range<T>(RangeFunctions.Byte_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(byte)) return new Range<T>(RangeFunctions.Ubyte_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(short)) return new Range<T>(RangeFunctions.Short_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(ushort)) return new Range<T>(RangeFunctions.Ushort_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(int)) return new Range<T>(RangeFunctions.Int_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(uint)) return new Range<T>(RangeFunctions.Uint_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(long)) return new Range<T>(RangeFunctions.Long_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(ulong)) return new Range<T>(RangeFunctions.Ulong_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(float)) return new Range<T>(RangeFunctions.Float_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(double)) return new Range<T>(RangeFunctions.Double_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(Csharp.Library.S1)) return new Range<T>(RangeFunctions.Csharp_library_s1_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(Csharp.Library.S2)) return new Range<T>(RangeFunctions.Csharp_library_s2_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(Csharp.Library.C1)) return new Range<T>(RangeFunctions.Csharp_library_c1_Slice(_slice, new IntPtr(begin), new IntPtr(end)));

            else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
        }
        public static Range<T> operator +(Range<T> range, T value) {
            if (typeof(T) == typeof(bool)) { range._slice = RangeFunctions.Bool_AppendValue(range._slice, (bool)(object)value); return range; }
            else if (typeof(T) == typeof(string) && range._strings != null && range._type == DStringType.None) { range._strings.Add((string)(object)value); return range; }
            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._string) { range._slice = RangeFunctions.String_AppendValue(range._slice, SharedFunctions.CreateString((string)(object)value)); return range; }
            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._wstring) { range._slice = RangeFunctions.Wstring_AppendValue(range._slice, SharedFunctions.CreateWstring((string)(object)value)); return range; }
            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._dstring) { range._slice = RangeFunctions.Dstring_AppendValue(range._slice, SharedFunctions.CreateDstring((string)(object)value)); return range; }
            else if (typeof(T) == typeof(sbyte)) { range._slice = RangeFunctions.Byte_AppendValue(range._slice, (sbyte)(object)value); return range; }
            else if (typeof(T) == typeof(byte)) { range._slice = RangeFunctions.Ubyte_AppendValue(range._slice, (byte)(object)value); return range; }
            else if (typeof(T) == typeof(short)) { range._slice = RangeFunctions.Short_AppendValue(range._slice, (short)(object)value); return range; }
            else if (typeof(T) == typeof(ushort)) { range._slice = RangeFunctions.Ushort_AppendValue(range._slice, (ushort)(object)value); return range; }
            else if (typeof(T) == typeof(int)) { range._slice = RangeFunctions.Int_AppendValue(range._slice, (int)(object)value); return range; }
            else if (typeof(T) == typeof(uint)) { range._slice = RangeFunctions.Uint_AppendValue(range._slice, (uint)(object)value); return range; }
            else if (typeof(T) == typeof(long)) { range._slice = RangeFunctions.Long_AppendValue(range._slice, (long)(object)value); return range; }
            else if (typeof(T) == typeof(ulong)) { range._slice = RangeFunctions.Ulong_AppendValue(range._slice, (ulong)(object)value); return range; }
            else if (typeof(T) == typeof(float)) { range._slice = RangeFunctions.Float_AppendValue(range._slice, (float)(object)value); return range; }
            else if (typeof(T) == typeof(double)) { range._slice = RangeFunctions.Double_AppendValue(range._slice, (double)(object)value); return range; }
            else if (typeof(T) == typeof(Csharp.Library.S1)) { range._slice = RangeFunctions.Csharp_library_s1_AppendValue(range._slice, (Csharp.Library.S1)(object)value); return range; }
            else if (typeof(T) == typeof(Csharp.Library.S2)) { range._slice = RangeFunctions.Csharp_library_s2_AppendValue(range._slice, (Csharp.Library.S2)(object)value); return range; }
            else if (typeof(T) == typeof(Csharp.Library.C1)) { range._slice = RangeFunctions.Csharp_library_c1_AppendValue(range._slice, ((DLangObject)(object)value).DLangPointer); return range; }

            else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
        }
        public static Range<T> operator +(Range<T> range, Range<T> source) {
            if (typeof(T) == typeof(bool)) { range._slice = RangeFunctions.Bool_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(string) && range._strings != null && range._type == DStringType.None) { foreach(T s in source) range._strings.Add((string)(object)s); return range; }
            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._string) { range._slice = RangeFunctions.String_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._wstring) { range._slice = RangeFunctions.Wstring_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._dstring) { range._slice = RangeFunctions.Dstring_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(sbyte)) { range._slice = RangeFunctions.Byte_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(byte)) { range._slice = RangeFunctions.Ubyte_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(short)) { range._slice = RangeFunctions.Short_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(ushort)) { range._slice = RangeFunctions.Ushort_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(int)) { range._slice = RangeFunctions.Int_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(uint)) { range._slice = RangeFunctions.Uint_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(long)) { range._slice = RangeFunctions.Long_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(ulong)) { range._slice = RangeFunctions.Ulong_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(float)) { range._slice = RangeFunctions.Float_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(double)) { range._slice = RangeFunctions.Double_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(Csharp.Library.S1)) { range._slice = RangeFunctions.Csharp_library_s1_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(Csharp.Library.S2)) { range._slice = RangeFunctions.Csharp_library_s2_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(Csharp.Library.C1)) { range._slice = RangeFunctions.Csharp_library_c1_AppendSlice(range._slice, source._slice); return range; }

            else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
        }
        public IEnumerator<T> GetEnumerator() {
            for(long i = 0; i < _slice.length.ToInt64(); i++) {
                if (typeof(T) == typeof(bool)) yield return (T)(object)RangeFunctions.Bool_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) yield return (T)(object)_strings[(int)i];
                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._string) yield return (T)(object)SharedFunctions.SliceToString(RangeFunctions.String_Get(_slice, new IntPtr(i)), DStringType._string);
                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._wstring) yield return (T)(object)SharedFunctions.SliceToString(RangeFunctions.Wstring_Get(_slice, new IntPtr(i)), DStringType._wstring);
                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._dstring) yield return (T)(object)SharedFunctions.SliceToString(RangeFunctions.Dstring_Get(_slice, new IntPtr(i)), DStringType._dstring);
                else if (typeof(T) == typeof(sbyte)) yield return (T)(object)(sbyte)RangeFunctions.Byte_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(byte)) yield return (T)(object)(byte)RangeFunctions.Ubyte_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(short)) yield return (T)(object)(short)RangeFunctions.Short_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(ushort)) yield return (T)(object)(ushort)RangeFunctions.Ushort_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(int)) yield return (T)(object)(int)RangeFunctions.Int_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(uint)) yield return (T)(object)(uint)RangeFunctions.Uint_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(long)) yield return (T)(object)(long)RangeFunctions.Long_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(ulong)) yield return (T)(object)(ulong)RangeFunctions.Ulong_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(float)) yield return (T)(object)(float)RangeFunctions.Float_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(double)) yield return (T)(object)(double)RangeFunctions.Double_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Csharp.Library.S1)) yield return (T)(object)(Csharp.Library.S1)RangeFunctions.Csharp_library_s1_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Csharp.Library.S2)) yield return (T)(object)(Csharp.Library.S2)RangeFunctions.Csharp_library_s2_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Csharp.Library.C1)) yield return (T)(object)new Csharp.Library.C1(RangeFunctions.Csharp_library_c1_Get(_slice, new IntPtr(i)));

            }
        }
        public static implicit operator T[](Range<T> slice) {
            return slice.ToArray();
        }
        public static implicit operator Range<T>(T[] array) {
            var vs = new Range<T>(array.Length);
            foreach(var t in array) {
                vs += t;
            }
            return vs;
        }
        public static implicit operator List<T>(Range<T> slice) {
            return new List<T>(slice.ToArray());
        }
        public static implicit operator Range<T>(List<T> array) {
            var vs = new Range<T>(array.Count);
            foreach(var t in array) {
                vs += t;
            }
            return vs;
        }
        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => this.GetEnumerator();
    }}
