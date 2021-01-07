# purescript-simple-csv

This package provides the feature to parse string into CSV and print CSV into string. Parsing and printing in this package are based on [RFC4180](https://www.ietf.org/rfc/rfc4180.txt) that means:

- field may or may not be enclosed by double-quotes but if the field contains line breaks, double quotes or commas, it's always enclosed by double quotes like "hello, world"
- double quote inside field is escaped by preceding double-quote like "b""bb"

But for the sake of "simple but usefull as much as possible" policy, it's not fully compliant with RFC4180 like:

- line breaks can be CR, LF or CRLF on parsing
- header is not handled by this library itself. CSV type is just alias for `Array (Array String)` and it may or may not contain header
- the number of fields on each record can differ. It's not checked at all on parsing and printing.
- the last record in the file may or may not have an ending line break. This means parsing "aaa,bbb,ccc CRLF" becomes `[["aaa", "bbb", "ccc"]]` instead of `[["aaa", "bbb", "ccc"], [""]]`
- if you try to parse "", it returns `[]` instead of `[[""]]`

TSV(Tab-Separated Values) is also supported and the spec is basically the same as the CSV one described above.