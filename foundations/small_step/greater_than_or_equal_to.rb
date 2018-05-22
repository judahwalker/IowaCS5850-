require_relative '../syntax/greater_than_or_equal_to'
require_relative 'boolean'

class GreaterThanOrEqualTo
  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      GreaterThanOrEqualTo.new(left.reduce(environment), right)
    elsif right.reducible?
      GreaterThanOrEqualTo.new(left, right.reduce(environment))
    else
      Boolean.new(left.value >= right.value)
    end
  end
end
