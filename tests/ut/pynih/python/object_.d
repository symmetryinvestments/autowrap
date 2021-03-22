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
    (three < three).should == false;
    (five < three).should == false;

    (three < PythonObject("foo"))
        .shouldThrowWithMessage!PythonException(
            "TypeError: '<' not supported between instances of 'int' and 'str'");
}


@("le")
unittest {
    const three = PythonObject(3);
    const five = PythonObject(5);

    (three <= five).should == true;
    (three <= three).should == true;
    (five <= three).should == false;

    (three <= PythonObject("foo"))
        .shouldThrowWithMessage!PythonException(
            "TypeError: '<' not supported between instances of 'int' and 'str'");
}


@("eq")
unittest {
    const three = PythonObject(3);
    const five = PythonObject(5);

    (three == three).should == true;
    (three == five).should == false;
    (five == three).should == false;

    (three == PythonObject("foo")).should == false;
}



@("gt")
unittest {
    const three = PythonObject(3);
    const five = PythonObject(5);

    (three > five).should == false;
    (three > three).should == false;
    (five > three).should == true;

    (three < PythonObject("foo"))
        .shouldThrowWithMessage!PythonException(
            "TypeError: '<' not supported between instances of 'int' and 'str'");
}


@("ge")
unittest {
    const three = PythonObject(3);
    const five = PythonObject(5);

    (three >= five).should == false;
    (three >= three).should == true;
    (five >= three).should == true;

    (three <= PythonObject("foo"))
        .shouldThrowWithMessage!PythonException(
            "TypeError: '<' not supported between instances of 'int' and 'str'");
}


@("str")
unittest {
    PythonObject(3).str.toString.should == "3";
    PythonObject("foo").str.toString.should == "foo";
    PythonObject([1: 2]).str.toString.should == "{1: 2}";
}


@("repr")
unittest {
    PythonObject(3).repr.toString.should == "3";
    PythonObject("foo").repr.toString.should == "'foo'";
    PythonObject([1: 2]).repr.toString.should == "{1: 2}";
}


@("toString")
unittest {
    PythonObject(3).toString.should == "3";
    PythonObject("foo").toString.should == "foo";
    PythonObject([1: 2]).toString.should == "{1: 2}";
}
