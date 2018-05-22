require_relative '../syntax/equal_to'
require_relative 'boolean'

class EqualTo
  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      EqualTo.new(left.reduce(environment), right)
    elsif right.reducible?
      EqualTo.new(left, right.reduce(environment))
    else
      Boolean.new(left.value == right.value)
    end
  end
end
