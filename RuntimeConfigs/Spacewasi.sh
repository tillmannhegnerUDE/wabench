SPACEWASI="spacewasi"
MVPconverter="/home/wasm2mvp.sh"

if [ ! -z "$WasmDir" ]
then
  SpaceDir=" --dir $WasmDir"
fi

wasm-opt \
    --llvm-memory-copy-fill-lowering \
    --signext-lowering \
    --disable-bulk-memory \
    --llvm-nontrapping-fptoint-lowering \
    --disable-multivalue \
    --disable-simd \
    -O$OptLevel \
    $Wasm \
    -o mvp.wasm

RunCommand="$SPACEWASI$SpaceDir mvp.wasm $NativeArg"

AOTavailable=false