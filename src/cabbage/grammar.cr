class Cabbage::Grammar(T)
  property start : GrammarSymbol
  property terminal : Proc(Terminal, T)
  property rules : Hash(Nonterminal, Array(Rule(T)))

  def initialize(@start, @terminal, @rules)
    @lr0 = Hash(Tuple(Rule(T), UInt8), LR0(T)).new
  end

  def parse(input)
    Cabbage::Parser(T).new(self).parse(input)
  end

  def lr0(key : Tuple(Rule(T), UInt8))
    if item = @lr0[key]?
      item
    else
      @lr0[key] = LR0(T).new(*key, self)
    end
  end
end
