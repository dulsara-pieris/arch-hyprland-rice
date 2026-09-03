#!/bin/bash

cava -p ~/.config/cava/config | while read -r line; do
        bars=""

        for n in $(echo "$line" | tr ';' ' '); do
                case $n in
                        0) bars+="▁" ;;
                        1) bars+="▂" ;;
                        2) bars+="▃" ;;
                        3) bars+="▄" ;;
                        4) bars+="▅" ;;
                        5) bars+="▆" ;;
                        6) bars+="▇" ;;
                        *) bars+="█" ;;
                esac
        done

        echo "$bars"
done
