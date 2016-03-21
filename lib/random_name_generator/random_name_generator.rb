require_relative 'rng_syllable'

class RandomNameGenerator
  dirname = File.dirname(__FILE__)

  ELVEN = File.new("#{dirname}/languages/elven.txt")
  FANTASY = File.new("#{dirname}/languages/fantasy.txt")
  GOBLIN = File.new("#{dirname}/languages/goblin.txt")
  ROMAN = File.new("#{dirname}/languages/roman.txt")

  attr_reader :pre, :pre_syllables, :sur_syllables, :mid_syllables

  def initialize(filename = RandomNameGenerator::FANTASY)
    @file = File.new(filename)
    @pre_syllables = []
    @sur_syllables = []
    @mid_syllables = []

    refresh
  end

  def self.flip_mode
    langs = [RandomNameGenerator::FANTASY,
             RandomNameGenerator::ELVEN,
             RandomNameGenerator::GOBLIN,
             RandomNameGenerator::ROMAN]
    new(langs.sample)
  end

  def compose(count = RandomNameGenerator.pick_number_of_syllables)
    @pre = pre_syllables.sample
    return @pre.to_s.capitalize if count < 2

    name = determine_middle_syllables(count - 2, pre)
    name << determine_last_syllable(name.last)
    name.map(&:to_s).join.capitalize
  end

  def determine_middle_syllables(count, pre)
    determine_next_syllables(count, pre, @mid_syllables)
  end

  def determine_last_syllable(next_to_last_syllable)
    determine_next_syllable(next_to_last_syllable, @sur_syllables)
  end

  def determine_next_syllables(count, pre, syllables)
    name = Array(pre)
    return name if count < 1
    next_syllable = pre
    count.times do
      next_syllable = determine_next_syllable(next_syllable, syllables)
      name << next_syllable
    end
    name
  end

  def determine_next_syllable(this_syllable, sampler)
    next_syllable = ''
    loop do
      next_syllable = sampler.sample
      break unless this_syllable.incompatible?(next_syllable)
    end
    next_syllable
  end

  def refresh
    @file.readlines.each do |line|
      syllable = RNGSyllable.new(line) unless line.empty?
      if syllable.prefix?
        @pre_syllables.push(syllable)
      elsif syllable.suffix?
        @sur_syllables.push(syllable)
      else
        @mid_syllables.push(syllable)
      end
    end
  end

  def self.pick_number_of_syllables
    [2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 5].sample
  end

  def to_s
    "NameGenerator (#{@file.path})"
  end
end
