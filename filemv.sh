#!/bin/bash

#please set the path to your TV library parent directory, could be relative or absolute
path='../../TV'

#function to convert to title case, used in Directory location
#by stackoverflow user agc
ftc() { set ${*,,} ; set ${*^} ; echo -n "$1 " ; shift 1 ; \
        for f in "$@" ; do \
            case $f in  A|The|Is|Of|And|Or|But|About|To|In|By) \
                    echo -n "${f,,} " ;; \
                 *) echo -n "$f " ;; \
            esac ; \
        done ; echo ; }

#establish variables for different modes
quiet_flag=''
test_flag=''

#create usage function
print_usage() {
  printf '%b\n' "Usage: -q for quiet mode and -t to test the command without making any changes to the file system"
}

#getopts to get option flags
while getopts 'qtvh' flag; do
  case "${flag}" in
    q) quiet_flag='true' ;;
    t) test_flag='true' ;;
    h | *) print_usage
       exit 1 ;;
  esac
done

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
        filename=$(ftc "$filename")
        if printf '%s\n' "$filename" | grep -iqF rupaul; then
            filename=$(printf '%s\n' "$filename" | sed 's/rupaul/RuPaul/gi')
        fi
        if printf '%s\n' "$filename" | grep -iqF \ Uk; then
            filename=$(printf '%s\n' "$filename" | sed 's/Uk/UK/gi')
        fi
        filename="$(printf '%b\n' "$filename" | sed -e 's/[[:space:]]*$//')"
        if ! [[ $quiet_flag ]]; then
          printf '%b\n' "FOUND MATCH: ${filename}"
        fi
    else
        if ! [[ $quiet_flag ]]; then
          printf '%b\n' "No match found!"
        fi
    fi

    #attempt to identify season #
    if [[ $f =~ $regex2 ]]; then
        season=${BASH_REMATCH[1]}
        season=$(printf %02d "$season")
        if ! [[ $quiet_flag ]]; then
          printf '%b\n' "FOUND SEASON: ${season}"
        fi
    else
        if ! [[ $quiet_flag ]]; then
          printf '%b\n' "No season found!"
        fi
    fi

    #attempt to identify episode #
    if [[ $f =~ $regex3 ]]; then
        episode=${BASH_REMATCH[1]}
        if ! [[ $quiet_flag ]]; then
          printf '%b\n' "FOUND EPISODE: ${episode}"
        fi
    else
        if ! [[ $quiet_flag ]]; then
          printf '%b\n' "No episode found!"
        fi
    fi

    #sets directory target based on information found above
    dir="${path}/${filename}/Season ${season}/"
    #and if that directory exists, move file there, and if not, and new season (episode 1)
    #identified, then create that directory first before moving
    if [[ -d $dir ]]; then
        if ! [[ $quiet_flag ]]; then
          printf '%b\n' "Directory $dir exists!"
        fi
        if ! [[ $test_flag ]]; then
          if ! [[ $quiet_flag ]]; then
            mv -vn "$f" "$dir"
          else
            mv -n "$f" "$dir"
          fi
        fi
    elif [[ $episode = "01" || $episode = "1" ]]; then
        if ! [[ $quiet_flag ]]; then
          printf '%b\n' "New season detected!"
        fi
        if ! [[ $test_flag ]]; then
          mkdir "$dir"
          if ! [[ $quiet_flag ]]; then
            mv -vn "$f" "$dir"
          else
            mv -n "$f" "$dir"
          fi
        fi
    else
        if ! [[ $quiet_flag ]]; then
          printf '%b\n' "Directory not found for $dir, did not move."
        fi
    fi
done
