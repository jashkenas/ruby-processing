require 'ruby-processing'

class LinesOneAtATime < Processing::App
  
  # No for loop here. Instead, a global variable.
  # In ruby, global variables start with $.
  $y = 0
  
  def setup
    background 255
    # Slowing down the frame rate so we can easily see the effect.
    frame_rate 5
  end
  
  def draw
    # Draw a line
    stroke 0 
    # Only one line is drawn each time through draw.
    line 0, $y, width, $y  
    # Increment y
    $y += 10

    # Reset y back to 0 when it gets to the bottom of window
    # In ruby, you can put if statements at the end, like speaking.
    $y = 0 if $y > height
  end
  
end

LinesOneAtATime.new :title => "Lines One At A Time", :width => 200, :height => 200