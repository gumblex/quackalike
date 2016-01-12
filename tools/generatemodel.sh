#!/bin/bash

TEXT="$1"
TOKENIZED_TEXT=../model/tokenized.txt
DICT=../model/dict.txt
MODEL=../model/model.binlm
KENLM_DIR=~/software/moses/bin

MIN_SEEN=1
ORDER=5

echo 'starting at '`date`' on '`hostname`

if [ ! -f "$TOKENIZED_TEXT" ]; then
  python3 tokenizer.py < "$TEXT" > "$TOKENIZED_TEXT"
fi

sed 's/  / /g;s/ /\n/g' "$TOKENIZED_TEXT" | awk '{seen[$0]++} END {for (i in seen) {if (seen[i] > '$MIN_SEEN') print i}}' > $DICT

$KENLM_DIR/lmplz -o $ORDER --text "$TOKENIZED_TEXT" --arpa "$MODEL".arpa
$KENLM_DIR/build_binary -q 8 -b 8 trie "$MODEL".arpa "$MODEL"

rm "$MODEL".arpa
echo 'finished at '`date`
