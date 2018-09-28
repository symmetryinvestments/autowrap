module csharp.library;

//export:

export int freeFunction (int value) {
	return value;
}

export extern(C) string stringFunction(string value) {
	return value;
}

s2[] arrayFunction(s2[] arr) {
    return arr.dup;
}

c1[] classRangeFunction(c1[] arr) {
    import std.stdio;
    writeln("Array Length: ", arr.length);
    foreach (c1 a; arr) {
        writeln("Class String Value: ", a.stringValue);
        writeln("Class Int Value: ", a.intValue);
    }
    return arr.dup;
}

string testErrorMessage(bool throwError) {
    if(throwError) 
        throw new Exception("Test Error Message");
    else
        return "No Error Thrown";
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
}

struct s2 {
	public int value;
	public string str;
}

class c1 {
	public int intValue;
	public string stringValue;

	//TODO: We will deal with these cases later.
	//public c1 refMember;
	//public c1[] refArray;
	//public s1[] structArray;

	private s2 hidden;
	public @property s2 getHidden() {
		return hidden;
	}
	public @property s2 setHidden(s2 value) {
		return hidden = value;
	}

	public string testMemberFunc(string test, s1 value){
		return test;
	}
}
