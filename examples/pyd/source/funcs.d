module funcs;

string appends_to_fn_cb(string function(int) callback, int i, string s) {
    return callback(i) ~ s;
}
