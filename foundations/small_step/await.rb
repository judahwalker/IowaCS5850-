require_relative '../syntax/await'
require_relative '../syntax/do_nothing'
require_relative 'boolean'

class Await
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
      while self.simple.reducible?
        tuple = self.simple.reduce(environment)
        self.simple = tuple[0]
        environment = tuple[1]
      end
      [self.simple, environment]
    when Boolean.new(false)
      self.condition = temp
      [self, environment]
    end
  end
end
