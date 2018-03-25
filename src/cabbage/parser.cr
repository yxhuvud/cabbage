class Cabbage::Parser(T)
  getter grammar : Grammar(T)
  getter sets : Array(Set(T))

  def initialize(@grammar)
    current = Cabbage::Set(T).new(grammar, 0)
    current.predict(grammar.start)
    @sets = Array(Set(T)).new
    @sets << current
    @consumed = 0

    memoize_transitions(0)
  end

  def process(input)
    each_earley_step(input) do |index, c|
      scan index, c
      return false if sets[index].empty?
      reduce(index)
      memoize_transitions(index)
    end
    # sets[position].
    accepted?
  end

  def scan(i : Int32, c : Terminal)
    items = sets[i - 1].wants[c]?
    current = sets[i]

    if items
      items.each do |item|
      end
    end
  end

  def reduce(i : Int32)
  end

  def evaluate
    accepted_item.walk
  end

  def accepted?
    sets[@consumed].has_item?(accepted_rule)
  end

  def parse(input)
    if process(input)
      evaluate
    else
      valid = 0..input.size
      before = input[(@consumed - 15).clamp(valid)..@consumed]
      after = input[(@consumed + 1).clamp(valid)..(@consumed + 5).clamp(valid)]
      snippet = "#{before}•#{after}"
      # Fixme: Own exception
      raise <<-EOS
        Parse failed at position #{@consumed}
        #{snippet}
        EOS
    end
  end

  private def each_earley_step(input)
    index = 1 + @consumed
    input.each_char do |c|
      yield i, c
      index += 1
      @consumed = index
    end
  end

  private def memoize_transitions(i : Int32)
    sets[i].items.each do |item|
      add_symbol(item.next_sym, i, item)
    end
  end

  private def add_symbol(sym : Terminal, i : Int32, item : Item(T))
  end

  private def add_symbol(sym : Nonterminal, i : Int32, item : Item(T))
    sets[i]
  end

  private def accepted_item
    sets[consumed].index[accepted_rule]
  end

  # Fixme: Support for multiples.
  private def accepted_rule
    {grammar.start, 0}
  end
end
