Wasm3="/home/wasm3-0.5.0/build/wasm3"

Wasm3NativeArg="$NativeArg"

if [ "$RunAOT" = false ]
then
runtest "$Wasm3 --stack-size 500000000 $Wasm $Wasm3NativeArg" "output_wasm3" "wasm3" $1
fi