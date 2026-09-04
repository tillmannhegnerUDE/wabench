Wasmer="/root/.wasmer/bin/wasmer"

if [ ! -z "$WasmDir" ]
then
  WasmerDir=" --volume $WasmDir:/"
fi

WasmerNativeArg="-- $NativeArg"


AOTCompilation="$Wasmer compile $Wasm -o $WasmAOT"

AOTRunCommand="$Wasmer run$WasmerDir $WasmAOT $WasmerNativeArg"

RunCommand="$Wasmer run$WasmerDir $Wasm $WasmerNativeArg"

AOTavailable=true