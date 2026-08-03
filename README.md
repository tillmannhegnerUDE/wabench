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
```
$ docker build --platform linux/amd64 -t wabench <path to Dockerfile>
$ docker run wabench <options>
```
Some options are offered to run with different configurations:
```
-a run with AOT compilation for all runtimes that support it
-c skip cleaning up after execution. Output files and binaries persist.
-h show this help message
-n perform a dry run
-m measure the peak memory consumption
-p measure performance metrics like number of instructions, number of cache misses and number of branch prediction errors 
    (Since the perf-tool doing these messurements needs additional permissions, the flags 
    '--cap-add=SYS_ADMIN --privileged -it' have to be added to the 'run' command)  
-s perform a smoke test
```
