/**
   A module that doesn't get mentioned explicitly in app, just to test that its
   definitions turn up.
 */
module impl;

struct OtherString {
    string s;
    this(string s) { this.s = s; }
}
