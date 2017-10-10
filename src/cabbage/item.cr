module Cabbage
  # Fixme: Change to struct when derivations are known to work.
  # Requires pointer magic to avoid recursive structs.
  class Item(T)
    include Derivation(T)

    property tag : LR0(T) | GrammarSymbol
    property start : Set(T)
    property stop : Set(T)

    def to_s
      "#{tag.to_s} #{start.position}-#{stop.position}"
    end

    def initialize(@tag, @start, @stop)
    end

    def predict(current)
      sym = lr0!.next_symbol
      if sym.is_a?(Nonterminal)
        current.predict(sym)
      end
    end

    def complete
      start.each_wanted_for(tag) do |item|
        next_tag = item.lr0!
        added_or_existing = stop.add_item(next_tag.advance, item.start) ||
                            stop.item(next_tag.advance, item.start)
        added_or_existing.add_derivation(item, self)
      end
    end

    def terminal_action(char)
      start.grammar.terminal.call(char)
    end

    def nonterminal_action(item)
      rule!.action.call(item)
    end

    def lhs
      if tag.is_a?(LR0(T))
        rule!.lhs
      else
        tag
      end
    end

    def rule!
      lr0!.rule
    end

    def lr0!
      tag.as(LR0(T))
    end
  end
end
