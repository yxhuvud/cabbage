struct Cabbage::Grammar(T)
  property start : GrammarSymbol
  property terminal : Proc(Terminal, T)
  property rules : Hash(Nonterminal, Array(Rule(T)))

  def initialize(@start, @terminal, @rules)
  end

  def parse(input)
    Cabbage::Parser(T).new(self).parse(input)
  end
end
