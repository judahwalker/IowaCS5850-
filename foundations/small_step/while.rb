require_relative '../syntax/while'
require_relative 'do_nothing'
require_relative 'if'
require_relative 'sequence'
require 'Treetop'

base_path = File.expand_path(File.dirname(__FILE__))
base_path = base_path.chomp('/small_step')
#Treetop.load('foundations/parser/while')
Treetop.load(File.join(base_path, '/parser/while.treetop'))
class While
  def reducible?
    true
  end
  def reduce(environment)
    temp = condition
    while self.condition.reducible?
      self.condition = self.condition.reduce(environment)
    end
    case self.condition
    when Boolean.new(true)
      self.condition = temp
      parse_tree = SimpleParser.new.parse(self.to_s)
      [Sequence.new(self.body, parse_tree.to_ast), environment]
    when Boolean.new(false)
      [DoNothing.new, environment]
    end
    #[If.new(self.condition.dup, Sequence.new(self.body.dup, While.new(self.condition.dup, self.body.dup)), DoNothing.new), environment]
  end
end
