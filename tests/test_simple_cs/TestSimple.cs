namespace Autowrap.CSharp.Examples.Simple.Tests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Autowrap.CSharp.Examples.Simple;

    [TestClass]
    public class TestSimple
    {
        public TestSimple()
        {
            SharedFunctions.DruntimeInitialize();
        }

        [TestMethod]
        public void ImaTest()
        {
            Console.WriteLine("I'm a test!");
        }
    }
}
