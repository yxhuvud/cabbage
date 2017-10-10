module Cabbage
  module Derivation(T)
    property previous : Item(T) | DerivationNode(T) | Nil
    property child : Item(T) | DerivationNode(T) | Nil
    property next_derivation : Item(T) | DerivationNode(T) | Nil

    def add_derivation(previous, child)
      if !(previous || child)
        return
      end

   #   if previous
      previous_tag = previous.tag
      if previous_tag.is_a?(LR0) && previous_tag.beginning_and_not_complete?
        previous = nil
      end
      #  end

      if !(self.previous || self.child)
        self.previous = previous
        self.child = child
      elsif self.child
        add_second_derivation previous, child
      else
        add_another_derivation previous, child
      end
    end

    def same?(previous, child)
      self.previous == previous && self.child == child
    end

    def add_second_derivation(previous, child)
      unless same?(previous, child)
        old = DerivationNode(T).new(self.previous, self.child, nil)
        #       self.previous = DerivationNode(T).new(previous, child, old)
        #   self.child = nil
        # # FIXME: Doublecheck against SPPF paper. This make more sense:
        self.previous = previous
        self.child = child
        self.next_derivation = old
      end
    end

    def add_another_derivation(previous, child)
      d = self.previous
      while d
        return if d.same?(previous, child)
        d = d.next_derivation
      end
      self.previous = DerivationNode(T).new(previous, child, self.previous)
    end

    def derivation_list?
      next_derivation
    end

    def walk
      previous = @previous.not_nil!
      # Current is actual symbol and doesn't have nonterminal_action.
      # FIXME: remove symbol items as they are not necessary?
      previous.nonterminal_action(self)
    end

    def rhs
      # Getting all children by iterating backwards through the item.
      # Doesn't currently handle multiple derivations.
      tree_node = Deque(T).new
      previous = @previous

      # if next_derivation
      #   p next_derivation.not_nil!.walk
      # end

      while previous
        # if previous.next_derivation
        #   p previous.walk
        # end
        evaluate(previous) { |element| tree_node.unshift element }
        previous = previous.previous
      end
      tree_node
    end

    def evaluate(prev)
      if child = prev.child
        tag = child.tag
        element =
          if tag.is_a?(Terminal)
            prev.terminal_action(tag)
          else
            child.walk
          end
        yield element
      end
    end
  end

  class DerivationNode(T)
    include Derivation(T)

    def initialize(@previous, @child, @next_derivation)
    end

    def tag
      raise "UNREACHABLE"
    end

    def terminal_action(char)
      raise "todo"
    end

    def nonterminal_action(item)
      raise "UNREACHABLE"
    end

    def lhs
      raise "UNREACHABLE (for now)"
    end

    def rule!
      raise "UNREACHABLE (for now)"
    end
  end
end
