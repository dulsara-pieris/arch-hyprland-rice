#!/bin/bash

count=$(checkupdates 2>/dev/null | wc -l)

if [ "$count" -gt 0 ]; then
        echo "󰂚 $count"
else
        echo "󰂚 0"
fi