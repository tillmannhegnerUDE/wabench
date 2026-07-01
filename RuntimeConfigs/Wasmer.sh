Wasmer="/root/.wasmer/bin/wasmer"

if [ ! -z "$WasmDir" ]
then
  WasmerDir=" --dir $WasmDir"
fi

WasmerNativeArg="-- $NativeArg"

if [ "$RunAOT" = true ]
then
runaot "$Wasmer compile $Wasm -o $WasmAOT" $1
runtest "$Wasmer run$WasmerDir $WasmAOT $WasmerNativeArg" "output_wasmer" "wasmer" $1
else
runtest "$Wasmer run$WasmerDir $Wasm $WasmerNativeArg" "output_wasmer" "wasmer" $1
fi

