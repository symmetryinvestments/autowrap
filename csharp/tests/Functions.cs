namespace Autowrap.CSharp.Tests
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Test;

    [TestClass]
    public class Functions
    {
        public Functions() {
            SharedFunctions.DRuntimeInitialize();
        }

        [TestMethod]
        public void ParameterlessFunction() {
            var result = Test.Functions.ParameterlessFunction();
            Assert.AreEqual("Parameterless Function", result, "Unexpected FreeFunction Result");
        }

        [TestMethod]
        public void FreeFunction() {
            var testValue = 1;
            var result = Test.Functions.FreeFunction(testValue);
            Assert.AreEqual(testValue, result, "Unexpected FreeFunction Result");
        }

        [TestMethod]
        public void StringFunction() {
            var testString = "Hello World!";
            var result = Test.Functions.StringFunction(testString);
            Assert.AreEqual(testString, result, "Unexpected StringFunction Result");
        }

        [TestMethod]
        public void RangeFunction() {
            var arr = new S2[] {new S2() { Value = 1, Str = "Test1"}, new S2() { Value = 2, Str = "Test2" }, new S2() { Value = 3, Str = "Test3" }};
            var retSlice = Test.Functions.RangeFunction(arr);
            Assert.AreEqual(retSlice.Length, arr.Length, "Unexpected array length returned from RangeFunction");
            Assert.AreEqual(1, retSlice[0].Value, "Incorrect Value for retSlice[0]");
            Assert.AreEqual(2, retSlice[1].Value, "Incorrect Value for retSlice[1]");
            Assert.AreEqual(3, retSlice[2].Value, "Incorrect Value for retSlice[2]");
            Assert.AreEqual("Test1", retSlice[0].Str, "Incorrect Str for retSlice[0]");
            Assert.AreEqual("Test2", retSlice[1].Str, "Incorrect Str for retSlice[1]");
            Assert.AreEqual("Test3", retSlice[2].Str, "Incorrect Str for retSlice[2]");
        }

        [TestMethod]
        public void ClassRangeFunction() {
            var classArray = new List<C1>() { new C1("Class1", 1) { IntValue = 1 }, new C1("Class2", 2), new C1("Class3", 3) };
            List<C1> retClassArray = Test.Functions.ClassRangeFunction(classArray);
            Assert.AreEqual(retClassArray.Count, classArray.Count, "Unexpected array length returned from ClassRangeFunction");
            Assert.AreEqual(1, retClassArray[0].IntValue, "Incorrect Value for retClassArray[0]");
            Assert.AreEqual(2, retClassArray[1].IntValue, "Incorrect Value for retClassArray[1]");
            Assert.AreEqual(3, retClassArray[2].IntValue, "Incorrect Value for retClassArray[2]");
        }

        [TestMethod]
        public void TestDLangExceptions() {
            var errorResult = Test.Functions.TestErrorMessage(false);
            Assert.AreEqual("No Error Thrown", errorResult, "Unexpected Result from TestErrorMessage.");
            Assert.ThrowsException<DLangException>(() => Test.Functions.TestErrorMessage(true));
        }
    }
}
