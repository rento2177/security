let alpha = {
    "a": 2147, 
    "b": 3675, 
    "c": 5127, 
    "d": 7983, 
    "e": 1135, 
    "f": 1376, 
    "g": 1799, 
    "h": 1939, 
    "i": 2321, 
    "j": 3121, 
    "k": 3782, 
    "l": 4166, 
    "m": 4399, 
    "n": 4734, 
    "o": 5319, 
    "p": 5975, 
    "q": 6181, 
    "r": 6721, 
    "s": 7143, 
    "t": 7321, 
    "u": 7945, 
    "v": 8367, 
    "w": 8999, 
    "x": 9751, 
    "y": 9822, 
    "x": 9933, 
    "A": 1221, 
    "B": 1233, 
    "C": 1255, 
    "D": 1277, 
    "E": 1211, 
    "F": 2213, 
    "G": 5217, 
    "H": 2319, 
    "I": 1223, 
    "J": 1231, 
    "K": 9237, 
    "L": 2241, 
    "M": 1243, 
    "N": 5247, 
    "O": 8253, 
    "P": 7259, 
    "Q": 5261, 
    "R": 4267, 
    "S": 1271, 
    "T": 1273, 
    "U": 1279, 
    "V": 1283, 
    "W": 1289, 
    "X": 1297, 
    "Y": 2298, 
    "Z": 3299, 
    "{": 4991, 
    "}": 5883, 
    " ": 5727, 
    "=": 5999, 
    "+": 4413, 
    "-": 1272, 
    "*": 831, 
    "/": 1371, 
    "\"": 139, 
    "'": 149, 
    "~": 151, 
    ".": 157, 
    ",": 163, 
    "\n": 9999
}

function crypt(str) {
    for (i in alpha) {
        str = str.replaceAll(i, "@" + alpha[i] + "0");
    }
    return str;
}

function decrypt(str) {
    for (i in alpha) {
        str = str.replaceAll("@" + alpha[i] + "0", i);
    }
    return str;
}