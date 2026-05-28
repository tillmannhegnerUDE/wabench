FROM ubuntu:latest
LABEL authors="tillmannhegner"

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    xz-utils \
    libc6-dev \
    clang \
    make \
    build-essential \
    linux-libc-dev \
    time \
    bc

WORKDIR /home/
RUN wget https://github.com/bytecodealliance/wasmtime/releases/download/dev/wasmtime-dev-x86_64-linux.tar.xz
RUN tar -xf wasmtime-dev-x86_64-linux.tar.xz
RUN wget https://github.com/WAVM/WAVM/releases/download/nightly%2F2026-04-05/wavm-nightly-2026-04-05-linux-x64.tar.gz
RUN tar -xzf wavm-nightly-2026-04-05-linux-x64.tar.gz
RUN curl https://get.wasmer.io -sSfL | sh -s "v6.1.0"
RUN wget https://github.com/wasm3/wasm3/releases/download/v0.5.0/wasm3-linux-x64.elf
RUN chmod +x wasm3-linux-x64.elf
RUN wget https://github.com/bytecodealliance/wasm-micro-runtime/releases/download/WAMR-2.4.4/iwasm-2.4.4-x86_64-ubuntu-22.04.tar.gz
RUN tar -xzf iwasm-2.4.4-x86_64-ubuntu-22.04.tar.gz
#RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.0/LLVM-22.1.0-Linux-X64.tar.xz
#RUN tar -xf LLVM-22.1.0-Linux-X64.tar.xz
RUN wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-10/wasi-sdk-10.0-linux.tar.gz
RUN tar -xzf wasi-sdk-10.0-linux.tar.gz

RUN mkdir wabench
COPY . /home/wabench
WORKDIR /home/wabench

ENTRYPOINT ["./run.sh", "-n"]