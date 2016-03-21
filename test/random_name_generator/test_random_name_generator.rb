require 'random_name_generator'
require_relative '../test_helper'

class TestRandomNameGenerator < Minitest::Test
  def test_compose
    fuzz = RandomNameGenerator.new(RandomNameGenerator::ELVEN)
    fuzz.pre_syllables.stubs(:sample).returns(RNGSyllable.new('foo')).returns(RNGSyllable.new('bar'))
    fuzz.compose(3)

    assert_equal('foo', fuzz.pre.to_s)
    fuzz.compose(3)
    assert_equal('bar', fuzz.pre.to_s)
  end

  def test_determine_next_syllable
    fuzz = RandomNameGenerator.new(RandomNameGenerator::ELVEN)
    fuzz.mid_syllables.stubs(:sample).returns(RNGSyllable.new('oh')).returns(RNGSyllable.new('bar'))
    next_syllable = fuzz.determine_next_syllable(RNGSyllable.new('foo +c'), fuzz.mid_syllables)
    assert_equal('bar', next_syllable.to_s)
  end

  def test_default_lang
    fuzz = RandomNameGenerator.new
    refute_empty fuzz.compose
  end

  def test_elven
    fuzz = RandomNameGenerator.new(RandomNameGenerator::ELVEN)
    refute_empty fuzz.compose
  end

  def test_fantasy
    fuzz = RandomNameGenerator.new(RandomNameGenerator::FANTASY)
    refute_empty fuzz.compose
  end

  def test_goblin
    fuzz = RandomNameGenerator.new(RandomNameGenerator::GOBLIN)
    refute_empty fuzz.compose
  end

  def test_roman
    fuzz = RandomNameGenerator.new(RandomNameGenerator::ROMAN)
    refute_empty fuzz.compose
  end
end
