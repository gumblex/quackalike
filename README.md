Quackalike
==========

This simple script attempts to generate text that looks like the training material.

## Requirements

* [KenLM](https://github.com/kpu/kenlm)
* Language tokenizers you like. (eg. [nltk](https://github.com/nltk/nltk), [tokenizer.perl](https://github.com/moses-smt/mosesdecoder/blob/master/scripts/tokenizer/tokenizer.perl) in Moses, [jieba](https://github.com/fxsjy/jieba) for Chinese)

### Compiling KenLM

* `git clone https://github.com/kpu/kenlm.git`
* `cd kenlm`
* See [kenlm/BUILDING](https://github.com/kpu/kenlm/blob/master/BUILDING)
* `sudo python3 setup.py install`

## Training

* Tokenize your corpus (eg. saved as `TOKENIZED_TEXT.txt`). Sentences should be splitted in desired way.
* Prepare the dictionary, eg. `sed 's/  / /g;s/ /\n/g' TOKENIZED_TEXT.txt | awk '{seen[$0]++} END {for (i in seen) {if (seen[i] > 1) print i}}' > dict.txt` (This filters out tokens that have appeared only once)
* `kenlm/bin/lmplz -o 6 --text TOKENIZED_TEXT.txt --arpa model.lm`
* `kenlm/bin/build_binary trie -q 8 -b 8 model.lm model.binlm` (See `--help` for explanation of the arguments)
* _Optional_ Learn the contextual vocabulary: `python3 learnctx.py dict.txt < TOKENIZED_TEXT.txt`

## Usage

`yes '' | python3 say.py model.binlm dict.txt`

