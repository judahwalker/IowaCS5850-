require_relative '../syntax/add'
require_relative 'number'

class Add
  def reducible?
    true
  end

  def reduce(environment)
    while left.reducible?
      self.left = self.left.reduce(environment)
    end
    while right.reducible?
      self.right = self.right.reduce(environment)
    end
    Number.new(left.value + right.value)
  end
end
