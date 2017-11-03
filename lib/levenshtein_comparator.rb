# coding: utf-8

require 'levenshtein'
require 'htmlentities'

class LevenshteinComparator
  attr_accessor :cleanified_strings
  
  STOP_WORDS = [
    "un",
    "une",
    "the",
    "le",
    "la",
    "les",
    "a",
    "an",
    "of",
    "du",
    "de",
    "des",
    "et",
    "and",
    "ne",
    "en",
    "au"
  ]
  
  ASCII_REGEXP_MAPPING = {
    /[ÄÀÁÂÃÅĀĄĂ]/ => 'A',
    /[âäàãáäåāăąǎǟǡǻȁȃȧẵặ]/ => 'a',
    /[Æ]/ => 'Ae',
    /[æ]/ => 'ae',
    /[ÇĆČĈĊ]/ => 'C',
    /[çćčĉċ]/ => 'c',
    /[ĎĐ]/ => 'D',
    /[ďđ]/ => 'd',
    /[ÈÉÊËĒĘĚĔĖ]/ =>'E',
    /[ëêéèẽēĕėẻȅȇẹȩęḙḛềếễểḕḗệḝ]/ => 'e',
    /[ƒ]/ => 'f',
    /[ĜĞĠĢ]/ => 'G',
    /[ĝğġģ]/ => 'g',
    /[ĤĦ]/ => 'H',
    /[ĥħ]/ => 'h',
    /[ÌÍÎÏĪĨĬĮİ]/ => 'I',
    /[ìíîĩīĭïỉǐịįȉȋḭɨḯ]/ => 'i',
    /[Ĳ]/ => 'IJ',
    /[Ĵ]/ => 'J',
    /[ĵ]/ => 'j',
    /[Ķ]/ => 'K',
    /[ķĸ]/ => 'k',
    /[ŁĽĹĻĿ]/ => 'L',
    /[łľĺļŀ]/ => 'l',
    /[ÑŃŇŅŊ]/ => 'N',
    /[ñńňņŉŋ]/ => 'n',
    /[ÒÓÔÕØŌŐŎÖ]/ => 'O',
    /[òóôõōŏȯöỏőǒȍȏơǫọɵøồốỗổȱȫȭṍṏṑṓờớỡởợǭộǿ]/ => 'o',
    /[Œ]/ => 'OE',
    /[œ]/ => 'oe',
    /[ŔŘŖ]/ =>'R',
    /[ŕřŗ]/ =>'r',
    /[ŚŠŞŜȘ]/ => 'S',
    /[śšşŝș]/ => 's',
    /[ß]/ => 'ss',
    /[ŤŢŦȚ]/ => 'T',
    /[ťţŧț]/ => 't',
    /[ÜÙÚÛŪŮŰŬŨŲ]/ => 'U',
    /[ùúûũūŭüủůűǔȕȗưụṳųṷṵṹṻǖǜǘǖǚừứữửự]/ => 'u',
    /[Ŵ]/ => 'W',
    /[ŵ]/ => 'w',
    /[ỳýŷỹȳẏÿỷẙƴỵ]/ => 'y',
    /[ŹŽŻ]/ =>'Z',
    /[žżź]/ =>'z'
  }
  
  def initialize(s)
    self.cleanified_strings = self.class.to_array(s)
  end
  
  def self.remove_parenthesis(s)
    res = s.gsub(/([\(\[].*[\)\]])/, '')
    res.strip
  end
  
  def self.remove_featuring(s)
    res = s.gsub(/([fF]eat(\.|uring) .*)/, '')
    res.strip
  end
  
  def self.unaccent!(s)
    ASCII_REGEXP_MAPPING.each do |key, value|
      s.gsub! key, value
    end
    s
  end
  
  def self.unaccent(s)
    self.unaccent!(s.dup)
  end
  
  def self.decode_html_entities(s)
    HTMLEntities.new.decode(s)
  end
  
  def self.remove_stop_words(a)
    a - STOP_WORDS
  end
  
  # Cut the string into an array of words
  # Two words separated by a dash (-) should be considered as :
  # 1 word if the first or the second word is only 1 character
  # 2 words otherwise
  def self.to_array(s)
    s = self.clean(s)
    
    arr = s.gsub(/\b(\w{2,})-(\w{2,})\b/, '\1 \2').split.map do |w|
      w.gsub(/[^A-Za-z0-9]/, '').downcase
    end.delete_if do |w|
      w.length < 2 && w !~ /\d/
    end
    
    self.remove_stop_words(arr)
  end
  
  def self.clean(s)
    self.unaccent(
      self.remove_featuring(
        self.remove_parenthesis(
          self.decode_html_entities(s)
        )
      )
    )
  end
  
  def compare(pattern)
    pattern = self.class.to_array(pattern)
    
    size = cleanified_strings.size
    cleanified_strings.delete_if do |word|
      matched_word = pattern.find do |guess|
        if word =~ /\d+/
          guess == word
        else
          if guess.length > 4 and word.length > 4
            Levenshtein.distance(guess, word) <= 2
          elsif guess.length > 2 and word.length > 2
            Levenshtein.distance(guess, word) <= 1
          else
            guess == word
          end
        end
      end
      # only deleting one of the words
      pattern.delete_at(pattern.index(matched_word)) if matched_word
    end
    size != cleanified_strings.size ? cleanified_strings.size == 0 ? :ok : :almost : :ko
  end
  
end