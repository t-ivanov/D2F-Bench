#!/bin/bash

# TPC-H

# Name of the benchmark
BENCHMARK=tpch

# Tables in the TPC-H schema.
TABLES="part partsupp supplier customer orders lineitem nation region"

# Scale factor
SCALE=2

# The root directory of external tables
DIR=

# The total number of chunks. The entire dataset will be divided into this number of chunks.
BUCKETS=13

# Data file format for storing the table data in Hive 
# Supported formats are: ORC, RCfile, Parquet, Avro, SequenceFile, TextFile 
FILE_FORMAT=orc

# Name of the database in Metastore
DATABASE=${BENCHMARK}_${FILE_FORMAT}_${SCALE}sf

# Number of queries to execute in TPC-H --> 22 for all, or space separated list
NUM_QUERIES=22

# Ths ssh options
#SSH_OPTS="-o StrictHostKeyChecking=no -o ServerAliveInterval=30"
#SSH="ssh ${SSH_OPTS}"

# The root directory of external tables
#EXTERNAL_DIR="/apps/hive"

# Tables in this benchmark
#TABLES="customer nation part region lineitem orders partsupp supplier"

# The total number of chunks. The entire dataset will be divided into this number of chunks.
#CHUNK_NUM=1