class Cabbage::Grammar
  property start
  property rules

  def initialize(@start, @rules)
  end

  def parse(input)
    s0 = Cabbage::Set.new(self, 0)
    s0.predict start
    s0.process
    sets = [s0]
    current = s0
    input.each_char do |c|
      puts current.to_s
      puts "scanned #{c}"
      current = current.scan(c)
      current.process
      sets << current
    end
    success = TagPair.new(start, 0)
    if current.index.has_key? success
      puts :success
      puts current.index[success].to_s
      current.index[success]
    end
  end
end
