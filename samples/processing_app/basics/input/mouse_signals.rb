# Move and click the mouse to generate signals. 
# The top row is the signal from "mouseX", 
# the middle row is the signal from "mouseY",
# and the bottom row is the signal from "mousePressed". 


def setup
  size 640, 360
  @xvals = Array.new width, 0
  @yvals = Array.new width, 0
  @bvals = Array.new width, 0
end

def draw
  background 102
  no_smooth
  width.times do |i|
    @xvals[i] = @xvals[i + 1]
    @yvals[i] = @yvals[i + 1]
    @bvals[i] = @bvals[i + 1]
  end
  
  @xvals[width-1], @yvals[width-1] = mouse_x, mouse_y
  @bvals[width-1] = mouse_pressed? ? 0 : 200
	
  fill 255
  no_stroke
  rect 0, height/3, width, height/3+1
  stroke_weight 2
  (1...width).each do |i|
    stroke 255
    point i, @xvals[i] / 3
    stroke 0
    point i, height / 3+@yvals[i] / 3
    stroke 255
    line i, 2*height/3+@bvals[i] / 3, i, 2*height/3+@bvals[i-1] / 3
	end
end


