require_relative '../syntax/if'
require_relative 'boolean'

class If
  def reducible?
    true
  end

  def reduce(environment)
    while condition.reducible?
      self.condition = self.condition.reduce(environment)
    end
    case condition
    when Boolean.new(true)
      [consequence, environment]
    when Boolean.new(false)
      [alternative, environment]
    end

  end
end
