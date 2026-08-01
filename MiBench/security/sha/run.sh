#!/bin/bash

Language=C

Native=./sha

NativeArg="input_large.asc"

Iter=10

WasmDir=.



# Do not check result due to differences
CheckResult=false

. ../../../common.sh
