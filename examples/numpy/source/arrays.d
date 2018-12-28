int[] append42(int[] arr) {
    return arr ~ 42;
}

double[][] matrixInc1(double[][] arr) {
    foreach(i; 0 .. arr.length) {
        foreach(j; 0 .. arr[i].length) {
            ++arr[i][j];
        }
    }

    return arr;
}
