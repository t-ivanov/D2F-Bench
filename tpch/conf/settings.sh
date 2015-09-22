#!/bin/bash

# TPC-H

# Name of the benchmark
BENCHMARK=tpch

# Tables in the TPC-H schema.
TABLES="part partsupp supplier customer orders lineitem nation region"

# Scale factor
SCALE=1000

# The root directory of external tables
DIR=

# The total number of chunks. The entire dataset will be divided into this number of chunks.
BUCKETS=13

# Execution engine: hive, pig, spark-sql, impala etc.
ENGINE=impala

# Connection node for the impala deamon. Should be different than the NameNode
IMPALA_NODE=babar1

# Data file format for storing the table data in Hive 
# Supported formats are: ORC, RCfile, Parquet, Avro, SequenceFile, TextFile 
FILE_FORMAT=parquet

# Name of the database in Metastore
DATABASE=${BENCHMARK}_${FILE_FORMAT}_${SCALE}sf
DATABASE_SPARK=${BENCHMARK}_${FILE_FORMAT}_${SCALE}sf

# Number of queries to execute in TPC-H --> 
# hive - space separated 22 queries list
#TEST_QUERIES="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22"
# impala
TEST_QUERIES="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22"
# spark sql - 20 queries without Q11 and Q17
#TEST_QUERIES="1 2 6 7 10 12 13 14 15 16 19 22"

# Pig specific params
PIG_INPUT_DIR=/user/hive/warehouse/${DATABASE}
PIG_OUTPUT_DIR=/user/hive/warehouse

# Ths ssh options
#SSH_OPTS="-o StrictHostKeyChecking=no -o ServerAliveInterval=30"
#SSH="ssh ${SSH_OPTS}"

# The root directory of external tables
#EXTERNAL_DIR="/apps/hive"

# Tables in this benchmark
#TABLES="customer nation part region lineitem orders partsupp supplier"

# The total number of chunks. The entire dataset will be divided into this number of chunks.
#CHUNK_NUM=1