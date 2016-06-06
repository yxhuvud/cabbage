struct Cabbage::Grammar
  property start
  property rules

  def initialize(@start, @rules)
  end

  def parse(input)
    Cabbage::Parser.new(self).parse(input)
  end
end
