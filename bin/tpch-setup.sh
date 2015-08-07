#!/bin/bash

# function usage {
#	echo "Usage: tpch-setup.sh scale_factor [temp_directory]"
#	exit 1
# }

# get home path
BENCH_HOME=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd );
echo "\$BENCH_HOME is set to $BENCH_HOME";

# Read the TPC-H config parameters
source $BENCH_HOME/tpch/conf/settings.sh

function runcommand {
	if [ "X$DEBUG_SCRIPT" != "X" ]; then
		$1
	else
		$1 2>/dev/nullhadoo
	fi
}

if [ ! -f $BENCH_HOME/tpch/tpch-gen/target/tpch-gen-1.0-SNAPSHOT.jar ]; then
	echo "Please build the data generator with ./tpch-build.sh first"
	exit 1
fi
which hive > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Script must be run where Hive is installed"
	exit 1
fi

if [ "X$DEBUG_SCRIPT" != "X" ]; then
	set -x
fi

# Sanity checking.
if [ X"$SCALE" = "X" ]; then
	usage
fi
if [ X"$DIR" = "X" ]; then
	DIR=/tmp/tpch-generate
fi
if [ $SCALE -eq 1 ]; then
	echo "Scale factor must be greater than 1"
	exit 1
fi

# Do the actual data load.
hdfs dfs -mkdir -p ${DIR}
hdfs dfs -ls ${DIR}/${SCALE} > /dev/null
if [ $? -ne 0 ]; then
	echo "Generating data at scale factor $SCALE."
	(cd $BENCH_HOME/tpch/tpch-gen; hadoop jar target/*.jar -d ${DIR}/${SCALE}/ -s ${SCALE})
fi
hdfs dfs -ls ${DIR}/${SCALE} > /dev/null
if [ $? -ne 0 ]; then
	echo "Data generation failed, exiting."
	exit 1
fi
echo "TPC-H text data generation complete."

# Create the text/flat tables as external tables. These will be later be converted to ORCFile/ other File formats.
echo "Loading text data into external tables."
LOAD_TEXT_CMD="hive -i $BENCH_HOME/$BENCHMARK/conf/load-flat.sql -f $BENCH_HOME/$BENCHMARK/ddl/alltables.sql -d DB=${BENCHMARK}_text_${SCALE} -d LOCATION=${DIR}/${SCALE}"
runcommand "$LOAD_TEXT_CMD"

# Initialize log file for data loading times
LOG_FILE_EXEC_TIMES="${BENCH_HOME}/${BENCHMARK}/logs/load_times.csv"
if [ ! -e "$LOG_FILE_EXEC_TIMES" ]
  then
    touch "$LOG_FILE_EXEC_TIMES"
    echo "STARTDATE_EPOCH|STOPDATE_EPOCH|DURATION_MS|STARTDATE|STOPDATE|DURATION|BENCHMARK|DATABASE|SCALE_FACTOR|FILE_FORMAT|TABLE" >> "${LOG_FILE_EXEC_TIMES}"
fi

if [ ! -w "$LOG_FILE_EXEC_TIMES" ]
  then
    echo "ERROR: cannot write to: $LOG_FILE_EXEC_TIMES, no permission"
    return 1
fi

# Create the optimized tables.
i=1
total=8

for t in ${TABLES}
do
	echo "Optimizing table $t ($i/$total)."
	COMMAND="hive -i $BENCH_HOME/$BENCHMARK/conf/load-flat.sql -f $BENCH_HOME/$BENCHMARK/ddl/${t}.sql -d DB=${DATABASE} \	
	-d SOURCE=${BENCHMARK}_text_${SCALE} -d BUCKETS=${BUCKETS} -d FILE=${FILE_FORMAT}"
	
	# Start timer to measure data loading for the file formats
	STARTDATE="`date +%Y/%m/%d:%H:%M:%S`"
	STARTDATE_EPOCH="`date +%s`" # seconds since epoch
	# execute table load
	runcommand "$COMMAND"
	if [ $? -ne 0 ]; then
		echo "Command failed, try 'export DEBUG_SCRIPT=ON' and re-running"
		exit 1
	fi
	
	# Finish loading data to a table
	# Calculate the time
	STOPDATE="`date +%Y/%m/%d:%H:%M:%S`"
	STOPDATE_EPOCH="`date +%s`" # seconds since epoch
	DIFF_s="$(($STOPDATE_EPOCH - $STARTDATE_EPOCH))"
	DIFF_ms="$(($DIFF_s * 1000))"
	DURATION="$(($DIFF_s / 3600 ))h $((($DIFF_s % 3600) / 60))m $(($DIFF_s % 60))s"
	# log the times in load_time.csv file
	echo "${STARTDATE_EPOCH}|${STOPDATE_EPOCH}|${DIFF_ms}|${STARTDATE}|${STOPDATE}|${DURATION}|${BENCHMARK}|${DATABASE}|${SCALE}|${FILE_FORMAT}|${t}" >> ${LOG_FILE_EXEC_TIMES}
	
	# get table information
	hive -e "use ${DATABASE}; describe formatted ${t};exit;" > ${BENCH_HOME}/${BENCHMARK}/logs/${t}_info.log 2>&1
	
	i=`expr $i + 1`
done


  
echo "Data loaded into database ${DATABASE}."
