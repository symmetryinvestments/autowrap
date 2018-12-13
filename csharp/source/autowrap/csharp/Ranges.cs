    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    internal class RangeFunctions {
%1$s
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    public class Range<T> : IEnumerable<T> {
        private slice _slice;
        private DStringType _type;
        private IList<string> _strings;

        internal slice ToSlice(DStringType type = DStringType.None) {
            if (type == DStringType.None && _strings != null) {
                throw new TypeAccessException("Cannot pass a range of strings to a non-string range.");
            }

            if (_strings == null) {
                return _slice;
            } else {
                _type = type;
                if (_type == DStringType._string) {
                    _slice = RangeFunctions.String_Create(new IntPtr(_strings.Count()));
                    foreach(var s in _strings) {
                        _slice = RangeFunctions.String_AppendValue(_slice, SharedFunctions.CreateString(s));
                    }
                } else if (_type == DStringType._wstring) {
                    _slice = RangeFunctions.Wstring_Create(new IntPtr(_strings.Count()));
                    foreach(var s in _strings) {
                        _slice = RangeFunctions.Wstring_AppendValue(_slice, SharedFunctions.CreateWstring(s));
                    }
                } else if (_type == DStringType._dstring) {
                    _slice = RangeFunctions.Dstring_Create(new IntPtr(_strings.Count()));
                    foreach(var s in _strings) {
                        _slice = RangeFunctions.Dstring_AppendValue(_slice, SharedFunctions.CreateDstring(s));
                    }
                }
                _strings = null;
                return _slice;
            }
        }
        public long Length => _strings?.Count ?? _slice.length.ToInt64();

        internal Range(slice range, DStringType type) {
            this._slice = range;
            this._type = type;
        }

        public Range(IEnumerable<T> values) {
            if (typeof(T) == typeof(string)) {
                this._strings = new List<string>();
                foreach(var t in values) {
                    this._strings.Add((string)(object)t);
                }
            } else {
                CreateSlice(values.Count());
                foreach(var t in values) {
                    this.Append(t);
                }
            }
        }

        public Range(long capacity = 0) {
            CreateSlice(capacity);
        }
        private void CreateSlice(long capacity) {
%2$s
            else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
        }
        ~Range() {
            SharedFunctions.ReleaseMemory(_slice.ptr);
        }

        public T this[long i] {
            get {
%3$s
                else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
            }
            set {
%4$s
            }
        }
        public Range<T> Slice(long begin) {
%5$s
            else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
        }
        public Range<T> Slice(long begin, long end) {
            if (end > (_strings?.Count ?? _slice.length.ToInt64())) {
                throw new IndexOutOfRangeException("Value for parameter 'end' is greater than that length of the slice.");
            }
%6$s
            else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
        }
        private void Append(T value) {
%7$s
            else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
        }
        public static Range<T> operator +(Range<T> range, T value) {
            range.Append(value);
            return range;
        }
        public static Range<T> operator +(Range<T> range, Range<T> source) {
%8$s
            else throw new TypeAccessException($"Range does not support type: {typeof(T).ToString()}");
        }
        public IEnumerator<T> GetEnumerator() {
            for(long i = 0; i < (_strings?.Count ?? _slice.length.ToInt64()); i++) {
%9$s
            }
        }

        public static implicit operator T[](Range<T> slice) {
            return slice.ToArray();
        }
        public static implicit operator Range<T>(T[] array) {
            return new Range<T>(array);
        }
        public static implicit operator List<T>(Range<T> slice) {
            return new List<T>(slice.ToArray());
        }
        public static implicit operator Range<T>(List<T> array) {
            return new Range<T>(array);
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => this.GetEnumerator();
    }