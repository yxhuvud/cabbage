module Cabbage
  alias Nonterminal = Symbol
  alias Terminal = Char
  alias GrammarSymbol = Nonterminal | Terminal
  alias Tag = LR0 | GrammarSymbol
  alias TagPair = Tuple(Tag, Int32)

  struct Set
    property grammar : Grammar
    property position : Int32
    property items : Array(Item)
    property index : Hash(TagPair, Item)
    property wants : Hash(GrammarSymbol, Array(Item))

    def initialize(@grammar, @position)
      @items = [] of Item
      @index = {} of TagPair => Item
      @wants = {} of GrammarSymbol => Array(Item)
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

    def add_item(tag, start)
      if has_item?({tag, start.position})
        index[{tag, start.position}]
      else
        append_item(tag, start)
      end
    end

    def has_item?(key)
      index.has_key?(key)
    end

    def register_item(tag_pair, item)
      index[tag_pair] = item
    end

    def append_item(tag, start)
      item = Item.new(tag, start, self)
      items << item
      register_item(TagPair.new(tag, start.position), item)
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
      # Fixme this is silly.
      while (items.size > old)
        old = items.size
        process_once
      end
    end

    def each_wanted_for(tag)
      if wants.has_key?(tag)
        wants[tag].each do |item|
          yield item
        end
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
