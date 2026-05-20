Wasm=$Native.wasm
WasmAOT=$Native.cwasm

Wasmtime="$HOME/.wasmtime/bin/wasmtime"
WAVM="$HOME/.wavm/bin/wavm"
#Wasmer="$HOME/runtimes/wasmer/target/release/wasmer"
Wasmer="$HOME/.wasmer/bin/wasmer"
Wasm3="/opt/homebrew/Cellar/wasm3/0.5.0/bin/wasm3"
WAMR="$HOME/wasm-micro-runtime-WAMR-2.4.4/product-mini/platforms/darwin/build/iwasm"



runaot() {
    cmd="$1"
    if [ "$2" = "-n" ] # dry run
    then 
        echo $1
        echo ""
        return 0
    fi
    start=`date +%s.%N`
    sh -c "$cmd"
    end=`date +%s.%N`
    aottime=$( echo "$end - $start" | bc -l )
    echo "AOT compilation time: $aottime seconds"
}

runtest() { # $1: Path to native program or command that should be invoked for wasm $2: argument for native program $3: indicated which runtime the test is run with or if it is run natively $4: if this is "-n", a dry run is started first. The argument "-n" has to be given to the call of run.sh
    cmd="$1 >$2 2>&1"
    if [ "$4" = "-n" ] # dry run
    then
        echo $cmd
        echo ""
        return 0
    fi
    if [ "$MeasureMem" = true ]
    then
        sh -c "/usr/bin/time -v $cmd"
        mem=$( cat "$2" | grep "Maximum resident set size (kbytes)" | sed 's/.*: //' )
        echo -e "$3:   \t$mem kbytes"
    elif [ "$MeasurePerf" = true ]
    then
: '
        sh -c "perf stat $cmd"
        cycles=$( cat "$2" | grep "cycles" | sed 's/      cycles.*//' | sed 's/        //' )
        insns=$( cat "$2" | grep "instructions" | sed 's/      instructions.*//' | sed 's/        //')
        branches=$( cat "$2" | grep "branches" | grep -v "branch-misses" | sed 's/      branches.*//' | sed 's/        //')
        brmisses=$( cat "$2" | grep "branch-misses" | sed 's/      branch-misses.*//' | sed 's/        //')
        echo -e "$3:   \t$cycles cycles"
        echo -e "$3:   \t$insns instructions"
        echo -e "$3:   \t$branches branches"
        echo -e "$3:   \t$brmisses branch-misses"
'
        sh -c "perf stat -e cache-misses,cache-references $cmd"
        cachemisses=$( cat "$2" | grep "cache-misses" | sed 's/      cache-misses.*//' | sed 's/        //' )
        cacherefs=$( cat "$2" | grep "cache-references" | sed 's/      cache-references.*//' | sed 's/        //')
        echo -e "$3:   \t$cachemisses cache-misses"
        echo -e "$3:   \t$cacherefs cache-references"
    else
        timeRes=$(/usr/bin/time -p sh -c "for (( i=1; i<=$Iter; i++ ))
                do
                    $cmd
                done" 2>&1 | awk '/user/ {print $2}')
        # depending on the result wanted, I can either choose the time in "real", from the "user" or from the "system"
        echo -e "$3:   \t$timeRes seconds"
        TimeTableLine="$TimeTableLine;$timeRes"
#        echo "Total run time: $runtime seconds"
        #echo "Each iter time: $itertime seconds"
        #cat "$2"
    fi
    if grep -q "ERROR\|Error\|error\|Exception\|exception\|Fail\|fail" "$2"
    then
        echo "Error encountered. Please double-check $2"
    fi
}

if [ ! -z "$WasmDir" ]
then
    WasmtimeDir="--dir $WasmDir"
    WAVMDir="--mount-root $WasmDir"
    WasmerDir="--dir $WasmDir"
    WAMRDir="--dir=$WasmDir"
fi


WasmtimeNativeArg="$NativeArg"
WAVMNativeArg="$NativeArg"
WasmerNativeArg="-- $NativeArg"
Wasm3NativeArg="$NativeArg"
WAMRNativeArg="$NativeArg"

#echo "Iteration(s): $Iter"

#: '
echo "normal run"
runtest "$Native $NativeArg" "output_native" "native" $1

if [ "$RunAOT" = true ]
then
runaot "$Wasmtime compile $Wasm -o $WasmAOT" $1
runtest "$Wasmtime run --allow-precompiled $WasmtimeDir $WasmAOT $WasmtimeNativeArg" "output_wasmtime" "wasmtime" $1
else
runtest "$Wasmtime run $WasmtimeDir $Wasm $WasmtimeNativeArg" "output_wasmtime" "wasmtime" $1
fi

if [ "$RunAOT" = true ]
then
runaot "$WAVM compile $Wasm $WasmAOT" $1
runtest "$WAVM run --precompiled $WAVMDir $WasmAOT $WAVMNativeArg" "output_wavm" "wavm" $1
else
runtest "$WAVM run $WAVMDir $Wasm $WAVMNativeArg" "output_wavm" "wavm" $1
fi

if [ "$RunAOT" = true ]
then
runaot "$Wasmer compile $Wasm -o $WasmAOT" $1
runtest "$Wasmer run $WasmerDir $WasmAOT $WasmerNativeArg" "output_wasmer" "wasmer" $1
else
runtest "$Wasmer run $WasmerDir $Wasm $WasmerNativeArg" "output_wasmer" "wasmer" $1
fi

#'

: '
#echo ""
runtest "$Wasmer --singlepass $WasmerDir $Wasm $WasmerNativeArg" "output_wasmer" "wasmer (singlepass)" $1

#echo ""
runtest "$Wasmer --cranelift $WasmerDir $Wasm $WasmerNativeArg" "output_wasmer" "wasmer (cranelift)" $1

#echo ""
runtest "$Wasmer --llvm $WasmerDir $Wasm $WasmerNativeArg" "output_wasmer" "wasmer (llvm)" $1
'

#: '
if [ "$RunAOT" = false ]
then
#echo ""
# enlarge stack size for wasm3
runtest "$Wasm3 --stack-size 500000000 $Wasm $Wasm3NativeArg" "output_wasm3" "wasm3" $1
fi

if [ "$RunAOT" = false ]
then
#echo ""
# 32KB stack size for WAMR
runtest "$WAMR --stack-size=32768 $WAMRDir $Wasm $WAMRNativeArg" "output_wamr" "wamr" $1
fi

#'

#echo ""

if [ "$1" == "-n" ] # No need to compare results for a dry run
then
    return 0
fi

if [ "$CheckResult" = true ]
then
    echo "check results ..."
    diff output_native output_wasmtime
    diff output_native output_wavm
    diff output_native output_wasmer
    diff output_native output_wasm3
    diff output_native output_wamr
fi
