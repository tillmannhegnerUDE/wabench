SPACEWASI="spacewasi"
MVPconverter="/home/wasm2mvp.sh"

if [ ! -z "$WasmDir" ]
then
  SpaceDir=" --dir $WasmDir"
fi

$MVPconverter $Wasm mvp.wasm

RunCommand="$SPACEWASI$SpaceDir mvp.wasm $NativeArg"

AOTavailable=false