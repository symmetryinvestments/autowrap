namespace Autowrap.CSharp.Examples.Simple.Tests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Autowrap;

    using Adder;
    using Api;
    using Impl;
    using Not_wrapped;
    using Prefix;
    using Structs;
    using Wrap_all;

    [TestClass]
    public class TestSimple
    {
        public TestSimple()
        {
            SharedFunctions.DRuntimeInitialize();
        }

        // Each [TestMethod] method has a corresponding test in python in test_simple.py

        [TestMethod]
        public void TestAdder()
        {
            Assert.AreEqual((new Adder(3)).Add(5), 8);
            Assert.AreEqual((new Adder(2)).Add(7), 9);
        }

        [TestMethod]
        public void TestPrefix()
        {
            var p = new Prefix("foo");
            Assert.AreEqual(p.Pre("bar"), "foobar");
        }

        [TestMethod]
        public void TestIntString1()
        {
            var x = new IntString(42);
            Assert.AreEqual(x.I, 42);
            Assert.IsNull(x.S);
        }

        [TestMethod]
        public void TestIntString2()
        {
            var x = new IntString(33, "foobar");
            Assert.AreEqual(x.I, 33);
            Assert.AreEqual(x.S, "foobar");
        }

        [TestMethod]
        public void TestPoint()
        {
            // TODO: Templated type support still needs to be added to autowrap's C#
        }

        [TestMethod]
        public void TestCreateOuter()
        {
            // TODO: Templated type support still needs to be added to autowrap's C#
        }

        [TestMethod]
        public void TestCreateOuters()
        {
            // TODO: Templated type support still needs to be added to autowrap's C#
        }

        [TestMethod]
        public void TestCreateDatetime()
        {
            // TODO: The way that autowrap's C# handles std.datetime is error-prone and needs to be changed
        }

        [TestMethod]
        public void TestCreateDatetimeArray()
        {
            // TODO: The way that autowrap's C# handles std.datetime is error-prone and needs to be changed
        }

        [TestMethod]
        public void TestPoints()
        {
            // TODO: Aside from arrays of strings, arrays of arrays are not yet supported,
            //       and points returns AnotherPoint[][]
        }

        [TestMethod]
        public void TestTupleofDateTimes()
        {
            // TODO: Templated type support still needs to be added to autowrap's C#
            // TODO: The way that autowrap's C# handles std.datetime is error-prone and needs to be changed
        }

        [TestMethod]
        public void TestCreateOuter2()
        {
            // TODO: Templated type support still needs to be added to autowrap's C#
        }

        [TestMethod]
        public void TestTypedef()
        {
            // TODO: Templated type support still needs to be added to autowrap's C#
        }

        [TestMethod]
        public void TestCreateDate()
        {
            // TODO: The way that autowrap's C# handles std.datetime is error-prone and needs to be changed
        }

        [TestMethod]
        public void TestFoo()
        {
            var f = new Foo(2, 3);
            Assert.AreEqual(f.ToString(), "Foo(2, 3)");
        }

        // test_not_copyable from test_simple.py not reproduced here, because it doesn't seem relevant to C#

        [TestMethod]
        public void TestProduct()
        {
            Assert.AreEqual(Wrap_all.Functions.Product(2, 3), 6);
            Assert.AreEqual(Wrap_all.Functions.Product(4, 5), 20);
        }

        [TestMethod]
        public void TestIdentyInt()
        {
            // TODO: Aliases of templated functions are not currently supported by autowrap's C#
            // Aliases in general probably don't work either, but nothing with templates does
        }

        [TestMethod]
        public void TestApiOuter()
        {
            var outer = new ApiOuter(42, new NotWrappedInner("foobar"));
            Assert.AreEqual(outer.Value, 42);
            Assert.AreEqual(outer.Inner.Value, "foobar");
        }

        [TestMethod]
        public void TestSafePureEtcStruct()
        {
            var s = new SafePureEtcStruct();
            Assert.AreEqual(s.Stuff(3), 6);
        }

        [TestMethod]
        public void TestTheYear()
        {
            // TODO: The way that autowrap's C# handles std.datetime is error-prone and needs to be changed
        }

        [TestMethod]
        public void TestWrapAllString()
        {
            Assert.AreEqual(new Wrap_all.String("foobar").S, "foobar");
        }

        [TestMethod]
        public void TestWrapAllOtherStringAsParam()
        {
            Assert.AreEqual(Wrap_all.Functions.OtherStringAsParam(new OtherString("hello ")), "hello quux");
        }

        [TestMethod]
        public void TestAddWithDefault()
        {
            Assert.AreEqual(Api.Functions.AddWithDefault(1, new NotWrappedInt(2)), 3);
            Assert.AreEqual(Api.Functions.AddWithDefault(1), 43);
        }

        // test_struct_with_private_member from test_simple.py not reproduced, because AFAIK,
        // it's not possible to test whether a piece of code compiles in C#
    }
}
