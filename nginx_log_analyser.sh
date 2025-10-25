#!/bin/bash

# Check if a log file argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <nginx_access_log>"
    exit 1
fi

LOGFILE="$1"

# Check if the file exists and is readable
if [ ! -f "$LOGFILE" ]; then
    echo "Error: File '$LOGFILE' does not exist."
    exit 1
elif [ ! -r "$LOGFILE" ]; then
    echo "Error: File '$LOGFILE' is not readable."
    exit 1
fi

# Top 5 IP addresses
echo "Top 5 IP addresses with the most requests:"
awk '{print $1}' "$LOGFILE" | sort | uniq -c | sort -nr | head -5 | awk '{print $2 " - " $1 " requests"}'
echo ""

# Top 5 most requested paths
echo "Top 5 most requested paths:"
awk '{print $7}' "$LOGFILE" | sort | uniq -c | sort -nr | head -5 | awk '{print $2 " - " $1 " requests"}'
echo ""

# Top 5 response status codes
echo "Top 5 response status codes:"
awk '{print $9}' "$LOGFILE" | sort | uniq -c | sort -nr | head -5 | awk '{print $2 " - " $1 " requests"}'
echo ""

# Top 5 user agents
echo "Top 5 user agents:"
awk -F\" '{print $6}' "$LOGFILE" | sort | uniq -c | sort -nr | head -5 | awk '{$1=$1; print $0}'
echo ""

# Optional: Top 5 referrers
echo "Top 5 referrers:"
awk -F\" '{print $4}' "$LOGFILE" | sort | uniq -c | sort -nr | head -5 | awk '{$1=$1; print $0}'
echo ""

# Optional: Average response size
echo -n "Average response size: "
awk '{sum+=$10; count+=1} END {if(count>0) print sum/count; else print 0}' "$LOGFILE"
echo ""


