#
# Pixel Array. 
# 
# Click and drag the mouse up and down to control the signal and 
# press and hold any key to see the current pixel being read. 
# This program sequentially reads the color of every pixel of an image
# and displays this color to fill the window.  
#

 

attr_reader :signal, :img, :direction

def setup
  size(640, 360)
  no_fill
  stroke(255)
  frame_rate(30)
  @img = load_image("sea.jpg")
  @direction = 1
  @signal = 0
end

def draw
  if (signal > img.width * img.height - 1 || signal < 0)
    @direction = direction * -1 
  end

  if (mousePressed) 
    mx = constrain(mouse_x, 0, img.width-1)
    my = constrain(mouse_y, 0, img.height-1)
    @signal = my * img.width + mx
  else 
    @signal += 0.33 * direction
  end

  sx = signal.to_i % img.width
  sy = signal.to_i / img.width

  if (keyPressed) 
    set(0, 0, img)  # fast way to draw an image
    point(sx, sy)
    rect(sx - 5, sy - 5, 10, 10)
  else 
    c = img.get(sx, sy)
    background(c)
  end
end
