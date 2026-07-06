WasmEdge="/home/wasmedge/bin/wasmedge"

if [ ! -z "$WasmDir" ]
then
  WasmEdgeDir=" --dir $WasmDir"
fi

WasmEdgeNativeArg="-- $NativeArg"

if [ "$RunAOT" = true ]
then
  #todo
runaot "$WasmEdge compile $Wasm $WasmAOT" $1
runtest "$WasmEdge run$WasmEdgeDir $WasmAOT $WasmEdgeNativeArg" "output_wasmEdge" "wasmEdge" $1
else
runtest "$WasmEdge run$WasmEdgeDir $Wasm $WasmEdgeNativeArg" "output_wasmEdge" "wasmEdge" $1
fi