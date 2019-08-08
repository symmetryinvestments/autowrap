namespace Autowrap.CSharp.Examples.Simple.Tests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Autowrap;

    [TestClass]
    public class TestSimple
    {
        public TestSimple()
        {
            SharedFunctions.DRuntimeInitialize();
        }

        [TestMethod]
        public void ImaTest()
        {
            Console.WriteLine("I'm a test!");
        }
    }
}
