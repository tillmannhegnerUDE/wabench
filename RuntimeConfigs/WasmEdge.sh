WasmEdge="/home/wasmedge/bin/wasmedge"

if [ ! -z "$WasmDir" ]
then
  WasmEdgeDir=" --dir $WasmDir"
fi

WasmEdgeNativeArg=" $NativeArg"


AOTCompilation="$WasmEdge compile --optimize $OptLevel $Wasm $WasmAOT"

AOTRunCommand="$WasmEdge run$WasmEdgeDir $WasmAOT $WasmEdgeNativeArg"

RunCommand="$WasmEdge run$WasmEdgeDir $Wasm $WasmEdgeNativeArg"

AOTavailable=true