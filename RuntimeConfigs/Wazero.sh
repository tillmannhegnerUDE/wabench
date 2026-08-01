Wazero="/home/wazero/wazero"

if [ ! -z "$WasmDir" ]
then
  WazeroDir=" --cachedir $WazeroDir"
fi

WazeroNativeArg="$NativeArg"


AOTCompilation="$Wazero compile $Wasm -o $WasmAOT"

AOTRunCommand="$Wazero run$WazeroDir $WasmAOT $WazeroNativeArg"

RunCommand="$Wazero run$WazeroDir $Wasm $WazeroNativeArg"

AOTavailable=true