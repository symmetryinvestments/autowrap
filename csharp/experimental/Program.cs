using System;
using System.Collections.Generic;
using Autowrap;
using Csharp.Library;

namespace csharp
{
    class Program
    {
        static void Main(string[] args)
        {
            Autowrap.SharedFunctions.DRuntimeInitialize();

            Console.WriteLine("Testing Primitive Types (Int)");
            int testInt = 1;
            var iret = Csharp.Library.Functions.FreeFunction(testInt);
            if (iret != testInt) {
                Console.WriteLine($"Expected: {testInt} - Actual: {iret}");
            }
            Console.WriteLine($"FreeFunction Result: {iret}");

            //Test primitive types
            Console.WriteLine("Testing Primitive Types (String)");
            string testString = "Hello World!";
            var sret = Csharp.Library.Functions.StringFunction(testString);
            if (sret.ToString().Equals(testString, StringComparison.Ordinal)) {
                Console.WriteLine($"Expected: {testString} - Actual: {sret}");
            }
            Console.WriteLine($"StringFunction Result: {sret}");

            //Test string functions
            string str = Csharp.Library.Functions.StringFunction(testString);
            Console.WriteLine($"DLang_String_StringFunction Result: {str}");

            //Test struct ranges
            var arr = new S2[] {new S2() { Value = 1, Str = "Test1"}, new S2() { Value = 2, Str = "Test2" }, new S2() { Value = 3, Str = "Test3" }};
            var retSlice = Csharp.Library.Functions.ArrayFunction(arr);
            Console.WriteLine($"Returned array length: {retSlice.Length}");
            Console.WriteLine(retSlice[0].Str);
            Console.WriteLine(retSlice[1].Str);
            Console.WriteLine(retSlice[2].Str);

            //Test class
            var testClass = new C1(4, "TestClass4");
            Console.WriteLine("Testing Class");
            testClass.IntValue = -1;
            var isv = testClass.IntValue;
            Console.WriteLine($"Class Test Int: {isv}");
            var funcString = testClass.TestMemberFunc("TestMemberFunc", new S1());
            Console.WriteLine($"Class Func String: {funcString}");

            //Test class ranges
            var classArray = new List<C1>() { new C1(0, "Class1") { IntValue = 1 }, new C1(1, "Class2"), new C1(2, "Class3") };
            List<C1> retClassArray = Csharp.Library.Functions.ClassRangeFunction(classArray);
            foreach(var c in retClassArray) {
                Console.WriteLine($"Class Array Item: {c.DstringMember} {c.IntValue}");
            }

            //Test struct member functions
            var s1struct = new S1();
            s1struct.Value = 1.1f;
            var s1value = s1struct.GetValue();
            Console.WriteLine($"Struct Value: {s1value}");

            //Test error messages
            var errorResult = Csharp.Library.Functions.TestErrorMessage(false);
            Console.WriteLine($"No Error Message: {errorResult}");
            try {
                var error = Csharp.Library.Functions.TestErrorMessage(true);
            } catch (DLangException ex) {
                Console.WriteLine($"Error: {Environment.NewLine}{ex.DLangExceptionText}");
            }
        }
    }
}
