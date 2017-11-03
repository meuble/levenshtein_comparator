# coding: utf-8

require File.join(File.dirname(__FILE__), 'spec_helpers')

describe LevenshteinComparator do
  it 'should remove parenthesis and brackets' do
    expect(LevenshteinComparator.remove_parenthesis("Ki dit Mié (Album Version)")).to eq("Ki dit Mié")
    expect(LevenshteinComparator.remove_parenthesis("Elle [Radio Edit]")).to eq("Elle")
  end
  
  it 'should remove all parenthesis' do
    expect(LevenshteinComparator.remove_parenthesis("Come Undone (Radio Edit) (2004 Digital Remaster)")).to eq("Come Undone")
  end
  
  it 'should remove all featuring' do
    expect(LevenshteinComparator.remove_featuring("Last Night Featuring Keyshia Cole")).to eq("Last Night")
    expect(LevenshteinComparator.remove_featuring("Last Night Feat. Keyshia Cole")).to eq("Last Night")
    expect(LevenshteinComparator.remove_featuring("Last Night featuring Keyshia Cole")).to eq("Last Night")
    expect(LevenshteinComparator.remove_featuring("Last Night feat. Keyshia Cole")).to eq("Last Night")
  end
  
  it 'should transform string into array of words' do
    expect(LevenshteinComparator.to_array("Relax, Take It Easy")).to eq(%w(relax take it easy))
    expect(LevenshteinComparator.to_array("P. Diddy")).to eq(%w(diddy))
    expect(LevenshteinComparator.to_array("D.A.N.C.E")).to eq(%w(dance))
    expect(LevenshteinComparator.to_array("Don't Phunk With My Heart")).to eq(%w(dont phunk with my heart))
    expect(LevenshteinComparator.to_array("Desert Rose / Sting")).to eq(%w(desert rose sting))
    
    expect(LevenshteinComparator.to_array('Jean-Jacques Goldman')).to eq(['jean', 'jacques', 'goldman'])
  	expect(LevenshteinComparator.to_array('Jean-Jacques Gold-Man')).to eq(['jean', 'jacques', 'gold', 'man'])
  	expect(LevenshteinComparator.to_array('L-O-V-E')).to eq(['love'])
  	expect(LevenshteinComparator.to_array('U-Turn')).to eq(['uturn'])
  	expect(LevenshteinComparator.to_array('D-12')).to eq(['d12'])
    expect(LevenshteinComparator.to_array('N°10')).to eq(['n10'])
    expect(LevenshteinComparator.to_array("3 doors down")).to eq(%w(3 doors down))
  end
  
  it 'should remove accent' do
    expect(LevenshteinComparator.unaccent("yéyè")).to eq("yeye")
    expect(LevenshteinComparator.unaccent('Björk')).to eq('Bjork')
    expect(LevenshteinComparator.unaccent('Saïan')).to eq('Saian')
    expect(LevenshteinComparator.unaccent('Cœur')).to eq('Coeur')
    expect(LevenshteinComparator.unaccent('Lætitia')).to eq('Laetitia')
  end
  
  it 'should decode html entities' do
    expect(LevenshteinComparator.decode_html_entities("Me &amp; Mr Jones")).to eq("Me & Mr Jones")
  end
  
  it 'should remove stop words' do
    expect(LevenshteinComparator.remove_stop_words(%w(la radiolina))).to eq(%w(radiolina))
    expect(LevenshteinComparator.remove_stop_words(%w(dont stop the music))).to eq(%w(dont stop music))
    expect(LevenshteinComparator.remove_stop_words(%w(a little bit))).to eq(%w(little bit))
  end

  it 'should clean and split a string at initializing' do
    lc = LevenshteinComparator.new("Désert the Rose / Sting")
    expect(lc.cleanified_strings).to eq(%w(desert rose sting))
    
    lc = LevenshteinComparator.new("Me &amp; Mr Jones")
    expect(lc.cleanified_strings).to eq(%w(me mr jones))
  end
  
  it 'should compare almost' do
    result = LevenshteinComparator.new('belles belles belles').compare(' belles')
    expect(result).to eq(:almost)
    
    result = LevenshteinComparator.new('noir desir').compare('nosir')
    expect(result).to eq(:almost)
    
    result = LevenshteinComparator.new('Les têtes raides').compare('tata raide')
    expect(result).to eq(:almost)
    
    result = LevenshteinComparator.new('On a tous une lula').compare('lula')
    expect(result).to eq(:almost)
    
    result = LevenshteinComparator.new('Putain vous m\'aurez plus').compare('vous m\'aurez plus')
    expect(result).to eq(:almost)
    
    result = LevenshteinComparator.new('Jeunesse lève toi').compare('Jeunes et con')
    expect(result).to eq(:almost)
  end
  
  it 'should compare ok' do
    result = LevenshteinComparator.new('calo').compare('cali')
    expect(result).to eq(:ok)
    
    result = LevenshteinComparator.new('fall').compare('fall fall')
    expect(result).to eq(:ok)
    
    result = LevenshteinComparator.new('Les primptemps').compare('le primptemp')
    expect(result).to eq(:ok)
    
    result = LevenshteinComparator.new('saez').compare('saeze')
    expect(result).to eq(:ok)
    
    result = LevenshteinComparator.new('Sonnez Toscin Dans Les Campagnes').compare('Sonner Toscins Dons Les Campagne')
    expect(result).to eq(:ok)
    
    result = LevenshteinComparator.new('Jeunesse Lève-Toi').compare('Jeunesse Lève-Toi')
    expect(result).to eq(:ok)
  end
  
  it 'should compare ko' do
    result = LevenshteinComparator.new('Des marées d\'écumes').compare('on n\'a pas la tune')
    expect(result).to eq(:ko)
    
    result = LevenshteinComparator.new('Jeunesse lève toi').compare('Jeune et con')
    expect(result).to eq(:ko)
    
    result = LevenshteinComparator.new('Alice').compare('Al bundee')
    expect(result).to eq(:ko)
    
    result = LevenshteinComparator.new('Gorraszewska').compare('Gorazseska')
    expect(result).to eq(:ko)
  end
  
  it 'should not test levenshtein for small words' do
    result = LevenshteinComparator.new('up in the air').compare('ap an the air')
    expect(result).to eq(:almost)
    
    result = LevenshteinComparator.new('no no no').compare('ni ni ni')
    expect(result).to eq(:ko)
  end
  
  it 'should have a levenshtein distance of 1 for medium words' do
    result = LevenshteinComparator.new('cali').compare('colo')
    expect(result).to eq(:ko)
    
    result = LevenshteinComparator.new('not in my mind').compare('or in my mind')
    expect(result).to eq(:almost)
  end
  
end
