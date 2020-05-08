#!/bin/bash

#function to convert to title case, used in Directory location
#by stackoverflow user agc
ftc() { set ${*,,} ; set ${*^} ; echo -n "$1 " ; shift 1 ; \
        for f in ${*} ; do \
            case $f in  A|The|Is|Of|And|Or|But|About|To|In|By) \
                    echo -n "${f,,} " ;; \
                 *) echo -n "$f " ;; \
            esac ; \
        done ; echo ; }

#set 3 regex expressions to isolate show title, season # and episode #
#season/episode should be formated s#e#, but case or leading zero shouldn't matter
regex='(.+)[\.][sS][0-9|1-9]+'
regex2='[sS]([0-9|1-9]+)'
regex3='[eE]([0-9|1-9]+)'

#for all .mkv files in active directory
for f in *.mkv

do
    #attempt to locate be searching before the season, then converting periods to spaces
    #and standardizing captialization. extra work needed for non standard RuPaul capitalization
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
    
    #attempt to identify season #
    if [[ $f =~ $regex2 ]]; then
        season=${BASH_REMATCH[1]}
        echo "FOUND SEASON: ${season}"
    else
        echo "No season found!"
    fi

    #attempt to identify episode #
    if [[ $f =~ $regex3 ]]; then
        episode=${BASH_REMATCH[1]}
        echo "FOUND EPISODE: ${episode}"
    else
        echo "No episode found!"
    fi

    #sets directory target based on information found above
    dir="../../TV/$filename/Season $season/"
    #and if that directory exists, move file there, and if not, and new season (episode 1)
    #identified, then create that directory first before moving
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
