Benchmark = bzip2

SRCDIR = ./src
SRCSUFFIX = c

CFLAGS = -D_FILE_OFFSET_BITS=64
CINCLUDE =
OPT = -O2
LDFLAGS =
WASMFLAGS = -D_WASI_EMULATED_SIGNAL -lwasi-emulated-signal -D_WASI_EMULATED_PROCESS_CLOCKS -lwasi-emulated-process-clocks

TEMPFILE = input_file.bz2

include ../../Makefile.in
