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

            Console.WriteLine("Testing Primitive Types (String)");
            string testString = "Hello World!";
            var sret = library.StringFunction(testString);
            if (sret.Equals(testString, StringComparison.Ordinal)) {
                Console.WriteLine($"Expected: {testString} - Actual: {sret}");
            }
            Console.WriteLine($"StringFunction Result: {sret}");

            string str = library.DLang_String_StringFunction(testString);
            string wstr = library.DLang_WString_StringFunction(testString);
            string dstr = library.DLang_DString_StringFunction(testString);
        }
    }
}
