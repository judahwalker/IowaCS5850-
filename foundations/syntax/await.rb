# encoding: utf-8

class Await < Struct.new(:condition, :simple)
  def to_s
    "await (#{condition}) then (#{simple})"
  end

  def inspect
    "«#{self}»"
  end
end
