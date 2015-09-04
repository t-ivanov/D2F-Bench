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
# Initialize log file for data loading times
LOG_FILE_EXEC_TIMES="${BENCH_HOME}/${BENCHMARK}/logs/query_times.csv"
if [ ! -e "$LOG_FILE_EXEC_TIMES" ]
  then
    touch "$LOG_FILE_EXEC_TIMES"
    echo "STARTDATE_EPOCH|STOPDATE_EPOCH|DURATION_MS|STARTDATE|STOPDATE|DURATION|BENCHMARK|DATABASE|SCALE_FACTOR|ENGINE|FILE_FORMAT|QUERY" >> "${LOG_FILE_EXEC_TIMES}"
fi

if [ ! -w "$LOG_FILE_EXEC_TIMES" ]
  then
    echo "ERROR: cannot write to: $LOG_FILE_EXEC_TIMES, no permission"
    return 1
fi


HOSTFILE=$BENCH_HOME/bin/hostlist
i=1
while [ $i -le $NUM_QUERIES ]
do
	if [ $HOSTFILE != "" ]
	then
	  echo "Drop all caches from all nodes list in ${HOSTFILE}"
  	$BENCH_HOME/bin/drop-cache-all.sh $HOSTFILE
	fi
	
	# Measure time for query execution time
	# Start timer to measure data loading for the file formats
	STARTDATE="`date +%Y/%m/%d:%H:%M:%S`"
	STARTDATE_EPOCH="`date +%s`" # seconds since epoch
	# Execute query
	if [ $ENGINE == "spark-sql" ]
	then
	# set the spark-sql resource parameters
	SPARKSQL_PARAMS="-v --driver-memory 10g --executor-memory 9g --executor-cores 3 --num-executors 9 --master yarn"
	# first have to select the database "use tpch_orc_2sf"
		echo "use ${DATABASE_SPARK};"|cat - ${QUERY_DIR}/tpch_query${i}.sql > /tmp/tmp_query${i}.sql
		/home/user1/spark/bin/spark-sql ${SPARKSQL_PARAMS} -i ${HIVE_SETTING} -f /tmp/tmp_query${i}.sql > ${RESULT_DIR}/${DATABASE}_query${i}.txt 2>&1
	elif [ $ENGINE == "pig" ]
	then
		#execute pig queires
		# delete existing output file
		hadoop fs -rmr "$PIG_OUTPUT_DIR/Q${i}_out"
		echo "Running Pig Query Q$i"
		pig -param input=${PIG_INPUT_DIR} -param output=${PIG_OUTPUT_DIR}  -f ${QUERY_DIR}/pig/Q${i}.pig > ${RESULT_DIR}/${DATABASE}_pig_Q${i}.txt 2>&1
	else
		#default engine is hive
		ENGINE=hive
		echo "Hive query: ${i}"
		hive -i ${HIVE_SETTING} --database ${DATABASE} -f ${QUERY_DIR}/tpch_query${i}.sql > ${RESULT_DIR}/${DATABASE}_query${i}.txt 2>&1
	fi
	# Calculate the time
	STOPDATE="`date +%Y/%m/%d:%H:%M:%S`"
	STOPDATE_EPOCH="`date +%s`" # seconds since epoch
	DIFF_s="$(($STOPDATE_EPOCH - $STARTDATE_EPOCH))"
	DIFF_ms="$(($DIFF_s * 1000))"
	DURATION="$(($DIFF_s / 3600 ))h $((($DIFF_s % 3600) / 60))m $(($DIFF_s % 60))s"
	# log the times in load_time.csv file
	echo "${STARTDATE_EPOCH}|${STOPDATE_EPOCH}|${DIFF_ms}|${STARTDATE}|${STOPDATE}|${DURATION}|${BENCHMARK}|${DATABASE}|${SCALE}|${ENGINE}|${FILE_FORMAT}|Query ${i}" >> ${LOG_FILE_EXEC_TIMES}

	
	#i=$(( i+1 ))	
	i=`expr $i + 1`
done