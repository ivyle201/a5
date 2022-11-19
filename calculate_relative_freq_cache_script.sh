#!/bin/bash


echo -n "Please enter 1 for 'replies' or  2 for 'retweets': "

read value

if [ "$value" -eq 1 ] ;
then
	output_file="replies_hashtag_freqs.tsv"
	INFLUENCE_CLUSTER="INFLUENCE_CLUSTERS_REPLIES"
	time="0m16.922s"
	#count all hashtags of replies from the original file
	count_hashtags_entire_dataset=`cat entire_hashtags_for_replies.tsv | wc -l`
elif [ "$value" -eq 2 ] ; 
then
	output_file="retweets_hashtag_freqs.tsv"
	INFLUENCE_CLUSTER="INFLUENCE_CLUSTERS_RETWEETS"
	time="3m58.658s"
	#count all hashtags of retweets from original file
	count_hashtags_entire_dataset=`cat entire_hashtags_for_retweets.tsv | wc -l`
else
	echo "Wrong number was input."
	exit 1
fi

echo "Reading hashtag files from directory $INFLUENCE_CLUSTER and writing to $output_file. Processing...please wait $time."

#header columns
echo -e "hashtag\tcluster_C_leader(userID)\trelative_frequency_H_C\tfrequency_H_in_C\tfrequency_H_overall\tcount_H_in_C\tcount_hashtags_in_C\tcount_H_entire_dataset\tcount_hashtags_entire_dataset" > $output_file

declare -A cache_array

#iterate through the INFL file from INFLUENCE_CLUSTER directory 

for INFL_FILE in `ls $INFLUENCE_CLUSTER | head -n 1000`; do

	for HASHTAG in `cat $INFLUENCE_CLUSTER/$INFL_FILE` ; do
        	
		count_H_in_C=`grep $HASHTAG $INFLUENCE_CLUSTER/$INFL_FILE | wc -l`
		count_hashtags_in_C=`cat $INFLUENCE_CLUSTER/$INFL_FILE | wc -l`
		
		#get count_H_entire_dataset
		count_H_entire_dataset=${cache_array[$HASHTAG]}
		#if the value is not in the array
		if [ -z "$count_H_entire_dataset" ] ;
		then
		
			if [ "$value" -eq 1 ] ; 
			then
				count_H_entire_dataset=`grep $HASHTAG entire_hashtags_for_replies.tsv | wc -l` 
		
			elif [ "$value" -eq 2 ] ; 
			then
				count_H_entire_dataset=`grep $HASHTAG entire_hashtags_for_retweets.tsv | wc -l`
			fi
			cache_array[$HASHTAG]=$count_H_entire_dataset
		fi

		frequency_H_in_C=`echo "scale=2; $count_H_in_C/$count_hashtags_in_C" | bc -l`
		frequency_H_overall=`echo "scale=7; $count_H_entire_dataset/$count_hashtags_entire_dataset" | bc -l`
		relative_frequency_H_C=`echo "scale=2; $frequency_H_in_C/$frequency_H_overall" | bc -l`
		
		echo -e "$HASHTAG\t $INFL_FILE\t$relative_frequency_H_C\t$frequency_H_in_C\t$frequency_H_overall\t$count_H_in_C\t$count_hashtags_in_C\t$count_H_entire_dataset\t$count_hashtags_entire_dataset"
	done;
done >> $output_file 
