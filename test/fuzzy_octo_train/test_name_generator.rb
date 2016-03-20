require 'fuzzy_octo_train'
require_relative '../test_helper'

include FuzzyOctoTrain

class TestNameGenerator < Minitest::Test

  def test_compose

    fuzz = NameGenerator.new(NameGenerator::ELVEN)
    fuzz.pre_syllables.stubs(:sample).returns('foo').returns('bar')
    fuzz.compose(3)

    assert_equal('foo', fuzz.pre)
    fuzz.compose(3)
    assert_equal('bar', fuzz.pre)
  end


end