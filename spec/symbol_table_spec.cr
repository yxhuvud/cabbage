require "./spec_helper"

describe "Cabbage::SymbolTable" do
  describe "#lookup" do
    it "returns the same nonterminal for same input" do
      table = Cabbage::SymbolTable.new
      table.lookup(:S.to_s).should eq table.lookup(:S.to_s)
    end

  end
  
  it "can mark e-nonterminals" do
    table = Cabbage::SymbolTable.new
    original = table.lookup(:S.to_s)
    table.e_nonterminal?(original).should be_false
    new = table.generate_e_nonterminal_for original
    table.to_s(new).should eq "Sϵ"
    table.e_nonterminal?(new).should be_true
  end
end
