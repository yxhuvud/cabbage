# coding: utf-8
module Cabbage
  struct LR0(T)
    property rule : Rule(T)
    property dot : UInt8
    property complete : Bool

    def initialize(@rule, @dot)
      @complete = dot == rule.size
    end

    def to_s
      "#{rule.symbol}: " +
        rule.pretty_production(0, @dot) +
        "·" +
        rule.pretty_production(@dot, @rule.size)
    end

    def next_symbol
      if dot < rule.size
        rule.production[dot]
      end
    end

    def symbol
      rule.symbol
    end

    def advance
      if complete?
        symbol
      else
        self.class.new(rule, dot + 1_u8)
      end
    end


    def complete?
      @complete
    end
  end
end
