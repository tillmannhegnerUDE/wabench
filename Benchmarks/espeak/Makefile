Benchmark = espeak

SRCDIR = ./src
SRCSUFFIX = cpp

CFLAGS = -fno-exceptions -std=c++98  -DPATH_ESPEAK_DATA=\"./espeak-data\"
CINCLUDE = -I./src
OPT = -O2
LDFLAGS =
WASMFLAGS = -D_WASI_EMULATED_SIGNAL -lwasi-emulated-signal

include ../../Makefile.in
