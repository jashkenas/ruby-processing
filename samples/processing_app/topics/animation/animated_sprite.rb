#
# Animated Sprite (Shifty + Teddy)
# by James Paterson, rubified by Martin Prout. 
# 
# Hold down the mouse button to change animations.
# Demonstrates loading, displaying, and animating GIF images.
# It would be easy to write a program to display 
# animated GIFs, but would not allow as much control over 
# the display sequence and rate of display. 
#

DRAG = 30.0
attr_reader :xpos, :ypos, :animation1, :animation2

def setup
  size(640, 360)
  background(255, 204, 0)
  frame_rate(24)
  @animation1 = Animation.new('PT_Shifty_', 38)
  @animation2 = Animation.new('PT_Teddy_', 60)
  @ypos = height * 0.25
  @xpos = 0
end

def draw 
  dx = mouse_x - xpos
  @xpos = xpos + dx / DRAG
  # Display the sprite at the position xpos, ypos
  if mouse_pressed?
    background(153, 153, 0)
    animation1.display(xpos - animation1.get_width / 2, ypos)
  else
    background(255, 204, 0)
    animation2.display(xpos - animation2.get_width / 2, ypos)
  end
end

class Animation 
  attr_reader :images, :image_count, :frame
  
  def initialize(image_prefix, count)
    @image_count = count
    @frame = 0
    @images = (0 ... image_count).map { 
    |i| load_image(format('%s%04d%s', image_prefix, i, '.gif')) 
    }
  end

  def display(xpos, ypos)
    @frame = (frame + 1) % image_count
    image(images[frame], xpos, ypos)
  end
  
  def get_width
    images[0].width
  end
end
