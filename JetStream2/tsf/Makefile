Benchmark = tsf

SRCDIR = ./src
SRCSUFFIX = c
#-D_POSIX_C_SOURCE=200809L
CFLAGS = -g1 -std=gnu90  -D_GNU_SOURCE -include strings.h -include alloca.h -include string.h -DTSF_BUILD_SYSTEM=1
CINCLUDE = -I./src
OPT = -O2
LDFLAGS = -lm
# -D _POSIX_C_SOURCE=200809L
WASMFlags = -D _GNU_SOURCE=1 -D TSF_BUILD_SYSTEM=1

TEMPFILE = tsf_ir_speed_test_file.tsf

include ../../Makefile.in
