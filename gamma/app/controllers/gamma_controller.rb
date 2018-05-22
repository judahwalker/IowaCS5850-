require 'Open3'
require 'rgl/adjacency'
require 'rgl/dot'
require 'net/http'
require "uri"
require_relative "gamma2_controller"
class GammaController < ApplicationController
  #def index
  #  @@list.push(params[:state])
  #  render :text => 'Successs : ' + @@list.to_s, :layout => true
  #end

  #@@list = []


  def create
#=begin
    #while true
      url = 'http://localhost:4000/generator'
      uri = URI.parse(URI.encode(url))
      http = Net::HTTP.new(uri.host, uri.port)
      response = Net::HTTP.get_response(uri)
      puts response.body
      if response.body =~ /\n\n\[\]\n\n/m
        if !Gamma2Controller.list.empty?
          state = Gamma2Controller.list.pop()
          forsink = "'" + state + "'"
          forgenerator = state
          Thread.new do
            url = 'http://localhost:6000/sink'
            uri = URI.parse(URI.encode(url))
            http = Net::HTTP.new(uri.host, uri.port)
            request = Net::HTTP::Post.new(uri.request_uri)
            request.set_form_data({"state" => forsink})
            response = http.request(request)
            url = 'http://localhost:4000/generator'
            uri = URI.parse(URI.encode(url))
            http = Net::HTTP.new(uri.host, uri.port)
            request = Net::HTTP::Post.new(uri.request_uri)
            request.set_form_data({"state" => forgenerator})
            http.request(request)
          end
          render :text => 'Successs : ' + state, :layout => true
          #sleep(0.5)
        else
          render :text => 'no data!', :layout => true
        end
      else
      #  sleep(1)
      render :text => 'generator has data still!', :layout => true
      end
#=end
    #end
  end
end
