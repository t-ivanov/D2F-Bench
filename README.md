# D2F-Bench (Data File Format Benchmark)

## Prerequisites

* Apache Hadoop 2.2 or later  / Cloudera CDH / HortonWorks HDP 
* Apache Hive version 13 or later
* Between 15 minutes and 2 days to generate data (depending on the Scale Factor you choose and available hardware).


## Install & Setup TPC-H

1. Create a copy of the project locally:

_git clone https://github.com/t-ivanov/D2F-Bench_

2. Download, compile and package the appropriate TPC-H data generator by executing:

_./tpch-build.sh_

3. Adjust the benchmark settings according to your needs.

Edit the _~/D2F-Bench/tpch/conf/settings.sh_ file: 
* __TABLES="part partsupp supplier customer orders lineitem nation region"__ -- defines which tables to use for the tests. This should not be changed unless you are testing any new functionality.
* __SCALE=1__ -- defines the scale factor for the data generation phase. (0.1= 100MB, 0.5=500MB, 1 = 1GB, 2=2GB ... 1000=1TB)
* __ENGINE=hive__ -- set the execution engine with which you want to run the benchmark. Supported are hive, pig, spark-sql, impala.
* __FILE_FORMAT=orc__ -- defines the data file format for storing the table data. Supported are ORC, RCfile, Parquet, SequenceFile, TextFile. 
* __TEST_QUERIES="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22"__ -- defines the list of queries to execute sequencially in one data test. Between each execution is performed cache cleanup on underlying operating system.

There are additionial parameters which are engine specific and are curently in test-mode.

## ACKNOWLEDGMENTS
Hive-testbench - https://github.com/hortonworks/hive-testbench

BigBench - https://github.com/intel-hadoop/Big-Data-Benchmark-for-Big-Bench

HiBench Suite - https://github.com/intel-hadoop/HiBench

TPC-H for Pig - https://github.com/JerryLead/BenchmarkScripts & https://github.com/ssavvides/tpch-pig

TPC-H for Impala & Hive - https://github.com/kj-ki/tpc-h-impala
