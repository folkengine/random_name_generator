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
# 1) +v means that next syllable must definitely start with a vocal.
# 2) +c means that next syllable must definitely start with a consonant.
# 3) -v means that this syllable can only be added to another syllable, that ends with a vocal.
# 4) -c means that this syllable can only be added to another syllable, that ends with a consonant.
module FuzzyOctoTrain
  class Syllable
    attr_reader :raw, :syllable, :next_syllable_requirement, :previous_syllable_requirement

    VOWELS = %w(i y ɨ ʉ ɯ u ɪ ʏ ʊ ɯ ʊ e ø ɘ ɵ ɤ o ø ə ɵ ɤ o ɛ œ ɜ ɞ ʌ ɔ æ ɐ ɞ a ɶ ä ɒ ɑ)
    CONSONANTS = %w(b ɓ ʙ β c d ɗ ɖ ð f g h j k l ł m ɱ n ɳ p q r s t v w x y z)

    def initialize(args)
      if args.is_a?(Syllable) then
        and_so_it_begins(args.raw)
      else
        and_so_it_begins(args)
      end
    end

    def incompatible?(next_syllable)
      a = (next_syllable_must_start_with_vowel? && next_syllable.consonant_first?)
      b = (next_syllable_must_start_with_consonant? && next_syllable.vowel_first?)
      c = (vowel_last? && next_syllable.previous_syllable_must_end_with_consonant?)
      d = (consonant_last? && next_syllable.previous_syllable_must_end_with_vowel?)

      (a || b || c  || d)
    end

    def compatible?(next_syllable)
      incompatible = incompatible?(next_syllable)
      ! incompatible
    end

    def self.u_u?(a_link, b_link)
      (a_link.next_syllable_universal? && b_link.previous_syllable_universal?)
    end

    # while (expecting == 1 && vocalFirst(pureSyl(mid.get(b[i]))) == false || expecting == 2 && consonantFirst(pureSyl(mid.get(b[i]))) == false
    # || last == 1 && hatesPreviousVocals(mid.get(b[i])) || last == 2 && hatesPreviousConsonants(mid.get(b[i])));
    #
    # while (expecting == vowel && vocalFirst(pureSyl(sur.get(c))) == false || expecting == consonant && consonantFirst(pureSyl(sur.get(c))) == false
    # || last == vowel && hatesPreviousVocals(sur.get(c)) || last == consonant && hatesPreviousConsonants(sur.get(c)));
    def compatible_behind?(previous_syllable)
      (previous_syllable.next_syllable_universal? ||
        (previous_syllable.next_syllable_must_start_with_vowel? && self.vowel_first?) ||
          (previous_syllable.next_syllable_must_start_with_consonant? && self.consonant_first?))
    end

    def compatible_in_front?(next_syllable)
      (next_syllable.next_syllable_universal? ||
          (next_syllable.next_syllable_must_start_with_vowel? && self.vowel_first?) ||
          (next_syllable.next_syllable_must_start_with_consonant? && self.consonant_first?))
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

    def and_so_it_begins(raw)
      @raw = raw

      @is_prefix = false
      @is_suffix = false
      @next_syllable_requirement = :letter
      @previous_syllable_requirement = :letter

      args = raw.to_s.strip.split(' ')
      parse_syllable(args[0])
      parse_flags(args[1..-1])
    end

    def parse_syllable(syll)
      if (syll.nil? || syll.empty?)
        raise ArgumentError.new('Empty String is not allowed.')
      end
      captures = /([+-]?)(.+)/.match(syll).captures
      parse_prefix(captures[0])
      @syllable = captures[1]
    end

    def parse_prefix(prefix)
      if prefix.eql?('-')
        @is_prefix = true
      elsif prefix.eql?('+')
        @is_suffix = true
      end
    end

    def parse_flags(flags)
      if flags.include?('+v')
        @next_syllable_requirement = :vowel
      elsif flags.include?('+c')
        @next_syllable_requirement = :consonant
      end
      if flags.include?('-v')
        @previous_syllable_requirement = :vowel
      elsif flags.include?('-c')
        @previous_syllable_requirement = :consonant
      end
    end
  end
end
