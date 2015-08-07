#!/bin/bash

# get home path
BENCH_HOME=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd );
echo "\$BENCH_HOME is set to $BENCH_HOME";

# Read the TPC-H config parameters
source $BENCH_HOME/tpch/conf/settings.sh

# Set path to the hive settings
HIVE_SETTING=$BENCH_HOME/$BENCHMARK/queries/hive.settings
# Set path to tpc-h queries
QUERY_DIR=$BENCH_HOME/$BENCHMARK/queries
# Create output directory
CURDATE="`date +%Y-%m-%d`"
RESULT_DIR=$BENCH_HOME/$BENCHMARK/results/$CURDATE
mkdir $RESULT_DIR

HOSTFILE=$BENCH_HOME/bin/hostlist
i=1
while [ $i -le $NUM_QUERIES ]
do
	if [ $HOSTFILE != "" ]
	then
	  echo "Drop all caches from all nodes list in ${HOSTFILE}"
  	$BENCH_HOME/bin/drop-cache-all.sh $HOSTFILE
	fi
	hive -i ${HIVE_SETTING} --database ${DATABASE} -f ${QUERY_DIR}/tpch_query${i}.sql > ${RESULT_DIR}/${DATABASE}_query${i}.txt 2>&1
	#i=$(( i+1 ))	
	i=`expr $i + 1`
done