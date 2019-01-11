module Cabbage
  struct Nonterminal
    property value : Int16

    def initialize(@value)
    end

    def to_s
      value
    end
  end
end
