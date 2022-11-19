#!/bin/bash

echo -n "Creating clusters. Please enter for 1 'replies' or  2 for 'retweets': "

read value

if [ "$value" -eq 1 ] ;
then 

	file="INFL_UserIDs_3Rgreater_replies.tsv"
	INFLUENCE_CLUSTER="INFLUENCE_CLUSTERS_REPLIES"
	file2="downloaded_tweets_extend_original_nolf2_NOBOT_repliedTo.tsv"

elif [ "$value" -eq 2 ] ;
then
        file="INFL_UserIDs_3Rgreater_retweets.tsv"
        INFLUENCE_CLUSTER="INFLUENCE_CLUSTERS_RETWEETS"
	file2="join_retweeted_message_ids_with_original_nolf2_NOBOT.tsv"
else
	echo "Wrong number was enter. Please try again."
	exit 1

fi	
for userID_of_INFL in `cat $file` ; do
      		
	grep  $userID_of_INFL $file2 \
	| awk -F "\t" '{print $4}' | tr ',' '\n' | tr '"' '\n'| tr '[:upper:]' '[:lower:]' \
	| grep . > $INFLUENCE_CLUSTER/$userID_of_INFL ;
done

echo "Creating files in directory: $INFLUENCE_CLUSTER"
