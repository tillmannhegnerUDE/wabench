#!/bin/bash

Language=C

Native=./crc32

NativeArg="large.pcm"

Iter=10

WasmDir=.

RunAOT=false

# Do not check result due to differences
CheckResult=false