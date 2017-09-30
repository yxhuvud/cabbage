require "./spec_helper"

def rule
  Rule.new(:X, ['x', :X, :Y], stringify)
end

describe Cabbage::Rule do
  it "has size" do
    rule.size.should eq(3)
  end

  it "can print itself" do
    rule.to_s.should eq("X -> 'x'XY")
  end

  it "can print part of productions" do
    rule.pretty_production(2, 3).should eq("Y")
  end
end
