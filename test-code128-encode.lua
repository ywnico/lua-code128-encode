dofile("code128-encode.lua")


assert(not isStringLatin1("abcなに"))
assert(isStringLatin1("Le Vent se lève"))


str_long           = "123456blah123456a1234nd33838388and12313212"
str_nonascii       = "123bl1234Ând3383212"
str_ascii          = "asdkfasdkfjhjh"
str_broken_numbers = "098x1234567y23"
str_numbers        = "09811234567323"
str_Wikipedia      = "Wikipedia" -- compare to https://en.wikipedia.org/wiki/Code_128#/media/File:Barcode_diagram.svg
str_RI47           = "RI476394652CH" -- compare to https://en.wikipedia.org/wiki/Code_128#/media/File:9494-RI476394652CH.jpg

pat_long           = code128Encode(str_long)
pat_nonascii       = code128Encode(str_nonascii)
pat_ascii          = code128Encode(str_ascii)
pat_broken_numbers = code128Encode(str_broken_numbers)
pat_numbers        = code128Encode(str_numbers)
pat_Wikipedia      = code128Encode(str_Wikipedia)
pat_RI47           = code128Encode(str_RI47)

code128EncodeBMP(str_long,           "barcode_test_long.bmp",           80)
code128EncodeBMP(str_nonascii,       "barcode_test_nonascii.bmp",       1, 3)
code128EncodeBMP(str_ascii,          "barcode_test_ascii.bmp",          1, 3)
code128EncodeBMP(str_broken_numbers, "barcode_test_broken_numbers.bmp", 1, 3)
code128EncodeBMP(str_numbers,        "barcode_test_numbers.bmp",        1, 3)
code128EncodeBMP(str_Wikipedia,      "barcode_test_Wikipedia.bmp",      1, 3)
code128EncodeBMP(str_RI47,           "barcode_test_RI47.bmp",           1, 3)
