WAVM="/home/bin/wavm"

if [ ! -z "$WasmDir" ]
then
    WAVMDir=" --mount-root $WasmDir"
fi

WAVMNativeArg="$NativeArg"

if [ "$RunAOT" = true ]
then
runaot "$WAVM compile $Wasm $WasmAOT" $1
runtest "$WAVM run --precompiled$WAVMDir $WasmAOT $WAVMNativeArg" "output_wavm" "wavm" $1
else
runtest "$WAVM run$WAVMDir $Wasm $WAVMNativeArg" "output_wavm" "wavm" $1
fi