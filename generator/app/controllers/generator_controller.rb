require 'Open3'
require 'rgl/adjacency'
require 'rgl/dot'
require_relative '../../../foundations'
class GeneratorController < ApplicationController
  def index
    render :text => @@list.to_s, :layout => true
  end

  @@list = []

  def create
    state = params[:state]
    state = state.tr("'","")
    if state =~ /0(.)?([1-9]+.)*([1-9])?,.*,{.*}/
      state = state.split(",",3)
      state_pre = state.clone
      commands = state[1].split(" || ")
      contains_await = false
      index = 0
      for command in commands
        if command.start_with? "await"
          contains_await = true
          index = commands.index command
        end
      end

      #figure out env
      env_list = state[2].tr("{}","").split(", ")
      env_list.each do |i|
        temp = i.split("->")
        env_list[env_list.index i] = temp
      end
      env_hash = Hash.new
      env_list.each do |i|
        env_hash[i[0].to_sym] = Number.new(i[1].to_i)
      end

      perform_await = false
      if contains_await
        expression_tree = ExpressionParser.new.parse(commands[index].scan(/await \((.*)\) then \(/).first.last)
        if ExpressionMachine.new(expression_tree.to_ast, env_hash).run == "true"
          perform_await = true #The await will execute
        end
      end

      branch = 0
      if contains_await
        if perform_await
          for command in commands
            branch = branch + 1
            pushedstate = state[0] + "." + branch.to_s + "," + state[1] + "," + state[2]
            @@list.push(pushedstate)
          end
        else
          for command in commands
            if command.start_with? "await"
              next
            end
            branch = branch + 1
            pushedstate = state[0] + "." + branch.to_s + "," + state[1] + "," + state[2]
            @@list.push(pushedstate)
          end
        end
      else
        for command in commands
          branch = branch + 1
          pushedstate = state[0] + "." + branch.to_s + "," + state[1] + "," + state[2]
          @@list.push(pushedstate)
        end
      end

      while !@@list.empty?
        post_state = @@list.pop
        url = 'http://localhost:5000/subroutine'
        uri = URI.parse(URI.encode(url))
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data({"state" => post_state})
        response = http.request(request)
      end
      render :text => 'Success', :layout => true
    else
      render :text => 'State is final state no need to send to subroutine: ' + state, :layout => true
    end
  end
end
