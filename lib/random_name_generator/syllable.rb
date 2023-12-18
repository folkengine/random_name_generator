# frozen_string_literal: true

module RandomNameGenerator
  # Syllable: Class for managing properties of individual syllables with in language name file. Each line within a file
  # translates into a syllable object. The reason behind this class is to take over most of the complexity of parsing each
  # syllable, greatly simplifying the work done by RandomNameGenerator. This code is not meant to be called directly as a
  # part of standard usage.
  #
  # Examples
  #
  #   syllable = Syllable.new('-foo +c')
  #
  # This creates a foo syllable object that needs to be the first syllable and followed by a constant.
  #
  # For testing purposes, passing in another Syllable object will create a clone:
  #
  #   syllable_clone = Syllable.new(syllable)
  #
  # SYLLABLE CLASSIFICATION:
  # Name is usually composed from 3 different class of syllables, which include prefix, middle part and suffix.
  # To declare syllable as a prefix in the file, insert "-" as a first character of the line.
  # To declare syllable as a suffix in the file, insert "+" as a first character of the line.
  # everything else is read as a middle part.
  #
  # NUMBER OF SYLLABLES:
  # Names may have any positive number of syllables. In case of 2 syllables, name will be composed from prefix and suffix.
  # In case of 1 syllable, name will be chosen from amongst the prefixes.
  # In case of 3 and more syllables, name will begin with prefix, is filled with middle parts and ended with suffix.
  #
  # ASSIGNING RULES:
  # I included a way to set 4 kind of rules for every syllable. To add rules to the syllables, write them right after the
  # syllable and SEPARATE WITH WHITESPACE. (example: "aad +v -c"). The order of rules is not important.
  #
  # RULES:
  # 1) +v means that next syllable must definitely start with a vowel.
  # 2) +c means that next syllable must definitely start with a consonant.
  # 3) -v means that this syllable can only be added to another syllable, that ends with a vowel.
  # 4) -c means that this syllable can only be added to another syllable, that ends with a consonant.
  #
  # :reek:TooManyMethods
  # :reek:TooManyInstanceVariables
  class Syllable
    attr_reader :raw, :syllable, :next_syllable_requirement, :previous_syllable_requirement

    VOWELS = %w[i y ɨ ʉ ɯ u ɪ ʏ ʊ ɯ ʊ e ø ɘ ɵ ɤ o ø ə ɵ ɤ o ɛ œ ɜ ɞ ʌ ɔ æ ɐ ɞ a ɶ ä ɒ ɑ].freeze
    CONSONANTS = %w[b ɓ ʙ β c d ɗ ɖ ð f g h j k l ł m ɱ n ɳ p q r s t v w x y z].freeze

    def initialize(args)
      @raw = args.strip
      @syllable = ""
      @is_prefix = false
      @is_suffix = false
      @next_syllable_requirement = :letter
      @previous_syllable_requirement = :letter

      if args.is_a?(Syllable)
        parse_args(args.raw)
      else
        parse_args(args)
      end
    end

    def incompatible?(next_syllable)
      next_incompatible?(next_syllable) || previous_incompatible?(next_syllable)
    end

    def compatible?(next_syllable)
      !incompatible?(next_syllable)
    end

    def prefix?
      @is_prefix
    end

    def suffix?
      @is_suffix
    end

    def consonant_first?
      CONSONANTS.include?(syllable[0])
    end

    def vowel_first?
      VOWELS.include?(syllable[0])
    end

    def consonant_last?
      CONSONANTS.include?(syllable[-1])
    end

    def vowel_last?
      VOWELS.include?(syllable[-1])
    end

    def next_syllable_universal?
      @next_syllable_requirement == :letter
    end

    def next_syllable_must_start_with_vowel?
      @next_syllable_requirement == :vowel
    end

    def next_syllable_must_start_with_consonant?
      @next_syllable_requirement == :consonant
    end

    def previous_syllable_universal?
      @previous_syllable_requirement == :letter
    end

    def previous_syllable_must_end_with_vowel?
      @previous_syllable_requirement == :vowel
    end

    def previous_syllable_must_end_with_consonant?
      @previous_syllable_requirement == :consonant
    end

    def to_s
      @syllable
    end

    def to_str
      @syllable
    end

    private

    # :reek:FeatureEnvy
    def parse_args(args)
      args = args.to_s.strip.downcase.split
      parse_syllable(args[0])
      parse_flags(args[1..-1])
    end

    def parse_syllable(syll)
      raise ArgumentError "Empty String is not allowed." if syll.empty?

      captures = /([+-]?)(.+)/.match(syll).captures
      parse_prefix(captures[0])
      @syllable = captures[1]
    end

    # :reek:ControlParameter
    def parse_prefix(prefix)
      case prefix
      when "-"
        @is_prefix = true
      when "+"
        @is_suffix = true
      end
    end

    def parse_flags(flags)
      if flags.include?("+v")
        @next_syllable_requirement = :vowel
      elsif flags.include?("+c")
        @next_syllable_requirement = :consonant
      end
      if flags.include?("-v")
        @previous_syllable_requirement = :vowel
      elsif flags.include?("-c")
        @previous_syllable_requirement = :consonant
      end
    end

    def next_incompatible?(next_syllable)
      vnc = next_syllable_must_start_with_vowel? && next_syllable.consonant_first?
      cnv = next_syllable_must_start_with_consonant? && next_syllable.vowel_first?

      vnc || cnv
    end

    def previous_incompatible?(next_syllable)
      vlc = vowel_last? && next_syllable.previous_syllable_must_end_with_consonant?
      clv = consonant_last? && next_syllable.previous_syllable_must_end_with_vowel?

      vlc || clv
    end
  end
end
