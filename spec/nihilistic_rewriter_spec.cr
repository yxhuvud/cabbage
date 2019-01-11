require "./spec_helper"

describe "Cabbage::NihilisticRewriter" do
  it "doesn't change grammars without e productions" do
    g = Grammar.new :S, terminal do |g|
      g.add_rule :S, [:S, 'b'], stringify
      g.add_rule :S, ['b'] of Cabbage::GrammarSymbol, stringify
    end
    g.rules.size.should eq 2
    g.e_nonterminals.empty?.should eq true
  end

  it "parses" do
    g = Grammar.new(:S, terminal) do |g|
      g.add_rule :S, ['a', :S], stringify
      g.add_rule :S, [] of Cabbage::GrammarSymbol, stringify
    end
    sym = g.symbol_table.lookup(:S.to_s + 'ε')
    g.symbol_table.e_nonterminal?(sym).should be_true
  end
end
