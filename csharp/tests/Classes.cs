namespace Autowrap.CSharp.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
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
        public void ClassSysDateTime() {
            var t = new C1("Hello World!", 1);
            var dt1 = new DateTime(2000, 1, 1, 0,0,0, DateTimeKind.Utc);
            var dt2 = new DateTime(2000, 1, 1, 0,0,0, DateTimeKind.Utc);
            var dt3 = new DateTime(2000, 1, 1, 0,0,0, DateTimeKind.Utc);
            var dta = new DateTime[] {dt1, dt2, dt3};
            var dto1 = new DateTimeOffset(dt1, new TimeSpan(0));
            var dto2 = new DateTimeOffset(dt2, new TimeSpan(0));
            var dto3 = new DateTimeOffset(dt3, new TimeSpan(0));
            var dtoa = new DateTimeOffset[] {dto1, dto2, dto3};
            var ts1 = new TimeSpan(1,0,0);
            var ts2 = new TimeSpan(2,0,0);
            var ts3 = new TimeSpan(3,0,0);
            var ts4 = new TimeSpan(4,0,0);
            var tsa = new TimeSpan[] {ts1, ts2, ts3, ts4};

            t.DateMember = dt1;
            Assert.AreEqual(dt1.Date, t.DateMember.Date, "Incorrect Value for t.DateMember");
            t.DateArray = dta;
            Assert.AreEqual(dta.Length, t.DateArray.Length, "Incorrect Length for t.DateArray");
            Assert.AreEqual(dt1.Date, t.DateArray[0].Date, "Incorrect Value for t.DateArray[0]");
            Assert.AreEqual(dt2.Date, t.DateArray[1].Date, "Incorrect Value for t.DateArray[1]");
            Assert.AreEqual(dt3.Date, t.DateArray[2].Date, "Incorrect Value for t.DateArray[2]");

            t.DateTimeMember = dt1;
            Assert.AreEqual(dt1, t.DateTimeMember, "Incorrect Value for t.DateTimeMember");
            t.DateTimeArray = dta;
            Assert.AreEqual(dta.Length, t.DateTimeArray.Length, "Incorrect Length for t.DateTimeArray");
            Assert.AreEqual(dt1, t.DateTimeArray[0], "Incorrect Value for t.DateTimeArray[0]");
            Assert.AreEqual(dt2, t.DateTimeArray[1], "Incorrect Value for t.DateTimeArray[1]");
            Assert.AreEqual(dt3, t.DateTimeArray[2], "Incorrect Value for t.DateTimeArray[2]");

            t.TimeOfDayMember = dt1;
            Assert.AreEqual(dt1.TimeOfDay, t.TimeOfDayMember.TimeOfDay, "Incorrect Value for t.TimeOfDayMember");
            t.TimeOfDayArray = dta;
            Assert.AreEqual(dta.Length, t.TimeOfDayArray.Length, "Incorrect Length for t.TimeOfDayArray");
            Assert.AreEqual(dt1.TimeOfDay, t.TimeOfDayArray[0].TimeOfDay, "Incorrect Value for t.TimeOfDayArray[0]");
            Assert.AreEqual(dt2.TimeOfDay, t.TimeOfDayArray[1].TimeOfDay, "Incorrect Value for t.TimeOfDayArray[1]");
            Assert.AreEqual(dt3.TimeOfDay, t.TimeOfDayArray[2].TimeOfDay, "Incorrect Value for t.TimeOfDayArray[2]");

            t.SysTimeMember = dto1;
            Assert.AreEqual(dto1, t.SysTimeMember, "Incorrect Value for t.SysTimeMember");
            t.SysTimeArray = dtoa;
            Assert.AreEqual(dtoa.Length, t.SysTimeArray.Length, "Incorrect Length for t.SysTimeArray");
            Assert.AreEqual(dto1, t.SysTimeArray[0], "Incorrect Value for t.SysTimeArray[0]");
            Assert.AreEqual(dto2, t.SysTimeArray[1], "Incorrect Value for t.SysTimeArray[1]");
            Assert.AreEqual(dto3, t.SysTimeArray[2], "Incorrect Value for t.SysTimeArray[2]");

            t.DurationMember = ts1;
            Assert.AreEqual(ts1, t.DurationMember, "Incorrect Value for t.DurationMember");
            t.DurationArray = tsa;
            Assert.AreEqual(tsa.Length, t.DurationArray.Length, "Incorrect Length for t.DurationArray");
            Assert.AreEqual(ts1, t.DurationArray[0], "Incorrect Value for t.DurationArray[0]");
            Assert.AreEqual(ts2, t.DurationArray[1], "Incorrect Value for t.DurationArray[1]");
            Assert.AreEqual(ts3, t.DurationArray[2], "Incorrect Value for t.DurationArray[2]");
            Assert.AreEqual(ts4, t.DurationArray[3], "Incorrect Value for t.DurationArray[3]");
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