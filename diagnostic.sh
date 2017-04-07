#!/bin/bash

TMP_UID=$(LC_ALL=C;cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
DIR="/tmp/report-$TMP_UID"
mkdir $DIR

echo "# Information report"

echo "## Hardware"
echo "system_profiler"
system_profiler > $DIR/system_profiler

echo "## Network"
echo "### Interfaces"
echo "ifconfig"
ifconfig > $DIR/ifconfig

echo "### Wifi"
echo "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s"
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s > $DIR/airport

echo "### Routing"
echo "#### Routing table"
echo "netstat -nr"
netstat -nr > $DIR/network
echo "#### Traceroute"
echo "traceroute -I ubuntu.com"
traceroute -I ubuntu.com >> $DIR/network

echo "### DNS"
echo "scutil --dns"
scutil --dns >> $DIR/network

echo "## System"
echo "### Memory"
echo "vm_stat"
vm_stat > $DIR/vm_stat

echo "ram_usage"
ps xmo rss=,pmem=,comm= | while read rss pmem comm; do

size="$[rss/1024]";
short=$[4-${#size}];
size="(${size}M)";
i=0;
while ((i++ < short)); do size=" $size"; done;

        pmem="${pmem%%.*}"
	rcomm=`echo $comm|sed 's/^-//'`
        echo "$pmem% $size $(basename "$rcomm")"$"" >> $DIR/ram_usage; 
done


echo "### Disk"
echo "#### Mounts"
echo "mount"
mount > $DIR/mounts
echo "#### Usage"
echo "df -h"
df -h > $DIR/disk_usage
echo "#### Partitions"
echo "diskutil list"
diskutil list > $DIR/diskutil
for i in $(diskutil list|grep "/");do echo "*********************\n\n" >> $DIR/diskutil;diskutil info $i >> $DIR/diskutil;done
diskutil corestorage list >> $DIR/diskutil

echo "### Agents"
echo "/System/Library/CoreServices/talagent -winfo"
/System/Library/CoreServices/talagent -winfo > $DIR/talagent
echo "/System/Library/CoreServices/talagent -casinfo"
/System/Library/CoreServices/talagent -casinfo >> $DIR/talagent

echo "Reports files are in directory "$DIR
