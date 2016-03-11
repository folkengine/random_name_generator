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
      @pre_syllables = []
      @sur_syllables = []
      @mid_syllables = []
      refresh
    end

    def compose(syllables)
      pre = @pre_syllables.sample
      expecting = determine_expecting(pre)
    end

    def refresh
      @file.readlines.each do |line|
        syllable = Syllable.new(line) unless line.empty?
        if syllable.prefix?
          @pre_syllables.push(syllable)
        elsif syllable.suffix?
          @sur_syllables.push(syllable)
        else
          @mid_syllables.push(syllable)
        end
      end
    end

    def to_s
      "NameGenerator (#{@file.path})"
    end

    private

    def determine_expecting(syllable)
      expecting = 0
      if pre.next_syllable_must_start_with_vowel?
        expecting = 1
      elsif pre.next_syllable_must_start_with_consonant?
        expecting = 2
      end
      expecting
    end
  end
end
