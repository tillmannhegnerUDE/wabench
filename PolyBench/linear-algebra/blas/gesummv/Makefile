Benchmark = gesummv

SRCDIR = ./src
SRCSUFFIX = c

CFLAGS = -DPOLYBENCH_DUMP_ARRAYS -DPOLYBENCH_USE_C99_PROTO
CINCLUDE = -I./src

LDFLAGS =
WASMFLAGS = -D_WASI_EMULATED_PROCESS_CLOCKS -lwasi-emulated-process-clocks

include ../../../../Makefile.in
