Wasmtime="/home/wasmtime-dev-x86_64-linux/wasmtime"

if [ ! -z "$WasmDir" ]
then
    WasmtimeDir=" --dir $WasmDir"
fi

WasmtimeNativeArg="$NativeArg"

if [ "$RunAOT" = true ]
then
runaot "$Wasmtime compile $Wasm -o $WasmAOT" $1
runtest "$Wasmtime run --allow-precompiled$WasmtimeDir $WasmAOT $WasmtimeNativeArg" "output_wasmtime" "wasmtime" $1
else
runtest "$Wasmtime run$WasmtimeDir $Wasm $WasmtimeNativeArg" "output_wasmtime" "wasmtime" $1
fi