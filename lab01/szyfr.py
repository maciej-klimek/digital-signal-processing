szyfrogram = "WXQOWK LXCFRXBCXUAWJO R URXLXCFRXBCXUAWJO J AKAWXQOBM WXNXRUSDEQOWKBCUKBM FDEPACOQK UO NOLDEOWDEROBM"
replacement_map = {
    "X": "E",
    "U": "N",
    "R": "I",
    "L": "B",
    "C": "Z",
    "F": "P",
    "R": "I",
    "B": "C",
    "C": "Z",
    "A": "S",
    "W": "T",
    "J": "W",
    "O": "A",
    "K": "Y",
    "Q": "M",
    "M": "H",
    "N": "L",
    "S": "F",
    "D": "O",
    "E": "R",
    "P": "U"
}

result = ""
for letter in szyfrogram:
    if letter in replacement_map:
        result += replacement_map[letter]
    else:
        result += letter

print(result)
