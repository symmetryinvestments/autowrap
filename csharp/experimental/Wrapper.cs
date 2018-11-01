namespace Csharp.Library {
    using System;
    using System.Collections;
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
            if (!string.IsNullOrEmpty(dlang_ret.error)) throw new DLangException(dlang_ret.error);
            return dlang_ret.value;
        }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_StringFunction", CallingConvention = CallingConvention.Cdecl)]
        private static extern dstring dlang_StringFunction(dstring value);
        public static string StringFunction(string value) {
            var dlang_ret = dlang_StringFunction(value);
            return dlang_ret;
        }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_ArrayFunction", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_ArrayFunction(slice arr);
        public static ValueSlice<Csharp.Library.S2> ArrayFunction(ValueSlice<Csharp.Library.S2> arr) {
            var dlang_ret = dlang_ArrayFunction(arr.ToSlice());
            if (!string.IsNullOrEmpty(dlang_ret.error)) throw new DLangException(dlang_ret.error);
            return new ValueSlice<Csharp.Library.S2>(dlang_ret.value);
        }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_ClassRangeFunction", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_ClassRangeFunction(slice arr);
        public static RefSlice<Csharp.Library.C1> ClassRangeFunction(RefSlice<Csharp.Library.C1> arr) {
            var dlang_ret = dlang_ClassRangeFunction(arr.ToSlice());
            if (!string.IsNullOrEmpty(dlang_ret.error)) throw new DLangException(dlang_ret.error);
            return new RefSlice<Csharp.Library.C1>(dlang_ret.value);
        }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_TestErrorMessage", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_dstring_error dlang_TestErrorMessage([MarshalAs(UnmanagedType.Bool)]bool throwError);
        public static string TestErrorMessage(bool throwError) {
            var dlang_ret = dlang_TestErrorMessage(throwError);
            if (!string.IsNullOrEmpty(dlang_ret.error)) throw new DLangException(dlang_ret.error);
            return dlang_ret.value;
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct S2 {
        public int Value;
        public string Str;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct S1 {
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_S1_GetValue", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_float_error dlang_S1_GetValue(ref Csharp.Library.S1 __obj__);
        public float GetValue() {
            var dlang_ret = dlang_S1_GetValue(ref this);
            if (!string.IsNullOrEmpty(dlang_ret.error)) throw new DLangException(dlang_ret.error);
            return dlang_ret.value;
        }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_S1_SetNestedStruct", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_void_error dlang_S1_SetNestedStruct(ref Csharp.Library.S1 __obj__, Csharp.Library.S2 nested);
        public void SetNestedStruct(Csharp.Library.S2 nested) {
            var dlang_ret = dlang_S1_SetNestedStruct(ref this, nested);
            if (!string.IsNullOrEmpty(dlang_ret.error)) throw new DLangException(dlang_ret.error);
        }

        public float Value;
        public Csharp.Library.S2 NestedStruct;
    }

    public class C1 : DLangObject {
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1___ctor", CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr dlang_C1___ctor(int i, dstring s);
        public C1(int i, string s) : base(dlang_C1___ctor(i, s)) { }
        private C1(IntPtr ptr) : base(ptr) { }

        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StructProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_csharp_library_s2_error dlang_C1_StructProperty(IntPtr __obj__);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StructProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_csharp_library_s2_error dlang_C1_StructProperty(IntPtr __obj__, Csharp.Library.S2 value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_RefProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_csharp_library_c1_error dlang_C1_RefProperty(IntPtr __obj__);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_RefProperty", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_csharp_library_c1_error dlang_C1_RefProperty(IntPtr __obj__, Csharp.Library.C1 value);
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
        private static extern return_dstring_error dlang_C1_TestMemberFunc(IntPtr __obj__, dstring test, Csharp.Library.S1 value);
        public string TestMemberFunc(string test, Csharp.Library.S1 value) {
            var dlang_ret = dlang_C1_TestMemberFunc(DLangPointer, test, value);
            if (!string.IsNullOrEmpty(dlang_ret.error)) throw new DLangException(dlang_ret.error);
            return dlang_ret.value;
        }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_ToString", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_dstring_error dlang_C1_ToString(IntPtr __obj__);
        public override string ToString() {
            var dlang_ret = dlang_C1_ToString(DLangPointer);
            if (!string.IsNullOrEmpty(dlang_ret.error)) throw new DLangException(dlang_ret.error);
            return dlang_ret.value;
        }

        public Csharp.Library.S2 StructProperty { get => dlang_C1_StructProperty(DLangPointer).value; set => dlang_C1_StructProperty(DLangPointer, value); }
        public Csharp.Library.C1 RefProperty { get => dlang_C1_RefProperty(DLangPointer).value; set => dlang_C1_RefProperty(DLangPointer, value); }
        public ulong ValueProperty { get => dlang_C1_ValueProperty(DLangPointer).value; set => dlang_C1_ValueProperty(DLangPointer, value); }
        public ValueSlice<ulong> ValueSliceProperty { get => new ValueSlice<ulong>(dlang_C1_ValueSliceProperty(DLangPointer).value); set => dlang_C1_ValueSliceProperty(DLangPointer, value.ToSlice()); }
        public StringSlice StringSliceProperty { get => new StringSlice(dlang_C1_StringSliceProperty(DLangPointer).value); set => dlang_C1_StringSliceProperty(DLangPointer, value.ToSlice()); }
        public StringSlice WstringSliceProperty { get => new StringSlice(dlang_C1_WstringSliceProperty(DLangPointer).value); set => dlang_C1_WstringSliceProperty(DLangPointer, value.ToSlice()); }
        public StringSlice DstringSliceProperty { get => new StringSlice(dlang_C1_DstringSliceProperty(DLangPointer).value); set => dlang_C1_DstringSliceProperty(DLangPointer, value.ToSlice()); }
        public ValueSlice<Csharp.Library.S1> StructSliceProperty { get => new ValueSlice<Csharp.Library.S1>(dlang_C1_StructSliceProperty(DLangPointer).value); set => dlang_C1_StructSliceProperty(DLangPointer, value.ToSlice()); }
        public RefSlice<Csharp.Library.C1> RefSliceProperty { get => new RefSlice<Csharp.Library.C1>(dlang_C1_RefSliceProperty(DLangPointer).value); set => dlang_C1_RefSliceProperty(DLangPointer, value.ToSlice()); }
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
        private static extern dstring dlang_stringMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StringMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_stringMember_set(IntPtr ptr, dstring value);
        public string StringMember { get => dlang_stringMember_get(DLangPointer); set => dlang_stringMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_WstringMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern dstring dlang_wstringMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_WstringMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_wstringMember_set(IntPtr ptr, dstring value);
        public string WstringMember { get => dlang_wstringMember_get(DLangPointer); set => dlang_wstringMember_set(DLangPointer, value); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_DstringMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern dstring dlang_dstringMember_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_DstringMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_dstringMember_set(IntPtr ptr, dstring value);
        public string DstringMember { get => dlang_dstringMember_get(DLangPointer); set => dlang_dstringMember_set(DLangPointer, value); }
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
        public RefSlice<Csharp.Library.C1> RefArray { get => new RefSlice<Csharp.Library.C1>(dlang_refArray_get(DLangPointer)); set => dlang_refArray_set(DLangPointer, value.ToSlice()); }
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StructArray_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern slice dlang_structArray_get(IntPtr ptr);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_Csharp_Library_C1_StructArray_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_structArray_set(IntPtr ptr, slice value);
        public ValueSlice<Csharp.Library.S1> StructArray { get => new ValueSlice<Csharp.Library.S1>(dlang_structArray_get(DLangPointer)); set => dlang_structArray_set(DLangPointer, value.ToSlice()); }
    }

}

namespace Autowrap {
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.InteropServices;
    using Mono.Unix;

    public class DLangException : Exception {
        public string DLangExceptionText { get; }
        public DLangException(string dlang) : base() {
            DLangExceptionText = dlang;
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct dstring {
        private IntPtr length;
        private IntPtr ptr;

        public override string ToString() {
            unsafe {
                return System.Text.Encoding.Unicode.GetString((byte*)ptr.ToPointer(), length.ToInt32()*2);
            }
        }

        public void Release()
        {
            Functions.ReleaseMemory(ptr);
        }

        public static implicit operator string(dstring str)
        {
            return str.ToString();
        }

        public static implicit operator dstring(string str)
        {
            return Functions.CreateString(str);
        }
    }

    internal struct slice : IDisposable {
        internal IntPtr length;
        internal IntPtr ptr;

        public slice(IntPtr ptr, IntPtr length)
        {
            this.ptr = ptr;
            this.length = length;
        }

        public void Dispose()
        {
            Functions.ReleaseMemory(ptr);
        }
    }

    public abstract class DLangObject : IDisposable {
        private readonly IntPtr _ptr;
        internal protected IntPtr DLangPointer => _ptr;

        protected DLangObject(IntPtr ptr) {
            this._ptr = ptr;
        }

        public void Dispose() {
            Functions.ReleaseMemory(_ptr);
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_void_error {
        public dstring error;
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_bool_error {
        [MarshalAs(UnmanagedType.Bool)] public bool value;
        public dstring error;
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_dstring_error {
        public dstring value;
        public dstring error;
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_slice_error {
        public slice value;
        public dstring error;
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_ulong_error {
        public ulong value;
        public dstring error;
    }
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_int_error {
        public int value;
        public dstring error;
    }
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_csharp_library_s2_error {
        public Csharp.Library.S2 value;
        public dstring error;
    }
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_float_error {
        public float value;
        public dstring error;
    }
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_csharp_library_c1_error {
        public Csharp.Library.C1 value;
        public dstring error;
    }

    internal static class Functions {
        static Functions() {
            Stream stream = null;
            var outputName = RuntimeInformation.IsOSPlatform(OSPlatform.OSX) ? "libcsharp.dylib" : RuntimeInformation.IsOSPlatform(OSPlatform.Linux) ? "libcsharp.so" : "csharp.dll";

            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Kaleidic.libcsharp.dylib");
            }
            if (Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Kaleidic.libcsharp.x64.so");
            }
            if (!Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Kaleidic.libcsharp.x86.so");
            }
            if (Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Windows)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Kaleidic.csharp.x64.dll");
            }
            if (!Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Windows)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Kaleidic.csharp.x86.dll");
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
                throw new DllNotFoundException($"The required native assembly was not found for the current operating system and process architecture.");
            }

            DRuntimeInitialize();
        }

        // ValueSlice Functions
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Bool_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_bool_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Bool_Get", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.Bool)]
        internal static extern bool dlang_slice_bool_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Bool_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_bool_Set(slice dslice, IntPtr index, [MarshalAs(UnmanagedType.Bool)] bool value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Bool_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_bool_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Bool_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_bool_Append(slice dslice, [MarshalAs(UnmanagedType.Bool)] bool value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Bool_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_bool_Append(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Dstring_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Dstring_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Dstring_Get", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.Bool)]
        internal static extern dstring dlang_slice_Dstring_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Dstring_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_Dstring_Set(slice dslice, IntPtr index, dstring value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Dstring_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Dstring_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Dstring_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Dstring_Append(slice dslice, dstring value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Dstring_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Dstring_Append(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Byte_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Byte_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Byte_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern sbyte dlang_slice_Byte_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Byte_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_Byte_Set(slice dslice, IntPtr index, sbyte value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Byte_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Byte_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Byte_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Byte_Append(slice dslice, sbyte value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Byte_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Byte_Append(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ubyte_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Ubyte_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ubyte_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern byte dlang_slice_Ubyte_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ubyte_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_Ubyte_Set(slice dslice, IntPtr index, byte value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ubyte_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Ubyte_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ubyte_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Ubyte_Append(slice dslice, byte value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ubyte_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Ubyte_Append(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Short_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Short_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Short_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern short dlang_slice_Short_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Short_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_Short_Set(slice dslice, IntPtr index, short value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Short_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Short_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Short_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Short_Append(slice dslice, short value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Short_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Short_Append(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ushort_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Ushort_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ushort_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern ushort dlang_slice_Ushort_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ushort_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_Ushort_Set(slice dslice, IntPtr index, ushort value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ushort_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Ushort_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ushort_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Ushort_Append(slice dslice, ushort value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ushort_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Ushort_Append(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Int_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Int_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Int_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern int dlang_slice_Int_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Int_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_Int_Set(slice dslice, IntPtr index, int value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Int_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Int_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Int_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Int_Append(slice dslice, int value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Int_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Int_Append(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Uint_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Uint_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Uint_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern uint dlang_slice_Uint_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Uint_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_Uint_Set(slice dslice, IntPtr index, uint value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Uint_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Uint_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Uint_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Uint_Append(slice dslice, uint value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Uint_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Uint_Append(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Long_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Long_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Long_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern long dlang_slice_Long_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Long_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_Long_Set(slice dslice, IntPtr index, long value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Long_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Long_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Long_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Long_Append(slice dslice, long value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Long_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Long_Append(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ulong_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Ulong_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ulong_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern ulong dlang_slice_Ulong_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ulong_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_Ulong_Set(slice dslice, IntPtr index, ulong value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ulong_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Ulong_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ulong_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Ulong_Append(slice dslice, ulong value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Ulong_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Ulong_Append(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Float_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Float_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Float_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern float dlang_slice_Float_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Float_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_Float_Set(slice dslice, IntPtr index, float value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Float_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Float_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Float_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Float_Append(slice dslice, float value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Float_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Float_Append(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Double_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Double_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Double_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern double dlang_slice_Double_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Double_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_Double_Set(slice dslice, IntPtr index, double value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Double_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Double_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Double_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Double_Append(slice dslice, double value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Double_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Double_Append(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S1_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Csharp_library_s1_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S1_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern Csharp.Library.S1 dlang_slice_Csharp_library_s1_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S1_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_Csharp_library_s1_Set(slice dslice, IntPtr index, Csharp.Library.S1 value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S1_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Csharp_library_s1_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S1_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Csharp_library_s1_Append(slice dslice, Csharp.Library.S1 value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S1_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Csharp_library_s1_Append(slice dslice, slice array);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S2_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Csharp_library_s2_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S2_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern Csharp.Library.S2 dlang_slice_Csharp_library_s2_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S2_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_Csharp_library_s2_Set(slice dslice, IntPtr index, Csharp.Library.S2 value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S2_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Csharp_library_s2_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S2_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Csharp_library_s2_Append(slice dslice, Csharp.Library.S2 value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_S2_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Csharp_library_s2_Append(slice dslice, slice array);

        // RefSlice Functions
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_C1_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Csharp_library_c1_Create(IntPtr capacity);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_C1_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern IntPtr dlang_slice_Csharp_library_c1_Get(slice dslice, IntPtr index);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_C1_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void dlang_slice_Csharp_library_c1_Set(slice dslice, IntPtr index, IntPtr value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_C1_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Csharp_library_c1_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_C1_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Csharp_library_c1_Append(slice dslice, IntPtr value);
        [DllImport("csharp", EntryPoint = "autowrap_csharp_slice_Csharp_Library_C1_Append", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice dlang_slice_Csharp_library_c1_Append(slice dslice, slice array);

        // Support Functions
        [DllImport("csharp", EntryPoint = "autowrap_csharp_createString", CallingConvention = CallingConvention.Cdecl)]
        internal static extern dstring CreateString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "autowrap_csharp_release", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void ReleaseMemory(IntPtr ptr);

        [DllImport("csharp", EntryPoint = "rt_init", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeInitialize();  

        [DllImport("csharp", EntryPoint = "rt_term", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeTerminate();  
    }

    public class StringSlice : IEnumerable<string> {
        private readonly slice _slice;
        internal StringSlice(slice dslice) {
            this._slice = dslice;
        }
        internal slice ToSlice() => _slice;
        public long Length => _slice.length.ToInt64();

        public StringSlice(long capacity = 0) {
            this._slice = Functions.dlang_slice_Dstring_Create(new IntPtr(capacity));
        }

        public string this[long i] {
            get {
                return Functions.dlang_slice_Dstring_Get(_slice, new IntPtr(i));
            }
            set {
                Functions.dlang_slice_Dstring_Set(_slice, new IntPtr(i), value);
            }
        }
        public StringSlice Slice(long begin) {
            return new StringSlice(Functions.dlang_slice_Dstring_Slice(_slice, new IntPtr(begin), _slice.length));
        }

        public StringSlice Slice(long begin, long end) {
            if (end > _slice.length.ToInt64()) {
                throw new IndexOutOfRangeException("Value for parameter 'end' is greater than that length of the slice.");
            }
            return new StringSlice(Functions.dlang_slice_Dstring_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
        }

        public static StringSlice operator +(StringSlice dslice, string value) {
            return new StringSlice(Functions.dlang_slice_Dstring_Append(dslice._slice, value));
        }

        public static StringSlice operator +(StringSlice dslice, StringSlice value) {
            return new StringSlice(Functions.dlang_slice_Dstring_Append(dslice._slice, value._slice));
        }

        public IEnumerator<string> GetEnumerator() {
            for(long i = 0; i < _slice.length.ToInt64(); i++) {
                yield return Functions.dlang_slice_Dstring_Get(_slice, new IntPtr(i));
            }
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => this.GetEnumerator();
    }

    public class ValueSlice<T> : IEnumerable<T> where T : struct {
        private readonly slice _slice;
        internal ValueSlice(slice dslice) {
            this._slice = dslice;
        }
        internal slice ToSlice() => _slice;
        public long Length => _slice.length.ToInt64();

        public ValueSlice(long capacity = 0) {
            if (typeof(T) == typeof(bool)) this._slice = Functions.dlang_slice_bool_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(sbyte)) this._slice = Functions.dlang_slice_Byte_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(byte)) this._slice = Functions.dlang_slice_Ubyte_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(short)) this._slice = Functions.dlang_slice_Short_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(ushort)) this._slice = Functions.dlang_slice_Ushort_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(int)) this._slice = Functions.dlang_slice_Int_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(uint)) this._slice = Functions.dlang_slice_Uint_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(long)) this._slice = Functions.dlang_slice_Long_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(ulong)) this._slice = Functions.dlang_slice_Ulong_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(float)) this._slice = Functions.dlang_slice_Float_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(double)) this._slice = Functions.dlang_slice_Double_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(Csharp.Library.S1)) this._slice = Functions.dlang_slice_Csharp_library_s1_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(Csharp.Library.S2)) this._slice = Functions.dlang_slice_Csharp_library_s2_Create(new IntPtr(capacity));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public T this[long i] {
            get {
                if (typeof(T) == typeof(bool)) return (T)(object)Functions.dlang_slice_bool_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(sbyte)) return (T)(object)Functions.dlang_slice_Byte_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(byte)) return (T)(object)Functions.dlang_slice_Ubyte_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(short)) return (T)(object)Functions.dlang_slice_Short_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(ushort)) return (T)(object)Functions.dlang_slice_Ushort_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(int)) return (T)(object)Functions.dlang_slice_Int_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(uint)) return (T)(object)Functions.dlang_slice_Uint_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(long)) return (T)(object)Functions.dlang_slice_Long_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(ulong)) return (T)(object)Functions.dlang_slice_Ulong_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(float)) return (T)(object)Functions.dlang_slice_Float_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(double)) return (T)(object)Functions.dlang_slice_Double_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Csharp.Library.S1)) return (T)(object)Functions.dlang_slice_Csharp_library_s1_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Csharp.Library.S2)) return (T)(object)Functions.dlang_slice_Csharp_library_s2_Get(_slice, new IntPtr(i));
                throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
            }
            set {
                if (typeof(T) == typeof(bool)) Functions.dlang_slice_bool_Set(_slice, new IntPtr(i), (bool)(object)value);
                else if (typeof(T) == typeof(sbyte)) Functions.dlang_slice_Byte_Set(_slice, new IntPtr(i), (sbyte)(object)value);
                else if (typeof(T) == typeof(byte)) Functions.dlang_slice_Ubyte_Set(_slice, new IntPtr(i), (byte)(object)value);
                else if (typeof(T) == typeof(short)) Functions.dlang_slice_Short_Set(_slice, new IntPtr(i), (short)(object)value);
                else if (typeof(T) == typeof(ushort)) Functions.dlang_slice_Ushort_Set(_slice, new IntPtr(i), (ushort)(object)value);
                else if (typeof(T) == typeof(int)) Functions.dlang_slice_Int_Set(_slice, new IntPtr(i), (int)(object)value);
                else if (typeof(T) == typeof(uint)) Functions.dlang_slice_Uint_Set(_slice, new IntPtr(i), (uint)(object)value);
                else if (typeof(T) == typeof(long)) Functions.dlang_slice_Long_Set(_slice, new IntPtr(i), (long)(object)value);
                else if (typeof(T) == typeof(ulong)) Functions.dlang_slice_Ulong_Set(_slice, new IntPtr(i), (ulong)(object)value);
                else if (typeof(T) == typeof(float)) Functions.dlang_slice_Float_Set(_slice, new IntPtr(i), (float)(object)value);
                else if (typeof(T) == typeof(double)) Functions.dlang_slice_Double_Set(_slice, new IntPtr(i), (double)(object)value);
                else if (typeof(T) == typeof(Csharp.Library.S1)) Functions.dlang_slice_Csharp_library_s1_Set(_slice, new IntPtr(i), (Csharp.Library.S1)(object)value);
                else if (typeof(T) == typeof(Csharp.Library.S2)) Functions.dlang_slice_Csharp_library_s2_Set(_slice, new IntPtr(i), (Csharp.Library.S2)(object)value);
            }
        }
        public ValueSlice<T> Slice(long begin) {
            if (typeof(T) == typeof(bool)) return new ValueSlice<T>(Functions.dlang_slice_bool_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(sbyte)) return new ValueSlice<T>(Functions.dlang_slice_Byte_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(byte)) return new ValueSlice<T>(Functions.dlang_slice_Ubyte_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(short)) return new ValueSlice<T>(Functions.dlang_slice_Short_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(ushort)) return new ValueSlice<T>(Functions.dlang_slice_Ushort_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(int)) return new ValueSlice<T>(Functions.dlang_slice_Int_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(uint)) return new ValueSlice<T>(Functions.dlang_slice_Uint_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(long)) return new ValueSlice<T>(Functions.dlang_slice_Long_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(ulong)) return new ValueSlice<T>(Functions.dlang_slice_Ulong_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(float)) return new ValueSlice<T>(Functions.dlang_slice_Float_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(double)) return new ValueSlice<T>(Functions.dlang_slice_Double_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(Csharp.Library.S1)) return new ValueSlice<T>(Functions.dlang_slice_Csharp_library_s1_Slice(_slice, new IntPtr(begin), _slice.length));
            else if (typeof(T) == typeof(Csharp.Library.S2)) return new ValueSlice<T>(Functions.dlang_slice_Csharp_library_s2_Slice(_slice, new IntPtr(begin), _slice.length));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public ValueSlice<T> Slice(long begin, long end) {
            if (end > _slice.length.ToInt64()) {
                throw new IndexOutOfRangeException("Value for parameter 'end' is greater than that length of the slice.");
            }
            if (typeof(T) == typeof(bool)) return new ValueSlice<T>(Functions.dlang_slice_bool_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(sbyte)) return new ValueSlice<T>(Functions.dlang_slice_Byte_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(byte)) return new ValueSlice<T>(Functions.dlang_slice_Ubyte_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(short)) return new ValueSlice<T>(Functions.dlang_slice_Short_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(ushort)) return new ValueSlice<T>(Functions.dlang_slice_Ushort_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(int)) return new ValueSlice<T>(Functions.dlang_slice_Int_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(uint)) return new ValueSlice<T>(Functions.dlang_slice_Uint_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(long)) return new ValueSlice<T>(Functions.dlang_slice_Long_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(ulong)) return new ValueSlice<T>(Functions.dlang_slice_Ulong_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(float)) return new ValueSlice<T>(Functions.dlang_slice_Float_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(double)) return new ValueSlice<T>(Functions.dlang_slice_Double_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(Csharp.Library.S1)) return new ValueSlice<T>(Functions.dlang_slice_Csharp_library_s1_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            else if (typeof(T) == typeof(Csharp.Library.S2)) return new ValueSlice<T>(Functions.dlang_slice_Csharp_library_s2_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public static ValueSlice<T> operator +(ValueSlice<T> dslice, T value) {
            if (typeof(T) == typeof(bool)) return new ValueSlice<T>(Functions.dlang_slice_bool_Append(dslice._slice, (bool)(object)value));
            else if (typeof(T) == typeof(sbyte)) return new ValueSlice<T>(Functions.dlang_slice_Byte_Append(dslice._slice, (sbyte)(object)value));
            else if (typeof(T) == typeof(byte)) return new ValueSlice<T>(Functions.dlang_slice_Ubyte_Append(dslice._slice, (byte)(object)value));
            else if (typeof(T) == typeof(short)) return new ValueSlice<T>(Functions.dlang_slice_Short_Append(dslice._slice, (short)(object)value));
            else if (typeof(T) == typeof(ushort)) return new ValueSlice<T>(Functions.dlang_slice_Ushort_Append(dslice._slice, (ushort)(object)value));
            else if (typeof(T) == typeof(int)) return new ValueSlice<T>(Functions.dlang_slice_Int_Append(dslice._slice, (int)(object)value));
            else if (typeof(T) == typeof(uint)) return new ValueSlice<T>(Functions.dlang_slice_Uint_Append(dslice._slice, (uint)(object)value));
            else if (typeof(T) == typeof(long)) return new ValueSlice<T>(Functions.dlang_slice_Long_Append(dslice._slice, (long)(object)value));
            else if (typeof(T) == typeof(ulong)) return new ValueSlice<T>(Functions.dlang_slice_Ulong_Append(dslice._slice, (ulong)(object)value));
            else if (typeof(T) == typeof(float)) return new ValueSlice<T>(Functions.dlang_slice_Float_Append(dslice._slice, (float)(object)value));
            else if (typeof(T) == typeof(double)) return new ValueSlice<T>(Functions.dlang_slice_Double_Append(dslice._slice, (double)(object)value));
            else if (typeof(T) == typeof(Csharp.Library.S1)) return new ValueSlice<T>(Functions.dlang_slice_Csharp_library_s1_Append(dslice._slice, (Csharp.Library.S1)(object)value));
            else if (typeof(T) == typeof(Csharp.Library.S2)) return new ValueSlice<T>(Functions.dlang_slice_Csharp_library_s2_Append(dslice._slice, (Csharp.Library.S2)(object)value));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public static ValueSlice<T> operator +(ValueSlice<T> dslice, ValueSlice<T> value) {
            if (typeof(T) == typeof(bool)) return new ValueSlice<T>(Functions.dlang_slice_bool_Append(dslice._slice, value._slice));
            else if (typeof(T) == typeof(sbyte)) return new ValueSlice<T>(Functions.dlang_slice_Byte_Append(dslice._slice, value._slice));
            else if (typeof(T) == typeof(byte)) return new ValueSlice<T>(Functions.dlang_slice_Ubyte_Append(dslice._slice, value._slice));
            else if (typeof(T) == typeof(short)) return new ValueSlice<T>(Functions.dlang_slice_Short_Append(dslice._slice, value._slice));
            else if (typeof(T) == typeof(ushort)) return new ValueSlice<T>(Functions.dlang_slice_Ushort_Append(dslice._slice, value._slice));
            else if (typeof(T) == typeof(int)) return new ValueSlice<T>(Functions.dlang_slice_Int_Append(dslice._slice, value._slice));
            else if (typeof(T) == typeof(uint)) return new ValueSlice<T>(Functions.dlang_slice_Uint_Append(dslice._slice, value._slice));
            else if (typeof(T) == typeof(long)) return new ValueSlice<T>(Functions.dlang_slice_Long_Append(dslice._slice, value._slice));
            else if (typeof(T) == typeof(ulong)) return new ValueSlice<T>(Functions.dlang_slice_Ulong_Append(dslice._slice, value._slice));
            else if (typeof(T) == typeof(float)) return new ValueSlice<T>(Functions.dlang_slice_Float_Append(dslice._slice, value._slice));
            else if (typeof(T) == typeof(double)) return new ValueSlice<T>(Functions.dlang_slice_Double_Append(dslice._slice, value._slice));
            else if (typeof(T) == typeof(Csharp.Library.S1)) return new ValueSlice<T>(Functions.dlang_slice_Csharp_library_s1_Append(dslice._slice, value._slice));
            else if (typeof(T) == typeof(Csharp.Library.S2)) return new ValueSlice<T>(Functions.dlang_slice_Csharp_library_s2_Append(dslice._slice, value._slice));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public IEnumerator<T> GetEnumerator() {
            for(long i = 0; i < _slice.length.ToInt64(); i++) {
                if (typeof(T) == typeof(bool)) yield return (T)(object)Functions.dlang_slice_bool_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(sbyte)) yield return (T)(object)Functions.dlang_slice_Byte_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(byte)) yield return (T)(object)Functions.dlang_slice_Ubyte_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(short)) yield return (T)(object)Functions.dlang_slice_Short_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(ushort)) yield return (T)(object)Functions.dlang_slice_Ushort_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(int)) yield return (T)(object)Functions.dlang_slice_Int_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(uint)) yield return (T)(object)Functions.dlang_slice_Uint_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(long)) yield return (T)(object)Functions.dlang_slice_Long_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(ulong)) yield return (T)(object)Functions.dlang_slice_Ulong_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(float)) yield return (T)(object)Functions.dlang_slice_Float_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(double)) yield return (T)(object)Functions.dlang_slice_Double_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Csharp.Library.S1)) yield return (T)(object)Functions.dlang_slice_Csharp_library_s1_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Csharp.Library.S2)) yield return (T)(object)Functions.dlang_slice_Csharp_library_s2_Get(_slice, new IntPtr(i));
            }
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => this.GetEnumerator();
    }

    public class RefSlice<T> : IEnumerable<T> where T : DLangObject {
        private readonly slice _slice;
        internal RefSlice(slice dslice) {
            this._slice = dslice;
        }
        internal slice ToSlice() => _slice;
        public long Length => _slice.length.ToInt64();

        public RefSlice(long capacity = 0) {
            if (typeof(T) == typeof(Csharp.Library.C1)) this._slice = Functions.dlang_slice_Csharp_library_c1_Create(new IntPtr(capacity));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public T this[long i] {
            get {
                if (typeof(T) == typeof(Csharp.Library.C1)) return (T)(object)Functions.dlang_slice_Csharp_library_c1_Get(_slice, new IntPtr(i));
                throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
            }
            set {
                if (typeof(T) == typeof(Csharp.Library.C1)) Functions.dlang_slice_Csharp_library_c1_Set(_slice, new IntPtr(i), value.DLangPointer);
            }
        }
        public RefSlice<T> Slice(long begin) {
            if (typeof(T) == typeof(Csharp.Library.C1)) return new RefSlice<T>(Functions.dlang_slice_Csharp_library_c1_Slice(_slice, new IntPtr(begin), _slice.length));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public RefSlice<T> Slice(long begin, long end) {
            if (end > _slice.length.ToInt64()) {
                throw new IndexOutOfRangeException("Value for parameter 'end' is greater than that length of the slice.");
            }
            if (typeof(T) == typeof(Csharp.Library.C1)) return new RefSlice<T>(Functions.dlang_slice_Csharp_library_c1_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public static RefSlice<T> operator +(RefSlice<T> dslice, T value) {
            if (typeof(T) == typeof(Csharp.Library.C1)) return new RefSlice<T>(Functions.dlang_slice_Csharp_library_c1_Append(dslice._slice, value.DLangPointer));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public static RefSlice<T> operator +(RefSlice<T> dslice, RefSlice<T> value) {
            if (typeof(T) == typeof(Csharp.Library.C1)) return new RefSlice<T>(Functions.dlang_slice_Csharp_library_c1_Append(dslice._slice, value._slice));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public IEnumerator<T> GetEnumerator() {
            for(long i = 0; i < _slice.length.ToInt64(); i++) {
                if (typeof(T) == typeof(Csharp.Library.C1)) yield return (T)(object)Functions.dlang_slice_Csharp_library_c1_Get(_slice, new IntPtr(i));
            }
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => this.GetEnumerator();
    }
}
