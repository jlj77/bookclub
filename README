# Bash scripts for our book club @ nfld.uk

## gen_feed.sh

Generates a crude RSS feed, based off of `wdiff` output of HTML files in the current working directory. It expects the older file to have an additional .old extension.

### Dependencies
- wdiff

## grab_pads.sh

Crawls the master Etherpad for our book club – at: https://pad.nfld.uk/p/bookclub_master – looking for other linked Etherpads to pull down. All of these are exported to HTML files, with any pre-existing copies moved to .old prior to the `curl`.

### Dependencies
- curl
- tidy (HTML tidy)
- lynx
- gawk

_(Note: all the regex code could be rewritten to reduce these, of course. But it works!)_
