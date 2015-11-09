require "./spec_helper"

describe Cabbage do
  # TODO: Write tests

  it "works" do
    x = Cabbage::Grammar.new :S, {
          :S => [
            Cabbage::Rule.new(:S, ['a', :X, :X, 'c'], nil),
          ],
          :X => [
            Cabbage::Rule.new(:X, [:X, 'b'], nil),
            Cabbage::Rule.new(:X, [] of Cabbage::GrammarSymbol, nil),
          ],
        }
    x.parse "abbc"
  end
end
