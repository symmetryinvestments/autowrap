namespace Autowrap.CSharp {
    using System;
    using System.Reflection;
    using System.Runtime.InteropServices;

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorBool
    {
        [MarshalAs(UnmanagedType.Bool)]
        public bool value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorByte
    {
        public sbyte value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorUByte
    {
        public byte value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorShort
    {
        public int value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorUShort
    {
        public uint value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorInt
    {
        public int value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorUInt
    {
        public uint value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorLong
    {
        public int value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorULong
    {
        public uint value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorFloat
    {
        public float value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorDouble
    {
        public double value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorIntPtr
    {
        public IntPtr value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorUIntPtr
    {
        public UIntPtr value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorString
    {
        public DLangString value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorWString
    {
        public DLangWString value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorDString
    {
        public DLangDString value;
        public ulong errorId;
    }
}