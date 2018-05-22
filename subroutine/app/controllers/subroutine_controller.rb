require 'Open3'
require 'rgl/adjacency'
require 'rgl/dot'
require_relative '../../../foundations'
class SubroutineController < ApplicationController
  def index
    subroutine = [
      { id: 123, name: 'The Things' },
    ]
    render json: subroutine
  end

  def create
    state = params[:state]
    state = state.tr("'","")
    state = state.split(",",3)
    if state[1] == ""
      url = 'http://localhost:3000/gamma'
      uri = URI.parse(URI.encode(url))
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data({"temp" => temp.to_s.gsub(/\"/, "")})
      response = http.request(request)
      puts response.body
      render :text => 'Successs', :layout => true
    else
      state_pre = state.clone
      state[0] = state[0].split(".")
      piece = state[0][state[0].length - 1]
      command = state[1].split(" || ")[piece.to_i - 1]
      parse_tree = SimpleParser.new.parse(command)
      env_list = state[2].tr("{}","").split(", ")
      env_list.each do |i|
        temp = i.split("->")
        env_list[env_list.index i] = temp
      end
      env_hash = Hash.new
      env_list.each do |i|
        env_hash[i[0].to_sym] = Number.new(i[1].to_i)
      end
      myparse = StatementMachine.new(parse_tree.to_ast, env_hash).run
      if myparse[1] =~ /^{.*}/
        if state_pre[1].split(" || ").length == 1
          env_new = myparse[1]
          state = state_pre[0] + "," + env_new
          #url = 'http://localhost:3000/gamma'
          #uri = URI.parse(URI.encode(url))
          #http = Net::HTTP.new(uri.host, uri.port)
          #request = Net::HTTP::Post.new(uri.request_uri)
          #request.set_form_data({"state" => state.gsub(/"/, "")})
          #response = http.request(request)
          #puts response.body
#=begin
          uri = URI.parse( "http://localhost:3000/gamma2" ); params = {'state'=>state.gsub(/"/, "")}
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Get.new(uri.path)
          request.set_form_data( params )
          request = Net::HTTP::Get.new( uri.path+ '?' + request.body )
          response = http.request(request)
#=end
          render :text => 'Successs output: ' + state, :layout => true
        else
          env_new = myparse[1]
          breakout = state_pre[1].split(" || ")
          breakout.delete_at(piece.to_i - 1)
          breakout = breakout * " || "
          state = state_pre[0] + "," + breakout + "," + env_new
          #url = 'http://localhost:3000/gamma'
          #uri = URI.parse(URI.encode(url))
          #http = Net::HTTP.new(uri.host, uri.port)
          #request = Net::HTTP::Post.new(uri.request_uri)
          #request.set_form_data({"state" => state.gsub(/"/, "")})
          #response = http.request(request)
          #puts response.body
#=begin
          uri = URI.parse( "http://localhost:3000/gamma2" ); params = {'state'=>state.gsub(/"/, "")}
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Get.new(uri.path)
          request.set_form_data( params )
          request = Net::HTTP::Get.new( uri.path+ '?' + request.body )
          response = http.request(request)
#=end
          render :text => 'Successs output: ' + state, :layout => true
        end
      else
        result_pre = myparse[1].split(',',2)[0]
        env_new = myparse[1].split(',',2)[1]
        breakout = state[1].split(" || ")
        breakout[piece.to_i - 1] = result_pre
        breakout = breakout * " || "
        state = state_pre[0] + "," + breakout + "," + env_new
        #url = 'http://localhost:3000/gamma'
        #uri = URI.parse(URI.encode(url))
        #http = Net::HTTP.new(uri.host, uri.port)
        #request = Net::HTTP::Post.new(uri.request_uri)
        #request.set_form_data({"state" => state.gsub(/"/, "")})
        #response = http.request(request)
        #puts response.body
#=begin
        uri = URI.parse( "http://localhost:3000/gamma2" ); params = {'state'=>state.gsub(/"/, "")}
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.path)
        request.set_form_data( params )
        request = Net::HTTP::Get.new( uri.path+ '?' + request.body )
        response = http.request(request)
#=end
        render :text => 'Successs output: ' + state, :layout => true
      end
    end
  end
end
