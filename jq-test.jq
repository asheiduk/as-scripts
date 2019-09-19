#!/usr/bin/jq --run-tests
# test 1
.
{"FOO":{"key1":42,"key2":"foo"},"BAR":{"key1":21,"key2":"bar"}}
{"FOO":{"key1":42,"key2":"foo"},"BAR":{"key1":21,"key2":"bar"}}

# test 2
.[]
{"FOO":{"key1":42,"key2":"foo"},"BAR":{"key1":21,"key2":"bar"}}
{"key1":42,"key2":"foo"}
{"key1":21,"key2":"bar"}

# test 3
.[][]
{"FOO":{"key1":42,"key2":"foo"},"BAR":{"key1":21,"key2":"bar"}}
42
"foo"
21
"bar"

# Rename Keys with data from object and "String interpolation"
with_entries(.key = "\(.key)-\(.value.key2)" )
{"FOO":{"key1":42,"key2":"foo"},"BAR":{"key1":21,"key2":"bar"}}
{"FOO-foo":{"key1":42,"key2":"foo"},"BAR-bar":{"key1":21,"key2":"bar"}}

# Syntax-Tip: `def` and multiple arguments:
def foo($a; $b): $a == $b; foo(.a; .b)
{ "a": 42, "b": 42 }
true