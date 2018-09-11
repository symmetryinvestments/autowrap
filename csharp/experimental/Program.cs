using System;

namespace csharp
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Testing Primitive Types (Int)");
            int testInt = 1;
            var iret = library.FreeFunction(testInt);
            if (iret != testInt) {
                Console.WriteLine($"Expected: {testInt} - Actual: {iret}");
            }
            Console.WriteLine($"FreeFunction Result: {iret}");

            //Test primitive types
            Console.WriteLine("Testing Primitive Types (String)");
            string testString = "Hello World!";
            var sret = library.StringFunction(testString);
            if (sret.Equals(testString, StringComparison.Ordinal)) {
                Console.WriteLine($"Expected: {testString} - Actual: {sret}");
            }
            Console.WriteLine($"StringFunction Result: {sret}");

            //Test string functions
            string str = library.DLang_String_StringFunction(testString);
            Console.WriteLine($"DLang_String_StringFunction Result: {str}");
            string wstr = library.DLang_WString_StringFunction(testString);
            Console.WriteLine($"DLang_WString_StringFunction Result: {wstr}");
            string dstr = library.DLang_DString_StringFunction(testString);
            Console.WriteLine($"DLang_DString_StringFunction Result: {dstr}");

            //Test struct ranges
            var arr = new S2[] {new S2(1, "Test1"), new S2(2, "Test2"), new S2(3, "Test3")};
            Span<S2> retSpan = library.ArrayFunction(arr);
            var retArr = retSpan.ToArray();
            Console.WriteLine($"Returned array length: {retArr.Length}");
            Console.WriteLine(retArr[0].str);
            Console.WriteLine(retArr[1].str);
            Console.WriteLine(retArr[2].str);

            //Test class
            var testClass = new C1();
            Console.WriteLine("Testing Class");
            testClass.StringValue = "TestStringValue";
            var tsv = testClass.StringValue;
            Console.WriteLine($"Class Test String: {tsv}");
            testClass.IntValue = -1;
            var isv = testClass.IntValue;
            Console.WriteLine($"Class Test Int: {isv}");
            var funcString = testClass.TestMemberFunc("TestMemberFunc", new S1());
            Console.WriteLine($"Class Func String: {funcString}");

            //Test class ranges
            var classArray = new C1[] { new C1() { StringValue = "Class1", IntValue = 1 }, new C1() { StringValue = "Class2", IntValue = 2 }, new C1() { StringValue = "Class3", IntValue = 3 } };
            var retClassArray = library.ClassRangeFunction(classArray);
            foreach(var c in retClassArray) {
                Console.WriteLine($"Class Array Item: {c.StringValue} {c.IntValue}");
            }

            //Test struct member functions
            var s1struct = new S1();
            s1struct.value = 1.1f;
            var s1value = s1struct.getValue();
            Console.WriteLine($"Struct Value: {s1value}");

            //Test error messages
            try {
                var error = library.TestErrorMessage();
            } catch (DLangException ex) {
                Console.WriteLine($"Error: {Environment.NewLine}{ex.DLangExceptionText}");
            }
        }
    }
}
