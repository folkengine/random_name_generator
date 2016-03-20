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

    attr_reader :pre, :pre_syllables, :sur_syllables, :mid_syllables

    def initialize(filename)
      @file = File.new(filename)
      @pre_syllables = []
      @sur_syllables = []
      @mid_syllables = []

      refresh
    end

    def compose(syllables)
      @pre = pre_syllables.sample

      # name = determine_middle_syllables(syllables, pre)
      #
      # name << determine_last_syllable(name.last)
      #
      # mid = Array.new(3)
    end

    def determine_middle_syllables(syllables, pre)
      expecting = pre.next_syllable_requirement
    end

    # while (expecting == vowel && vocalFirst(pureSyl(sur.get(c))) == false || expecting == consonant && consonantFirst(pureSyl(sur.get(c))) == false
    # || last == vowel && hatesPreviousVocals(sur.get(c)) || last == consonant && hatesPreviousConsonants(sur.get(c)));
    def determine_next_syllable(this_syllable)
      loop do
        next_syllable = @mid_syllables.sample
        break unless this_syllable.incompatible?(next_syllable)
      end
    end

    def determine_last_syllable(next_to_last_syllable)

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
  end
end

n = FuzzyOctoTrain::NameGenerator.new(FuzzyOctoTrain::ELVEN)
n.compose(3)
