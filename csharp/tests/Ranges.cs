namespace Autowrap.CSharp.Tests
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Test;

    [TestClass]
    public class Ranges
    {
        public Ranges() {
            SharedFunctions.DRuntimeInitialize();
        }

        [TestMethod]
        public void ValueRange() {
            Range<ulong> valueArray = new List<ulong>() { 1UL, 2UL, 3UL };
            Assert.AreEqual(3L, valueArray.Length, "Incorrect Length for valueArray");
            Assert.AreEqual(1UL, valueArray[0], "Incorrect value for valueArray[0]");
            Assert.AreEqual(2UL, valueArray[1], "Incorrect value for valueArray[1]");
            Assert.AreEqual(3UL, valueArray[2], "Incorrect value for valueArray[2]");

            valueArray += 4UL;
            Assert.AreEqual(4L, valueArray.Length, "Incorrect Length for valueArray");
            Assert.AreEqual(4UL, valueArray[3], "Incorrect value for valueArray[3]");

            var slicedRange = valueArray.Slice(0, 2);
            Assert.AreEqual(2L, slicedRange.Length, "Incorrect Length for slicedArray");
            Assert.AreEqual(1UL, slicedRange[0], "Incorrect value for slicedArray[0]");
        }

        [TestMethod]
        public void StringRange() {
            Range<string> stringArray = new List<string>() { "Entry 1", "Entry 2", "Entry 3" };
            Assert.AreEqual(3L, stringArray.Length, "Incorrect Length for stringArray");
            Assert.AreEqual("Entry 1", stringArray[0], "Incorrect value for stringArray[0]");
            Assert.AreEqual("Entry 2", stringArray[1], "Incorrect value for stringArray[1]");
            Assert.AreEqual("Entry 3", stringArray[2], "Incorrect value for stringArray[2]");

            stringArray += "Entry 4";
            Assert.AreEqual(4L, stringArray.Length, "Incorrect Length for stringArray");
            Assert.AreEqual("Entry 4", stringArray[3], "Incorrect value for stringArray[3]");

            var slicedRange = stringArray.Slice(0, 2);
            Assert.AreEqual(2L, slicedRange.Length, "Incorrect Length for slicedArray");
            Assert.AreEqual("Entry 1", slicedRange[0], "Incorrect value for slicedArray[0]");
        }

        [TestMethod]
        public void StructRange() {
            Range<S2> structArray = new S2[] {new S2() { Value = 1, Str = "Test1"}, new S2() { Value = 2, Str = "Test2" }, new S2() { Value = 3, Str = "Test3" }};
            Assert.AreEqual(3L, structArray.Length, "Incorrect Length for cstructrray");
            Assert.AreEqual(1, structArray[0].Value, "Incorrect value for structArray[0].Value");
            Assert.AreEqual("Test1", structArray[0].Str, "Incorrect value for structArray[0].Str");
            Assert.AreEqual(2, structArray[1].Value, "Incorrect value for structArray[1].Value");
            Assert.AreEqual("Test2", structArray[1].Str, "Incorrect value for structArray[1].Str");
            Assert.AreEqual(3, structArray[2].Value, "Incorrect value for structArray[2].Value");
            Assert.AreEqual("Test3", structArray[2].Str, "Incorrect value for structArray[2].Str");
        }

        [TestMethod]
        public void ClassRange() {
            Range<C1> classArray = new List<C1>() { new C1("Class1", 1) { IntValue = 1 }, new C1("Class2", 2), new C1("Class3", 3) };
            Assert.AreEqual(3L, classArray.Length, "Incorrect Length for classArray");
            Assert.AreEqual(1, classArray[0].IntValue, "Incorrect value for classArray[0].IntValue");
            Assert.AreEqual("Class1", classArray[0].StringValueGetter, "Incorrect value for classArray[0].StringValueGetter");
            Assert.AreEqual(2, classArray[1].IntValue, "Incorrect value for classArray[1].IntValue");
            Assert.AreEqual("Class2", classArray[1].StringValueGetter, "Incorrect value for classArray[1].StringValueGetter");
            Assert.AreEqual(3, classArray[2].IntValue, "Incorrect value for classArray[2].IntValue");
            Assert.AreEqual("Class3", classArray[2].StringValueGetter, "Incorrect value for classArray[2].StringValueGetter");

            classArray += new C1("Class4", 4);
            Assert.AreEqual(4L, classArray.Length, "Incorrect Length for classArray");
            Assert.AreEqual(4, classArray[3].IntValue, "Incorrect value for classArray[3].IntValue");
            Assert.AreEqual("Class4", classArray[3].StringValueGetter, "Incorrect value for classArray[3].StringValueGetter");

            var slicedRange = classArray.Slice(0, 2);
            Assert.AreEqual(2L, slicedRange.Length, "Incorrect Length for classArray");
            Assert.AreEqual(1, slicedRange[0].IntValue, "Incorrect value for classArray[0].IntValue");
            Assert.AreEqual("Class1", slicedRange[0].StringValueGetter, "Incorrect value for classArray[0].StringValueGetter");
        }
    }
}