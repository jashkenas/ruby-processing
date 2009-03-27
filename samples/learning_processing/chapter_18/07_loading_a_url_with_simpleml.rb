#
# Example 18-7: Loading a URL with simpleML
#
load_library "simpleML"
import "simpleML"

def setup
  size 200, 200
  @html     = ""   # String to hold data from request
  @counter  = 0    # Counter to animate rectangle across window
  @back     = 255  # Background brightness

  # Create and make an asynchronous request using
  # the Request object from the library
  @htmlRequest = HTMLRequest.new(self, "http://www.yahoo.com")
  @htmlRequest.makeRequest
  @timer = Timer.new(5000)
  @timer.start
  background 0
end

def draw
  background @back

  # A request is made every 5s. 
  # The data is not received here, however, this is only the request.  
  if @timer.finished?
    @htmlRequest.makeRequest
    # XXX: was println("Making request!");
    puts "Making request!" 
    @timer.start
  end

  # When a request is finished the data the available 
  # flag is set to true - and we get a chance to read
  # the data returned by the request
  if @htmlRequest.available?
    @html = @htmlRequest.readRawSource # Read the raw data
    @back = 255                        # Reset background
    puts "Request completed!"          # Print message 
  end

  # Draw some lines with colors based on characters from data retrieved
  width.times do |i|
    if i < @html.length
      c = @html[i]
      stroke c, 150
      line i, 0, i, height
    end
  end

  # Animate rectangle and dim rectangle
  fill 255
  noStroke
  rect @counter, 0, 10, height
  @counter = (@counter + 1) % width
  @back    = constrain(@back - 1, 0, 255)
end

# XXX: There are still issues related to events from imported library
#      so we're not implementing this yet.
# When a request is finished the data is received in the netEvent() 
# function which is automatically called whenever data is ready.
#def net_event(ml) 
#  @html = ml.readRawSource      # Read the raw data
#  @back = 255                   # Reset background
#  # XXX: was println("Request completed!");
#  puts "Request completed!"     # Print message 
#end

#
# Timer Class from Chapter 10
#
class Timer
  def initialize(tempTotalTime)
    @totalTime = tempTotalTime
    @running   = false
  end

  def start
    @running   = true
    @savedTime = $app.millis
  end

  def finished?
    passedTime = $app.millis - @savedTime
    if @running && (passedTime > @totalTime)
      @running = false
      return true;
    else
      return false;
    end
  end
end
