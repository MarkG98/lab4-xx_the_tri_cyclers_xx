#! /usr/bin/env python3
"""Read tests from a csv and output verilog code.

Usage: `./buildtests.py tests.csv`

This expects a csv file with columns 'a,b,comment'.
'a' and 'b' are 4-digit bitstring inputs to set, and 'comment' will be left in a comment above the
test.
"""
import csv
import sys

def bs_literal(bitstring):
    return "'b{}".format(bitstring)

def assign(name, value):
    """Assign a value.

    >>> assign('a', "'b0111")
    "a='b0111;"
    """
    return "{}={};".format(name, value)

def test_eq(multiplicand1, multiplicand2, test):
    """Test that a value is equal to an expected value."""
    return '`check_eq({},8{} * 8{});'.format(test,multiplicand1, multiplicand2)


def make_test(**values):
    """Builds a string of verilog code to set, test, and print the result."""
    def fmt_bitstring(b):
        # adds the 'b for a verilog binary literal
        return bs_literal(b)

    return '\n'.join(filter(None, (
        '// {}'.format(values['comment']) if values['comment'] else None,
        '$display("{}");'.format(values['comment']) if values['comment'] else None,
        '@(negedge clk);',
        assign('a', fmt_bitstring(values['a'])),
        assign('b', fmt_bitstring(values['b'])),
        assign('start',fmt_bitstring(1)),
        '@(negedge clk);',
        assign('start',fmt_bitstring(0)),
        '@(posedge done) #1;',
        '`DELAY `print;',
        test_eq(fmt_bitstring(values['a']),fmt_bitstring(values['b']), 'res'),
        '@(posedge clk);'
    )))

def printRow(row):
    print(row["Phase"]+"_"+row["Operation"]+": ", "begin ",end="")
    for i in row:
        if(not(i == "Phase" or i =="Operation")):
            print(i + " = " + row[i] + "; ",end="")
    print("end")

def main():
    if len(sys.argv) < 2:
        print('Provide a csv file of tests')
        sys.exit(1)
    fname = sys.argv[1]
    with open(fname) as f:
        reader = list(csv.DictReader(f))
        for row in reader:
            printRow(row)
if __name__ == '__main__':
    main()
