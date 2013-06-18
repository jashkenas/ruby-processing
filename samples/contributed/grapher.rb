# Grapher is based on a context free art design
# by ColorMeImpressed (takes a bit of time to run)
# http://www.contextfreeart.org/gallery/view.php?id=2844
#

CMIN = -2.0 # Important to specify float else get random int from range?
CMAX = 2.0
FUZZ = 0.04
SZ = 5

def setup
  size 600, 600    
  no_stroke
  color_mode(HSB, 1.0)
  background(0)
  frame_rate(4000)
end

def draw
  translate(width/2, height/2)
  dot(rand(-PI .. PI), rand(-PI .. PI), rand(CMIN .. CMAX)) unless frame_count > 200000
end

def dot(px, py, c)    
  func = sin(px) + sin(py) + c
  # change function to change the graph eg.
  #func = sin(px) + tan(py) + c    
  #func = cos(px) + sin(py) + c
  if func.abs <= FUZZ
    fill(((CMIN - c) / (CMIN - CMAX)), 1, 1)
    ellipse px * width / TWO_PI, py * height / TWO_PI, SZ, SZ
  else
    dot(rand(-PI .. PI), rand(-PI .. PI), rand(CMIN .. CMAX))
  end
end
