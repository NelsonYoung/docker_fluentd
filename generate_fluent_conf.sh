#!/bin/bash
# 
# Desc: generate fluent configuration
# Date: 2016-02-24 15:49:20
# Author: Jun
# 

ipadd=`ip add | grep "10\." | awk '{print $2}' | cut -f 1 -d/`
all_game=(`ls /data/game | grep ^game`)
for game in ${all_game[@]}
do
    echo "<source>" >> fluent.conf
    echo "  @type tail" >> fluent.conf
    echo "  format multiline" >> fluent.conf 
    echo "  format_firstline /\d{4}-\d{1,2}-\d{1,2}/" >> fluent.conf
    echo "  format1 /^(?<time>\d{4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}) \[(?<thread>.*)\] (?<level>[^\s]+) (?<tag>.*) \[(?<pid>.\d{1,3})\] \-\> (?<message>.*)/" >> fluent.conf
    echo "  path /data/game/${game}/log/logFile.log" >> fluent.conf
    echo "  pos_file /var/log/fluent_pos/logFile_${game}.log.pos" >> fluent.conf
    echo ${game} | grep "*" > /dev/null 2>&1
    if [ $? -eq 0 ] 
    then
        game_id=`echo "${game}" | awk -F"@" '{print $1}'`
        game_range_start=`echo "${game}" | awk -F"@" '{print $2}' | cut -f 1 -d*`
        game_range_end=`echo "${game}" | awk -F"@" '{print $2}' | cut -f 2 -d*`
        game_combind=${game_id}@${game_range_start}_${game_range_end}
        echo "  tag gamelog.${game_combind}" >> fluent.conf
    else
        echo "  tag gamelog.${game}" >> fluent.conf
    fi
    echo "</source>" >> fluent.conf

done

echo "<match gamelog.*>" >> fluent.conf
echo "  @type elasticsearch" >> fluent.conf
echo "  logstash_format true" >> fluent.conf
echo "  host 10.96.33.38" >> fluent.conf
echo "  port 9200" >> fluent.conf
echo "  include_tag_key true" >> fluent.conf
echo "  tag_key @log_name" >> fluent.conf
echo "</match>" >> fluent.conf
