struct Cabbage::Rule(T)
  property symbol : GrammarSymbol
  property production : Array(GrammarSymbol)
  property action : Proc(Item(T), Deque(T), T)


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

  private def pretty_sym(s)
    if s.is_a? Symbol
      s.to_s
    else
      "'#{s}'"
    end
  end
end
