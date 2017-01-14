module Cabbage
  # Fixme: Change to struct when derivations are known to work.
  # Requires pointer magic to avoid recursive structs.
  class Item
    include Derivation

    property tag : Tag
    property start : Set
    property stop : Set

    def to_s
      "#{tag.to_s} #{start.position}-#{stop.position}"
    end

    def initialize(@tag, @start, @stop)
      @left = nil
      @right = nil
    end

    def complete
      start.each_wanted_for(tag) do |item|
        case (next_tag = item.tag)
        when LR0
          added = stop.add_item(next_tag.advance, item.start)
          added.add_derivation(item, self)
        end
      end
    end
  end
end
