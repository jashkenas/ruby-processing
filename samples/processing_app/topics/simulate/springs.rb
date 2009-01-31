require 'ruby-processing'

#
# Ported from http://www.processing.org/learning/topics/springs.html
#
# Move the mouse over one of the circles and click to re-position. When you release the mouse, it will 
# snap back into position. Each circle has a slightly different behavior.
#
class Springs < Processing::App

  def setup
    no_stroke
    smooth

    @springs = []
    @springs << Spring.new(self,  70, 160,  20, 0.98, 8.0, 0.1, @springs, 0)
    @springs << Spring.new(self, 150, 110,  60, 0.95, 9.0, 0.1, @springs, 1)
    @springs << Spring.new(self,  40,  70, 120, 0.90, 9.9, 0.1, @springs, 2)
  end

  def draw
    background(51)
    @springs.each do |sp|
      sp.update
      sp.display
    end
  end

  def mouse_pressed
    @springs.each {|x| x.pressed}
  end

  def mouse_released
    @springs.each {|x| x.released}
  end

end

class Spring 

  def initialize(app, x, y, s, d, m, k, others, id)
    @app = app

    # Screen values
    @xpos      = @tempxpos = x
    @ypos      = @tempypos = y
    @rest_posx = x       # Rest position X
    @rest_posy = y       # Rest position Y
    @size      = s
    @damp      = d       # Damping
    
    # Spring simulation constants
    @mass      = m       # Mass
    @kin       = k       # Spring constant
    @friends   = others
    @me        = id      # Index of me in @friends
    @over      = false
    @move      = false
    
    # Spring simulation variables
    @velx      = 0.0     # X Velocity
    @vely      = 0.0     # Y Velocity
    @accel     = 0       # Acceleration
    @force     = 0       # Force
  end

  def update
    if (@move)
      @rest_posx = @app.mouse_x
      @rest_posy = @app.mouse_y
    end

    @force = -1 * @kin * (@tempypos - @rest_posy)   # f=-ky 
    @accel = @force / @mass                         # Set the acceleration, f=ma == a=f/m 
    @vely = @damp * (@vely + @accel);               # Set the velocity 
    @tempypos = @tempypos + @vely;                  # Updated position 

    @force = -1 * @kin * (@tempxpos - @rest_posx)   # f=-ky 
    @accel = @force / @mass;                        # Set the acceleration, f=ma == a=f/m 
    @velx = @damp * (@velx + @accel);               # Set the velocity 
    @tempxpos = @tempxpos + @velx;                  # Updated position 

    @over = ((over? || @move) && !other_over?)
  end

  # Test to see if mouse is over this spring
  def over?
    dis_x = @tempxpos - @app.mouse_x
    dis_y = @tempypos - @app.mouse_y
    Math::sqrt(@app.sq(dis_x) + @app.sq(dis_y)) < @size/2
  end

  # Make sure no other springs are active
  def other_over?
    @friends.each_with_index do |f, i|
      if (i != @me)
        if f.over?
          return true
        end
      end
    end
    return false
  end

  def display
    if (over?)
      @app.fill(153)
    else
      @app.fill(255)
    end
    @app.ellipse(@tempxpos, @tempypos, @size, @size)
  end

  def pressed
    @move = over?
  end

  def released
    @move = false 
    @rest_posx = @xpos
    @rest_posy = @ypos
  end
end

Springs.new(:width => 200, :height => 200, :title => "Springs", :full_screen => false)