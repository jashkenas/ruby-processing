
# LoadFile 1
# 
# Loads a text file that contains two numbers separated by a tab ('\t').
# A new pair of numbers is loaded each frame and used to draw a point on the screen.
#

attr_reader :points, :count
X, Y = 0, 1

def setup
  size(200, 200)
  background(0)
  stroke(255)
  stroke_weight 3
  frame_rate(12)
  @count = 0
  @points = []
  # The use of vanilla processing load_strings convenience method is
  # of dubious value in ruby processing when you can do this
  
  File.open("data/positions.txt").each_line do |line|
    points << line.split(/\t/).map! { |i| i.to_i * 2 }
  end    
end

def draw
  if count < points.size
    point(points[count][X], points[count][Y]) 
    @count += 1 
  end
end
