class Cabbage::Rule(T)
  property symbol : Nonterminal
  property production : Array(GrammarSymbol)
  property action : Proc(Item(T) | DerivationNode(T), T)

  def initialize(@symbol, @production, @action)
  end

  def size
    @production.size
  end

  def to_s
    "#{symbol.to_s} -> #{pretty_production}"
  end

  def pretty_production(start = 0, stop = production.size)
    @production[start, stop - start].map { |c| pretty_sym(c) }.join
  end

  def lhs
    symbol
  end

  delegate empty?, to: @production

  private def pretty_sym(s)
    if s.is_a? Nonterminal
      s.to_s
    else
      "'#{s}'"
    end
  end
end
