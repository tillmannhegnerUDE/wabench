Wazero="/home/wazero/bin/wazero"

if [ ! -z "$WasmDir" ]
then
  WazeroDir=" --cachedir $WazeroDir"
fi

WazeroNativeArg="$NativeArg"

if [ "$RunAOT" = true ]
then
runaot "$Wazero compile $Wasm -o $WasmAOT" $1
runtest "$Wazero run$WazeroDir $WasmAOT $WazeroNativeArg" "output_wazero" "wazero" $1
else
runtest "$Wazero run$WazeroDir $Wasm $WazeroNativeArg" "output_wazero" "wazero" $1
fi