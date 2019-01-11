class Cabbage::Grammar(T)
  property start : Nonterminal
  property terminal : Proc(Terminal, T)
  property rules : Array(Rule(T))
  property e_nonterminals : Hash(Nonterminal, Nonterminal)
  property symbol_table : SymbolTable

  def initialize(start, @terminal)
    @symbol_table = SymbolTable.new
    @start = symbol_table.lookup(start)
    @rules = Array(Rule(T)).new
    @e_nonterminals = Hash(Nonterminal, Nonterminal).new
    yield self
    NihilisticRewriter(T).new(self).rewrite!
    # generate_all_lr0_items
  end

  # parses
  def add_rule(lhs : Symbol, production, action)
    rules << Rule(T).new(symbol_table, lhs, production, action)
  end

  # Already parsed
  def add_rule(lhs : Nonterminal, production, action)
    rules << Rule(T).new(lhs, production, action)
  end

  def delete_rule(rule)
    rules.delete(rule)
  end

  def parse(input)
    Cabbage::Parser(T).new(self).parse(input)
  end

  def to_s
    <<-EOS
    Grammar
      start: #{start.to_s}
      rules:
    #{format_rules}
    EOS
  end

  private def grouped_rules
    rules.group_by(&.lhs)
  end

  def format_rules
    grouped_rules.map do |(nt, rhss)|
      (["    #{nt.to_s}:"] +
        rhss.map &.to_s).join("\n      ")
    end.join("\n")
  end

  def compact_rules(rules)
    grouped_rules.map do |key, r|
      "#{key.to_s} -> " + r.map(&.pretty_production).join(" | ")
    end.join("\n")
  end

end
