# Hello HSC!

This script allows you to download a sheet from the Google Doc Collectors sheet as a CSV, and run with the following:

`ruby trade.rb PATH_TO_CSV`

It will do its best to find the people and items automatically, but it only took an hour to make so is likely to break!

The assumptions are:

- The name row contains a column for Marty, and a column for emmie (capitalised in the same way, in that order, and the first instance of that is the name row!)
- The sheet is indented with one empty column

The script sorts everyone's wants, and then puts them in order so that everyone gets a turn to want something.

The biggest assumption, however, is that you expect nothing in return for your trade. This is designed to make a trading party where we try to fulfil everything you want and everyone else is fine with that.

If you have any suggestions on how to make this more reciprocal, I'm all ears! If people would use it, I'll make a UI where you can choose yourself and your trader and see what you're both looking for and both have.
