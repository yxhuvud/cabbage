require "./spec_helper"

describe Cabbage::DSL do
  it "definition" do
    grammar = Cabbage::DSL(String).define do
      start :S
      terminal { |c| c.to_s }

      rule(:S, 'b') { |item| "(#{item.lhs} #{item.rhs.join(" ")})" }
    end

    grammar.start.as(Symbol).should eq :S
    grammar.terminal.should_not be_nil
    grammar.parse("b").should eq "(S b)"
  end

  describe "rule contents" do
    it "empty" do
      grammar = Cabbage::DSL(String).define do
        start :S
        terminal { |c| c.to_s }

        rule(:S) { |item| "(#{item.lhs})" }
      end

      grammar.parse("").should eq "(S)"
    end

    # describe "with terminal" do
    # Covered in definition test
    # end

    it "with non-terminals" do
      grammar = Cabbage::DSL(String).define do
        start :S
        terminal { |c| c.to_s }

        rule(:S, :A) { |item| item.rhs.join(" ") }
        rule(:A, :C, 'b') do |item|
          rhs = item.rhs
          "(#{rhs[0]})#{rhs[1]}"
        end
        rule(:C, :C, 'x') { |item| item.rhs.join }
        rule(:C) { "" }
      end

      grammar.parse("xxxb").should eq "(xxx)b"
    end
  end
end
