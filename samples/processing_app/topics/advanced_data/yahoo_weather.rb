#
# Loading XML Data
# by Daniel Shiffman.  
#
# This example demonstrates how to use loadXML()
# to retrieve data from an XML document via a URL
#

attr_reader :zip, :weather, :temperature

def setup
  size(600, 360)
  @zip = 10003
  font = create_font("Merriweather-Light.ttf", 28)
  text_font(font)

  # The URL for the XML document
  url = "http://xml.weather.yahoo.com/forecastrss?p=#{zip}"
  
  # Load the XML document
  xml = loadXML(url)

  # Grab the element we want
  forecast = xml.get_child("channel").get_child("item").get_child("yweather:forecast")
  
  # Get the attributes we want
  @temperature = forecast.get_int("high")
  @weather = forecast.get_string("text")
end

def draw
  background(255)
  fill(0)
  # Display all the stuff we want to display
  text("Zip code: #{zip}", width*0.15, height*0.33)
  text("Today's high: #{temperature}", width*0.15, height*0.5)
  text("Forecast: #{weather}", width*0.15, height*0.66)
end
