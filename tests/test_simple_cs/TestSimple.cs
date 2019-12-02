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
        // Each [TestMethod] method has a corresponding test in python in test_simple.py

        static TestSimple()
        {
            SharedFunctions.DRuntimeInitialize();
        }

        [TestMethod]
        public void TestAdder()
        {
            Assert.AreEqual(8, (new Adder(3)).Add(5));
            Assert.AreEqual(9, (new Adder(2)).Add(7));
        }

        [TestMethod]
        public void TestPrefix()
        {
            var p = new Prefix("foo");
            Assert.AreEqual("foobar", p.Pre("bar"));
        }

        [TestMethod]
        public void TestIntString1()
        {
            var x = new IntString(42);
            Assert.AreEqual(42, x.I);
            Assert.IsNull(x.S);
        }

        [TestMethod]
        public void TestIntString2()
        {
            var x = new IntString(33, "foobar");
            Assert.AreEqual(33, x.I);
            Assert.AreEqual("foobar", x.S);
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
        public void TestCreateDateTime()
        {
            var d = Api.Functions.CreateDateTime(2017, 1, 2);
            Assert.AreEqual(2017, d.Year);
            Assert.AreEqual(1, d.Month);
            Assert.AreEqual(2, d.Day);
        }

        [TestMethod]
        public void TestCreateDateTimeArray()
        {
            // TODO: Aside from arrays of strings, arrays of arrays are not yet supported,
            //       and points returns DateTime[][]
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
            var d = Api.Functions.CreateDate(2017, 1, 2);
            Assert.AreEqual(2017, d.Year);
            Assert.AreEqual(1, d.Month);
            Assert.AreEqual(2, d.Day);
        }

        [TestMethod]
        public void TestFoo()
        {
            var f = new Foo(2, 3);
            Assert.AreEqual("Foo(2, 3)", f.ToString());
        }

        // test_not_copyable from test_simple.py not reproduced here, because it doesn't seem relevant to C#

        [TestMethod]
        public void TestProduct()
        {
            Assert.AreEqual(6, Wrap_all.Functions.Product(2, 3));
            Assert.AreEqual(20, Wrap_all.Functions.Product(4, 5));
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
            Assert.AreEqual(42, outer.Value);
            Assert.AreEqual("foobar", outer.Inner.Value);
        }

        [TestMethod]
        public void TestSafePureEtcStruct()
        {
            var s = new SafePureEtcStruct();
            Assert.AreEqual(6, s.Stuff(3));
        }

        [TestMethod]
        public void TestTheYear()
        {
            Assert.AreEqual(2017, Api.Functions.TheYear(new DateTime(2017, 1, 1)));
            Assert.AreEqual(2018, Api.Functions.TheYear(new DateTime(2018, 2, 3)));
        }

        [TestMethod]
        public void TestWrapAllString()
        {
            Assert.AreEqual("foobar", new Wrap_all.String("foobar").S);
        }

        [TestMethod]
        public void TestWrapAllOtherStringAsParam()
        {
            Assert.AreEqual("hello quux", Wrap_all.Functions.OtherStringAsParam(new OtherString("hello ")));
        }

        [TestMethod]
        public void TestAddWithDefault()
        {
            Assert.AreEqual(3, Api.Functions.AddWithDefault(1, new NotWrappedInt(2)));
            Assert.AreEqual(43, Api.Functions.AddWithDefault(1));
        }

        // test_struct_with_private_member from test_simple.py not reproduced, because AFAIK,
        // it's not possible to test whether a piece of code compiles in C#
    }
}
