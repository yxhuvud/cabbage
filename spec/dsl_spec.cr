require "./spec_helper"

describe Cabbage::DSL do
  describe "definition" do
    grammar = Cabbage::DSL(String).define do
      start :S
      terminal { |c| c.to_s }

      rule(:S, 'b') do |item, args|
        "(#{item.lhs} #{args.join(" ")})"
      end
    end

    grammar.start.as(Symbol).should eq :S
    grammar.terminal.should_not be_nil
    grammar.parse("b").should eq "(S b)"
  end

  describe "rule contents" do
    describe "empty" do
      grammar = Cabbage::DSL(String).define do
        start :S
        terminal { |c| c.to_s }

        rule(:S) { |item, args| "(#{item.lhs})" }
      end

      grammar.parse("").should eq "(S)"
    end

    # describe "with terminal" do
    # Covered in definition test
    # end

    describe "with non-terminals" do
      grammar = Cabbage::DSL(String).define do
        start :S
        terminal { |c| c.to_s }

        rule(:S, :A) { |item, args| args.join(" ") }
        rule(:A, :C, 'b') { |item, args| "(#{args[0]})#{args[1]}" }
        rule(:C, :C, 'x') { args.join }
        rule(:C) { "" }
      end

      grammar.parse("xxxb").should eq "(xxx)b"
    end
  end
end
