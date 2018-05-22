# encoding: utf-8

class If < Struct.new(:condition, :consequence, :alternative)
  def to_s
    "if (#{condition}) then (#{consequence}) else (#{alternative})"
  end

  def inspect
    "«#{self}»"
  end
end
