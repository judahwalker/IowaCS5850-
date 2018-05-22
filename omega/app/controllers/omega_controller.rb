require 'Open3'
require 'rgl/adjacency'
require 'rgl/dot'
#require_relative '../../../foundations'
class OmegaController < ApplicationController
  def index
    omega = [
      { id: 123, name: 'The Things' },
    ]

    render json: omega
  end

  def create
    def syscall(*cmd)
      begin
        stdout, stderr, status = Open3.capture3(*cmd)
        status.success? && stdout.slice!(0..-(1 + $/.size)) # strip trailing eol
      rescue
      end
    end

    def populate(links,splits,root)
      splits.each do |i|
        if (root[0].length + 1 == i[0].length) && (root[0][root[0].length - 1] == i[0][root[0].length - 1])
          matched = true
          iter = 0
          root[0].each do |j|
            if !(j == (i[0][iter]))
              matched = false
            end
            iter = iter + 1
          end
          if matched
            links.push([root[1],i[1]])
            populate(links,splits,i)
          end
        end
      end
    end

    def count_em(string, substring)
      string.scan(/(?=#{substring})/).count
    end

    #lists = ['0,while (x > 10) do (x := x - 1),{x->13}', '0.1,x := x - 1; while (x > 10) do (x := x - 1),{x->13}', '0.2,x := x - 1; while (x > 10) do (x := x - 1),{x->13}', '0.2.1,while (x > 10) do (x := x - 1),{x->12}', '0.2.2,x := x - 1; while (x > 10) do (x := x - 1),{x->13}', '0.1.1,while (x > 10) do (x := x - 1),{x->12}', '0.1.1.1,x := x - 1; while (x > 10) do (x := x - 1),{x->12}', '0.1.1.1.1,while (x > 10) do (x := x - 1),{x->11}', '0.1.1.1.1.1,x := x - 1; while (x > 10) do (x := x - 1),{x->11}', '0.1.1.1.1.1.1,while (x > 10) do (x := x - 1),{x->10}', '0.1.1.1.1.1.1.1,{x->10}']
    #lists = "['0,x := x + 1; x := x + 3; x := x * 2,{x->13, y->13}', '0.1,x := x + 3; x := x * 2,{x->14, y->13}', '0.1.1,x := x * 2,{x->17, y->13}', '0.1.1.1,{x->34, y->13}']"
    #p syscall('osascript', '-e', 'quit app "Preview"')
    lists_pre = params[:list].tr('[]', '')
    lists = []
    if count_em(lists_pre,"'") == 2
      lists.push(lists_pre.tr("'",""))
    else
      lists = lists_pre.split("', '")
    end
    lists[0] = lists[0].reverse.chomp("'").reverse
    lists[lists.length - 1] = lists[lists.length - 1].chomp("'")
    splits = []
    lists.each do |i|
      x = i.split(',', 2)
      x[0] = x[0].split('.')
      splits.push(x)
    end

    copies = []
    splits.each do |i|
      splits.each do |j|
        if i[0] == j[0]
          next
        end
        if i[1] == j[1]
          contains = false
          copies.each do |k|
            if k[2] == i[1]
              contains = true
            end
          end
          if !contains
            subset = false
            copies.each do |l|
              if (l[0][l[0].length - 1] == i[0][l[0].length - 1]) || (l[0][l[0].length - 1] == j[0][l[0].length - 1])
                subset = true
              end
            end
            if !subset
              addin = 'nofind'
              splits.each do |m|
                if (j[0].length - 1 == m[0].length) && (j[0][j[0].length - 2] == m[0][j[0].length - 2])
                  addin = m[1]
                  break
                end
              end
              copies.push([i[0], j[0], addin, j[1]])
            end
          end
        end
      end
    end

    dellist = []
    copies.each do |i|
      content = i[1][i[1].length - 1]
      index = i[1].length - 1
      splits.each do |j|
        if j[0][index] == content
          if !dellist.include? j
            #dellist.push(j.dup) #Too gready of deletes
          end
        end
      end
    end

    dellist.reverse_each do |i|
      if splits.include? i
        splits.delete_at splits.index i
      end
    end

    root = 'temp'
    splits.each do |i|
      if i[0].length == 1
        root = i
        splits.delete_at splits.index root
      end
    end

    links = []

    populate(links,splits,root)

    dellist = []
    copies.each do |i|
      copies.each do |j|
        if i == j
          next
        end
        if i[1] == j[0]
          if !dellist.include? j
            dellist.push(j.dup)
          end
        end
      end
    end

    dellist.reverse_each do |i|
      if copies.include? i
        copies.delete_at copies.index i
      end
    end

    copies.each do |i|
      links.push([i[2],i[3]])
    end

    dg=RGL::DirectedAdjacencyGraph[]
    links.each do |ma|
      dg.add_edge ma[0],ma[1]
    end
    dg.write_to_graphic_file('jpg')
    p syscall('open', 'graph.jpg')
    render :text => 'Successs', :layout => true
  end
end
