# HTTP Client. 
# 
# Starts a network client that connects to a server on port 80,
# sends an HTTP 1.0 GET request, and prints the results. 
# Note that this code is not necessary for simple HTTP GET request:
# Simply calling loadStrings("http://www.processing.org") would do
# the same thing as (and more efficiently than) this example.
# This example is for people who might want to do something more 
# complicated later.

load_library 'net'
include_package 'processing.net'

attr_reader :client, :data

def setup
  size(200, 200)
  background(50)
  fill(200)
  @client = Client.new(self, "www.processing.org", 80) # Connect to server on port 80
  client.write("GET / HTTP/1.0\r\n") # Use the HTTP "GET" command to ask for a Web page
  client.write("\r\n")
end

def draw
  if (client.available() > 0)   # If there's incoming data from the client...
    data = client.read_string()  # ...then grab it and print it
    println(data)
  end
end

