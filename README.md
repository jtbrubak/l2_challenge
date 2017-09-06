# Best Buy Scraper

This is a Ruby script intended to scrape Best Buy search results for any given term. It uses Ruby's ```open-uri```, ```csv```, and ```date``` libraries, as well as the Oga gem for parsing HTML, which will need to be installed before running the scraper (I've taken the liberty of including it in a gemfile so it can simply be bundle installed). To run it, clone this repository, navigate to the directory and simply use this command:

```ruby scraper.rb [search term]```

The search term should written just as you would type it into the search bar of the site, so if you intend to search for "smart tv", you would run ```ruby scraper.rb smart tv```.

The script loads the first page of search results, then picks out the brand name, model, average rating, and number of ratings for each item, which it saves to an array. This process repeats for each subsequent page until the length of the array matches the number of search results, at which points the results are written to a CSV file. I've included three days worth of search results for both "smart tv" and "curved smart tv", but give the script a whirl yourself if you're looking for more!
