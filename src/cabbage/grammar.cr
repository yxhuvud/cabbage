struct Cabbage::Grammar
  property start : GrammarSymbol
  property rules : Hash(Nonterminal, Array(Rule))

  def initialize(@start, @rules)
  end

  def parse(input)
    Cabbage::Parser.new(self).parse(input)
  end
end
