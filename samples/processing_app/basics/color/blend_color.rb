# example of processing blend_color (uses PImage blend_color under the hood)
# blend_color(c1, c2, MODE) returns a color int

def setup
  size 100, 100
  orange = color(204, 102, 0)
  blue = color(0, 102, 153)
  orangeblueadd = blend_color(orange, blue, ADD)
  background(51)
  noStroke()
  fill(orange)
  rect(14, 20, 20, 60)
  fill(orangeblueadd)
  rect(40, 20, 20, 60)
  fill(blue)
  rect(66, 20, 20, 60)
end
