require "./spec_helper"

def lr_grammar(rule)
  Grammar.new :X, terminal, {:X => [rule]}
end

def lrx(dot_pos, rule = Rule.new(:X, ['x', :X, :Y], stringify), g = lr_grammar(rule))
  g.lr0({rule, dot_pos.to_u8})
end

describe Cabbage::LR0 do
  describe :lr0 do
    it "#to_s" do
      lrx(0).to_s.should eq("X: ·'x'XY")
    end

    it "#next_symbol" do
      lrx(0).next_symbol.should eq('x')
    end

    it "#advance" do
      lr0 = lrx(0)
      lr1 = lrx(1, lr0.rule, lr0.grammar)
      lr0.advance.should eq(lr1)
    end

    it "#complete" do
      lrx(0).complete?.should eq(false)
    end
  end

  describe :lr1 do
    it "#to_s" do
      lrx(1).to_s.should eq("X: 'x'·XY")
    end

    it "#next_symbol" do
      lrx(1).next_symbol.should eq(:X)
    end

    it "#advance" do
      lr1 = lrx(1)
      lr2 = lrx(2, lr1.rule, lr1.grammar)
      lr1.advance.should eq(lr2)
    end
  end

  describe :lr2 do
    it "#complete?" do
      lrx(2).complete?.should eq(false)
    end
  end

  describe :lr3 do
    it "#to_s" do
      lrx(3).to_s.should eq("X: 'x'XY·")
    end

    it "#next_symbol" do
      lrx(3).next_symbol.should eq(nil)
    end

    it "#advance" do
      lrx(3).advance.should eq(:X)
    end

    it "#complete" do
      lrx(3).complete?.should eq(true)
    end
  end
end
