module Cabbage
  class DSL(T)
    property terminal_action : (Cabbage::Terminal -> T) | Nil
    property start_symbol : GrammarSymbol | Nil
    property rules : Array(Rule(T))

    def self.define
      dsl = DSL(T).new
      with dsl yield
      dsl.finish!
    end

    def initialize
      @terminal_action = nil
      @start_symbol = nil
      @rules = Array(Rule(T)).new
    end

    macro rule(lhs, *rhs)
      %action = action_catcher do |item|
        {{ yield }}
      end

      %rhs = [{{*rhs}}] of Cabbage::GrammarSymbol

      add_rule rule_type.new({{lhs}}, %rhs, %action)
    end

    def start(s : GrammarSymbol)
      @start_symbol = s
    end

    def terminal(&block : Cabbage::Terminal -> T)
      @terminal_action = block
    end

    # Can't access T in macro scope.
    private def rule_type
      Rule(T)
    end

    private def add_rule(rule)
      @rules << rule
    end

    # Can't access T in macro scope.
    private def action_catcher(&block : Proc(Item(T) | DerivationNode(T), T))
      block
    end

    def finish!
      start = @start_symbol
      terminal = @terminal_action
      rules = Hash(Nonterminal, Array(Rule(T))).new

      @rules.each do |rule|
        rules[rule.lhs] ||= [] of Rule(T)
        rules[rule.lhs] << rule
      end

      # FIXME: Own errors
      raise ArgumentError.new "No start symbol declared" unless start
      raise ArgumentError.new "No terminal action declared" unless terminal
      raise ArgumentError.new "No rules declared" if @rules.empty?

      Grammar(T).new(start, terminal, rules)
    end

    private def symbolize(val : Terminal | Symbol)
      case val
      when Symbol
        Nonterminal.get_or_new(val)
      else
        val
      end
    end
  end
end
