require "./spec_helper"

describe "Cabbage::Grammar" do
  describe "left recursive grammars" do
    it "parses" do
      x = Grammar.new :S, terminal, {
        :S => [
          Rule.new(:S, [:S, 'b'], stringify),
          Rule.new(:S, ['b'] of Cabbage::GrammarSymbol, stringify),
        ],
      }
      x.parse("bbb").should eq("(S (S (S b) b) b)")
    end
  end

  describe "right recursive grammars" do
    it "parses" do
      x = Grammar.new :S, terminal, {
        :S => [
          Rule.new(:S, ['b', :S], stringify),
          Rule.new(:S, ['b'] of Cabbage::GrammarSymbol, stringify),
        ],
      }
      x.parse("bbb").should eq("(S b (S b (S b)))")
    end
  end

  describe "ambiguous grammars" do
    it "parses" do
      x = Grammar.new :S, terminal, {
        :S => [
          Rule.new(:S, ['a', :X, :X, 'c'], stringify),
        ],
        :X => [
          Rule.new(:X, [:X, 'b'], stringify),
          Rule.new(:X, [] of Cabbage::GrammarSymbol, stringify),
        ],
      }

      # TODO: Handle multiple parse results.
      x.parse("abbc").should eq("(S a (X (X (X ) b) b) (X ) c)")
    end
  end
end
