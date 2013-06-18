#
# Puff  
# by Ira Greenberg.  
# 
# Series of ellipses simulating a multi-segmented 
# organism, utilizing a follow the leader algorithm.
# Collision detection occurs on the organism's head, 
# controlling overall direction, and on the individual 
# body segments, controlling body shape and jitter.
#

CELLS = 1000
attr_accessor :px, :py, :speed_x, :speed_y
attr_reader :radii_x, :radii_y, :angle, :frequency, :cell_radius, :head_x, :head_y

def setup  
  size(640, 360)
  # Begin in the center
  @head_x = width/2
  @head_y = height/2
  @speed_x = 0.7
  @speed_y = 0.9
  # Fill body arrays
  @radii_x = Array.new(CELLS, rand(-7 .. 7)) 
  @radii_y = Array.new(CELLS, rand(-7 .. 7) )
  @frequency = Array.new(CELLS, rand(-7 .. 7) )
  @cell_radius= Array.new(CELLS, rand(16 .. 30) )
  @angle = Array.new(CELLS, 0)
  @px = Array.new(CELLS, 0)
  @py = Array.new(CELLS, 0)
  frameRate(30)
end

def draw
  background(0)
  no_stroke
  fill(255, 255, 255, 5)
  
  # Follow the leader
  (0 ... CELLS).each do |i|
    if (i == 0)
      px[i] = head_x + sin(radians(angle[i]))*radii_x[i]
      py[i] = head_y + cos(radians(angle[i]))*radii_y[i]
    else
      px[i] = px[i-1] + cos(radians(angle[i]))*radii_x[i]
      py[i] = py[i-1] + sin(radians(angle[i]))*radii_y[i]
      
      # Check collision of body
      if ((px[i] >= width-cell_radius[i] / 2) || (px[i] <= cell_radius[i] / 2))
        radii_x[i]*=-1
        cell_radius[i] = random(1, 40)
        frequency[i]= random(-13, 13)
      end
      if ((py[i] >= height-cell_radius[i] / 2) || (py[i] <= cell_radius[i] / 2))
        radii_y[i]*=-1
        cell_radius[i] = random(1, 40)
        frequency[i]= random(-9, 9)
      end
    end
    # Draw puff
    ellipse(px[i], py[i], cell_radius[i], cell_radius[i])
    # Set speed of body
    angle[i] += frequency[i]
  end
  
  # Set velocity of head
  @head_x += speed_x
  @head_y += speed_y
  
  # Check boundary collision of head
  if ((head_x >= width-cell_radius[0] / 2) || (head_x <=cell_radius[0] / 2))
    @speed_x*=-1
  end
  if ((head_y >= height-cell_radius[0] / 2) || (head_y <= cell_radius[0] / 2))
    @speed_y*=-1
  end
end

