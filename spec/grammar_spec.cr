require "./spec_helper"

describe "Cabbage::Grammar" do
  describe "rewriting to NNF" do
    it "doesn't change grammars without e productions" do
      g = Grammar.new :S, terminal do |g|
        g.add_rule :S, [:S, 'b'], stringify
        g.add_rule :S, ['b'] of Cabbage::GrammarSymbol, stringify
      end
      g.rules.values.flatten.size.should eq 2
    end

    it "parses" do
      g = Grammar.new(:S, terminal) do |g|
        g.add_rule :S, ['a', :S], stringify
        g.add_rule :S, [] of Cabbage::GrammarSymbol, stringify
      end
      sym = g.symbol_table.lookup(:S.to_s + 'ϵ')
      g.symbol_table.e_nonterminal?(sym).should be_true
    end
  end

  # describe "left recursive grammars" do
  #   it "parses" do
  #     x = Grammar.new :S, terminal, {
  #       :S => [
  #         Rule.new(:S, [:S, 'b'], stringify),
  #         Rule.new(:S, ['b'] of Cabbage::GrammarSymbol, stringify),
  #       ],
  #     }
  #     x.parse("bbb").should eq("(S (S (S b) b) b)")
  #   end
  # end

  # describe "right recursive grammars" do
  #   it "parses" do
  #     x = Grammar.new :S, terminal, {
  #       :S => [
  #         Rule.new(:S, ['b', :S], stringify),
  #         Rule.new(:S, ['b'] of Cabbage::GrammarSymbol, stringify),
  #       ],
  #     }
  #     x.parse("bbb").should eq("(S b (S b (S b)))")
  #   end
  # end

  # describe "ambiguous grammars" do
  #   it "parses" do
  #     x = Grammar.new :S, terminal, {
  #       :S => [
  #         Rule.new(:S, ['a', :X, :X, 'c'], stringify),
  #       ],
  #       :X => [
  #         Rule.new(:X, [:X, 'b'], stringify),
  #         Rule.new(:X, [] of Cabbage::GrammarSymbol, stringify),
  #       ],
  #     }

  #     # TODO: Handle multiple parse results.
  #     x.parse("abbc").should eq("(S a (X (X (X ) b) b) (X ) c)")
  #   end
  # end
end
