#
# Handles. 
# 
# Click and drag the white boxes to change their position. 
#
H_SIZE = 10

attr_reader :handles

def setup
  size(640, 360)
  num = height/15
  @handles = []  
  num.times do |i|
    handles << Handle.new(width/2, 10 + i * 15, 50 - H_SIZE/2, 10, handles, width, height)
  end
end

def draw
  background(153)  
  handles.each do |handle|
    handle.update
    handle.display
  end  
  fill(0)
  rect(0, 0, width/2, height)
end

def mouse_released
  handles.each do |handle|
    handle.release_event
  end
end

class Handle
  attr_reader :x, :y, :boxx, :boxy, :stretch, :size, :over, :press
  attr_reader :others, :others_locked, :locked, :width, :height
  
  def initialize(ix, iy, il, is, o, width, height)
    @x = ix
    @y = iy
    @stretch = il
    @size = is
    @boxx = x + stretch - size/2
    @boxy = y - size/2
    @others = o
    @locked = false
    @others_locked = false
    @width = width
    @height = height
  end
  
  def update
    @boxx = x+stretch
    @boxy = y - size/2
    
    others.each do |other|
      if (other.locked == true)
        @others_locked = true
        break
      else
        @others_locked = false
      end
    end
    if (others_locked == false)
      over_event
      press_event
    end
    if (press)
      @stretch = lock(mouse_x - width/2 - size/2, 0, width/2-size-1)
    end
  end
  
  def over_event
    @over = over_rect?(boxx, boxy, size, size)
  end
  
  def press_event
    if (over && mouse_pressed? || locked)
      @press, @locked = true, true
    else
      @press = false
    end
  end
  
  def release_event
    @locked = false
  end
  
  def display
    line(x, y, x+stretch, y)
    fill(255)
    stroke(0)
    rect(boxx, boxy, size, size)
    if (over || press)
      line(boxx, boxy, boxx + size, boxy + size)
      line(boxx, boxy + size, boxx + size, boxy)
    end    
  end 
  
  def over_rect?(x, y, width, height)
    (mouse_x >= x && mouse_x <= x + width && mouse_y >= y && mouse_y <= y + height)
  end
  
  def lock(val, minv, maxv) 
    min(max(val, minv), maxv) 
  end 
end
