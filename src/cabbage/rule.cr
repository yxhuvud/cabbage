class Cabbage::Rule(T)
  property symbol : Nonterminal
  property production : Array(GrammarSymbol)
  property action : Proc(Item(T) | DerivationNode(T), T)

  def self.new(symbol_table, lhs : Symbol, production, action)
    sym = symbol_table.lookup(lhs)
    prod = Array(GrammarSymbol).new
    production.each do |sym_or_char|
      prod <<
        case sym_or_char
        when Symbol
          symbol_table.lookup(sym_or_char.to_s)
        when Char
          sym_or_char
        else
          raise "Unreachable"
        end
    end
    new(sym, prod, action)
  end

  def initialize(@symbol, @production, @action)
  end

  def size
    @production.size
  end

  def to_s
    "#{symbol.to_s} -> #{pretty_production}"
  end

  def pretty_production(start = 0, stop = production.size)
    if empty?
      "ε"
    else
      @production[start, stop - start].map { |c| pretty_sym(c) }.join
    end
  end

  def lhs
    symbol
  end

  def rhs
    production
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
