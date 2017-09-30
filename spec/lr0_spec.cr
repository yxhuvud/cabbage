require "./spec_helper"

def lr0
  rule = Rule.new(:X, ['x', :X, :Y], stringify)
  LR0.new rule, 0
end

def lr1
  rule = Rule.new(:X, ['x', :X, :Y], stringify)
  LR0.new rule, 1
end

def lr2
  rule = Rule.new(:X, ['x', :X, :Y], stringify)
  LR0.new rule, 2
end

def lr3
  rule = Rule.new(:X, ['x', :X, :Y], stringify)
  LR0.new rule, 3
end

describe Cabbage::LR0 do
  describe :lr0 do
    it "#to_s" do
      lr0.to_s.should eq("X: ·'x'XY")
    end

    it "#next_symbol" do
      lr0.next_symbol.should eq('x')
    end

    it "#advance" do
      lr0.advance.should eq(lr1)
    end

    it "#complete" do
      lr0.complete?.should eq(false)
    end
  end

  describe :lr1 do
    it "#to_s" do
      lr1.to_s.should eq("X: 'x'·XY")
    end

    it "#next_symbol" do
      lr1.next_symbol.should eq(:X)
    end

    it "#advance" do
      lr1.advance.should eq(lr2)
    end
  end

  describe :lr2 do
    it "#complete?" do
      lr2.complete?.should eq(false)
    end
  end

  describe :lr3 do
    it "#to_s" do
      lr3.to_s.should eq("X: 'x'XY·")
    end

    it "#next_symbol" do
      lr3.next_symbol.should eq(nil)
    end

    it "#advance" do
      lr3.advance.should eq(:X)
    end

    it "#complete" do
      lr3.complete?.should eq(true)
    end
  end
end
