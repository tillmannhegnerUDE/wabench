Benchmark = tsf

SRCDIR = ./src
SRCSUFFIX = c

CFLAGS = -g1 -std=c99 -D_POSIX_C_SOURCE=1 -include strings.h -include alloca.h -include string.h -DTSF_BUILD_SYSTEM=1
CINCLUDE = -I./src
OPT = -O2
LDFLAGS = -lm

TEMPFILE = tsf_ir_speed_test_file.tsf

include ../../Makefile.in
