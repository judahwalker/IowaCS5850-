require 'Open3'
require 'rgl/adjacency'
require 'rgl/dot'
require 'net/http'
require "uri"
class GateController < ApplicationController
  def index
    gate = [
      { id: 123, name: 'The Things' },
    ]

    render json: gate
  end

  def create
    command = params[:command]
    sigma = params[:sigma]
    state = '0,' + command + ',' + sigma

    url = 'http://localhost:6000/sink'
    uri = URI.parse(URI.encode(url))
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"state" => "clear"})
    response = http.request(request)

    uri = URI.parse( "http://localhost:3000/gamma2" ); params = {'state'=>state}
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.path)
    request.set_form_data( params )
    request = Net::HTTP::Get.new( uri.path+ '?' + request.body )
    response = http.request(request)


    #url = 'http://localhost:3000/gamma'
    #uri = URI.parse(URI.encode(url))
    #http = Net::HTTP.new(uri.host, uri.port)
    #request = Net::HTTP::Post.new(uri.request_uri)
    #request.set_form_data({})
    #response = http.request(request)

    render :text => 'Successs : ' + state, :layout => true
  end

end
