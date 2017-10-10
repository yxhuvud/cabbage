require "./spec_helper"

describe Cabbage::DSL do
  it "definition" do
    grammar = Cabbage::DSL(String).define do
      start :S
      terminal { |c| c.to_s }

      rule(:S, 'b') { |item, args| "(#{item.lhs} #{args.join(" ")})" }
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

        rule(:S) { |item, _| "(#{item.lhs})" }
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

        rule(:S, :A) { |item, args| args.join(" ") }
        rule(:A, :C, 'b') { |item, args| "(#{args[0]})#{args[1]}" }
        rule(:C, :C, 'x') { |item, args| args.join }
        rule(:C) { "" }
      end

      grammar.parse("xxxb").should eq "(xxx)b"
    end
  end
end
