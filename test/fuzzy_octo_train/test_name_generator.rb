require 'fuzzy_octo_train'
require_relative '../test_helper'

include FuzzyOctoTrain

class TestNameGenerator < Minitest::Test
  def test_compose
    fuzz = NameGenerator.new(NameGenerator::ELVEN)
    fuzz.pre_syllables.stubs(:sample).returns(Syllable.new('foo')).returns(Syllable.new('bar'))
    fuzz.compose(3)

    assert_equal('foo', fuzz.pre.to_s)
    fuzz.compose(3)
    assert_equal('bar', fuzz.pre.to_s)
  end

  def test_determine_next_syllable
    fuzz = NameGenerator.new(NameGenerator::ELVEN)
    fuzz.mid_syllables.stubs(:sample).returns(Syllable.new('oh')).returns(Syllable.new('bar'))
    next_syllable = fuzz.determine_next_syllable(Syllable.new('foo +c'), fuzz.mid_syllables)
    assert_equal('bar', next_syllable.to_s)
  end
end
