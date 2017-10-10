module Cabbage
  alias Nonterminal = Symbol
  alias Terminal = Char
  alias GrammarSymbol = Nonterminal | Terminal

  class Set(T)
    # Fixme: space optimizations?

    property grammar : Grammar(T)
    property position : Int32
    property items : Array(Item(T))
    property index : Hash(Tuple(LR0(T) | GrammarSymbol, Int32), Item(T))
    property wants : Hash(GrammarSymbol, Array(Item(T)))

    def initialize(@grammar, @position)
      @items = [] of Item(T)
      @index = {} of Tuple(LR0(T) | GrammarSymbol, Int32) => Item(T)
      @wants = {} of GrammarSymbol => Array(Item(T))
    end

    def to_s
      w = wants.map { |k, v|
        "<#{k}> #{v.map(&.to_s).join(", ")}"
      }.join("\n")
      <<-EOS
        SET: #{position}
        has:
        #{"  " + items.map(&.to_s).join("\n  ")}
        wants:
        #{w}
        EOS
    end

    def predict(sym)
      grammar.rules[sym].each do |rule|
        lr_item = LR0(T).new(rule, 0_u8)
        add_item(lr_item, self)
      end
    end

    def add_item(tag, start)
      unless has_item?({tag, start.position})
        append_item(tag, start)
      end
    end

    def has_item?(key)
      index.has_key?(key)
    end

    def item(tag, start)
      index[{tag, start.position}]
    end

    def register_item(tag_pair, item)
      index[tag_pair] = item
    end

    def append_item(tag, start)
      item = Item(T).new(tag, start, self)
      items << item
      register_item({tag, start.position}, item)
      return item if tag.is_a?(GrammarSymbol)
      sym = tag.next_symbol
      if sym
        wants[sym] = [] of Item(T) unless wants.has_key?(sym)
        wants[sym] << item
      else # empty rule, add the symbol
        if added = add_item tag.symbol, start
          added.add_derivation(item, nil)
        end
      end
      item
    end

    def scan(sym)
      next_set = self.class.new(grammar, position + 1)
      next_set.add_item(sym, self)
      next_set
    end

    def process
      old = items.size
      process_range(0, old - 1)
      while (items.size > old)
        start = old
        old = items.size
        process_range(start, items.size - 1)
      end
    end

    def each_wanted_for(tag)
      if wants.has_key?(tag)
        wants[tag].each do |item|
          yield item
        end
      end
    end

    def process_range(start, stop)
      start.upto(stop) do |i|
        item = items[i]
        if item.tag.is_a?(LR0)
          item.predict(self)
        else
          item.complete
        end
      end
    end
  end
end
