require 'Open3'
require 'rgl/adjacency'
require 'rgl/dot'
require 'net/http'
require "uri"
require_relative "gamma_controller"
class Gamma2Controller < ApplicationController
  def index
    @@list.push(params[:state])
=begin    
    Thread.new do
      url = 'http://localhost:3000/gamma'
      uri = URI.parse(URI.encode(url))
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data({})
      response = http.request(request)
    end
=end
    render :text => 'Successs : ' + @@list.to_s, :layout => true
  end
  @@list = []

  def self.list
    @@list
  end
end
