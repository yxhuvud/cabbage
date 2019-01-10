module Cabbage
  class SymbolTable
    property nonterminals
    property lookup_table : Hash(String, Nonterminal)
    property e_nonterminals : ::Set(Nonterminal)

    def initialize
      @nonterminals = Array(String).new
      @lookup_table = Hash(String, Nonterminal).new
      @e_nonterminals = ::Set(Nonterminal).new
    end

    def lookup(sym : Symbol)
      lookup sym.to_s
    end
    
    def lookup(string)
      if val = lookup_table[string]?
        val
      else
        Nonterminal.new(nonterminals.size.to_i16).tap do |nt|
          nonterminals << string
          lookup_table[string] = nt
        end
      end
    end

    def e_nonterminal?(sym)
      e_nonterminals.includes?(sym)
    end

    def generate_e_nonterminal_for(sym)
      return sym if e_nonterminal?(sym)
      e = lookup(to_s(sym) + 'ϵ')
      e_nonterminals << e
      e
    end

    def to_s(sym)
      @nonterminals[sym.value]
    end
    
    def all_e_nons
      @nonterminals.values_at e_nonterminals
    end
  end
end
