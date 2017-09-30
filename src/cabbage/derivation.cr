module Cabbage
  module Derivation(T)
    property left : Item(T) | DerivationNode(T) | Nil
    property right : Item(T) | DerivationNode(T) | Nil
    property next_derivation : Item(T) | DerivationNode(T) | Nil

    def add_derivation(left, right)
      if !(left || right)
        return
      end
      # if left
      #   left_tag = left.tag
      #   if left_tag.is_a?(LR0) && left_tag.dot <= 1
      #     left = left.right
      #   end
      # end
      if !(self.left || self.right)
        self.left = left
        self.right = right
      elsif self.right
        add_second_derivation left, right
      else
        add_another_derivation left, right
      end
    end

    def same?(left, right)
      self.left == left && self.right == right
    end

    def add_second_derivation(left, right)
      unless same?(left, right)
        old = DerivationNode(T).new(self.left, self.right, nil)
        self.left = DerivationNode(T).new(left, right, old)
        self.right = nil
      end
    end

    def add_another_derivation(left, right)
      d = self.left
      while d
        return if d.same?(left, right)
        d = d.next_derivation
      end
      self.left = DerivationNode(T).new(left, right, self.left)
    end

    def derivation_list?
      next_derivation
    end

    def walk
      args = Deque(T).new
      left = @left

      # if next_derivation
      #   p next_derivation.not_nil!.walk
      # end

      while left
        # if left.next_derivation
        #   p left.walk
        # end
        if right = left.right
          tag = right.tag
          if tag.is_a?(Terminal)
            args.unshift(left.terminal_action(tag))
          else
            args.unshift right.walk.as(T)
          end
        end
        left = left.left
      end
      left = @left.not_nil!
      left.nonterminal_action(args)
    end
  end

  class DerivationNode(T)
    include Derivation(T)

    def initialize(@left, @right, @next_derivation)
    end

    def tag
      raise "x"
    end

    def terminal_action(char)
      raise "todo"
    end

    def nonterminal_action(args)
      raise "todo"
    end
  end
end
