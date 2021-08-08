# frozen_string_literal: true

RSpec.describe RandomNameGenerator::Syllable do
  context "flags" do
    context "prefix?" do
      ["-an", "-ang +v", "  -ansr +v", "-cael   ", "-dae +c"].each do |s|
        it "returns true when '#{s}' is marked as a prefix" do
          expect(RandomNameGenerator::Syllable.new(s).prefix?).to be true
        end
      end

      ["que -v +c", "ria", "rail", "ther", "thus", "thi", "san", "+ael -c"].each do |s|
        it "returns false when '#{s}' is marked as a prefix" do
          expect(RandomNameGenerator::Syllable.new(s).prefix?).to be false
        end
      end
    end

    context "suffix?" do
      ["+ath", " +ess", "+san", "+yth  ", "+las", "+lian", "+evar"].each do |s|
        it "returns true when '#{s}' is marked as a suffix" do
          expect(RandomNameGenerator::Syllable.new(s).suffix?).to be true
        end
      end

      ["-que -v +c", "ria", "rail", "ther", "thus", "thi", "san", "ael -c"].each do |s|
        it "returns false when '#{s}' is marked as a suffix" do
          expect(RandomNameGenerator::Syllable.new(s).suffix?).to be false
        end
      end
    end

    context "next_syllable_must_start_with_vowel?" do
      ["-ang +v", "-ansr +v -c"].each do |s|
        it "returns true when '#{s}' syllable has a +v must start with a vowel flag" do
          expect(RandomNameGenerator::Syllable.new(s).next_syllable_must_start_with_vowel?).to be true
        end
      end

      ["-ang -v", "-ansr -v +c", "-yada"].each do |s|
        it "returns false when '#{s}' syllable does not have a +v must start with a vowel flag" do
          expect(RandomNameGenerator::Syllable.new(s).next_syllable_must_start_with_vowel?).to be false
        end
      end
    end

    context "next_syllable_must_start_with_consonant?" do
      ["-ang +c", "-ansr -v +c"].each do |s|
        it "returns true when '#{s}' syllable has a +c must start with a consonant flag" do
          expect(RandomNameGenerator::Syllable.new(s).next_syllable_must_start_with_consonant?).to be true
        end
      end

      ["-ang -v", "-ansr -v -c", "-yada"].each do |s|
        it "returns false when '#{s}' syllable does not have a +c next must start with a consonant flag" do
          expect(RandomNameGenerator::Syllable.new(s).next_syllable_must_start_with_consonant?).to be false
        end
      end
    end

    context "previous_syllable_must_end_with_vowel?" do
      ["-ang -v", "-ansr -v +c"].each do |s|
        it "returns true when '#{s}' syllable has a -v flag" do
          expect(RandomNameGenerator::Syllable.new(s).previous_syllable_must_end_with_vowel?).to be true
        end
      end

      ["-ang +v", "-ansr +v -c", "-yada"].each do |s|
        it "returns false when '#{s}' syllable does not have a -v flag" do
          expect(RandomNameGenerator::Syllable.new(s).previous_syllable_must_end_with_vowel?).to be false
        end
      end
    end

    context "previous_syllable_must_end_with_consonant?" do
      ["-ang -c", "-ansr +v -c"].each do |s|
        it "returns true when '#{s}' syllable has a -c flag" do
          expect(RandomNameGenerator::Syllable.new(s).previous_syllable_must_end_with_consonant?).to be true
        end
      end

      ["-ang +v", "-ansr -v +c", "-yada"].each do |s|
        it "returns false when '#{s}' syllable has not have a -c flag" do
          expect(RandomNameGenerator::Syllable.new(s).previous_syllable_must_end_with_consonant?).to be false
        end
      end
    end

    context "consonant_first?" do
      ["-ng -c", "-sr +v -c", "-yada"].each do |s|
        it "returns true when '#{s}' starts with a consonant" do
          expect(RandomNameGenerator::Syllable.new(s).consonant_first?).to be true
        end
      end

      ["-ang +v", "-ansr -v +c"].each do |s|
        it "returns false when '#{s}' starts with a vowel" do
          expect(RandomNameGenerator::Syllable.new(s).consonant_first?).to be false
        end
      end
    end

    context "vowel_first?" do
      ["-ang +v", "-ansr -v +c", "-yada"].each do |s|
        it "returns true when '#{s} starts with a vowel" do
          expect(RandomNameGenerator::Syllable.new(s).vowel_first?).to be true
        end
      end

      ["-ng -c", "-sr +v -c"].each do |s|
        it "returns false when '#{s}' starts with a consonant" do
          expect(RandomNameGenerator::Syllable.new(s).vowel_first?).to be false
        end
      end
    end

    context "consonant_last?" do
      ["-ng -c", "-sr +v -c", "-ansr"].each do |s|
        it "returns true when '#{s}' ends with a consonant" do
          expect(RandomNameGenerator::Syllable.new(s).consonant_last?).to be true
        end
      end

      ["-yada", "ria -c", "thi"].each do |s|
        it "returns false when '#{s}' ends with a vowel" do
          expect(RandomNameGenerator::Syllable.new(s).consonant_last?).to be false
        end
      end
    end

    context "vowel_last?" do
      ["-yada", "ria +c", "thi"].each do |s|
        it "returns true when '#{s}' ends with a vowel" do
          expect(RandomNameGenerator::Syllable.new(s).vowel_last?).to be true
        end
      end

      ["-kan", "+emar", "+nes", "+nin", "dul", "ean -c", "el", "emar"].each do |s|
        it "returns false when '#{s}' ends with a consonant" do
          expect(RandomNameGenerator::Syllable.new(s).vowel_last?).to be false
        end
      end
    end
  end

  context "compatibility" do
    context "initialize" do
      it "strips the syllable" do
        expect(RandomNameGenerator::Syllable.new(" a  \n").syllable).to eq("a")
      end

      it "strips the raw value" do
        expect(RandomNameGenerator::Syllable.new(" a -c +v \n").raw).to eq("a -c +v")
      end

      it "preserves the values if they don't need to be stripped" do
        expect(RandomNameGenerator::Syllable.new("a").syllable).to eq("a")
        expect(RandomNameGenerator::Syllable.new("a -c +v").raw).to eq("a -c +v")
      end
    end

    context "when compatible" do
      [%w[yada ria], ["ae +c -c", "lean"], ["lean -c", "ae +c -c"]].each do |a_b|
        it "incompatible? must return false between #{a_b[0]} and #{a_b[1]}" do
          from = RandomNameGenerator::Syllable.new(a_b[0])
          to = RandomNameGenerator::Syllable.new(a_b[1])
          expect(from.incompatible?(to)).to be false
        end

        it "compatible? must return true between #{a_b[0]} and #{a_b[1]}" do
          from = RandomNameGenerator::Syllable.new(a_b[0])
          to = RandomNameGenerator::Syllable.new(a_b[1])
          expect(from.compatible?(to)).to be true
        end
      end

      context "when incompatible" do
        [["ria", "lean -c"], ["ae +c -c", "lean -c"], ["at", "la -v"], ["rail", "que -v +c"], ["ae +c -c", "ael -c"], ["ria", "ael -c"]].each do |a_b|
          it "incompatible? must return true between #{a_b[0]} and #{a_b[1]}" do
            from = RandomNameGenerator::Syllable.new(a_b[0])
            to = RandomNameGenerator::Syllable.new(a_b[1])
            expect(from.incompatible?(to)).to be true
          end

          it "compatible? must return false between #{a_b[0]} and #{a_b[1]}" do
            from = RandomNameGenerator::Syllable.new(a_b[0])
            to = RandomNameGenerator::Syllable.new(a_b[1])
            expect(from.compatible?(to)).to be false
          end
        end
      end
    end
  end

  context "as_json" do
    it "should return a single JSON entity for the syllable" do
      expect(RandomNameGenerator::Syllable.new(" a -c +v \n").as_json).to eq("{\"syllable\"=\"a\"}")
    end
  end
end
