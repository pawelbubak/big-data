#! /bin/bash

rm -r 132197_out
hadoop fs -rm -r /user/132197/labs/project/persons/input
hadoop fs -rm -r /user/132197/labs/project/persons/st_output
hadoop fs -rm -r /user/132197/labs/project/persons/output

mkdir 132197_out
hadoop fs -mkdir -p /user/132197/labs/project/persons/input
hadoop fs -copyFromLocal title.principals.tsv /user/132197/labs/project/persons/input/
hadoop fs -copyFromLocal name.basics.tsv /user/132197/labs/project/persons/input/
hadoop fs -ls /user/132197/labs/project/persons/input/

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
	-files persons_mapper.py,persons_reducer.py \
	-mapper persons_mapper.py \
	-combiner persons_reducer.py \
	-reducer persons_reducer.py \
	-input /user/132197/labs/project/persons/input/title.principals.tsv \
	-output /user/132197/labs/project/persons/st_output

hadoop fs -ls /user/132197/labs/project/persons/st_output/
hadoop fs -cp /user/132197/labs/project/persons/st_output/part-* /user/132197/labs/project/persons/input/

hive -f script.sql

hadoop fs -copyToLocal /user/132197/labs/project/persons/output/* 132197_out/

cat 132197_out/*
