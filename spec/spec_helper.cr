require "spec"
require "../src/cabbage"

def terminal
  ->(char : Cabbage::Terminal) { char.to_s }
end

def stringify
  ->(item : Cabbage::Item(String), args : Deque(String)) do
    "(#{item.lhs} #{args.join(" ")})"
  end
end

alias Grammar = Cabbage::Grammar(String)
alias Rule = Cabbage::Rule(String)
alias LR0 = Cabbage::LR0(String)
