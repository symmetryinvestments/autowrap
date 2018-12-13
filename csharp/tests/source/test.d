module test;

export string parameterlessFunction() {
    return "Parameterless Function";
}

export int freeFunction (int value) {
    return value;
}

export string stringFunction(string value) nothrow {
    return value;
}

export s2[] rangeFunction(s2[] arr) {
    return arr.dup;
}

export c1[] classRangeFunction(c1[] arr) {
    return arr.dup;
}

export string testErrorMessage(bool throwError) {
    if(throwError) 
        throw new Exception("Test Error Message");
    else
        return "No Error Thrown";
}

export string[] testStringRanges(dstring[] arr) {
    import std.conv : to;
    string[] temp;
    foreach(s; arr) {
        temp ~= to!string(s);
    }
    return temp;
}

struct s1 {
    public float value;
    public s2 nestedStruct;

    public float getValue() {
        return value;
    }

    public void setNestedStruct(s2 nested) {
        nestedStruct = nested;
    }

    public string parameterlessMethod() {
        return "Parameterless Method";
    }
}

struct s2 {
    public int value;
    public string str;
}

class c1 {
    public int intValue;
    protected string stringValue;
    public @property string StringValueGetter() {
        return stringValue;
    }

    public this(string s, int i) {
        intValue = i;
        stringValue = s;
    }

    public string parameterlessMethod() {
        return "Parameterless Method";
    }

    //Member variable test cases
    public bool boolMember;
    public byte byteMember;
    public ubyte ubyteMember;
    public short shortMember;
    public ushort ushortMember;
    public int intMember;
    public uint uintMember;
    public long longMember;
    public ulong ulongMember;
    public float floatMember;
    public double doubleMember;
    public string stringMember;
    public wstring wstringMember;
    public dstring dstringMember;
    public s1 valueMember;
    public c1 refMember;
    public c1[] refArray;
    public s1[] structArray;

    //Property test cases
    private s2 _structProperty;
    public @property s2 structProperty() {
        return _structProperty;
    }
    public @property s2 structProperty(s2 value) {
        return _structProperty = value;
    }
    
    private c1 _refProperty;
    public @property c1 refProperty() {
        return _refProperty;
    }
    public @property c1 refProperty(c1 value) {
        return _refProperty = value;
    }
    
    private ulong _valueProperty = 1001;
    public @property ulong valueProperty() {
        return _valueProperty;
    }
    public @property ulong valueProperty(ulong value) {
        return _valueProperty = value;
    }
    
    private ulong[] _valueSliceProperty;
    public @property ulong[] valueSliceProperty() {
        return valueSliceProperty;
    }
    public @property ulong[] valueSliceProperty(ulong[] value) {
        return valueSliceProperty = value;
    }
    
    private string[] _stringSliceProperty;
    public @property string[] stringSliceProperty() {
        return _stringSliceProperty;
    }
    public @property string[] stringSliceProperty(string[] value) {
        return _stringSliceProperty = value;
    }
    
    private wstring[] _wstringSliceProperty;
    public @property wstring[] wstringSliceProperty() {
        return _wstringSliceProperty;
    }
    public @property wstring[] wstringSliceProperty(wstring[] value) {
        return _wstringSliceProperty = value;
    }
    
    private dstring[] _dstringSliceProperty;
    public @property dstring[] dstringSliceProperty() {
        return _dstringSliceProperty;
    }
    public @property dstring[] dstringSliceProperty(dstring[] value) {
        return _dstringSliceProperty = value;
    }
    
    private s1[] _structSliceProperty;
    public @property s1[] structSliceProperty() {
        return _structSliceProperty;
    }
    public @property s1[] structSliceProperty(s1[] value) {
        return _structSliceProperty = value;
    }
    
    private c1[] _refSliceProperty;
    public @property c1[] refSliceProperty() {
        return _refSliceProperty;
    }
    public @property c1[] refSliceProperty(c1[] value) {
        return _refSliceProperty = value;
    }

    public string testMemberFunction(string test, s1 value){
        return test;
    }
}
