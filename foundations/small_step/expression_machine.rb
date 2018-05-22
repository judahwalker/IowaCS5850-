class ExpressionMachine < Struct.new(:expression, :environment)
  def step
    self.expression = expression.reduce(environment)
  end

  def run
    while expression.reducible?
      #puts expression
      step
    end

    return expression.to_s
  end
end
