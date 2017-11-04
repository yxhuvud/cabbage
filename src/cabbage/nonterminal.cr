module Cabbage
  struct Nonterminal
    property value : Int32

    # Fixme: Use a symbol table instead of class variables. This would
    # limit grammars to a single instantiation and can create strange
    # bugs.
    @@string_pool = Hash(Nonterminal, String).new
    @@lookup = Hash(String, Nonterminal).new
    @@e_nonterminals = ::Set(Nonterminal).new

    def self.get_or_new(string)
      if val = @@lookup[string]?
        val
      else
        new(string)
      end
    end

    def initialize(string)
      @value = @@string_pool.size
      @@string_pool[self] = string
    end

    def e_nonterminal?
      @@e_nonterminals.includes?(self)
    end

    # Mark itself as having an ϵ-production.
    def e_nonterminal!
      e = self.class.get_or_new(to_s + 'ϵ')
      @@e_nonterminals << e
      e
    end

    def to_s
      @@string_pool[self]
    end
  end
end
