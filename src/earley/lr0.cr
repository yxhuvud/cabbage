# coding: utf-8
module Earley
  struct LR0
    property rule
    property dot

    def initialize(@rule, @dot)
    end

    def to_s
      "#{rule.symbol} -> " +
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
        self.class.new(rule, dot + 1)
      end
    end

    def complete?
      dot == rule.size
    end
  end
end
