# frozen_string_literal: true

RSpec.describe RandomNameGenerator do
  before(:all) do
    dirname = File.dirname(__FILE__)
    @elven = RandomNameGenerator::Generator.new(RandomNameGenerator::ELVEN)
    @fantasy = RandomNameGenerator::Generator.new(RandomNameGenerator::FANTASY)
    @goblin = RandomNameGenerator::Generator.new(RandomNameGenerator::GOBLIN)
    @roman = RandomNameGenerator::Generator.new(RandomNameGenerator::ROMAN)
    @micro = RandomNameGenerator::Generator.new(File.new("#{dirname}/languages/test-micro.txt"))
    @tiny = RandomNameGenerator::Generator.new(File.new("#{dirname}/languages/test-tiny.txt"))
  end
  it "has a version number" do
    expect(RandomNameGenerator::VERSION).not_to be nil
  end

  context "languages" do
    it "has an Elvish language" do
      expect(RandomNameGenerator::ELVEN).to be_a_kind_of(File)
      expect(RandomNameGenerator::ELVEN.path).to include("languages/elven.txt")
    end

    it "has an Elvish Russian language" do
      expect(RandomNameGenerator::ELVEN_RU).to be_a_kind_of(File)
      expect(RandomNameGenerator::ELVEN_RU.path).to include("languages/elven-ru.txt")
    end

    it "has an Fantasy language" do
      expect(RandomNameGenerator::FANTASY).to be_a_kind_of(File)
      expect(RandomNameGenerator::FANTASY.path).to include("languages/fantasy.txt")
    end

    it "has an Fantasy Russian language" do
      expect(RandomNameGenerator::FANTASY_RU).to be_a_kind_of(File)
      expect(RandomNameGenerator::FANTASY_RU.path).to include("languages/fantasy-ru.txt")
    end

    it "has an Goblin language" do
      expect(RandomNameGenerator::GOBLIN).to be_a_kind_of(File)
      expect(RandomNameGenerator::GOBLIN.path).to include("languages/goblin.txt")
    end

    it "has an Goblin Russian language" do
      expect(RandomNameGenerator::GOBLIN_RU).to be_a_kind_of(File)
      expect(RandomNameGenerator::GOBLIN_RU.path).to include("languages/goblin-ru.txt")
    end

    it "has an Roman language" do
      expect(RandomNameGenerator::ROMAN).to be_a_kind_of(File)
      expect(RandomNameGenerator::ROMAN.path).to include("languages/roman.txt")
    end

    it "has an Roman Russian language" do
      expect(RandomNameGenerator::ROMAN_RU).to be_a_kind_of(File)
      expect(RandomNameGenerator::ROMAN_RU.path).to include("languages/roman-ru.txt")
    end
  end

  context "flip_mode" do
    it "returns a Generator with a random language" do
      sut = RandomNameGenerator.flip_mode
      expect(sut.language.path).to end_with(".txt")
    end

    it "cyrillic returns a Generator with a random language" do
      sut = RandomNameGenerator.flip_mode_cyrillic
      expect(sut.language.path).to end_with(".txt")
    end
  end

  context "pick_number_of_syllables" do
    10.times do
      it "returns an integer between 1 and 6" do
        expect(RandomNameGenerator.pick_number_of_syllables).to be_between(1, 5)
      end
    end
  end

  context "new" do
    it "creates a static factory for the Generator class" do
      elven = RandomNameGenerator.new(RandomNameGenerator::ELVEN)
      expect(elven.language.path).to eq(RandomNameGenerator::ELVEN.path)
    end
  end

  describe RandomNameGenerator::Generator do
    context "initialize" do
      context "language" do
        it "is set to the right language when the file is passed in" do
          expect(@elven.language.path).to eq(RandomNameGenerator::ELVEN.path)
        end

        it "can accept an external language file" do
          expect(@micro.language.path).to include("languages/test-micro.txt")
        end

        it "syllables are distributed" do
          expect(@micro.pre_syllables.length).to be(1)
          expect(@micro.mid_syllables.length).to be(1)
          expect(@micro.sur_syllables.length).to be(1)
        end
      end
    end

    context "scratch" do
      it "does stuff" do
        expect(@tiny.compose).not_to be nil
        expect(@tiny.compose(5).length).to be(5)
      end
    end

    context "compose" do
      5.times do
        # this is to capture a nasty edgecase of the language files being reused and not rewound.
        it "tiny always does the thing" do
          expect(@tiny.compose).not_to be nil
        end

        it "elven returns a name" do
          name = @elven.compose
          expect(name).not_to be nil
        end

        it "fantasy returns a name" do
          name = @fantasy.compose
          expect(name).not_to be nil
        end

        it "goblin returns a name" do
          name = @goblin.compose
          expect(name).not_to be nil
        end

        it "roman returns a name" do
          name = @roman.compose
          expect(name).not_to be nil
        end

        it "flip mode" do
          flip = RandomNameGenerator.flip_mode
          name = flip.compose
          expect(name).not_to be nil
        end
      end
    end

    context "compose_array" do
      sut = RandomNameGenerator.flip_mode
      it "returns the connect number of syllables when specified" do
        expect(sut.compose_array(2).length).to be(2)
        expect(sut.compose_array(3).length).to be(3)
        expect(sut.compose_array(4).length).to be(4)
        expect(sut.compose_array(5).length).to be(5)
      end
    end

    context "to_s" do
      it "returns a clear representation of the class name and language file name" do
        expect(@elven.to_s).to eq("RandomNameGenerator::Generator (elven.txt)")
      end
    end
  end
end
