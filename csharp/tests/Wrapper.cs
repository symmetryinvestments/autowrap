namespace Test {
    using System;
    using System.CodeDom.Compiler;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.InteropServices;
    using Autowrap;

    public static class Functions {
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_TestParameterlessFunction", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_slice_error dlang_ParameterlessFunction();
        public static string ParameterlessFunction() {
            var dlang_ret = dlang_ParameterlessFunction();
            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);
        }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_TestFreeFunction", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_int_error dlang_FreeFunction(int value);
        public static int FreeFunction(int value) {
            var dlang_ret = dlang_FreeFunction(value);
            return dlang_ret;
        }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_TestStringFunction", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_slice_error dlang_StringFunction(slice value);
        public static string StringFunction(string value) {
            var dlang_ret = dlang_StringFunction(SharedFunctions.CreateString(value));
            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);
        }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_TestRangeFunction", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_slice_error dlang_RangeFunction(slice arr);
        public static Range<Test.S2> RangeFunction(Range<Test.S2> arr) {
            var dlang_ret = dlang_RangeFunction(arr.ToSlice());
            return new Range<Test.S2>(dlang_ret, DStringType.None);
        }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_TestClassRangeFunction", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_slice_error dlang_ClassRangeFunction(slice arr);
        public static Range<Test.C1> ClassRangeFunction(Range<Test.C1> arr) {
            var dlang_ret = dlang_ClassRangeFunction(arr.ToSlice());
            return new Range<Test.C1>(dlang_ret, DStringType.None);
        }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_TestTestErrorMessage", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_slice_error dlang_TestErrorMessage([MarshalAs(UnmanagedType.Bool)]bool throwError);
        public static string TestErrorMessage(bool throwError) {
            var dlang_ret = dlang_TestErrorMessage(throwError);
            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);
        }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_TestTestStringRanges", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_slice_error dlang_TestStringRanges(slice arr);
        public static Range<string> TestStringRanges(Range<string> arr) {
            var dlang_ret = dlang_TestStringRanges(arr.ToSlice());
            return new Range<string>(dlang_ret, DStringType._string);
        }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_TestSystimeArrayTest", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_slice_error dlang_SystimeArrayTest(slice array);
        public static Range<DateTimeOffset> SystimeArrayTest(Range<DateTimeOffset> array) {
            var dlang_ret = dlang_SystimeArrayTest(array.ToSlice());
            return new Range<DateTimeOffset>(dlang_ret, DStringType.None);
        }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_TestDurationTest", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_datetime_error dlang_DurationTest(datetime value);
        public static TimeSpan DurationTest(TimeSpan value) {
            var dlang_ret = dlang_DurationTest(value);
            return dlang_ret;
        }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_TestDateTimeTest", CallingConvention = CallingConvention.Cdecl)]

        private static extern return_datetime_error dlang_DateTimeTest(datetime value);
        public static DateTime DateTimeTest(DateTime value) {
            var dlang_ret = dlang_DateTimeTest(value);
            return dlang_ret;
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
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_S1GetValue0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_float_error dlang_S1_GetValue(ref Test.S1 __obj__);
        public float GetValue() {
            var dlang_ret = dlang_S1_GetValue(ref this);
            return dlang_ret;
        }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_S1SetNestedStruct0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_void_error dlang_S1_SetNestedStruct(ref Test.S1 __obj__, Test.S2 nested);
        public void SetNestedStruct(Test.S2 nested) {
            var dlang_ret = dlang_S1_SetNestedStruct(ref this, nested);
        }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_S1ParameterlessMethod0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_S1_ParameterlessMethod(ref Test.S1 __obj__);
        public string ParameterlessMethod() {
            var dlang_ret = dlang_S1_ParameterlessMethod(ref this);
            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);
        }

        public float Value;
        public Test.S2 NestedStruct;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    public class C1 : DLangObject {
        public static implicit operator IntPtr(C1 ret) { return ret.DLangPointer; }
        public static implicit operator C1(IntPtr ret) { return new C1(ret); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1__ctor", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_C1_error dlang_C1___ctor(slice s, int i);
        public C1(string s, int i) : base(dlang_C1___ctor(SharedFunctions.CreateString(s), i)) { }
        internal C1(IntPtr ptr) : base(ptr) { }

        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1StringValueGetter0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_StringValueGetter(IntPtr __obj__);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1ParameterlessMethod0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_ParameterlessMethod(IntPtr __obj__);
        public string ParameterlessMethod() {
            var dlang_ret = dlang_C1_ParameterlessMethod(this);
            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);
        }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1StructProperty0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_Test_S2_error dlang_C1_StructProperty(IntPtr __obj__);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1StructProperty1", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_Test_S2_error dlang_C1_StructProperty(IntPtr __obj__, Test.S2 value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1RefProperty0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_Test_C1_error dlang_C1_RefProperty(IntPtr __obj__);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1RefProperty1", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_Test_C1_error dlang_C1_RefProperty(IntPtr __obj__, IntPtr value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1ValueProperty0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_ulong_error dlang_C1_ValueProperty(IntPtr __obj__);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1ValueProperty1", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_ulong_error dlang_C1_ValueProperty(IntPtr __obj__, ulong value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1ValueSliceProperty0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_ValueSliceProperty(IntPtr __obj__);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1ValueSliceProperty1", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_ValueSliceProperty(IntPtr __obj__, slice value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1StringSliceProperty0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_StringSliceProperty(IntPtr __obj__);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1StringSliceProperty1", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_StringSliceProperty(IntPtr __obj__, slice value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1WstringSliceProperty0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_WstringSliceProperty(IntPtr __obj__);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1WstringSliceProperty1", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_WstringSliceProperty(IntPtr __obj__, slice value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DstringSliceProperty0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_DstringSliceProperty(IntPtr __obj__);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DstringSliceProperty1", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_DstringSliceProperty(IntPtr __obj__, slice value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1StructSliceProperty0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_StructSliceProperty(IntPtr __obj__);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1StructSliceProperty1", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_StructSliceProperty(IntPtr __obj__, slice value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1RefSliceProperty0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_RefSliceProperty(IntPtr __obj__);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1RefSliceProperty1", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_RefSliceProperty(IntPtr __obj__, slice value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1SysTimeProperty0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_datetime_error dlang_C1_SysTimeProperty(IntPtr __obj__);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1SysTimeProperty1", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_datetime_error dlang_C1_SysTimeProperty(IntPtr __obj__, datetime value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1SysTimeSliceProperty0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_SysTimeSliceProperty(IntPtr __obj__);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1SysTimeSliceProperty1", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_SysTimeSliceProperty(IntPtr __obj__, slice value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1TestMemberFunction0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_TestMemberFunction(IntPtr __obj__, slice test, Test.S1 value);
        public string TestMemberFunction(string test, Test.S1 value) {
            var dlang_ret = dlang_C1_TestMemberFunction(this, SharedFunctions.CreateString(test), value);
            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);
        }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1ToString0", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_C1_ToString(IntPtr __obj__);
        public override string ToString() {
            var dlang_ret = dlang_C1_ToString(this);
            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);
        }

        public string StringValueGetter { get => SharedFunctions.SliceToString(dlang_C1_StringValueGetter(this), DStringType._string);}
        public Test.S2 StructProperty { get => dlang_C1_StructProperty(this); set => dlang_C1_StructProperty(this, value); }
        public Test.C1 RefProperty { get => new Test.C1(dlang_C1_RefProperty(this)); set => dlang_C1_RefProperty(this, value); }
        public ulong ValueProperty { get => dlang_C1_ValueProperty(this); set => dlang_C1_ValueProperty(this, value); }
        public Range<ulong> ValueSliceProperty { get => new Range<ulong>(dlang_C1_ValueSliceProperty(this), DStringType.None); set => dlang_C1_ValueSliceProperty(this, value.ToSlice()); }
        public Range<string> StringSliceProperty { get => new Range<string>(dlang_C1_StringSliceProperty(this), DStringType._string); set => dlang_C1_StringSliceProperty(this, value.ToSlice(DStringType._string)); }
        public Range<string> WstringSliceProperty { get => new Range<string>(dlang_C1_WstringSliceProperty(this), DStringType._wstring); set => dlang_C1_WstringSliceProperty(this, value.ToSlice(DStringType._wstring)); }
        public Range<string> DstringSliceProperty { get => new Range<string>(dlang_C1_DstringSliceProperty(this), DStringType._dstring); set => dlang_C1_DstringSliceProperty(this, value.ToSlice(DStringType._dstring)); }
        public Range<Test.S1> StructSliceProperty { get => new Range<Test.S1>(dlang_C1_StructSliceProperty(this), DStringType.None); set => dlang_C1_StructSliceProperty(this, value.ToSlice()); }
        public Range<Test.C1> RefSliceProperty { get => new Range<Test.C1>(dlang_C1_RefSliceProperty(this), DStringType.None); set => dlang_C1_RefSliceProperty(this, value.ToSlice()); }
        public DateTimeOffset SysTimeProperty { get => dlang_C1_SysTimeProperty(this); set => dlang_C1_SysTimeProperty(this, value); }
        public Range<DateTimeOffset> SysTimeSliceProperty { get => new Range<DateTimeOffset>(dlang_C1_SysTimeSliceProperty(this), DStringType.None); set => dlang_C1_SysTimeSliceProperty(this, value.ToSlice()); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1IntValue_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_int_error dlang_intValue_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1IntValue_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_intValue_set(IntPtr ptr, int value);
        public int IntValue { get => dlang_intValue_get(this); set => dlang_intValue_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1BoolMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_bool_error dlang_boolMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1BoolMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_boolMember_set(IntPtr ptr, [MarshalAs(UnmanagedType.Bool)] bool value);
        public bool BoolMember { get => dlang_boolMember_get(this); set => dlang_boolMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1ByteMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_sbyte_error dlang_byteMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1ByteMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_byteMember_set(IntPtr ptr, sbyte value);
        public sbyte ByteMember { get => dlang_byteMember_get(this); set => dlang_byteMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1UbyteMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_byte_error dlang_ubyteMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1UbyteMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_ubyteMember_set(IntPtr ptr, byte value);
        public byte UbyteMember { get => dlang_ubyteMember_get(this); set => dlang_ubyteMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1ShortMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_short_error dlang_shortMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1ShortMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_shortMember_set(IntPtr ptr, short value);
        public short ShortMember { get => dlang_shortMember_get(this); set => dlang_shortMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1UshortMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_ushort_error dlang_ushortMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1UshortMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_ushortMember_set(IntPtr ptr, ushort value);
        public ushort UshortMember { get => dlang_ushortMember_get(this); set => dlang_ushortMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1IntMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_int_error dlang_intMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1IntMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_intMember_set(IntPtr ptr, int value);
        public int IntMember { get => dlang_intMember_get(this); set => dlang_intMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1UintMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_uint_error dlang_uintMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1UintMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_uintMember_set(IntPtr ptr, uint value);
        public uint UintMember { get => dlang_uintMember_get(this); set => dlang_uintMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1LongMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_long_error dlang_longMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1LongMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_longMember_set(IntPtr ptr, long value);
        public long LongMember { get => dlang_longMember_get(this); set => dlang_longMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1UlongMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_ulong_error dlang_ulongMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1UlongMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_ulongMember_set(IntPtr ptr, ulong value);
        public ulong UlongMember { get => dlang_ulongMember_get(this); set => dlang_ulongMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1FloatMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_float_error dlang_floatMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1FloatMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_floatMember_set(IntPtr ptr, float value);
        public float FloatMember { get => dlang_floatMember_get(this); set => dlang_floatMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DoubleMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_double_error dlang_doubleMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DoubleMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_doubleMember_set(IntPtr ptr, double value);
        public double DoubleMember { get => dlang_doubleMember_get(this); set => dlang_doubleMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1StringMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_stringMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1StringMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_stringMember_set(IntPtr ptr, slice value);
        public string StringMember { get => SharedFunctions.SliceToString(dlang_stringMember_get(this), DStringType._string); set => dlang_stringMember_set(this, SharedFunctions.CreateString(value)); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1WstringMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_wstringMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1WstringMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_wstringMember_set(IntPtr ptr, slice value);
        public string WstringMember { get => SharedFunctions.SliceToString(dlang_wstringMember_get(this), DStringType._wstring); set => dlang_wstringMember_set(this, SharedFunctions.CreateWstring(value)); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DstringMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_dstringMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DstringMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_dstringMember_set(IntPtr ptr, slice value);
        public string DstringMember { get => SharedFunctions.SliceToString(dlang_dstringMember_get(this), DStringType._dstring); set => dlang_dstringMember_set(this, SharedFunctions.CreateDstring(value)); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1ValueMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_Test_S1_error dlang_valueMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1ValueMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_valueMember_set(IntPtr ptr, Test.S1 value);
        public Test.S1 ValueMember { get => dlang_valueMember_get(this); set => dlang_valueMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1RefMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_Test_C1_error dlang_refMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1RefMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_refMember_set(IntPtr ptr, IntPtr value);
        public Test.C1 RefMember { get => new Test.C1(dlang_refMember_get(this)); set => dlang_refMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1RefArray_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_refArray_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1RefArray_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_refArray_set(IntPtr ptr, slice value);
        public Range<Test.C1> RefArray { get => new Range<Test.C1>(dlang_refArray_get(this), DStringType.None); set => dlang_refArray_set(this, value.ToSlice()); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1StructArray_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_structArray_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1StructArray_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_structArray_set(IntPtr ptr, slice value);
        public Range<Test.S1> StructArray { get => new Range<Test.S1>(dlang_structArray_get(this), DStringType.None); set => dlang_structArray_set(this, value.ToSlice()); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DurationMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_datetime_error dlang_durationMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DurationMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_durationMember_set(IntPtr ptr, datetime value);
        public TimeSpan DurationMember { get => dlang_durationMember_get(this); set => dlang_durationMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DateMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_datetime_error dlang_dateMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DateMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_dateMember_set(IntPtr ptr, datetime value);
        public DateTime DateMember { get => dlang_dateMember_get(this); set => dlang_dateMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DateTimeMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_datetime_error dlang_dateTimeMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DateTimeMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_dateTimeMember_set(IntPtr ptr, datetime value);
        public DateTime DateTimeMember { get => dlang_dateTimeMember_get(this); set => dlang_dateTimeMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1SysTimeMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_datetime_error dlang_sysTimeMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1SysTimeMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_sysTimeMember_set(IntPtr ptr, datetime value);
        public DateTimeOffset SysTimeMember { get => dlang_sysTimeMember_get(this); set => dlang_sysTimeMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1TimeOfDayMember_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_datetime_error dlang_timeOfDayMember_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1TimeOfDayMember_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_timeOfDayMember_set(IntPtr ptr, datetime value);
        public DateTime TimeOfDayMember { get => dlang_timeOfDayMember_get(this); set => dlang_timeOfDayMember_set(this, value); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DurationArray_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_durationArray_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DurationArray_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_durationArray_set(IntPtr ptr, slice value);
        public Range<TimeSpan> DurationArray { get => new Range<TimeSpan>(dlang_durationArray_get(this), DStringType.None); set => dlang_durationArray_set(this, value.ToSlice()); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DateArray_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_dateArray_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DateArray_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_dateArray_set(IntPtr ptr, slice value);
        public Range<DateTime> DateArray { get => new Range<DateTime>(dlang_dateArray_get(this), DStringType.None); set => dlang_dateArray_set(this, value.ToSlice()); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DateTimeArray_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_dateTimeArray_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1DateTimeArray_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_dateTimeArray_set(IntPtr ptr, slice value);
        public Range<DateTime> DateTimeArray { get => new Range<DateTime>(dlang_dateTimeArray_get(this), DStringType.None); set => dlang_dateTimeArray_set(this, value.ToSlice()); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1SysTimeArray_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_sysTimeArray_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1SysTimeArray_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_sysTimeArray_set(IntPtr ptr, slice value);
        public Range<DateTimeOffset> SysTimeArray { get => new Range<DateTimeOffset>(dlang_sysTimeArray_get(this), DStringType.None); set => dlang_sysTimeArray_set(this, value.ToSlice()); }
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1TimeOfDayArray_get", CallingConvention = CallingConvention.Cdecl)]
        private static extern return_slice_error dlang_timeOfDayArray_get(IntPtr ptr);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Test_C1TimeOfDayArray_set", CallingConvention = CallingConvention.Cdecl)]
        private static extern void dlang_timeOfDayArray_set(IntPtr ptr, slice value);
        public Range<DateTime> TimeOfDayArray { get => new Range<DateTime>(dlang_timeOfDayArray_get(this), DStringType.None); set => dlang_timeOfDayArray_set(this, value.ToSlice()); }
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
        public static implicit operator bool(return_bool_error ret) { ret.EnsureValid(); return ret._value != 0; }
        private byte _value;
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
    internal struct datetime {
        public datetime(long ticks, long offset) {
            this._ticks = ticks;
            this._offset = offset;
        }
        public static implicit operator datetime(DateTime ret) { return new datetime(ret.Ticks, 0L); }
        public static implicit operator datetime(DateTimeOffset ret) { return new datetime(ret.Ticks, ret.Offset.Ticks); }
        public static implicit operator datetime(TimeSpan ret) { return new datetime(ret.Ticks, 0L); }
        public static implicit operator DateTime(datetime ret) { return new DateTime(ret._ticks, DateTimeKind.Local); }
        public static implicit operator DateTimeOffset(datetime ret) { return new DateTimeOffset(ret._ticks, new TimeSpan(ret._offset)); }
        public static implicit operator TimeSpan(datetime ret) { return new TimeSpan(ret._ticks); }
        private long _ticks;
        private long _offset;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_datetime_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator DateTime(return_datetime_error ret) { ret.EnsureValid(); return ret._value; }
        public static implicit operator DateTimeOffset(return_datetime_error ret) { ret.EnsureValid(); return ret._value; }
        public static implicit operator TimeSpan(return_datetime_error ret) { ret.EnsureValid(); return ret._value; }
        private datetime _value;
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
    internal struct return_Test_S1_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator Test.S1(return_Test_S1_error ret) { ret.EnsureValid(); return ret._value; }
        private Test.S1 _value;
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
    internal struct return_Test_C1_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator IntPtr(return_Test_C1_error ret) { ret.EnsureValid(); return ret._value; }
        private IntPtr _value;
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
    internal struct return_Test_S2_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator Test.S2(return_Test_S2_error ret) { ret.EnsureValid(); return ret._value; }
        private Test.S2 _value;
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
    public static class SharedFunctions {
        static SharedFunctions() {
            Stream stream = null;
            var outputName = Path.Combine(Environment.CurrentDirectory, RuntimeInformation.IsOSPlatform(OSPlatform.OSX) ? "libcsharp-tests.dylib" : RuntimeInformation.IsOSPlatform(OSPlatform.Linux) ? "libcsharp-tests.so" : "csharp-tests.dll");

            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Autowrap.CSharp.Tests.libcsharp-tests.dylib");
            }
            if (Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Autowrap.CSharp.Tests.libcsharp-tests.x64.so");
            }
            if (!Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Autowrap.CSharp.Tests.libcsharp-tests.x86.so");
            }
            if (Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Windows)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Autowrap.CSharp.Tests.csharp-tests.x64.dll");
            }
            if (!Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Windows)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Autowrap.CSharp.Tests.csharp-tests.x86.dll");
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
            try {
                unsafe {
                    var bytes = (byte*)str.ptr.ToPointer();
                    if (bytes == null) {
                        return null;
                    }
                    if (type == DStringType._string) {
                        return String.Copy(System.Text.Encoding.UTF8.GetString(bytes, str.length.ToInt32()*(int)type));
                    } else if (type == DStringType._wstring) {
                        return String.Copy(System.Text.Encoding.Unicode.GetString(bytes, str.length.ToInt32()*(int)type));
                    } else if (type == DStringType._dstring) {
                        return String.Copy(System.Text.Encoding.UTF32.GetString(bytes, str.length.ToInt32()*(int)type));
                    } else {
                        throw new UnauthorizedAccessException("Unable to convert D string to C# string: Unrecognized string type.");
                    }
                }
            } finally {
                SharedFunctions.ReleaseMemory(str.ptr);
            }
        }

        // Support Functions
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_createString", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice CreateString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_createWString", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice CreateWstring([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_createDString", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice CreateDstring([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_release", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void ReleaseMemory(IntPtr ptr);

        [DllImport("csharp-tests", EntryPoint = "rt_init", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeInitialize();

        [DllImport("csharp-tests", EntryPoint = "rt_term", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeTerminate();
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    internal class RangeFunctions {
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Bool_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Bool_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Bool_Get", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.Bool)]
        internal static extern return_bool_error Bool_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Bool_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Bool_Set(slice dslice, IntPtr index, [MarshalAs(UnmanagedType.Bool)] bool value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Bool_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Bool_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Bool_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Bool_AppendValue(slice dslice, [MarshalAs(UnmanagedType.Bool)] bool value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Bool_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Bool_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_String_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error String_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_String_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error String_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_String_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error String_Set(slice dslice, IntPtr index, slice value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_String_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error String_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_String_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error String_AppendValue(slice dslice, slice value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_String_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error String_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Wstring_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Wstring_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Wstring_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Wstring_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Wstring_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Wstring_Set(slice dslice, IntPtr index, slice value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Wstring_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Wstring_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Wstring_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Wstring_AppendValue(slice dslice, slice value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Wstring_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Wstring_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Dstring_Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Dstring_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Dstring_Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Dstring_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Dstring_Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Dstring_Set(slice dslice, IntPtr index, slice value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Dstring_Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Dstring_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Dstring_AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Dstring_AppendValue(slice dslice, slice value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_Dstring_AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Dstring_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_ByteCreate", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Byte_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_ByteSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Byte_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_ByteAppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Byte_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_ByteGet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_sbyte_error Byte_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_ByteSet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Byte_Set(slice dslice, IntPtr index, sbyte value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_ByteAppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Byte_AppendValue(slice dslice, sbyte value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UbyteCreate", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ubyte_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UbyteSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ubyte_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UbyteAppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ubyte_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UbyteGet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_byte_error Ubyte_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UbyteSet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Ubyte_Set(slice dslice, IntPtr index, byte value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UbyteAppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ubyte_AppendValue(slice dslice, byte value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_ShortCreate", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Short_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_ShortSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Short_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_ShortAppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Short_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_ShortGet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_short_error Short_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_ShortSet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Short_Set(slice dslice, IntPtr index, short value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_ShortAppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Short_AppendValue(slice dslice, short value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UshortCreate", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ushort_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UshortSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ushort_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UshortAppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ushort_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UshortGet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_ushort_error Ushort_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UshortSet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Ushort_Set(slice dslice, IntPtr index, ushort value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UshortAppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ushort_AppendValue(slice dslice, ushort value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_IntCreate", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Int_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_IntSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Int_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_IntAppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Int_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_IntGet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_int_error Int_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_IntSet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Int_Set(slice dslice, IntPtr index, int value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_IntAppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Int_AppendValue(slice dslice, int value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UintCreate", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Uint_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UintSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Uint_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UintAppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Uint_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UintGet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_uint_error Uint_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UintSet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Uint_Set(slice dslice, IntPtr index, uint value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UintAppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Uint_AppendValue(slice dslice, uint value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_LongCreate", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Long_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_LongSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Long_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_LongAppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Long_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_LongGet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_long_error Long_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_LongSet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Long_Set(slice dslice, IntPtr index, long value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_LongAppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Long_AppendValue(slice dslice, long value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UlongCreate", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ulong_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UlongSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ulong_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UlongAppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ulong_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UlongGet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_ulong_error Ulong_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UlongSet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Ulong_Set(slice dslice, IntPtr index, ulong value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_UlongAppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Ulong_AppendValue(slice dslice, ulong value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_FloatCreate", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Float_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_FloatSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Float_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_FloatAppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Float_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_FloatGet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_float_error Float_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_FloatSet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Float_Set(slice dslice, IntPtr index, float value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_FloatAppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Float_AppendValue(slice dslice, float value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_DoubleCreate", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Double_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_DoubleSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Double_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_DoubleAppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Double_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_DoubleGet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_double_error Double_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_DoubleSet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Double_Set(slice dslice, IntPtr index, double value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_DoubleAppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Double_AppendValue(slice dslice, double value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeCreate", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Std_datetime_date_DateTime_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Std_datetime_date_DateTime_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeAppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Std_datetime_date_DateTime_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeGet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_datetime_error Std_datetime_date_DateTime_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeSet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Std_datetime_date_DateTime_Set(slice dslice, IntPtr index, datetime value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeAppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Std_datetime_date_DateTime_AppendValue(slice dslice, datetime value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeCreate", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Std_datetime_systime_SysTime_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Std_datetime_systime_SysTime_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeAppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Std_datetime_systime_SysTime_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeGet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_datetime_error Std_datetime_systime_SysTime_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeSet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Std_datetime_systime_SysTime_Set(slice dslice, IntPtr index, datetime value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeAppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Std_datetime_systime_SysTime_AppendValue(slice dslice, datetime value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeCreate", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Core_time_Duration_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Core_time_Duration_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeAppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Core_time_Duration_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeGet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_datetime_error Core_time_Duration_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeSet", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Core_time_Duration_Set(slice dslice, IntPtr index, datetime value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Autowrap_Csharp_Boilerplate_DatetimeAppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Core_time_Duration_AppendValue(slice dslice, datetime value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_S1Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Test_s1_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_S1Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Test_s1_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_S1AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Test_s1_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_S1Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_Test_S1_error Test_s1_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_S1Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Test_s1_Set(slice dslice, IntPtr index, Test.S1 value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_S1AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Test_s1_AppendValue(slice dslice, Test.S1 value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_S2Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Test_s2_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_S2Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Test_s2_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_S2AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Test_s2_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_S2Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_Test_S2_error Test_s2_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_S2Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Test_s2_Set(slice dslice, IntPtr index, Test.S2 value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_S2AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Test_s2_AppendValue(slice dslice, Test.S2 value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_C1Create", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Test_c1_Create(IntPtr capacity);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_C1Slice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Test_c1_Slice(slice dslice, IntPtr begin, IntPtr end);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_C1AppendSlice", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Test_c1_AppendSlice(slice dslice, slice array);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_C1Get", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_Test_C1_error Test_c1_Get(slice dslice, IntPtr index);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_C1Set", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_void_error Test_c1_Set(slice dslice, IntPtr index, IntPtr value);
        [DllImport("csharp-tests", EntryPoint = "autowrap_csharp_slice_Test_C1AppendValue", CallingConvention = CallingConvention.Cdecl)]
        internal static extern return_slice_error Test_c1_AppendValue(slice dslice, IntPtr value);

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

        internal Range(slice range, DStringType type) {
            this._slice = range;
            this._type = type;
        }

        public Range(IEnumerable<T> values) {
            if (typeof(T) == typeof(string)) {
                this._strings = new List<string>();
                foreach(var t in values) {
                    this._strings.Add((string)(object)t);
                }
            } else {
                CreateSlice(values.Count());
                foreach(var t in values) {
                    this.Append(t);
                }
            }
        }

        public Range(long capacity = 0) {
            CreateSlice(capacity);
        }
        private void CreateSlice(long capacity) {
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
            else if (typeof(T) == typeof(DateTime)) this._slice = RangeFunctions.Std_datetime_date_DateTime_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(DateTimeOffset)) this._slice = RangeFunctions.Std_datetime_systime_SysTime_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(TimeSpan)) this._slice = RangeFunctions.Core_time_Duration_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(Test.S1)) this._slice = RangeFunctions.Test_s1_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(Test.S2)) this._slice = RangeFunctions.Test_s2_Create(new IntPtr(capacity));
            else if (typeof(T) == typeof(Test.C1)) this._slice = RangeFunctions.Test_c1_Create(new IntPtr(capacity));

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
                else if (typeof(T) == typeof(DateTime)) return (T)(object)(DateTime)RangeFunctions.Std_datetime_date_DateTime_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(DateTimeOffset)) return (T)(object)(DateTimeOffset)RangeFunctions.Std_datetime_systime_SysTime_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(TimeSpan)) return (T)(object)(TimeSpan)RangeFunctions.Core_time_Duration_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Test.S1)) return (T)(object)(Test.S1)RangeFunctions.Test_s1_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Test.S2)) return (T)(object)(Test.S2)RangeFunctions.Test_s2_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Test.C1)) return (T)(object)new Test.C1(RangeFunctions.Test_c1_Get(_slice, new IntPtr(i)));

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
                else if (typeof(T) == typeof(DateTime)) RangeFunctions.Std_datetime_date_DateTime_Set(_slice, new IntPtr(i), (DateTime)(object)value);
                else if (typeof(T) == typeof(DateTimeOffset)) RangeFunctions.Std_datetime_systime_SysTime_Set(_slice, new IntPtr(i), (DateTimeOffset)(object)value);
                else if (typeof(T) == typeof(TimeSpan)) RangeFunctions.Core_time_Duration_Set(_slice, new IntPtr(i), (TimeSpan)(object)value);
                else if (typeof(T) == typeof(Test.S1)) RangeFunctions.Test_s1_Set(_slice, new IntPtr(i), (Test.S1)(object)value);
                else if (typeof(T) == typeof(Test.S2)) RangeFunctions.Test_s2_Set(_slice, new IntPtr(i), (Test.S2)(object)value);
                else if (typeof(T) == typeof(Test.C1)) RangeFunctions.Test_c1_Set(_slice, new IntPtr(i), (Test.C1)(object)value);

            }
        }
        public Range<T> Slice(long begin) {
            if (typeof(T) == typeof(bool)) return new Range<T>(RangeFunctions.Bool_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) return new Range<T>((IEnumerable<T>)_strings.Skip((int)begin));
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._string) return new Range<T>(RangeFunctions.String_Slice(_slice, new IntPtr(begin), _slice.length), _type);
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._wstring) return new Range<T>(RangeFunctions.Wstring_Slice(_slice, new IntPtr(begin), _slice.length), _type);
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._dstring) return new Range<T>(RangeFunctions.Dstring_Slice(_slice, new IntPtr(begin), _slice.length), _type);
            else if (typeof(T) == typeof(sbyte)) return new Range<T>(RangeFunctions.Byte_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(byte)) return new Range<T>(RangeFunctions.Ubyte_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(short)) return new Range<T>(RangeFunctions.Short_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(ushort)) return new Range<T>(RangeFunctions.Ushort_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(int)) return new Range<T>(RangeFunctions.Int_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(uint)) return new Range<T>(RangeFunctions.Uint_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(long)) return new Range<T>(RangeFunctions.Long_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(ulong)) return new Range<T>(RangeFunctions.Ulong_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(float)) return new Range<T>(RangeFunctions.Float_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(double)) return new Range<T>(RangeFunctions.Double_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(DateTime)) return new Range<T>(RangeFunctions.Std_datetime_date_DateTime_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(DateTimeOffset)) return new Range<T>(RangeFunctions.Std_datetime_systime_SysTime_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(TimeSpan)) return new Range<T>(RangeFunctions.Core_time_Duration_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(Test.S1)) return new Range<T>(RangeFunctions.Test_s1_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(Test.S2)) return new Range<T>(RangeFunctions.Test_s2_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);
            else if (typeof(T) == typeof(Test.C1)) return new Range<T>(RangeFunctions.Test_c1_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);

            else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
        }
        public Range<T> Slice(long begin, long end) {
            if (end > (_strings?.Count ?? _slice.length.ToInt64())) {
                throw new IndexOutOfRangeException("Value for parameter 'end' is greater than that length of the slice.");
            }
            if (typeof(T) == typeof(bool)) return new Range<T>(RangeFunctions.Bool_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) return new Range<T>((IEnumerable<T>)_strings.Skip((int)begin).Take((int)end - (int)begin));
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._string) return new Range<T>(RangeFunctions.String_Slice(_slice, new IntPtr(begin), new IntPtr(end)), _type);
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._wstring) return new Range<T>(RangeFunctions.Wstring_Slice(_slice, new IntPtr(begin), new IntPtr(end)), _type);
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._dstring) return new Range<T>(RangeFunctions.Dstring_Slice(_slice, new IntPtr(begin), new IntPtr(end)), _type);
            else if (typeof(T) == typeof(sbyte)) return new Range<T>(RangeFunctions.Byte_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(byte)) return new Range<T>(RangeFunctions.Ubyte_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(short)) return new Range<T>(RangeFunctions.Short_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(ushort)) return new Range<T>(RangeFunctions.Ushort_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(int)) return new Range<T>(RangeFunctions.Int_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(uint)) return new Range<T>(RangeFunctions.Uint_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(long)) return new Range<T>(RangeFunctions.Long_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(ulong)) return new Range<T>(RangeFunctions.Ulong_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(float)) return new Range<T>(RangeFunctions.Float_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(double)) return new Range<T>(RangeFunctions.Double_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(DateTime)) return new Range<T>(RangeFunctions.Std_datetime_date_DateTime_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(DateTimeOffset)) return new Range<T>(RangeFunctions.Std_datetime_systime_SysTime_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(TimeSpan)) return new Range<T>(RangeFunctions.Core_time_Duration_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(Test.S1)) return new Range<T>(RangeFunctions.Test_s1_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(Test.S2)) return new Range<T>(RangeFunctions.Test_s2_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);
            else if (typeof(T) == typeof(Test.C1)) return new Range<T>(RangeFunctions.Test_c1_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);

            else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
        }
        private void Append(T value) {
            if (typeof(T) == typeof(bool)) { this._slice = RangeFunctions.Bool_AppendValue(this._slice, (bool)(object)value); }
            else if (typeof(T) == typeof(string) && this._strings != null && this._type == DStringType.None) { this._strings.Add((string)(object)value); }
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._string) { _slice = RangeFunctions.String_AppendValue(_slice, SharedFunctions.CreateString((string)(object)value)); }
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._wstring) { _slice = RangeFunctions.Wstring_AppendValue(_slice, SharedFunctions.CreateWstring((string)(object)value)); }
            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._dstring) { _slice = RangeFunctions.Dstring_AppendValue(_slice, SharedFunctions.CreateDstring((string)(object)value)); }
            else if (typeof(T) == typeof(sbyte)) { this._slice = RangeFunctions.Byte_AppendValue(this._slice, (sbyte)(object)value); }
            else if (typeof(T) == typeof(byte)) { this._slice = RangeFunctions.Ubyte_AppendValue(this._slice, (byte)(object)value); }
            else if (typeof(T) == typeof(short)) { this._slice = RangeFunctions.Short_AppendValue(this._slice, (short)(object)value); }
            else if (typeof(T) == typeof(ushort)) { this._slice = RangeFunctions.Ushort_AppendValue(this._slice, (ushort)(object)value); }
            else if (typeof(T) == typeof(int)) { this._slice = RangeFunctions.Int_AppendValue(this._slice, (int)(object)value); }
            else if (typeof(T) == typeof(uint)) { this._slice = RangeFunctions.Uint_AppendValue(this._slice, (uint)(object)value); }
            else if (typeof(T) == typeof(long)) { this._slice = RangeFunctions.Long_AppendValue(this._slice, (long)(object)value); }
            else if (typeof(T) == typeof(ulong)) { this._slice = RangeFunctions.Ulong_AppendValue(this._slice, (ulong)(object)value); }
            else if (typeof(T) == typeof(float)) { this._slice = RangeFunctions.Float_AppendValue(this._slice, (float)(object)value); }
            else if (typeof(T) == typeof(double)) { this._slice = RangeFunctions.Double_AppendValue(this._slice, (double)(object)value); }
            else if (typeof(T) == typeof(DateTime)) { this._slice = RangeFunctions.Std_datetime_date_DateTime_AppendValue(this._slice, (DateTime)(object)value); }
            else if (typeof(T) == typeof(DateTimeOffset)) { this._slice = RangeFunctions.Std_datetime_systime_SysTime_AppendValue(this._slice, (DateTimeOffset)(object)value); }
            else if (typeof(T) == typeof(TimeSpan)) { this._slice = RangeFunctions.Core_time_Duration_AppendValue(this._slice, (TimeSpan)(object)value); }
            else if (typeof(T) == typeof(Test.S1)) { this._slice = RangeFunctions.Test_s1_AppendValue(this._slice, (Test.S1)(object)value); }
            else if (typeof(T) == typeof(Test.S2)) { this._slice = RangeFunctions.Test_s2_AppendValue(this._slice, (Test.S2)(object)value); }
            else if (typeof(T) == typeof(Test.C1)) { this._slice = RangeFunctions.Test_c1_AppendValue(this._slice, (Test.C1)(object)value); }

            else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
        }
        public static Range<T> operator +(Range<T> range, T value) {
            range.Append(value);
            return range;
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
            else if (typeof(T) == typeof(DateTime)) { range._slice = RangeFunctions.Std_datetime_date_DateTime_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(DateTimeOffset)) { range._slice = RangeFunctions.Std_datetime_systime_SysTime_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(TimeSpan)) { range._slice = RangeFunctions.Core_time_Duration_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(Test.S1)) { range._slice = RangeFunctions.Test_s1_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(Test.S2)) { range._slice = RangeFunctions.Test_s2_AppendSlice(range._slice, source._slice); return range; }
            else if (typeof(T) == typeof(Test.C1)) { range._slice = RangeFunctions.Test_c1_AppendSlice(range._slice, source._slice); return range; }

            else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
        }
        public IEnumerator<T> GetEnumerator() {
            for(long i = 0; i < (_strings?.Count ?? _slice.length.ToInt64()); i++) {
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
                else if (typeof(T) == typeof(DateTime)) yield return (T)(object)(DateTime)RangeFunctions.Std_datetime_date_DateTime_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(DateTimeOffset)) yield return (T)(object)(DateTimeOffset)RangeFunctions.Std_datetime_systime_SysTime_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(TimeSpan)) yield return (T)(object)(TimeSpan)RangeFunctions.Core_time_Duration_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Test.S1)) yield return (T)(object)(Test.S1)RangeFunctions.Test_s1_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Test.S2)) yield return (T)(object)(Test.S2)RangeFunctions.Test_s2_Get(_slice, new IntPtr(i));
                else if (typeof(T) == typeof(Test.C1)) yield return (T)(object)new Test.C1(RangeFunctions.Test_c1_Get(_slice, new IntPtr(i)));

            }
        }

        public static implicit operator T[](Range<T> slice) {
            return slice.ToArray();
        }
        public static implicit operator Range<T>(T[] array) {
            return new Range<T>(array);
        }
        public static implicit operator List<T>(Range<T> slice) {
            return new List<T>(slice.ToArray());
        }
        public static implicit operator Range<T>(List<T> array) {
            return new Range<T>(array);
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => this.GetEnumerator();
    }
}
