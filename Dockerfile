FROM ubuntu:26.04
LABEL authors="tillmannhegner"

RUN apt-get update

RUN apt install -y curl
RUN apt-get install -y wget
RUN apt install -y xz-utils
RUN apt-get install -y curl
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
RUN apt-get install -y bc
RUN apt install -y clang
RUN apt-get update
RUN apt-get install -y build-essential
#RUN apt install --reinstall -y libc6-dev libc6
RUN wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-10/wasi-sdk-10.0-linux.tar.gz
RUN tar -xzf wasi-sdk-10.0-linux.tar.gz
RUN apt-get install -y time

RUN mkdir wabench
COPY . /home/wabench
WORKDIR /home/wabench

ENTRYPOINT ["./run.sh"]