# mvtv_by_name-season
bash script to move a file from a download directory into TV library

# intro
Why not use filebot? I wanted something simple and command line and a project to use for learning. Filebot's licensing and installation (and reliance on java and other dependencies) seemed complex and didn't match the philosophy of my lightweight, headless Linux server. If you want something more robust that can create a new library for you, cross reference to cloud TV databases, and deal with more file types and naming conventions, then don't use this. 

# installation
Clone the repo, or simply create a .sh file in your download directory. Make sure the new file is executionable. You want to pay attention to the dir variable on line 55. My download directory is [mountpoint]tmp/tv and my TV library is [mountpoint]TV, so if you run this file in your download directory, it assumes the TV library is located ../../TV/. If you don't have this set up (which you probably don't), you'll need to adjust line 55 to match where your library is in relation to your download directory. 

# usage
One you have your directory path set, you just need to run the file ./filemv.sh. You can set up a cronjob to run this task periodically, or you can even set up a task to monitor directory for changes. Will try to work on these automation instructions more in the future.

There are 2 additional option modes, -q and -t.
-q
  This is quiet mode (-q), and nothing will print in the command line, so you will get no feedback whether this worked or not
-t
  This is test mode (-t), and no actions will be taken with the file system in terms of moving or creating new directories, but all success and fail messages will print.
-h
  There is also a help flag that will print a summary of the 2 optional flags.

You may run in both quiet and test mode, but basically nothing would happen as the messages would be suppressed, and file operations also suppressed.

# assumptions
- TV library
  - must be named using title case convention, with standard common words lower case (except first word always capitalized). Those exemption words are a|the|is|of|and|or|but|about|to|in|by.
  - Additionally, TV library must have season folders with 2 digit/leading zero numbering
  - directory location is assumed to be '../../' in relation to download directory, but this can be changed if you modify source code
- File naming
  - Must be file type .mkv. Other file types could be added if required.
  - Must use a s#e# formatting. case and leading zero do not matter here
  - The s#e# must be directly after the title, and must be separated by a period
  - Title must use periods or spaces to separate words
  - Case does not matter in title, as there is a function to convert to a more standard capitalization scheme
  - RuPaul is non-standard capitilzation, so additional check to correct for that
  - Anything after the title and s#e# will be ignored, except the extension
  
# What if I don't have a directory set up for the show yet?

  Currently, this must be manually added. This script is for integrating new episodes into an existing library. I don't trust the script to automatically create directories, as small spelling errors or non-standard capitalization or punctuation has not been accounted for. Having an automated directory creation scheme would likely result in redundant/duplicate directories for the cases I haven't accounted for. You'll need filebot or equiv. for that functionality, and really would need to be super smart at identifying what show and cross reference to a cloud database. I'm not there yet.

# What if I don't have a directory set up for the season yet?

  If this is the first episode of a new season, the script will create that new season directory. If it is not the first season espisode, it assumes the directory exists already and won't create it. If you have an incomplete library or only want a few episodes that are not episode 1, you must manually add the season. If it cannot find the correct season for a non-episode 1 episode, it assumes something has gone wrong and requires manual intervention.
  
In my testing, nearly all of my files meet this criteria: .mkv file, title separated by periods, and s#e# formatting. My script has not choked on anything yet, but it has only been tested with about a dozen files. Will likely keep modifying and evolving as I run into different file types, but the idea is you name the file in a manner that the script accepts, and standarizating of naming across the board is key.
