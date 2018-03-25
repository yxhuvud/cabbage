class Cabbage::Grammar(T)
  property start : GrammarSymbol
  property terminal : Proc(Terminal, T)
  property rules : Hash(Nonterminal, Array(Rule(T)))
  property e_nonterminals : Hash(Nonterminal, Nonterminal)

  def initialize(@start, @terminal, @rules)
    @e_nonterminals = Hash(Nonterminal, Nonterminal).new
    rewrite_to_nihilistic_normal_form
    # generate_all_lr0_items
  end

  def parse(input)
    Cabbage::Parser(T).new(self).parse(input)
  end

  def rewrite_to_nihilistic_normal_form(rules)
    initialize_nullables(rules)
    to_split = e_nonterminals.to_a
    while to_split.any?
      split_rules(rules, to_split)
    end
  end

  def initialize_nullables(rules)
    rules.each do |nt, rules|
      if rules.any? &.empty?
        nt.e_nonterminal!
      end
    end
  end

  def split_rules(rules, to_split)
    rules.each do |sym, rhss|
      rhss.each do |rhs|
        expanded = split_nullable(rhs, to_split)
      end
    end
  end

  def split_nullable?(rhs, to_split)
  end
end
