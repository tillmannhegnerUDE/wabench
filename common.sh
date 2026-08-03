Wasm=$Native.wasm
WasmAOT=$Native.cwasm

timeRes=0
NativeTimeRes=0

runaot() { # $1: Command that will be executed $2 flag of the run-script
    cmd="$1"
    if [ "$DryRun" == "true" ] # dry run
    then 
        echo $1
        echo ""
        return 0
    fi
    timeRes=$(/usr/bin/time -p /bin/bash -c "$cmd" 2>&1 | awk '/user/ {print $2}')
    # depending on the result wanted, I can either choose the time in "real", from the "user" or from the "system"
    echo -e "AOT compilation time of $RuntimeName: \t$timeRes seconds"
    TimeTableLine="$TimeTableLine;$timeRes"
}

runtest() { # $1: command that will be executed (for native and wasm programs) $2: path to the output file $3: indicated which runtime the test is run with or if it is run natively $4: if this is "-n", a dry run is started first. The argument "-n" has to be given to the call of run.sh
    OutputFile="output_$RuntimeName" # this value was formally in the variable $2
    #the value formally in $3 is now in RuntimeName
    cmd="$1 &>$OutputFile"
    if [ "$DryRun" == "true" ] # dry run
    then
        echo $cmd
        echo ""
        return 0
    fi
    if [ "$MeasureMem" = "true" ]
    then
        #version for ubuntu:
        # sh -c "/usr/bin/time -v $cmd"
        # mem=$( cat "$2" | grep "Maximum resident set size (kbytes)" | sed 's/.*: //' )
        sh -c "/usr/bin/time -l -p $cmd"
        mem=$(cat "$OutputFile" | grep "maximum resident set size" | sed 's/maximum resident set size//' | xargs)
        echo -e "$RuntimeName:   \t$mem kbytes"
    elif [ "$MeasurePerf" = "true" ]
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
        #version for ubuntu:
        sh -c "perf stat -e cache-misses,cache-references $cmd"
        cachemisses=$( cat "$OutputFile" | grep "cache-misses" | sed 's/      cache-misses.*//' | sed 's/        //' )
        cacherefs=$( cat "$OutputFile" | grep "cache-references" | sed 's/      cache-references.*//' | sed 's/        //')
#        sh -c "xctrace record --template 'CPU Counters' --output $2.trace --launch -- $cmd"
        cat "$OutputFile"
        PerformanceTableLine="$PerformanceTableLine;$cachemisses"
        PerformanceTableLine="$PerformanceTableLine;$cacherefs"
        echo -e "$3:   \t$cachemisses cache-misses"
        echo -e "$3:   \t$cacherefs cache-references"
    else
#      /bin/bash -c $Wasm3
      timeRes=$(/usr/bin/time -p /bin/bash -c "for (( i=1; i<=$Iter; i++ ))
        do
          $cmd
        done" 2>&1 | awk '/user/ {print $2}')
      # depending on the result wanted, I can either choose the time in "real", from the "user" or from the "system"
      echo -e "$RuntimeName:   \t$timeRes seconds"
      if grep -q "ERROR\|Error\|error\|Exception\|exception\|Fail\|fail" "$OutputFile"
      then
        TimeTableLine="$TimeTableLine;Null"
      else
        TimeTableLine="$TimeTableLine;$timeRes"
      fi
#        echo "Total run time: $runtime seconds"
      #echo "Each iter time: $itertime seconds"
      if [ "$NativeRun" = "false" ]
      then
        timeDiff=$( echo "$timeRes - $NativeTimeRes" | bc -l )
        Res="$(echo "$timeDiff < 0" | bc -l)"
        if [ "$Res" -eq 1 ]
        then
          echo "somehow the runtime was faster."
#          cat "$OutputFile"
        fi
      fi
    fi
    if grep -q "ERROR\|Error\|error\|Exception\|exception\|Fail\|fail" "$OutputFile"
    then
        echo "Error encountered. Please double-check $OutputFile"
    fi
}

echo "normal run"
NativeRun=true
RuntimeName=native
runtest "$Native $NativeArg"
NativeTimeRes=$timeRes
NativeRun=false

#run all runtimes for the current benchmark
for runtime in $BenchRoot/$RuntimeFolder/*.sh; do
  RuntimeName="$(basename -s .sh $runtime)"
  . $runtime
  if [ "$RunAOT" == "true" ] && [ "$AOTavailable" == "true" ];
  then
    runaot "$AOTCompilation"
    runtest "$AOTRunCommand"
  else
    runtest "$RunCommand"
  fi
  done

if [ "$1" == "-n" ] # No need to compare results for a dry run
then
    return 0
fi

if [ "$CheckResult" = "true" ]
then
    echo "check results ..."
    for runtime in $BenchRoot/$RuntimeFolder/*.sh; do
      diff output_native "output_$(basename -s .sh $runtime)"
    done
#    diff output_native output_wasmtime
#    diff output_native output_wavm
#    diff output_native output_wasmer
#    diff output_native output_wasm3
#    diff output_native output_wamr
else
  echo "The results might differ for this program."
fi
