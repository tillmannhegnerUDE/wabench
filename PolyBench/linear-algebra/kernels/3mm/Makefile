Benchmark = 3mm

SRCDIR = ./src
SRCSUFFIX = c

CFLAGS = -DPOLYBENCH_DUMP_ARRAYS -DPOLYBENCH_USE_C99_PROTO
CINCLUDE = -I${SRCDIR}
OPT = -O2
LDFLAGS =
WASMFLAGS = -D_WASI_EMULATED_PROCESS_CLOCKS -lwasi-emulated-process-clocks

include ../../../../Makefile.in
