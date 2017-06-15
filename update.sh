#!/bin/bash

SRC=CodeMirror

echo "This script assumes a few things."
echo " 1 - you are on OS X (Linux should be fine but watch out)"
echo " 2 - that the CodeMirror source is checked out in this directory"
echo " 3 - that CodeMirror is checked out to a specific tag (i.e. git checkout 5.26.0)"

if [ ! -d $SRC ]; then
  echo 
  echo "You need to checkout a version of CodeMirror from github"
  echo "Try:"
  echo "  git clone https://github.com/codemirror/CodeMirror.git"
  echo
  exit -1
fi

echo "Hit enter to continue - Ctrl-C to quit"
read

echo "Building the CodeMirror source"
pushd $SRC  > /dev/null
npm install
popd > /dev/null

echo ""
echo "Copying CodeMirror javascript"
cp $SRC/lib/codemirror.js vendor/assets/javascripts

echo ""
echo "Copying CodeMirror stylesheets"
cp $SRC/lib/codemirror.css vendor/assets/stylesheets

for THING in addon keymap mode; do
    echo "Copying ${THING}s"
    for FILE in `find $SRC/$THING \( -name '*.js' -o -name '*.css' \)`; do
        FILE=${FILE#${SRC}/} # Remove the src directory prefix
        if [ ${FILE} == *.js ]; then
            mkdir -p vendor/assets/javascripts/`dirname $FILE`
            cp ${SRC}/${FILE} vendor/assets/javascripts/${FILE}
        fi
        if [ ${FILE} == *.css ]; then
            mkdir -p vendor/assets/stylesheets/`dirname $FILE`
            cp ${SRC}/${FILE} vendor/assets/stylesheets/${FILE}
        fi
    done
done

echo ""
echo "Here's what's changed:"
git status --porcelain

echo ""
echo "Current Version for $SRC :"
grep version $SRC/package.json

echo
echo "To finish update the file lib/codemirror/rails/version.rb"
echo ""
echo "Done."
