#!/bin/bash

RunAOT=false

MeasureMem=false

MeasurePerf=false

SmokeTest=false

DryRun=false

SkipCleaning=false

while getopts "achnmps" opt; do
    case $opt in
        a)
            RunAOT=true
            ;;
        c)
            SkipCleaning=true
            ;;
        h)
            showUsage=true
            ;;
        n)
            DryRun=true
            ;;
        m)
            MeasureMem=true
            ;;
        p)
            MeasurePerf=true
            ;;
        s)
            SmokeTest=true
            ;;
        ?)
            showUsage=true
            echo "unknown flags"
            ;;
    esac
done

ProgramCount=$(find . -mindepth 2 -name "run.sh" | wc -l | tr -d ' \t')
RuntimeCount=$(find RuntimeConfigs -maxdepth 1 -name "*.sh" | wc -l | tr -d ' \t')

echo "$RuntimeCount runtimes and $ProgramCount programs where found."

if [ $showUsage ]
then
  echo "This is a Benchmarking tool for WASM runtimes"
  echo "Options:"
  echo "  -a run with AOT compilation for all runtimes that support it"
  echo "  -c skip cleaning up after execution. Output files and binaries persist."
  echo "  -h show this help message"
  echo "  -n perform a dry run"
  echo "  -m measure the peak memory consumption"
  echo "  -p measure performance metrics like number of instructions, number of cache misses and number of branch prediction errors"
  echo "  -s perform a smoke test"
  echo ""
  exit 0
fi

#echo "aot=$RunAOT, Mem=$MeasureMem, Perf=$MeasurePerf, DryRun=$DryRun, SkipCleaning=$SkipCleaning, SmokeTest=$SmokeTest"

#exit 0

BenchRoot="/home/wabench"

CommonScript="$BenchRoot/common.sh"

TimesTable="timeResults.csv"

Message=""
ReturnValue=0
if [ "$SmokeTest" == "false" ]
then

    echo -n "Programm;Native" > $TimesTable
    for runtime in $BenchRoot/RuntimeConfigs/*.sh; do
      echo -n ";" >> $TimesTable
      if [ "$RunAOT" == "true" ]
      then
        . $runtime
        if [ "$AOTavailable" == "true" ]
        then
          basename -s .sh "$runtime" | tr -d '\n' >> $TimesTable;
          echo -n "Compilation" >> $TimesTable
          echo -n ";" >> $TimesTable
        fi
      fi
      basename -s .sh "$runtime" | tr -d '\n' >> $TimesTable;
      done
    echo "" >> $TimesTable
fi


nth=0
runBenchmarksForProgram() {
  nth=$((nth+1))
  echo "[${nth}/${ProgramCount}] $1"
}

for file in $(find . -mindepth 2 -type f -name "run.sh"); do
    nth=$((nth+1))
    echo "[${nth}/${ProgramCount}] $(dirname "$file")"
    echo "$(basename $(dirname $file))"
    cd $(dirname $file) || exit 1
    . ./run.sh

    if [ ! -f "$Native" ]
    then
      if [ "$Language" == "C" ]
      then
        echo "Building binaries..."
        Message=$(make 2>&1)
      fi
    else
      echo "The binaries seem to already exits"
    fi
    #    fi

    if [ "$SmokeTest" == false ]
    then
      if [ ! -f "$Native.wasm" ]
      then
        echo "ErrorMessage: $(pwd) $Message"
        if [ ! -f "$Native" ]
        then
          echo "The native application was not built"
        fi
        if [ ! -f "$Native.wasm" ]
        then
          echo "The wasm application was not built"
        fi
        ReturnValue=1
        cd "$BenchRoot"
        continue
      fi
    fi

    if [ ! -f "$Native.wasm" ]
    then
        echo "Cannot build WebAssembly binary..."
        echo "Cause: $(pwd) $Message"
        ReturnValue=1
        cd "$BenchRoot"
        continue
    fi
    Message=""

    if [ "$SmokeTest" == "false" ]
    then
      # Run benchmark
      TimeTableLine="$Native"
      echo "Running..."
      . $CommonScript
      if [ "$SkipCleaning" == "false" ]
      then
        echo "Cleanup..."
        make clean > /dev/null 2>&1
      fi
      cd "$BenchRoot"
      echo "$TimeTableLine">>$TimesTable
    else
      if [ "$SkipCleaning" == "false" ]
      then
        echo "Cleanup..."
        make clean > /dev/null 2>&1
      fi
      cd "$BenchRoot"
    fi

    echo ""
done
#find . -mindepth 2 -name "run.sh" -execdir ./run.sh \;

if [ $ReturnValue == 1 ]
then
  echo "$Message" > error-report.txt
  sleep 300
fi


echo "Return value: $ReturnValue"
exit $ReturnValue
