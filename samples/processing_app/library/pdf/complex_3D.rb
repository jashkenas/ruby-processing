# 
#  Geometry 
#  by Marius Watz. 
#  
load_library 'pdf'
include_package 'processing.pdf'

attr_reader :num, :pt, :style, :dosave

def setup
  size(1024, 768, P3D)  
  background(255)
  @dosave = false
  @num = 150
  @pt = []
  @style = []
  
  # Set up arc shapes
  index = 0
  (0 ... num).each do |i|
    pt.push(rand(TWO_PI)) # Random X axis rotation
    pt.push(rand(TWO_PI)) # Random Y axis rotation
    
    pt.push(rand(60 .. 80)) # Short to quarter-circle arcs
    if (rand(100)>90)
      pt[pt.length - 1] = rand(8 .. 27) * 10
    end     
    pt.push(rand(2 .. 50) * 5) # Radius. Space them out nicely
    
    pt.push(rand(4 .. 32)) # Width of band
    if (rand(100) > 90)
      pt[pt.length - 1] = rand(40 .. 60) # Width of band
    end
    
    pt.push(rand(0.005 .. 0.0334))# Speed of rotation
    
    # get colors
    prob = rand(100)
    if (prob < 30)
      style[i*2] = color_blended(rand, 255,0,100, 255,0,0, 210)
    elsif(prob < 70) 
      style[i*2] = color_blended(rand, 0,153,255, 170,225,255, 210)
    elsif(prob<90) 
      style[i*2] = color_blended(rand, 200,255,0, 150,255,0, 210)
    else 
      style[i*2] = color(255,255,255, 220)
    end
    
    if (prob < 50)
      style[i*2] = color_blended(rand, 200,255,0, 50,120,0, 210)
    elsif(prob < 90)
      style[i*2] = color_blended(rand, 255,100,0, 255,255,0, 210)
    else
      style[i*2] = color(255, 255, 255, 220)
      style[i*2+1] = rand(100) % 3
    end
  end
end

def draw 
  if(dosave) 
    # set up PGraphicsPDF for use with beginRaw
    pdf = begin_raw(PDF, "pdf_complex_out.pdf")
    # set default Illustrator stroke styles and paint background rect.
    pdf.stroke_join(MITER)
    pdf.stroke_cap(SQUARE)
    pdf.fill(0)
    pdf.no_stroke
    pdf.rect(0,0, width,height)
  end
  background(0)    
  index = 0
  translate(width/2, height/2, 0)
  rotate_x(PI/6)
  rotate_y(PI/6)    
  (0 ... num).each do |i|
    push_matrix        
    rotate_x(pt[index])
    rotate_y(pt[index + 1])
    index += 2
    if (style[i*2+1] == 0)
      stroke(style[i*2])
      no_fill
      stroke_weight(1)
      arc_line(0,0, pt[index],pt[index + 1],pt[index + 2])
      index += 3
    elsif (style[i*2+1] == 1)
      fill(style[i*2])
      no_stroke
      arc_line_bars(0,0, pt[index],pt[index + 1],pt[index + 2])
      index += 3
    else
      fill(style[i*2])
      no_stroke      
      arc(0,0, pt[index],pt[index + 1],pt[index + 2])
      index += 3
    end
    # increase rotation
    pt[index-5] += pt[index] / 10
    pt[index-4] += pt[index] / 20
    index += 1
    pop_matrix
  end
  if (dosave)
    end_raw
    @dosave=false
  end
end


# Get blend of two colors
def color_blended(fract, r, g, b, r2, g2, b2, a) 
  r2 = (r2 - r)
  g2 = (g2 - g)
  b2 = (b2 - b)
  return color(r + r2 * fract, g + g2 * fract, b + b2 * fract, a)
end


# Draw arc line
def arc_line(x, y, deg, rad, w) 
  a=(deg < 360)? deg : 0
  numlines = w/2    
  (0 ... numlines).each do 
    begin_shape
    (0 ... a).each do |i|                 
      vertex(cos(i.radians)*rad+x,sin(i.radians)*rad+y)
    end
    end_shape 
    rad += 2        
  end
end

# Draw arc line with bars
def arc_line_bars(x, y, deg, rad, w) 
  a=(deg < 360)? deg / 16 : 0   
  begin_shape(QUADS)
  (0 ... a).step(4) do |i|
    vertex(cos(i.radians)*(rad)+x,sin(i.radians)*(rad)+y)
    vertex(cos(i.radians)*(rad+w)+x,sin(i.radians)*(rad+w)+y)
    vertex(cos((i + 2).radians)*(rad+w)+x,sin((i + 2).radians)*(rad+w)+y)
    vertex(cos((i + 2).radians)*(rad)+x,sin((i + 2).radians)*(rad)+y)
  end
  end_shape
end
  
# Draw solid arc
def arc(x,y,deg,rad,w) 
  a = (deg < 360)? deg : 0
  begin_shape(QUAD_STRIP)
  (0 ... a).each do |i|
    vertex(cos(i.radians)*(rad)+x,sin(i.radians)*(rad)+y)
    vertex(cos(i.radians)*(rad+w)+x,sin(i.radians)*(rad+w)+y)
  end
  end_shape
end

def mouse_pressed
  @dosave = true
end
