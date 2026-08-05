#!/bin/bash

Language=Rust

Native=./mandelbrot

NativeArg=

Iter=5

WasmDir=

rustup toolchain install nightly

# Do not check result due to differences
CheckResult=true