#
# Example 18-5: Parsing Yahoo's XML weather feed manually
#
def setup
  size 200, 200
  textFont createFont("Georgia",16, true)

  # Make a WeatherGrabber object
  @counter = 0
  @zips    = ["10003", "21209", "90210"]
  @wg      = WeatherGrabber.new(@zips[@counter])

  # Tell it to request the weather
  @wg.request_weather
end

def draw
  background 255
  fill 0

  # Get the values to display
  weather = @wg.weather
  temp    = @wg.temperature

  # Display all the stuff we want to display
  text @zips[@counter], 10, 160
  text weather, 10, 90
  text "#{temp}", 10, 40
  text "Click to change zip.", 10, 180

  # Draw a little thermometer based on the temperature
  stroke 0
  fill 175
  rect 10, 50, temp * 2, 20
end

def mouse_pressed
  # Increment the counter and get the weather at the next zip code
  @counter = (@counter + 1) % @zips.length;
  @wg.zip  = @zips[@counter]
  
  # The data is requested again with a new zip code every time the mouse is pressed.
  @wg.request_weather
end

#
# A WeatherGrabber class
#
class WeatherGrabber
  attr_reader :temperature, :weather, :zip
  attr_writer :zip

   def initialize(zip)
     @temperature = 0
     @weather     = ""
     @zip         = zip
   end

   # Make the actual XML request
   def request_weather
     # Get all the HTML/XML source code into an array of strings
     # (each line is one element in the array)
     url   = "http://xml.weather.yahoo.com/forecastrss?p=" + @zip
     lines = $app.load_strings(url)

     # Turn array into one long String
     xml = lines.join # join(lines, ""); 

     # Searching for weather condition
     lookfor   = "<yweather:condition text=\""
     endmarker = "\""
     @weather  = give_me_text_between(xml, lookfor, endmarker)

     # Searching for temperature
     lookfor      = "temp=\""
     @temperature = $app.int(give_me_text_between(xml, lookfor, endmarker))
   end

   # A function that returns a substring between two substrings
   def give_me_text_between(s, before, after) 
     found = ""
     start = s.index(before)            # Find the index of the beginning tag
     return "" if start.nil?            # If we don't find anything, send back a blank String
     
     start    += before.length          # Move to the end of the beginning tag
     endmarker = s.index(after, start)  # Find the index of the end tag
     return "" if endmarker.nil?        # If we don't find the end tag, send back a blank String
     
     s[start, endmarker]                # Return the text in between
   end
end