# D2F-Bench (Data File Format Benchmark)

## Prerequisites

* Apache Hadoop 2.2 or later  / Cloudera CDH / HortonWorks HDP 
* Apache Hive version 13 or later
* Between 15 minutes and 2 days to generate data (depending on the Scale Factor you choose and available hardware).
* [Supported engines](https://github.com/t-ivanov/D2F-Bench/blob/master/engines.md): Hive, Spark SQL, Impala, Pig


## Install & Setup TPC-H

1.Create a copy of the project locally:

`git clone https://github.com/t-ivanov/D2F-Bench`

2.Download, compile and package the appropriate TPC-H data generator by executing:

`./tpch-build.sh`

3.Adjust the benchmark settings according to your needs.

Edit the `~/D2F-Bench/tpch/conf/settings.sh` file: 
* __TABLES="part partsupp supplier customer orders lineitem nation region"__ -- defines which tables to use for the tests. This should not be changed unless you are testing any new functionality.
* __SCALE=2__ -- defines the scale factor for the data generation phase. (2=2GB, 3=3GB ... 1000=1TB).
You need to decide on a "Scale Factor" which represents how much data you will generate. Scale Factor roughly translates to gigabytes, so a Scale Factor of 100 is about 100 gigabytes and one terabyte is Scale Factor 1000. Decide how much data you want and keep it in mind for the next step. If you have a cluster of 4-10 nodes or just want to experiment at a smaller scale, scale 1000 (1 TB) of data is a good starting point. If you have a large cluster, you may want to choose Scale 10000 (10 TB) or more.

* __ENGINE=hive__ -- set the execution engine with which you want to run the benchmark. Supported are hive, pig, spark-sql, impala.
* __FILE_FORMAT=orc__ -- defines the data file format for storing the table data. Supported are ORC, RCfile, Parquet, SequenceFile, TextFile. 
* __TEST_QUERIES="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22"__ -- defines the list of queries to execute sequencially in one data test. Between each execution is performed cache cleanup on underlying operating system.

There are additional parameters which are engine specific and are curently in test-mode.

4.Generate and load the data by executing (under root):

`sudo ./tpch-setup.sh`

5.Execute the queries specified in the __TEST_QUERIES__ list:

`./tpch-exec-queries.sh`

6.Results from the query runs are stored in folder `~/D2F-Bench/tpch/results/[Current-date]/[database_name_query_number].txt`. Additionally, in the file `~/D2F-Bench/tpch/logs/query_times.csv` are stored all query times from the latest executions.

## ACKNOWLEDGMENTS
Hive-testbench - https://github.com/hortonworks/hive-testbench

BigBench - https://github.com/intel-hadoop/Big-Data-Benchmark-for-Big-Bench

HiBench Suite - https://github.com/intel-hadoop/HiBench

TPC-H for Pig - https://github.com/JerryLead/BenchmarkScripts & https://github.com/ssavvides/tpch-pig

TPC-H for Impala & Hive - https://github.com/kj-ki/tpc-h-impala
