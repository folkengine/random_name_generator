$LOAD_PATH << File.dirname(__FILE__)

require 'fuzzy_octo_train/syllable'
require 'fuzzy_octo_train/version'

module FuzzyOctoTrain
  dirname = File.dirname(__FILE__)

  ELVEN = File.new("#{dirname}/languages/elven.txt")
  FANTASY = File.new("#{dirname}/languages/fantasy.txt")
  GOBLIN = File.new("#{dirname}/languages/goblin.txt")
  ROMAN = File.new("#{dirname}/languages/roman.txt")

  class NameGenerator
    def initialize(filename)
      @file = File.new(filename)
      @pre = []
      @sur = []
      @mid = []
      refresh
    end

    def compose(syllables, seed = nil)

    end

    def refresh
      @file.readlines.each do |line|
        syllable = Syllable.new(line) unless line.empty?
        if syllable.prefix?
          @pre.push(syllable)
        elsif syllable.suffix?
          @sur.push(syllable)
        else
          @mid.push(syllable)
        end
      end
    end

    def to_s
      'NameGenerator'
    end
  end
end
