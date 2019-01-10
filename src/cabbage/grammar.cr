class Cabbage::Grammar(T)
  property start : Nonterminal
  property terminal : Proc(Terminal, T)
  property rules : Hash(Nonterminal, Array(Rule(T)))
  property e_nonterminals : Hash(Nonterminal, Nonterminal)
  property symbol_table : SymbolTable

  def initialize(start, @terminal)
    @symbol_table = SymbolTable.new
    @start = symbol_table.lookup(start)
    @rules = Hash(Nonterminal, Array(Rule(T))).new
    @e_nonterminals = Hash(Nonterminal, Nonterminal).new
    yield self

    rewrite_to_nihilistic_normal_form(rules)
    # generate_all_lr0_items
  end

  def add_rule(lhs : Symbol, production, action)
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
    rules[sym] ||= [] of Rule(T)
    rules[sym] << Rule(T).new(sym, prod, action)
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

  def format_rules
    rules.map do |(nt, rhss)|
      (["    #{nt.to_s}:"] +
        rhss.map &.to_s).join("\n      ")
    end.join("\n")
  end

  def rewrite_to_nihilistic_normal_form(rules)
    initialize_nullables(rules)
    to_split = e_nonterminals.keys
    # while to_split.any?
    #   split_rules(rules, to_split)
    # end
  end

  def initialize_nullables(rules)
    rules.each do |nt, rules|
      if rules.any? &.empty?
        e_nonterminals[nt] = symbol_table.generate_e_nonterminal_for(nt)
      end
    end
  end

  def split_rules(rules, to_split)
    rules.each do |sym, rhss|
      # for each rhss matching symbol:
      rhss.each do |rhs|
        split_nullable(rhs, to_split)
      end
    end
  end

  def split_nullable(rhs, to_split)
  end
end
