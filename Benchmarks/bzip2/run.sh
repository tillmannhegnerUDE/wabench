#!/bin/bash

Language=C

Native=./bzip2

NativeArg="-k -f -z input_file"

Iter=1

WasmDir=.



# Do not check result due to differences
CheckResult=false