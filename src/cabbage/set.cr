module Cabbage
  alias Nonterminal = Symbol
  alias Terminal = Char
  alias GrammarSymbol = Nonterminal | Terminal
  alias Tag = LR0 | GrammarSymbol
  record TagPair, tag, pos

  struct Set
    property grammar
    property position
    property items
    property index
    property wants

    def initialize(@grammar, @position)
      @items = [] of Item
      @index = {} of TagPair       => Item
      @wants = {} of GrammarSymbol => Array(Item)
    end

    def to_s
      <<-EOS
SET: #{position}
has:
#{"  " + items.map(&.to_s).join("\n  ")}
wants:
#{wants.map { |k, v|
                                                                                       "<#{k}> #{v.map(&.to_s).join(", ")}"
                                                                                     }.join("\n")}
      EOS
    end

    def add_item(tag, start)
      key = TagPair.new(tag, start.position)
      if index.has_key?(key)
        index[key]
      else
        append_item(tag, start)
      end
    end

    def append_item(tag, start)
      item = Item.new(tag, start, self)
      items << item
      index[TagPair.new(tag, start.position)] = item
      return item if tag.is_a?(GrammarSymbol)
      sym = tag.next_symbol
      # fixme nullable check
      if sym
        wants[sym] = [] of Item unless wants.has_key?(sym)
        wants[sym] << item
      else # empty rule, add the symbol
        add_item tag.symbol, start
      end
      item
    end

    def predict(sym)
      assert { grammar.rules.has_key?(sym) }
      grammar.rules[sym].each do |rule|
        lr_item = LR0.new(rule, 0)
        add_item(lr_item, self)
      end
    end

    def scan(sym)
      next_set = self.class.new(grammar, position + 1)
      next_set.add_item(sym, self)
      next_set
    end

    def process
      old = items.size
      process_once
      while (items.size > old)
        old = items.size
        process_once
      end
    end

    def process_once
      items.each do |item|
        tag = item.tag
        if tag.is_a?(LR0)
          sym = tag.next_symbol
          if sym.is_a?(Nonterminal)
            predict(sym)
          end
        else
          item.complete
        end
      end
    end
  end
end
