# frozen_string_literal: true

require 'random_name_generator/rng_syllable'
require_relative '../test_helper'

class TestRngSyllable < Minitest::Test
  def test_prefix_returns_true_if_marked
    ['-an', '-ang +v', '  -ansr +v', '-cael   ', '-dae +c'].each do |s|
      assert RNGSyllable.new(s).prefix?, "GeneratorSyllable.new('#{s}').prefix? returns false"
    end
  end

  def test_prefix_returns_false_if_not_marked
    ['que -v +c', 'ria', 'rail', 'ther', 'thus', 'thi', 'san', '+ael -c'].each do |s|
      refute RNGSyllable.new(s).prefix?, "GeneratorSyllable.new('#{s}').prefix? returns true"
    end
  end

  def test_suffix_returns_true_if_marked
    ['+ath', '+ess', '+san', '+yth', '+las', '+lian', '+evar'].each do |s|
      assert RNGSyllable.new(s).suffix?, "GeneratorSyllable.new('#{s}').is_suffix? returns false"
    end
  end

  def test_suffix_returns_false_if_not_marked
    ['-que -v +c', 'ria', 'rail', 'ther', 'thus', 'thi', 'san', 'ael -c'].each do |s|
      refute RNGSyllable.new(s).suffix?, "GeneratorSyllable.new('#{s}').is_suffix? returns true"
    end
  end

  def test_next_syllable_must_start_with_vowel_returns_true_if_marked
    ['-ang +v', '-ansr +v -c'].each do |s|
      assert RNGSyllable.new(s).next_syllable_must_start_with_vowel?,
             "GeneratorSyllable.new('#{s}').next_syllable_must_start_with_vowel? returns false"
    end
  end

  def test_next_syllable_must_start_with_vowel_returns_false_if_not_marked
    ['-ang -v', '-ansr -v +c', '-yada'].each do |s|
      refute RNGSyllable.new(s).next_syllable_must_start_with_vowel?,
             "GeneratorSyllable.new('#{s}').next_syllable_must_start_with_vowel? returns true"
    end
  end

  def test_next_syllable_must_start_with_consonant_returns_true_if_marked
    ['-ang +c', '-ansr -v +c'].each do |s|
      assert RNGSyllable.new(s).next_syllable_must_start_with_consonant?
    end
  end

  def test_next_syllable_must_start_with_consonant_returns_false_if_not_marked
    ['-ang -v', '-ansr -v -c', '-yada'].each do |s|
      refute RNGSyllable.new(s).next_syllable_must_start_with_consonant?
    end
  end

  def test_previous_syllable_must_end_with_vowel_returns_true_if_marked
    ['-ang -v', '-ansr -v +c'].each do |s|
      assert RNGSyllable.new(s).previous_syllable_must_end_with_vowel?,
             "'#{s}'.previous_syllable_must_end_with_vowel? returns false"
    end
  end

  def test_previous_syllable_must_end_with_vowel_returns_false_if_not_marked
    ['-ang +v', '-ansr +v -c', '-yada'].each do |s|
      refute RNGSyllable.new(s).previous_syllable_must_end_with_vowel?
    end
  end

  def test_previous_syllable_must_end_with_consonant_returns_true_if_marked
    ['-ang -c', '-ansr +v -c'].each do |s|
      assert RNGSyllable.new(s).previous_syllable_must_end_with_consonant?
    end
  end

  def test_previous_syllable_must_end_with_consonant_returns_false_if_not_marked
    ['-ang +v', '-ansr -v +c', '-yada'].each do |s|
      refute RNGSyllable.new(s).previous_syllable_must_end_with_consonant?
    end
  end

  def test_consonant_first_returns_true_if_marked
    ['-ng -c', '-sr +v -c', '-yada'].each do |s|
      assert RNGSyllable.new(s).consonant_first?
    end
  end

  def test_consonant_first_returns_false_if_not_marked
    ['-ang +v', '-ansr -v +c'].each do |s|
      refute RNGSyllable.new(s).consonant_first?
    end
  end

  def test_vowel_first_returns_true_if_marked
    ['-ang +v', '-ansr -v +c', '-yada'].each do |s|
      assert RNGSyllable.new(s).vowel_first?
    end
  end

  def test_vowel_first_returns_false_if_not_marked
    ['-ng -c', '-sr +v -c'].each do |s|
      refute RNGSyllable.new(s).vowel_first?
    end
  end

  def test_consonant_last_returns_true_if_marked
    ['-ng -c', '-sr +v -c', '-ansr'].each do |s|
      assert RNGSyllable.new(s).consonant_last?
    end
  end

  def test_consonant_last_returns_false_if_not_marked
    ['-yada', 'ria', 'thi'].each do |s|
      refute RNGSyllable.new(s).consonant_last?
    end
  end

  def test_vowel_last_returns_true_if_marked
    ['-yada', 'ria', 'thi'].each do |s|
      assert RNGSyllable.new(s).vowel_last?, "GeneratorSyllable.new('#{s}').vowel_last? returns false"
    end
  end

  def test_vowel_last_returns_false_if_not_marked
    ['-kan', '+emar', '+nes', '+nin', 'dul', 'ean -c', 'el', 'emar'].each do |s|
      refute RNGSyllable.new(s).vowel_last?, "GeneratorSyllable.new('#{s}').vowel_last? returns true"
    end
  end
end

describe RNGSyllable do
  describe 'considering compatible?' do
    describe 'when compatible' do
      [['yada', 'ria'], ['ae +c -c', 'lean -c'], ['lean -c', 'ae +c -c']].each do |a_b|
        before do
          @before = RNGSyllable.new(a_b[0])
          @after = RNGSyllable.new(a_b[1])
        end

        it 'incompatible? must return false if compatible' do
          refute(@before.incompatible?(@after), "GeneratorSyllable.new(#{@before}).incompatible?(#{@after}) returns true")
        end

        it 'compatible? must return true if compatible' do
          assert(@before.compatible?(@after), "GeneratorSyllable.new(#{@before}).compatible?(#{@after}) returns false")
        end
      end
    end

    describe 'when incompatible' do
      [['ria', 'lean -c'], ['at', 'la -v'], ['rail', 'que -v +c'], ['ae +c -c', 'ael -c'], ['ria', 'ael -c']].each do |a_b|
        before do
          @before = RNGSyllable.new(a_b[0])
          @after = RNGSyllable.new(a_b[1])
        end

        it 'incompatible? must return true if incompatible' do
          assert(@before.incompatible?(@after), "GeneratorSyllable.new(#{@before}).incompatible?(#{@after}) returns false")
        end

        it 'compatible? must return false if incompatible' do
          refute(@before.compatible?(@after), "GeneratorSyllable.new(#{@before}).compatible?(#{@after}) returns true")
        end
      end
    end
  end
end
