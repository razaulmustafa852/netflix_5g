#!/bin/bash

bw_array=()
burst=()
b=1
d=1
while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11
 do
    bw_array[$b]=$col11
    #burst[$d]=$col2 
    #echo "I got:$col1|$col3"
    b=$((b + 1))
    d=$((d + 1))
done < 'inputtc/'5_g.csv


#------------------------------------------------------------------------------------#
#this role variable, first enable the TC then it delete the rule going in Else, but when It delete, it again enable new rule
role=1
runtime="5 minute"
endtime=$(date -ud "$runtime" +%s)
t=1
j=0
while [[ $(date -u +%s) -le $endtime ]]
do
    
    tc qdisc add dev s4-eth1 root handle 1: htb default 1
    
    # create class 1:1 and limit rate to 6Mbit
    sudo tc class add dev s4-eth1 parent 1: classid 1:1 htb rate "${bw_array[t]}"kbit ceil "${bw_array[t]}"kbit
   
    #tc qdisc show  dev s4-eth1
    echo  ${bw_array[t]}
    t=$((t + 1))
    sleep 4
    tc qdisc del dev s4-eth1 root
    
done
