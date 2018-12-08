namespace Autowrap.CSharp.Tests
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Test;

    [TestClass]
    public class Structs
    {
        public Structs() {
            SharedFunctions.DRuntimeInitialize();
        }

        [TestMethod]
        public void StructParameterlessFunction() {
            S1 t = new S1();
            var result = t.ParameterlessMethod();
            Assert.AreEqual("Parameterless Method", result, "Incorrect Return Value for t.ParameterlessMethod");
        }

        [TestMethod]
        public void StructFunction() {
            S2 x = new S2();
            x.Value = 1;
            x.Str = "Hello World!";
            Assert.AreEqual(1, x.Value, "Incorrect Value for S2.Value");
            Assert.AreEqual("Hello World!", x.Str, "Incorrect Value for S2.Str");

            S1 t = new S1();
            t.Value = 1.0f;
            Assert.AreEqual(1.0f, t.Value, "Incorrect Value for S1.Value");
            t.SetNestedStruct(x);
            Assert.AreEqual("Hello World!", t.NestedStruct.Str, "Incorrect Value for t.NestedStruct.Str");
            Assert.AreEqual(1, t.NestedStruct.Value, "Incorrect Value for t.NestedStruct.Value");
            Assert.AreEqual(1.0f, t.Value, "Incorrect Value for S1.Value");
        }
    }
}