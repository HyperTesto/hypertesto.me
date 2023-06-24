#/bin/bash

CURRENT_SCRIPT=$(readlink $0)

if [ -z "$1" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "Convert plain markdown files (.md) in DIR to hugo bundles"
    echo "Usage: $CURRENT_SCRIPT DIR [OPTIONS]"
    echo "ARGUMENTS:"
    echo "DIR          Directory where .md files are placed"
    echo "OPTIONS:"
    echo "-h|--help    Prints this help message"
    exit 100
fi

SEARCH_DIR=$1

find $SEARCH_DIR -name "*.md" -not  -name "index*.md" -not -name "_index*.md" -exec bash -c '
    BASE_DIR=$1
    BUNDLE_DIR="$BASE_DIR/$(basename $2 .md)"  
    SOURCE_FILE=$2
    TARGET_FILE=$BUNDLE_DIR/index.md
    echo "Moving $SOURCE_FILE to $TARGET_FILE"
    mkdir $BUNDLE_DIR 
    mv $SOURCE_FILE $TARGET_FILE
' bash $SEARCH_DIR {} \;
