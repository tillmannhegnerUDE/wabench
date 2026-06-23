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
    ccache

WORKDIR /opt/
RUN wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-19/wasi-sdk-19.0-linux.tar.gz
RUN tar xvf wasi-sdk-19.0-linux.tar.gz
WORKDIR /home/
RUN curl https://sh.rustup.rs -sSf -o sh.rustup.rs
RUN sh sh.rustup.rs -y
ENV PATH="$PATH:/root/.cargo/bin"
RUN cargo install wit-bindgen-cli
RUN cargo install --locked wasm-tools
RUN wget https://github.com/bytecodealliance/wasmtime/releases/download/dev/wasmtime-dev-x86_64-linux.tar.xz
RUN tar -xf wasmtime-dev-x86_64-linux.tar.xz
RUN wget https://github.com/WAVM/WAVM/releases/download/nightly%2F2026-04-05/wavm-nightly-2026-04-05-linux-x64.tar.gz
RUN tar -xzf wavm-nightly-2026-04-05-linux-x64.tar.gz
RUN curl https://get.wasmer.io -sSfL | sh -s "v6.1.0"
RUN wget https://github.com/wasm3/wasm3/archive/refs/tags/v0.5.0.tar.gz
RUN tar -xzf v0.5.0.tar.gz
WORKDIR /home/wasm3-0.5.0/
RUN mkdir build
WORKDIR /home/wasm3-0.5.0/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release
RUN make -j$(nproc)
RUN make install
#RUN /usr/bin/clang /home/wasm3-0.5.0/source/*.c
#RUN /usr/bin/clang /home/wasm3-0.5.0/platforms/app/*.c
#RUN chmod +x wasm3-linux-x64.elf
WORKDIR /home/
RUN wget https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-2.4.4.tar.gz
RUN tar -xzf WAMR-2.4.4.tar.gz
WORKDIR /home/wasm-micro-runtime-WAMR-2.4.4/product-mini/platforms/linux/
RUN mkdir build
WORKDIR /home/wasm-micro-runtime-WAMR-2.4.4/product-mini/platforms/linux/build/
RUN cmake ..
RUN make
#RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.0/LLVM-22.1.0-Linux-X64.tar.xz
#RUN tar -xf LLVM-22.1.0-Linux-X64.tar.xz
WORKDIR /home/
RUN mkdir wabench
COPY . /home/wabench
WORKDIR /home/wabench

ENTRYPOINT ["./run.sh", "-n"]