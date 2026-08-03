FROM snowstep/llvm:jammy
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
    bc \
    git \
    cmake \
    ninja-build \
    gcc-multilib \
    python3 \
    g++-multilib  \
    libgcc-11-dev  \
    lib32gcc-11-dev  \
    ccache \
    flex \
    bison \
    libelf-dev \
    libdw-dev \
    libaudit-dev \
    libunwind-dev  \
    libslang2-dev \
    python3-dev  \
    systemtap-sdt-dev \
    libperl-dev libnuma-dev \
    libcap-dev libbfd-dev \
    zlib1g-dev  \
    pkg-config  \
    libtraceevent-dev


#install the wasm compiler
WORKDIR /opt/
RUN wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-33/wasi-sdk-33.0-x86_64-linux.tar.gz && \
    tar -xvf wasi-sdk-33.0-x86_64-linux.tar.gz
WORKDIR /home/
#I want to run rust, so I need this::
#RUN curl https://sh.rustup.rs -sSf -o sh.rustup.rs
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="$PATH:/root/.cargo/bin"
#the wasm compilation target is supported with this:
RUN rustup target add wasm32-wasip1

# I can not remember what that was for... TODO: remove or find its source
#RUN cargo install wit-bindgen-cli && cargo install --locked wasm-tools

# to use WASIp2 or 3 I have to set this variable:
ENV WASI_SDK_PATH=/opt/wasi-sdk-33.0-x86_64-linux

## this is needed to install the perf tool:
RUN git clone --depth 1 --branch v6.12 \
        https://github.com/torvalds/linux.git /tmp/linux && \
    make -C /tmp/linux/tools/perf/ -f /tmp/linux/tools/perf/Makefile &&  \
    cp /tmp/linux/tools/perf/perf /usr/local/bin/ && \
    rm -rf ./linux

WORKDIR /home/
#install the runtimes
RUN wget https://github.com/bytecodealliance/wasmtime/releases/download/dev/wasmtime-dev-x86_64-linux.tar.xz && \
    tar -xf wasmtime-dev-x86_64-linux.tar.xz
RUN wget https://github.com/WAVM/WAVM/releases/download/nightly%2F2026-04-05/wavm-nightly-2026-04-05-linux-x64.tar.gz && \
    tar -xzf wavm-nightly-2026-04-05-linux-x64.tar.gz
RUN curl https://get.wasmer.io -sSfL | sh -s "v6.1.0"
RUN wget https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-2.4.5.tar.gz && \
    tar -xzf WAMR-2.4.5.tar.gz
WORKDIR /home/wasm-micro-runtime-WAMR-2.4.5/product-mini/platforms/linux/
RUN mkdir build
WORKDIR /home/wasm-micro-runtime-WAMR-2.4.5/product-mini/platforms/linux/build/
RUN cmake .. && make
WORKDIR /home/
RUN wget https://github.com/WasmEdge/WasmEdge/releases/download/0.17.0/WasmEdge-0.17.0-ubuntu20.04_x86_64.tar.gz && \
    mkdir wasmedge && \
    tar -xzf WasmEdge-0.17.0-ubuntu20.04_x86_64.tar.gz -C ./wasmedge/
RUN mkdir wazero && \
    cd wazero && \
    wget https://github.com/wazero/wazero/releases/download/v1.11.0/wazero_1.11.0_linux_amd64.tar.gz && \
    tar -xzf wazero_1.11.0_linux_amd64.tar.gz
RUN wget https://github.com/nasa/spacewasm/archive/refs/tags/v0.5.1.tar.gz && \
    tar -xzf v0.5.1.tar.gz && \
    cd spacewasm-0.5.1 && \
    cargo build -p spacewasi
#RUN apt-get install -y linux-tools-generic linux-tools-6.12.76-linuxkit linux-cloud-tools-6.12.76-linuxkit

#import code
WORKDIR /home/
RUN mkdir wabench
COPY . /home/wabench
WORKDIR /home/wabench

ENTRYPOINT ["./run.sh"]