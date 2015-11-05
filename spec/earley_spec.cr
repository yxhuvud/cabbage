require "./spec_helper"

describe Earley do
  # TODO: Write tests

  it "works" do
    x = Earley::Grammar.new :S, {
          :S => [
            Earley::Rule.new(:S, ['a', :X, :X, 'c'], nil),
          ],
          :X => [
            Earley::Rule.new(:X, [:X, 'b'], nil),
            Earley::Rule.new(:X, [] of Earley::GrammarSymbol, nil),
          ],
        }
    x.parse "abbc"
  end
end
