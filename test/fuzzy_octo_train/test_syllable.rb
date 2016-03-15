require 'fuzzy_octo_train/syllable'

require_relative '../test_helper'

include FuzzyOctoTrain

describe Syllable do
  # describe 'considering prefix?' do
  #   describe 'when marked as a prefix' do
  #     ['-an', '-ang +v', '  -ansr +v', '-cael   ', '-dae +c'].each do |s|
  #       it 'is_prefix? must return true' do
  #         assert(Syllable.new(s).prefix?, "Syllable.new('#{s}').prefix? returns false")
  #       end
  #     end
  #   end
  #   describe 'when not marked as a prefix' do
  #     ['que -v +c', 'ria', 'rail', 'ther', 'thus', 'thi', 'san', '+ael -c'].each do |s|
  #       it 'is_prefix? must return false' do
  #         refute(Syllable.new(s).prefix?, "Syllable.new('#{s}').prefix? returns true")
  #       end
  #     end
  #   end
  # end
  #
  # describe 'considering suffix?' do
  #   describe 'when marked as a suffix' do
  #     ['+ath', '+ess', '+san', '+yth', '+las', '+lian', '+evar'].each do |s|
  #       it 'is_suffix? must return true' do
  #         assert(Syllable.new(s).suffix?, "Syllable.new('#{s}').is_suffix? returns false")
  #       end
  #     end
  #   end
  #
  #   describe 'when not marked as a suffix' do
  #     ['-que -v +c', 'ria', 'rail', 'ther', 'thus', 'thi', 'san', 'ael -c'].each do |s|
  #       it 'is_suffix? must return false' do
  #         refute(Syllable.new(s).suffix?, "Syllable.new('#{s}').is_suffix? returns true")
  #       end
  #     end
  #   end
  # end
  #
  # describe 'considering next_syllable_must_start_with_vowel?' do
  #   describe 'when marked true (+v)' do
  #     ['-ang +v', '-ansr +v -c'].each do |s|
  #       it 'next_syllable_must_start_with_vowel? must return true' do
  #         assert(Syllable.new(s).next_syllable_must_start_with_vowel?,
  #                "Syllable.new('#{s}').next_syllable_must_start_with_vowel? returns false")
  #       end
  #     end
  #   end
  #   describe 'when marked false' do
  #     ['-ang -v', '-ansr -v +c', '-yada'].each do |s|
  #       it 'next_syllable_must_start_with_vowel? must return false' do
  #         refute(Syllable.new(s).next_syllable_must_start_with_vowel?,
  #                "Syllable.new('#{s}').next_syllable_must_start_with_vowel? returns true")
  #       end
  #     end
  #   end
  # end
  #
  # describe 'considering next_syllable_must_start_with_consonant?' do
  #   describe 'when marked true (+c)' do
  #     ['-ang +c', '-ansr -v +c'].each do |s|
  #       it 'next_syllable_must_start_with_consonant? must return true' do
  #         assert Syllable.new(s).next_syllable_must_start_with_consonant?
  #       end
  #     end
  #   end
  #   describe 'when marked false' do
  #     ['-ang -v', '-ansr -v -c', '-yada'].each do |s|
  #       it 'next_syllable_must_start_with_consonant? must return false' do
  #         refute Syllable.new(s).next_syllable_must_start_with_consonant?
  #       end
  #     end
  #   end
  # end
  #
  # describe 'considering previous_syllable_must_end_with_vowel?' do
  #   describe 'when marked true (-v)' do
  #     ['-ang -v', '-ansr -v +c'].each do |s|
  #       it 'previous_syllable_must_end_with_vowel? must return true' do
  #         assert Syllable.new(s).previous_syllable_must_end_with_vowel?
  #       end
  #     end
  #   end
  #   describe 'when marked false' do
  #     ['-ang +v', '-ansr +v -c', '-yada'].each do |s|
  #       it 'previous_syllable_must_end_with_vowel? must return false' do
  #         refute Syllable.new(s).previous_syllable_must_end_with_vowel?
  #       end
  #     end
  #   end
  # end
  #
  # describe 'considering previous_syllable_must_end_with_consonant?' do
  #   describe 'when marked true (-v)' do
  #     ['-ang -c', '-ansr +v -c'].each do |s|
  #       it 'previous_syllable_must_end_with_consonant? must return true' do
  #         assert Syllable.new(s).previous_syllable_must_end_with_consonant?
  #       end
  #     end
  #   end
  #   describe 'when marked false' do
  #     ['-ang +v', '-ansr -v +c', '-yada'].each do |s|
  #       it 'previous_syllable_must_end_with_consonant? must return false' do
  #         refute Syllable.new(s).previous_syllable_must_end_with_consonant?
  #       end
  #     end
  #   end
  # end
  #
  # describe 'considering consonant_first?' do
  #   describe 'when syllable starts with a consonant' do
  #     ['-ng -c', '-sr +v -c', '-yada'].each do |s|
  #       it 'consonant_first? must return true' do
  #         assert Syllable.new(s).consonant_first?
  #       end
  #     end
  #   end
  #   describe 'when syllable starts with a vowel' do
  #     ['-ang +v', '-ansr -v +c'].each do |s|
  #       it 'consonant_first? must return false' do
  #         refute Syllable.new(s).consonant_first?
  #       end
  #     end
  #   end
  # end
  #
  # describe 'considering vowel_first?' do
  #   describe 'when syllable starts with a vowel' do
  #     ['-ang +v', '-ansr -v +c', '-yada'].each do |s|
  #       it 'vowel_first? must return true' do
  #         assert(Syllable.new(s).vowel_first?)
  #       end
  #     end
  #   end
  #   describe 'when syllable starts with a consonant' do
  #     ['-ng -c', '-sr +v -c'].each do |s|
  #       it 'vowel_first? must return false' do
  #         refute(Syllable.new(s).vowel_first?)
  #       end
  #     end
  #   end
  # end
  #
  # describe 'considering consonant_last?' do
  #   describe 'when syllable ends with a consonant' do
  #     ['-ng -c', '-sr +v -c', '-ansr'].each do |s|
  #       it 'consonant_last? must return true' do
  #         assert(Syllable.new(s).consonant_last?)
  #       end
  #     end
  #   end
  #   describe 'when syllable ends with a vowel' do
  #     ['-yada', 'ria', 'thi'].each do |s|
  #       it 'consonant_last? must return false' do
  #         refute(Syllable.new(s).consonant_last?)
  #       end
  #     end
  #   end
  # end
  #
  # describe 'considering vowel_last?' do
  #   describe 'when syllable starts with a vowel' do
  #     ['-yada', 'ria', 'thi'].each do |s|
  #       it 'vowel_last? must return true' do
  #         assert(Syllable.new(s).vowel_last?, "Syllable.new('#{s}').vowel_last? returns false")
  #       end
  #     end
  #   end
  #   describe 'when syllable starts with a consonant' do
  #     ['-kan', '+emar', '+nes', '+nin', 'dul', 'ean -c', 'el', 'emar'].each do |s|
  #       it 'vowel_last? must return false' do
  #         refute(Syllable.new(s).vowel_last?, "Syllable.new('#{s}').vowel_last? returns true")
  #       end
  #     end
  #   end
  # end

  describe 'considering compatible?' do
    # describe 'when compatible' do
    #   [['yada', 'ria']].each do |a_b|
    #
    #     before do
    #       @before = Syllable.new(a_b[0])
    #       @after = Syllable.new(a_b[1])
    #     end
    #
    #     it 'incompatible? must return false if compatible' do
    #       refute(@before.incompatible?(@after), "Syllable.new(#{@before}).incompatible?(#{@after}) returns true")
    #     end
    #
    #     it 'compatible? must return true if compatible' do
    #       assert(@before.compatible?(@after), "Syllable.new(#{@before}).compatible?(#{@after}) returns false")
    #     end
    #
    #     # it 'u_u? must return false if not compatible' do
    #     #   refute(Syllable.u_u?(Syllable.new('foo +v'), Syllable.new('ai')), "Syllable.u_u?('#{@before}, #{@after}') returns false")
    #     # end
    #     #
    #     # it 'compatible? must return true if compatible' do
    #     #   assert(Syllable.compatible?(@before, @after), "Syllable.compatible?('#{@before}, #{@after}') returns false")
    #     # end
    #     #
    #     # it 'compatible? must return false if not compatible' do
    #     #   refute(Syllable.compatible?(Syllable.new('foo +v'), Syllable.new('ai')), "Syllable.compatible?('#{@before}, #{@after}') returns false")
    #     # end
    #   end
    # end

    describe 'when incompatible' do
      [['ria', 'lean -c'], ['at', 'la -v']].each do |a_b|

        before do
          @before = Syllable.new(a_b[0])
          @after = Syllable.new(a_b[1])
        end

        it 'incompatible? must return true if incompatible' do

          # refute((@before.next_syllable_must_start_with_vowel? && @after.consonant_first?),
          #        "#{@before.next_syllable_must_start_with_vowel?} && #{@after.consonant_first?}")
          # refute((@before.next_syllable_must_start_with_consonant? && @after.vowel_first?),
          #        "#{@before.next_syllable_must_start_with_consonant?} && #{@after.vowel_first?}")
          # refute((@before.vowel_last? && @after.previous_syllable_must_end_with_consonant?),
          #        "#{@before.vowel_last?} && #{@after.previous_syllable_must_end_with_consonant?}")
          # refute(@before.consonant_last? && @after.previous_syllable_must_end_with_vowel?)

          assert(@before.incompatible?(@after), "Syllable.new(#{@before}).incompatible?(#{@after}) returns false")
        end

        it 'compatible? must return false if incompatible' do
          # refute((@before.next_syllable_must_start_with_vowel? && @after.consonant_first?),
          #        "#{@before.next_syllable_must_start_with_vowel?} && #{@after.consonant_first?}")
          # refute((@before.next_syllable_must_start_with_consonant? && @after.vowel_first?),
          #        "#{@before.next_syllable_must_start_with_consonant?} && #{@after.vowel_first?}")
          # assert((@before.vowel_last? && @after.previous_syllable_must_end_with_consonant?),
          #        "#{@before.vowel_last?} && #{@after.previous_syllable_must_end_with_consonant?}")
          # refute((@before.consonant_last? && @after.previous_syllable_must_end_with_vowel?),
          #        "#{@before.consonant_last?} && #{@after.previous_syllable_must_end_with_vowel?}")

          refute(@before.compatible?(@after), "Syllable.new(#{@before}).compatible?(#{@after}) returns true")
        end
      end
    end
  end
end
