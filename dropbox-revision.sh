#!/bin/bash -e

# Icons
ICON_WARNING=/usr/share/icons/gnome/48x48/status/messagebox_warning.png
ICON_OK=~/.dropbox-dist/images/emblems/emblem-dropbox-uptodate.png

if [ $# -eq 0 ]; then
  echo "Missing argument."
  exit 113
fi


# Configuration
CFG_FILE=~/.dropbox-revision-it.cfg


case "$1" in

--configure|-c) 

  echo "dropbox-revisioin-it configuration"
  echo "----------------------------------"
  echo ""


  read -p "Insert Dropbox folder location [press enter for ~/Dropbox]: " -e REPLY1

  if [ -z "$REPLY1" ]; then
    DROPBOX_FOLDER=~/Dropbox
  else
    eval DROPBOX_FOLDER="${REPLY1%/}"
  fi

  if [ ! -d "$DROPBOX_FOLDER" ]; then
    echo "Inexistent Dropbox directory."
    echo "Aborting configuration. Bye."
    rm -f $CFG_FILE
    exit 113
  fi

  eval echo DROPBOX_FOLDER="$DROPBOX_FOLDER" > $CFG_FILE

  read -p "Choose browser [press enter for Google Chrome]: " -e REPLY2

  if [ -z "$REPLY2" ]; then
    BROWSER=/usr/bin/google-chrome
  else
    eval BROWSER="$REPLY2"
  fi

  eval echo BROWSER="$BROWSER" >> $CFG_FILE

  echo ""
  echo "Stored data:"
  echo "------------"

  cat $CFG_FILE

  exit 113

;;

--remove|-r)

  rm -f $CFG_FILE
  exit 113

;;

--help|-h)

  echo "dropbox-revision-it script"
  echo ""
  echo "Git repository: https://github.com/rjdsc/dropbox-revision-it"
  echo ""
  
  exit 113

;;

esac

if [ ! -d "$1" ] && [ ! -f "$1" ]; then

  notify-send "Dropbox-Revision-It!" \
              "Invalid input." \
              -i $ICON_WARNING
  exit 113

fi

# If there is no argument look at the clipboard
if [ -d "$1" ]; then

  notify-send "Dropbox-Revision-It!" \
              "Dropbox only revision control files." \
              -i $ICON_WARNING
  exit 113

fi

# Read configuration
source $CFG_FILE

# Get file full path
FULLFILEPATH=`ls -1 $(pwd)/"$1"`

STRIPED_PATH=`echo "$FULLFILEPATH" | sed -E "s|$DROPBOX_FOLDER/||g"`

RAWURL="https://www.dropbox.com/revisions/$STRIPED_PATH"
URL=`echo "$RAWURL" | \
     sed -E 's/ /%20/g'`

$BROWSER $URL

notify-send "Dropbox-Revision-It!" \
            "Revision available." \
            -i $ICON_OK


