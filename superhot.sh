mode="$1"

INPUT_PATH="/input"
OUTPUT_PATH="/output"
WORDCOUNT_INPUT_PATH=$INPUT_PATH/wordcount
WORDCOUNT_OUTPUT_PATH=$OUTPUT_PATH/wordcount
TOPN_INPUT_PATH=$WORDCOUNT_OUTPUT_PATH
TOPN_OUTPUT_PATH=$OUTPUT_PATH/topn
PIG_ARTICLE_INPUT_PATH=$INPUT_PATH/article
PIG_TOPN_INPUT_PATH=$TOPN_OUTPUT
PIG_OUTPUT_PATH=$OUTPUT_PATH/pig_out


if [ "$mode" == "y" ]
then
	echo "Will initialize. [press any key]:"
	read
fi
hadoop fs -rmr $INPUT_PATH
hadoop fs -rmr $OUTPUT_PATH
hadoop fs -mkdir $INPUT_PATH
hadoop fs -mkdir $OUTPUT_PATH
hadoop fs -mkdir $WORDCOUNT_INPUT_PATH
if [ "$mode" == "y" ]
then
	echo "Will parse date from server and generate date. [press any key]:"
	read
fi
java -jar superhot.jar
if [ "$mode" == "y" ]
then
	echo "Will copy date from local to hdfs. [press any key]:"
	read
fi
hadoop fs -copyFromLocal description.txt $WORDCOUNT_INPUT_PATH/description.txt
hadoop fs -copyFromLocal article.txt $PIG_ARTICLE_INPUT_PATH/article.txt
if [ "$mode" == "y" ]
then
	echo "Will run word count and TopN. [press any key]:"
	read
fi
hadoop jar wordcount-1.0-SNAPSHOT.jar WordCount $WORDCOUNT_INPUT_PATH $WORDCOUNT_OUTPUT_PATH
hadoop jar TopN-1.0-SNAPSHOT.jar TopN $TOPN_INPUT_PATH $TOPN_OUTPUT_PATH 10
hadoop fs -cat $TOPN_OUTPUT_PATH/*
if [ "$mode" == "y" ]
then
	echo "Will run pig to get top articles. [press any key]:"
	read
fi
pig getArticles.pig
hadoop fs -cat $PIG_OUTPUT_PATH/*
rm ./pig_output.txt
hadoop fs -cat $PIG_OUTPUT_PATH/part-r-00000 ./pig_output.txt
echo "DONE!!!"
