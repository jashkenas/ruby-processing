require 'ruby-processing'

#
# Ported from http://www.processing.org/learning/topics/spring.html
#
class Spring < Processing::App

  def setup
    rect_mode(CORNERS)
    no_stroke

    @s_height = 16 # Height
    @left = 50     # Left position
    @right = 150   # Right position
    @max = 100     # Maximum Y value
    @min = 20      # Minimum Y value
    @over = false  # If mouse over
    @move = false  # If mouse down and over

    # Spring simulation constants
    @M = 0.8   # Mass
    @K = 0.2   # Spring constant
    @D = 0.92  # Damping
    @R = 60    # Rest position

    # Spring simulation variables
    @ps = 60.0 # Position
    @vs = 0.0  # Velocity
    @as = 0    # Acceleration
    @f = 0     # Force
  end

  def draw
    background(102)
    update_spring
    draw_spring
  end

  def draw_spring
    # Draw base
    fill(0.2)
    b_width = 0.5 * @ps + -8
    rect(width/2 - b_width, @ps + @s_height, width/2 + b_width, 150)

    # Set color and draw top bar
    if (@over || @move)
      fill(255)
    else
      fill(204)
    end
    rect(@left, @ps, @right, @ps + @s_height)
  end

  def update_spring
    # Update the spring position
    if (!@move)
      @f = -1 * @K * (@ps - @R) # f=-ky
      @as = @f / @M             # Set the acceleration, f=ma == a=f/m
      @vs = @D * (@vs + @as)    # Set the velocity
      @ps = @ps + @vs           # Updated position
    end
    if (abs(@vs) < 0.1) 
      @vs = 0.0
    end

    # Test if mouse is over the top bar
    if(mouse_x > @left && mouse_x < @right && mouse_y > @ps && mouse_y < @ps + @s_height)
      @over = true
    else 
      @over = false
    end

    # Set and constrain the position of top bar
    if (@move) 
      @ps = mouseY - @s_height/2
      @ps = @min if (@ps < @min)
      @ps = @max if (@ps > @max)
    end
  end

  def mouse_pressed
    if (@over)
      @move = true
    end
  end

  def mouse_released
    @move = false
  end

  def abs(f)
    if (f < -1)
      f * -1
    else
      f
    end
  end

end

Spring.new(:width => 200, :height => 200, :title => "Spring", :full_screen => false)