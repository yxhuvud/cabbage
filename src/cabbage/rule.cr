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
    "#{symbol} -> #{pretty_production}"
  end

  def pretty_production(start = 0, stop = rule.size)
    @production[start, stop - start].map { |c| pretty_sym(c) }.join
  end

  def lhs
    symbol
  end

  def empty?
    @production.any?
  end

  private def pretty_sym(s)
    if s.is_a? Symbol
      s.to_s
    else
      "'#{s}'"
    end
  end
end
