Wazero="/home/wazero/wazero"

if [ ! -z "$WasmDir" ]
then
  WazeroDir=" -mount $WasmDir"
fi

WazeroNativeArg="$NativeArg"


AOTCompilation=""
#Wazero uses AOT by default
AOTRunCommand="$Wazero run$WazeroDir $Wasm $WazeroNativeArg"

RunCommand="$Wazero run$WazeroDir -interpreter $Wasm $WazeroNativeArg"

AOTavailable=true