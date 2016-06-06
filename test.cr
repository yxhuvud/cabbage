class Bar
  def initialize(@foo)
  end

  def to_s
  end
end

class Foo
  getter test

  @test : Bar

  def initialize
    @test = Bar.new(self)
  end

  def foo
    puts @test.to_s
  end
end

Foo.new.foo
