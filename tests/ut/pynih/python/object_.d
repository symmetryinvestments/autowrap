module pynih.python.object_;


import unit_threaded;
import python.object_;
import python.conv;
import python.exception;


@("lt")
unittest {
    const three = PythonObject(3);
    const five = PythonObject(5);

    (three < five).should == true;
    (five < three).should == false;

    (three < PythonObject("foo"))
        .shouldThrowWithMessage!PythonException(
            "TypeError: '<' not supported between instances of 'int' and 'str'");
}
