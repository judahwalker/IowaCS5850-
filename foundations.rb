#This will add in while parser for any program

require_relative 'foundations/small_step'
require_relative 'foundations/syntax'
require_relative 'foundations/parser'

base_path = File.expand_path(File.dirname(__FILE__))
Treetop.load(File.join(base_path, 'foundations/parser/expression.treetop'))
Treetop.load(File.join(base_path, 'foundations/parser/while.treetop'))
#Treetop.load('../../../foundations/parser/while')
=begin
examples follow shortly
parse_tree = SimpleParser.new.parse('if (x + 1 < 5) then (x := x * 2) else (x := x + 1)')
StatementMachine.new(parse_tree.to_ast, { x: Number.new(13) }).run
parse_tree = SimpleParser.new.parse('x := x * 2; x := x + 1; y := x * x')
StatementMachine.new(parse_tree.to_ast, { x: Number.new(13), y: Number.new(4) }).run
parse_tree = SimpleParser.new.parse('while (x > 10) do (x := x - 1)')
StatementMachine.new(parse_tree.to_ast, { x: Number.new(13) }).run #will not converge if equal to or less then 10
parse_tree = SimpleParser.new.parse('await (x > 10) then (x := x - 1; x := x - 2)')
StatementMachine.new(parse_tree.to_ast, { x: Number.new(13) }).run #will not converge if equal to or less then 10, and runs all simple in one step
parse_tree = SimpleParser.new.parse('await (x > 10) then (while (x > 10) do (x := x - 1))') #This will produce nil output as it is not a simple command
=end
