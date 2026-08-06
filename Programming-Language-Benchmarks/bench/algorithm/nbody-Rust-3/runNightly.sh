#!/bin/bash

Language=Rust

Native=./nbody

NativeArg=

Iter=5

WasmDir=

rustup toolchain install nightly

# Do not check result due to differences
CheckResult=true