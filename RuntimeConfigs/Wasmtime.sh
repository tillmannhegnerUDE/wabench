Wasmtime="/home/wasmtime-dev-x86_64-linux/wasmtime"

if [ ! -z "$WasmDir" ]
then
    WasmtimeDir=" --dir $WasmDir"
fi

WasmtimeNativeArg="$NativeArg"

WasmtimeOpt=$OptLevel
# the wasmtime compilation only offers optimization levels 0-2.
# This is why level 3 is changed to level 2 for this runtime.
if [ "$OptLevel" == "3" ]
then
  WasmtimeOpt=2
fi

AOTCompilation="$Wasmtime compile -O opt-level=1 $Wasm -o $WasmAOT"

AOTRunCommand="$Wasmtime run --allow-precompiled$WasmtimeDir $WasmAOT $WasmtimeNativeArg"

RunCommand="$Wasmtime run$WasmtimeDir $Wasm $WasmtimeNativeArg"

AOTavailable=true