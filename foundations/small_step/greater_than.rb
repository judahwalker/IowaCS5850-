require_relative '../syntax/greater_than'
require_relative 'boolean'

class GreaterThan
  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      GreaterThan.new(left.reduce(environment), right)
    elsif right.reducible?
      GreaterThan.new(left, right.reduce(environment))
    else
      Boolean.new(left.value > right.value)
    end
  end
end
