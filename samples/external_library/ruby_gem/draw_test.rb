#####################################################################
# Using the ai4r gem in ruby-processing.
# A simple example that demonstrates using
# a backpropagation neural network. Use the drop box menu to
# select a prebuilt shape. To draw a test shape tick drawing checkbox,
# release the mouse when drawing a discontinous shape eg cross.
# Clear the sketch with clear button. 
# Press evaluate and result is printed to the console....
####################################################################

require 'ai4r'
require 'json'

load_library :vecmath, :control_panel

attr_reader  :img, :img_pixels, :ci_input, :cr_input, :tr_input, :sq_input, :net, :points, :panel, :hide, :drawing, :source_string

def setup
  size(320, 320)
  control_panel do |c|
    c.title = "control"
    c.look_feel "Nimbus"
    c.checkbox :drawing
    c.button :clear
    c.button :evaluate
    c.menu :shape, ['CIRCLE', 'CROSS', 'CROSS_WITH_NOISE', 'SQUARE', 'SQUARE_WITH_NOISE', 'TRIANGLE', 'DEFAULT']
    @panel = c
  end
  @hide = false
  @source_string = open("data/data.json", "r"){ |file| file.read }
  triangle = JSON.parse(source_string)["TRIANGLE"]
  square = JSON.parse(source_string)["SQUARE"]
  cross = JSON.parse(source_string)["CROSS"]
  circle = JSON.parse(source_string)["CIRCLE"]
  @points = []
  srand 1
  @net = Ai4r::NeuralNetwork::Backpropagation.new([256, 3])
  @tr_input = triangle.flatten.collect { |input| input.to_f / 127.0}
  @sq_input = square.flatten.collect { |input| input.to_f / 127.0}
  @cr_input = cross.flatten.collect { |input| input.to_f / 127.0}
  @ci_input = circle.flatten.collect { |input| input.to_f / 127.0}
  train  
  background 255
end


def draw
  # only make control_panel visible once, or again when hide is false
  unless hide
    @hide = true
    panel.set_visible(hide)    
  end
  if drawing
    stroke_weight 32	
    stroke 127
    points.each_cons(2) { |ps, pe| line ps.x, ps.y, pe.x, pe.y}
  else    
    no_fill
    stroke_weight(32)
    stroke(127)
    case @shape
    when 'CIRCLE'
      background(255)
      draw_circle
      @shape = 'DEFAULT'
    when 'CROSS'
      background(255)
      draw_cross      
      @shape = 'DEFAULT'
    when 'CROSS_WITH_NOISE','SQUARE_WITH_NOISE'
      background(255)
      draw_shape @shape
      @shape = 'DEFAULT'
    when 'SQUARE'
      background(255)
      draw_square
      @shape = 'DEFAULT'
    when 'TRIANGLE'
      background(255)
      draw_triangle
      @shape = 'DEFAULT'
    end
  end
end

def draw_shape shp
  shape = JSON.parse(source_string)[shp]
  background(255)
  no_stroke
  (0  ... width / 20).each do |i|
    (0  ... height / 20).each do |j|
      col = 255 - shape[i][j]
      fill(col)
      rect(i * 20, j * 20,  20,  20)
    end
  end
end

def train
  puts "Training Network Please Wait"
  101.times do |i|
    error = net.train(tr_input, [1.0, 0, 0])
    error = net.train(sq_input, [0, 1.0, 0])
    error = net.train(cr_input, [0, 0, 1.0])
    error = net.train(ci_input, [0, 1.0, 1.0])
    puts "Error after iteration #{i}:\t#{format('%0.5f', error)}" if i%20 == 0
  end
end

def result_label(result)
  if result.inject(0, :+).between?(1.9, 2.1)
    if result[0] < 0.01 && result[1].between?(0.99, 1.0) && result[2].between?(0.99, 1.0)
      return "CIRCLE"
    else
      return "UNKNOWN"
    end
  elsif result.inject(0, :+).between?(0.95, 1.1)
    if result[0].between?(0.95, 1.0) && (result[1] + result[2]) < 0.01
      return "TRIANGLE"
    elsif result[1].between?(0.95, 1.0) && (result[0] + result[2]) < 0.01
      return "SQUARE"
    elsif result[2].between?(0.95, 1.0) && (result[1] + result[0]) < 0.01
      return "CROSS"
    else
      return "UNKNOWN"	  
    end
  end
  return "UNKNOWN"
end

def mouse_dragged
  points << Vec2D.new(mouse_x, mouse_y)
end

def mouse_released
  points.clear
end

def draw_circle
  ellipse(width / 2, height / 2, 320 - 32, 320 - 32)
end

def draw_square
  rect(16, 16, 320 - 32, 320 - 32)
end

def draw_cross
  line(width / 2, 0, width / 2, 320)
  line(0, height / 2,  320 , height / 2)
end

def draw_triangle
  triangle(width / 2, 32, 24, height - 16,  width - 24, height - 16)
end

def clear
  background 255
end

def evaluate    
  load_pixels
  img_pixels = []
  (0...height).step(20) do |y|
    row = []
    (0...width).step(20) do |x|
      row << 255 - brightness(pixels[(y + 10) * width + x + 10])
    end
    img_pixels << row
  end  	
  puts "#{net.eval(img_pixels.flatten).inspect} => #{result_label(net.eval(img_pixels.flatten))}"   	
end
