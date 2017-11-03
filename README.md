# Levenstein Comparator

Levenstein Comparator allows you to compare two sentences and say if their is a match, almost a match or nothing to compare.

This can be tipically used in a music quizz, where people have to find a song title and due to high pressure from competitors and time, are eager to do spelling mistakes, forget a word, ...
Levenstein Comparator helps decide if the user entry is close enough to the answer to give a point to the user.

Taken from the specs, here are some exemples :

```ruby
    result = LevenshteinComparator.new('calo').compare('cali')
    result.should == :ok
    
    result = LevenshteinComparator.new('fall').compare('fall fall')
    result.should == :ok
    
    result = LevenshteinComparator.new('Les primptemps').compare('le primptemp')
    result.should == :ok
    
    result = LevenshteinComparator.new('saez').compare('saeze')
    result.should == :ok
    
    result = LevenshteinComparator.new('Sonnez Toscin Dans Les Campagnes').compare('Sonner Toscins Dons Les Campagne')
    result.should == :ok
    
    result = LevenshteinComparator.new('Jeunesse Lève-Toi').compare('Jeunesse Lève-Toi')
    result.should == :ok
    
    result = LevenshteinComparator.new('belles belles belles').compare(' belles')
    result.should == :almost
    
    result = LevenshteinComparator.new('noir desir').compare('nosir')
    result.should == :almost
    
    result = LevenshteinComparator.new('Les têtes raides').compare('tata raide')
    result.should == :almost
    
    result = LevenshteinComparator.new('On a tous une lula').compare('lula')
    result.should == :almost
    
    result = LevenshteinComparator.new('Putain vous m\'aurez plus').compare('vous m\'aurez plus')
    result.should == :almost
    
    result = LevenshteinComparator.new('Jeunesse lève toi').compare('Jeunes et con')
    result.should == :almost
    
    result = LevenshteinComparator.new('Des marées d\'écumes').compare('on n\'a pas la tune')
    result.should == :ko
    
    result = LevenshteinComparator.new('Jeunesse lève toi').compare('Jeune et con')
    result.should == :ko
    
    result = LevenshteinComparator.new('Alice').compare('Al bundee')
    result.should == :ko
    
    result = LevenshteinComparator.new('Goraszewska').compare('Gorazseska')
    result.should == :ko
```

## About Levenstein Comparator

Levenstein Comparator is given to you by [The Social Client](http://www.thesocialclient.com), a digital and CRM consultant agency.

## Licencing

Levenstein Comparator is a [Beerware](http://en.wikipedia.org/wiki/Beerware) and is licensed under the terms of the [WTFPL](http://www.wtfpl.net), see the included WTFPL-LICENSE file.

If we meet some day, and you think this stuff is worth it, you can buy us a beer in return.