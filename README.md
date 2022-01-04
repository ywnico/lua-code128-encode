# lua-code128-encode

Lua library for producing [Code 128](https://en.wikipedia.org/wiki/Code_128) barcodes.

This has been tested only minimally. It seems to work, but more rigorous testing would be required to use in production.

## Usage

`code128Encode(input_string)` returns a list of 0s and 1s, 0 representing white and 1 black in the barcode.

`code128EncodeBMP(input_string, output_file, aspect_height, aspect_width)` creates a code 128 barcode from `input_string` and exports the result to `output_file`. The width is set by the number of bars and the height is set such that the output has the aspect ratio `aspect_width`/`aspect_height`.

`code128EncodeBMP(input_string, output_file, height_px)` creates a code 128 barcode from `input_string` and exports the result to `output_file`. The width is set by the number of bars and the height is set to `height_px` pixels.

Note that Code 128 allows encoding only of Latin-1 (ISO/IEC 8859-1) strings. Two helper functions are thus provided: `isStringLatin1` to test whether a string is Latin-1 encoded, and `utf8ToLatin1`, which converts a UTF-8 encoded string to Latin-1.

## License

The Lua [bitmap library](https://github.com/PG1003/bitmap/) from PG1003 is included under its original MIT license.

Remaining files are released under the Apache 2.0 license.
