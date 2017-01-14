class Cabbage::Parser
  getter grammar : Grammar
  getter sets : Array(Set)
  getter current : Set

  @current : Cabbage::Set

  def initialize(@grammar)
    @current = Cabbage::Set.new(grammar, 0)
    @sets = [current]
    current.predict grammar.start
    current.process
  end

  def consume_char(c)
    puts current.to_s
    puts "scanned #{c}"
    @current = current.scan(c)
    current.process
    sets << current
  end

  def process(input)
    input.each_char { |c| consume_char(c) }
  end

  # Fixme: Support for multiples.
  def accepted_rule
    {grammar.start, 0}
  end

  def accepted_item?
    current.has_item?(accepted_rule)
  end

  def accepted_item # Move to set?
    current.index[accepted_rule]
  end

  def parse(input)
    process(input)
    puts current.to_s
    if accepted_item?
      puts :accepted_state
      puts accepted_item.to_s
      p accepted_item.left
      p accepted_item.right
    end
  end
end
