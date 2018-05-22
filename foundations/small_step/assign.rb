require_relative '../syntax/assign'
require_relative 'do_nothing'

class Assign
  def reducible?
    true
  end

  def reduce(environment)
    while expression.reducible?
      self.expression = self.expression.reduce(environment)
    end
    [DoNothing.new, environment.merge({ name => expression })]
  end
end
