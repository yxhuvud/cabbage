module Earley
  class Derivation
    property left
    property right
    property next_derivation

    def initialize(@left, @right, @next_derivation)
    end

    def same_derivation(left, right)
      self.left == left && self.right == right
    end
  end
end
