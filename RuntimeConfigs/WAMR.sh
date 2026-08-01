WAMR="/home/wasm-micro-runtime-WAMR-2.4.5/product-mini/platforms/linux/build/iwasm"

if [ ! -z "$WasmDir" ]
then
  WAMRDir=" --dir=$WasmDir"
fi

WAMRNativeArg="$NativeArg"


RunCommand="$WAMR --stack-size=32768 $WAMRDir $Wasm $WAMRNativeArg"

AOTavailable=false