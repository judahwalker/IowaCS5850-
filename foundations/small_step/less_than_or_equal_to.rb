require_relative '../syntax/less_than_or_equal_to'
require_relative 'boolean'

class LessThanOrEqualTo
  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      LessThanOrEqualTo.new(left.reduce(environment), right)
    elsif right.reducible?
      LessThanOrEqualTo.new(left, right.reduce(environment))
    else
      Boolean.new(left.value <= right.value)
    end
  end
end
