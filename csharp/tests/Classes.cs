namespace Autowrap.CSharp.Tests
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Test;

    [TestClass]
    public class Classes
    {
        public Classes() {
            SharedFunctions.DRuntimeInitialize();
        }

        [TestMethod]
        public void ClassFunction() {
            var t = new C1("Hello World!", 1);
            Assert.AreEqual(1, t.IntValue, "Incorrect Value for t.Value");
            var result = t.TestMemberFunction("Hello World!", new S1() {});
            Assert.AreEqual("Hello World!", result, "Incorrect Return Value for t.TestMemberFunction");
        }

        [TestMethod]
        public void ClassParameterlessFunction() {
            var t = new C1("Hello World!", 1);
            var result = t.ParameterlessMethod();
            Assert.AreEqual("Parameterless Method", result, "Incorrect Return Value for t.ParameterlessMethod");
        }

        [TestMethod]
        public void ClassValueMembers() {
            var t = new C1("Hello World!", 1);
            t.BoolMember = true;
            Assert.AreEqual(true, t.BoolMember, "Incorrect Value for t.BoolMember");
            t.ByteMember = 0x01;
            Assert.AreEqual(0x01, t.ByteMember, "Incorrect Value for t.ByteMember");
            t.UbyteMember = 0x01;
            Assert.AreEqual(0x01, t.UbyteMember, "Incorrect Value for t.UbyteMember");
            t.ShortMember = 1;
            Assert.AreEqual(1, t.ShortMember, "Incorrect Value for t.ShortMember");
            t.UshortMember = 1;
            Assert.AreEqual(1, t.UshortMember, "Incorrect Value for t.UshortMember");
            t.IntMember = 1;
            Assert.AreEqual(1, t.IntMember, "Incorrect Value for t.IntMember");
            t.UintMember = 1;
            Assert.AreEqual(1U, t.UintMember, "Incorrect Value for t.UintMember");
            t.LongMember = 1;
            Assert.AreEqual(1, t.LongMember, "Incorrect Value for t.LongMember");
            t.UlongMember = 1;
            Assert.AreEqual(1UL, t.UlongMember, "Incorrect Value for t.UlongMember");
            t.FloatMember = 1.0f;
            Assert.AreEqual(1.0f, t.FloatMember, "Incorrect Value for t.FloatMember");
            t.DoubleMember = 1.0f;
            Assert.AreEqual(1.0f, t.DoubleMember, "Incorrect Value for t.DoubleMember");
            t.StringMember = "String";
            Assert.AreEqual("String", t.StringMember, "Incorrect Value for t.StringMember");
            t.WstringMember = "Wstring";
            Assert.AreEqual("Wstring", t.WstringMember, "Incorrect Value for t.WstringMember");
            t.DstringMember = "Dstring";
            Assert.AreEqual("Dstring", t.DstringMember, "Incorrect Value for t.DstringMember");
            t.ValueMember = new S1() { Value = 2.0f };
            Assert.AreEqual(2.0f, t.ValueMember.Value, "Incorrect Value for t.ValueMember");
            t.RefMember = new C1("Hello World!", 1);
            Assert.AreEqual(1, t.RefMember.IntValue, "Incorrect Value for t.RefMember.IntValue");
        }

        [TestMethod]
        public void ClassValueProperties() {
            var t = new C1("Hello World!", 1);

            Assert.AreEqual(1001UL, t.ValueProperty, "Incorrect Value for t.ValueProperty");
            t.ValueProperty = 1UL;
            Assert.AreEqual(1UL, t.ValueProperty, "Incorrect Value for t.ValueProperty");
            t.StructProperty = new S2() { Value = 1, Str = "Hello World!" };
            Assert.AreEqual("Hello World!", t.StructProperty.Str, "Incorrect Value for t.StructProperty.Str");
            t.RefProperty = new C1("Hello World!", 1);
            Assert.AreEqual(1, t.RefProperty.IntValue, "Incorrect Value for t.RefProperty.IntValue");
        }
    }
}