class Cabbage::NihilisticRewriter(T)
  property grammar : Grammar(T)

  def initialize(@grammar)
  end

  def rewrite!
    initialize_nullables(rules)
    to_split = e_nonterminals.keys
    while split = to_split.pop?
      split_rules(split)
    end
    puts compact_rules(rules)
  end

  private def initialize_nullables(rules)
    rules.select(&.empty?).each do |rule|
      e_nonterminals[rule.lhs] = symbol_table.generate_e_nonterminal_for(rule.lhs)
    end
  end

  private def split_rules(split_char)
    rules.each do |rule|
      split_nullable(rule, split_char) do |new_prod|
        add_rule(rule.lhs, new_prod, rule.action)
      end
    end
  end

  private def split_nullable(rule, split_char)
    return if rule.empty?

    yield rule.rhs if false
  end

  forward_missing_to @grammar
end
