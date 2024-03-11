text = "TEMATY BEZPIECZENSTWA I NIEBEZPIECZENSTWA W SYSTEMACH TELEINFORMATYCZNYCH PORUSZAMY NA LABORATORIACH"

translation_dict = {
    "E": [1, 2, 3, 'a', 5, 6, 7, 'b', 9, 10, 11],
    "A": ['c', 13, 14, 15, 'd', 17, 18, 19, 'e', 21],
    "T": [22, 23, 'f', 25, 26, 27, 'g', 29],
    "I": [30, '&', 32, 33, 34, 35],
    "N": [36, 37, 'h', 39, 40, 41],
    "C": [42, 43, 44, 45, 46, 47],
    "Z": [48, 49, 50, 51, 52, 53],
    "Y": [54, '%', 56, 57, 58],
    "S": [59, 60, 61, 62, 63],
    "M": [64, 65, 66, 67],
    "O": [65, 66, 67, 68],
    "R": [69, 70, '$', 72],
    "H": [73, 74, 75],
    "B": [76, 77, 78],
    "W": [79, '#', 81],
    "L": [82, 83, 84],
    "P": [85, 'ZRYT'],
    "U": [87],
    "F": [88],
    " ": " "
}

iterators = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

result = ""
for letter in text:
    i = 0
    while str(translation_dict[letter][i]) == "x":
        i += 1
    result += str(translation_dict[letter][i])
    
print(result)
