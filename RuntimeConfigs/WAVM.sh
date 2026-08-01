WAVM="/home/bin/wavm"

if [ ! -z "$WasmDir" ]
then
    WAVMDir=" --mount-root $WasmDir"
fi

AOTCompilation="$WAVM compile $Wasm $WasmAOT"

AOTRunCommand="$WAVM run --precompiled$WAVMDir $WasmAOT $NativeArg"

RunCommand="$WAVM run$WAVMDir $Wasm $NativeArg"

AOTavailable=true