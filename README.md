# WABench

A benchmark suite for standalone WebAssembly runtimes.

Note that WABench contains programs from existing benchmark suites and applications.

If you see any license/copyright issues, please let us know. We will remove the programs.

## Paper

[How Far We've Come - A Characterization Study of Standalone WebAssembly Runtimes](https://cobweb.cs.uga.edu/~wenwen/papers/iiswc2022.pdf)

[Wenwen Wang](https://cobweb.cs.uga.edu/~wenwen)

[IISWC 2022](http://www.iiswc.org/iiswc2022)

## Execution

Using the Dockerfile, this benchmark can run inside a container.
Using Docker, the image can be built and run with these commands:
```commandline
$ docker build --platform linux/amd64 -t wabench <path to Dockerfile>
$ docker run wabench <options>
```
Some options are offered to run with different configurations:
```
-a run with AOT compilation for all runtimes that support it
-A only run the runtimes that support AOT with it
-c skip cleaning up after execution. Output files and binaries persist inside the container.
-h show this help message
-n perform a dry run
-m measure the peak memory consumption
-o <level> set the compiler optimiziation level for each compiler in the benchmark (allowed values: 0, 1, 2, 3; the 
   default value is 2)
-p measure performance metrics like number of instructions, number of cache misses and number of branch prediction 
   errors (Since the perf-tool doing these messurements needs additional permissions, the flags 
   '--cap-add=SYS_ADMIN --privileged -it' have to be added to the 'run' command)  
-s perform a smoke test
```

Time metrics are meassured if neither memory nor performance is meassured.
When using the -m or -p option, no other measurement takes place in that run.
(And this means that the options can not be combined.)

The maximal memory consumption is saved in kilobytes.

The "RuntimeConfigs"-folder contains shell scripts that define how different WebAssembly runtimes are used.
They have to contain four at least two variables: the command for running the runtime and a variable which denotes whether ahead-of-time (AOT) compilation is possible for this runtime.
If it is possible, two additional variables for the compile-command and the run-commmand with AOT are necessary.
To remove or add a runtime from the benchmark, these scripts have to be removed or added.

## Results

The results of the benchmark are saved in csv files.
To get the execution times out of the container, run
```commandline
$ docker cp <container-id>:/home/wabench/timeResults.csv <directory on host to save to>
```
The performance metrics and memory consumption can be pulled out of the container with the following commands:
```commandline
$ docker cp <container-id>:/home/wabench/performanceResults.csv <directory on host to save to>

$ docker cp <container-id>:/home/wabench/memoryResults.csv <directory on host to save to>
```