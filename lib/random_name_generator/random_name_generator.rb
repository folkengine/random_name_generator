require_relative 'rng_syllable'

# RandomNameGenerator:
#
# Examples
#
#   rng = RandomNameGenerator.new(RandomNameGenerator::GOBLIN)
#   puts rng.compose(3)
#
# By default RandomNameGenerator uses the Fantasy syllable file and creates a name with between 2 and 5 syllables.
#
#   rng = RandomNameGenerator.new
#   puts rng.compose
#
class RandomNameGenerator
  dirname = File.dirname(__FILE__)

  ELVEN = File.new("#{dirname}/languages/elven.txt")
  FANTASY = File.new("#{dirname}/languages/fantasy.txt")
  GOBLIN = File.new("#{dirname}/languages/goblin.txt")
  ROMAN = File.new("#{dirname}/languages/roman.txt")

  attr_reader :pre, :pre_syllables, :sur_syllables, :mid_syllables

  def initialize(filename = RandomNameGenerator::FANTASY, random: Random.new)
    @file = File.new(filename)
    @rnd = random
    @pre_syllables = []
    @sur_syllables = []
    @mid_syllables = []

    refresh
  end

  # Public: Static factory method that instantiates a RandomNameGenerator in a random language.
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

  def self.pick_number_of_syllables
    [2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 5].sample
  end

  def to_s
    "RandomNameGenerator (#{@file.path})"
  end

  private

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
      next_syllable = sampler.sample(random: @rnd)
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
end
