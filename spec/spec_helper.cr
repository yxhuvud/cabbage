require "spec"
require "../src/cabbage"

def terminal
  ->(char : Cabbage::Terminal) { char.to_s }
end

def stringify
  ->(item : Cabbage::Item(String) | Cabbage::DerivationNode(String)) do
    "(#{item.tag} #{item.rhs.join(" ")})"
  end
end

alias Grammar = Cabbage::Grammar(String)
alias Rule = Cabbage::Rule(String)
alias LR0 = Cabbage::LR0(String)
