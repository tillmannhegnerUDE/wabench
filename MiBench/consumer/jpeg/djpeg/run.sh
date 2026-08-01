#!/bin/bash

Language=C

Native=./djpeg

NativeArg="-dct int -ppm -outfile output_large_decode.ppm input_large.jpg"

Iter=1

WasmDir=.



# Do not check result due to differences
CheckResult=false