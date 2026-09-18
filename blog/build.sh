#!/bin/sh

set -ue

TARGET=$1
HERE=$(pwd)

rm -rf $TARGET
cp -a content/ $TARGET

echo Generating notes/interesting-projects
python3 ../interesting-projects/interesting-projects.py >$TARGET/notes/interesting-projects.gmi

cd $TARGET

echo Generating index...
cat >index.gmi <<EOF
# El blog es mío
## Hay otros como él, pero este es el mío

=> /contacto Contacta conmigo.

=> notas/ Notas
=> notes/ Notes

EOF
find . -path './2???/??/*.gmi' -type f -print0 | coppewebite-indexer . >>index.gmi

echo Generating RSS...
coppewebite-to-rss <index.gmi https://alex.corcoles.net . >index.rss

$HERE/footers.py $HERE/content

echo Converting to HTML
find . -name '*.gmi' -print0 | xargs -0 coppewebite-to-html --css $HERE/style.css
coppewebite-to-html index.gmi --feed-title "El blog es mío" --feed-href index.rss --css $HERE/style.css

echo Done
