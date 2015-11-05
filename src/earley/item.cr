module Earley
  # Fixme: Change to struct when derivations are known to work.
  # Requires pointer magic to avoid recursive structs.
  class Item
    property tag
    property start
    property stop

    property left
    property right
    property next_derivation

    def to_s
      "<#{tag.to_s} :: #{start.position}<->#{stop.position}>"
    end

    def initialize(@tag, @start, @stop)
      @left = nil
      @right = nil
    end

    def complete
      if start.wants.has_key?(tag)
        start.wants[tag].each do |item|
          next_tag = item.tag as LR0
          added = stop.add_item(next_tag.advance, item.start)
          added.add_derivation(item, self)
        end
      end
    end

    def add_derivation(left, right)
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

    def same_derivation(left, right)
      self.left == left && self.right == right
    end

    def add_second_derivation(left, right)
      unless same_derivation(left, right)
        old = Derivation.new(self.left,
                             self.right,
                             nil)
        self.left = Derivation.new(left, right, old)
        self.right = nil
      end
    end

    def add_another_derivation(left, right)
      d = self.left
      while d
        return if d.same_derivation(left, right)
        d = d.next_derivation
      end
      self.left = Derivation.new(left, right, self.left)
    end
  end
end
