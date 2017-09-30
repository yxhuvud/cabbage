class Cabbage::Parser(T)
  getter grammar : Grammar(T)
  getter sets : Array(Set(T))
  getter current : Set(T)

  @current : Cabbage::Set(T)

  def initialize(@grammar)
    @current = Cabbage::Set(T).new(grammar, 0)
    @sets = [current]
    current.predict(grammar.start)
    current.process
  end

  def consume_char(c)
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

  def accepted_item
    current.index[accepted_rule]
  end

  def parse(input)
    process(input)
    if accepted_item?
      accepted_item.walk
    end
  end
end
