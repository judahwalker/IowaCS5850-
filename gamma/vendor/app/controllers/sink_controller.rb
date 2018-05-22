require 'Open3'
require 'rgl/adjacency'
require 'rgl/dot'
require 'net/http'
require "uri"
class gammaController < ApplicationController
  def index
    gamma = [
      { id: 123, name: 'The Things' },
    ]

    render json: gamma
  end
  @@list = []
  def create
    state = params[:state]
    if state == "clear"
      @@list = []
      render :text => @@list.to_s, :layout => true
    else
      @@list.push(state)
      url = 'http://localhost:4000/omega'
      uri = URI.parse(URI.encode(url))
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data({"list" => @@list.to_s.gsub(/\"/, "")})
      response = http.request(request)
      puts response.body
      render :text => @@list.to_s, :layout => true
    end
  end
end
