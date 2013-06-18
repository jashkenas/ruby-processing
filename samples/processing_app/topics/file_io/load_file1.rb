
# LoadFile 1
# 
# Loads a text file that contains two numbers separated by a tab ('\t').
# A new pair of numbers is loaded each frame and used to draw a point on the screen.
#

attr_reader :lines, :count

def setup
  size(200, 200)
  background(0)
  stroke(255)
  stroke_weight 3
  frame_rate(12)
  @count = 0
  @lines = []
  # The use of vanilla processing load_strings convenience method is
  # of dubious value in ruby processing, uncomment following to try it.
  #@lines = load_strings("positions.txt".to_java)  
  File.read("data/positions.txt").each_line do |line|
    lines << line.chop
  end
end

def draw
  if count < lines.length
    pieces = lines[count].scan(/\d+/)  
    point(Integer(pieces[1][0]) * 5, Integer(pieces[1][1]) * 5) if (pieces.length == 2)
  end
  @count += 1
end
