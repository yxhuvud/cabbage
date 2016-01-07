module Cabbage
  module Derivation
    property left
    property right
    property next_derivation

    def add_derivation(left, right)
      puts
      p self.to_s
      puts "add l: #{left.to_s} r: #{right.to_s}"
      if !(left || right)
        return
      end
      left_tag, right_tag = left.tag, right.tag
      if left_tag.is_a?(LR0) && left_tag.dot <= 1
        left = left.right
      end
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
        old = DerivationNode.new(self.left,
          self.right,
          nil)
        self.left = DerivationNode.new(left, right, old)
        self.right = nil
      end
    end

    def add_another_derivation(left, right)
      d = self.left
      while d
        return if d.same?(left, right)
        d = d.next_derivation
      end
      self.left = DerivationNode.new(left, right, self.left)
    end

    def derivation_list?
      next_derivation
    end
  end

  class DerivationNode
    include Derivation

    def initialize(@left, @right, @next_derivation)
    end
  end
end
