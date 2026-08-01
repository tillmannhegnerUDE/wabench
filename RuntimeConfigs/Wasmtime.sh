Wasmtime="/home/wasmtime-dev-x86_64-linux/wasmtime"

if [ ! -z "$WasmDir" ]
then
    WasmtimeDir=" --dir $WasmDir"
fi

WasmtimeNativeArg="$NativeArg"


AOTCompilation="$Wasmtime compile $Wasm -o $WasmAOT"

AOTRunCommand="$Wasmtime run --allow-precompiled$WasmtimeDir $WasmAOT $WasmtimeNativeArg"

RunCommand="$Wasmtime run$WasmtimeDir $Wasm $WasmtimeNativeArg"

AOTavailable=true