require 'Open3'
require 'net/http'

begin
  command = ARGV[0]
rescue
  put "Missing Command"
end
begin
  sigma = ARGV[1]
rescue
  put "Missing Sigma"
end

#"command=x := x + 1 || y := x - 2 || z := y - x || await (z = -1) then (x := 100)" "sigma={x->2, y->2, z->3}"
url = 'http://localhost:2000/gate'
uri = URI.parse(URI.encode(url))
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri)
request.set_form_data({"command"=>command,"sigma"=>sigma})
response = http.request(request)

while true
  sleep(1.2)
  Thread.new do
    url = 'http://localhost:3000/gamma'
    uri = URI.parse(URI.encode(url))
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({})
    response = http.request(request)
  end
end
