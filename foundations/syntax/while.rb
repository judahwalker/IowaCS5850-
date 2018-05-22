# encoding: utf-8

class While < Struct.new(:condition, :body)
  def to_s
    "while (#{condition}) do (#{body})"
  end

  def inspect
    "«#{self}»"
  end
end
