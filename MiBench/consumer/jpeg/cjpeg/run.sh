#!/bin/bash

Language=C

Native=./cjpeg

NativeArg="-dct int -progressive -opt -outfile output_large_encode.jpeg input_large.ppm"

Iter=5

WasmDir=.



# Do not check result due to differences
CheckResult=false