#!/bin/bash

#function to convert to title case, used in Directory location
ftc() { set ${*,,} ; set ${*^} ; echo -n "$1 " ; shift 1 ; \
        for f in ${*} ; do \
            case $f in  A|The|Is|Of|And|Or|But|About|To|In|By) \
                    echo -n "${f,,} " ;; \
                 *) echo -n "$f " ;; \
            esac ; \
        done ; echo ; }

regex='(.+)[\.][sS][0-9|1-9]+'
regex2='[sS]([0-9|1-9]+)'
regex3='[eE]([0-9|1-9]+)'

for f in *.mkv           # no need to use ls.

do
    if [[ $f =~ $regex ]]; then
        filename=${BASH_REMATCH[1]//./ }
        filename=$(ftc $filename)
        if echo $filename | grep -iqF rupaul; then
            filename=$(echo "$filename" | sed 's/rupaul/RuPaul/gi')
        fi
        filename="$(echo -e "$filename" | sed -e 's/[[:space:]]*$//')"
        echo "FOUND MATCH: ${filename}"
    else
        echo "No match found!"
    fi
    if [[ $f =~ $regex2 ]]; then
        season=${BASH_REMATCH[1]}
        echo "FOUND SEASON: ${season}"
    else
        echo "No season found!"
    fi


    if [[ $f =~ $regex3 ]]; then
        episode=${BASH_REMATCH[1]}
        echo "FOUND EPISODE: ${episode}"
    else
        echo "No episode found!"
    fi


    dir="../../TV/$filename/Season $season/"
    if [[ -d $dir ]]; then 
        echo "Directory $dir exists!"
        mv -vn "$f" "$dir"
    elif [[ $episode = "01" || $episode = "1" ]]; then
        echo "New season detected!"
        mkdir "$dir"
        mv -vn "$f" "$dir"
    else
        echo "Directory not found for $dir, did not move."
    fi

done


