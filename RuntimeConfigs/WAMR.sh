WAMR="/home/wasm-micro-runtime-WAMR-2.4.4/product-mini/platforms/linux/build/iwasm"

if [ ! -z "$WasmDir" ]
then
  WAMRDir=" --dir=$WasmDir"
fi

WAMRNativeArg="$NativeArg"

if [ "$RunAOT" = false ]
then
#echo ""
# 32KB stack size for WAMR
runtest "$WAMR --stack-size=32768 $WAMRDir $Wasm $WAMRNativeArg" "output_wamr" "wamr" $1
fi