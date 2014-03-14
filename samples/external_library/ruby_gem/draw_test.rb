##################################################
# Using the ai4r gem in ruby-processing.
# A simple example that demonstrates using
# a backpropagation neural network. Draw a
# shape and press 'e' or 'E' to evaluate it.
# Clear the sketch with 'c' or 'C'. Release
# mouse when drawing discontinous shape eg cross.
# Result is printed to console....
##################################################

require 'ai4r'
load_library :vecmath
require_relative 'training_patterns.rb'

attr_reader :img, :img_pixels, :ci_input, :cr_input, :tr_input, :sq_input, :net, :points

def setup
  size(320, 320)
  @points = []
  srand 1
  @net = Ai4r::NeuralNetwork::Backpropagation.new([256, 3])
  @tr_input = TRIANGLE.flatten.collect { |input| input.to_f / 127.0}
  @sq_input = SQUARE.flatten.collect { |input| input.to_f / 127.0}
  @cr_input = CROSS.flatten.collect { |input| input.to_f / 127.0}
  @ci_input = CIRCLE.flatten.collect { |input| input.to_f / 127.0}
  train  
  background 255
end


def draw
  stroke_weight 32	
  stroke 127
  points.each_cons(2) { |ps, pe| line ps.x, ps.y, pe.x, pe.y}
end

def train
  puts "Training Network Please Wait"
  101.times do |i|
    error = net.train(tr_input, [1.0, 0, 0])
    error = net.train(sq_input, [0, 1.0, 0])
    error = net.train(cr_input, [0, 0, 1.0])
    error = net.train(ci_input, [0, 1.0, 1.0])
    puts "Error after iteration #{i}:\t#{error}" if i%20 == 0
  end
end

def result_label(result)
  if result.inject(0, :+) > 1.9
    if result[0] < result[1] && result[0] < result[2]	  
      return "CIRCLE"
    else
      return "UNKNOWN"
    end	
  elsif result[0] > result[1] && result[0] > result[2]
    return "TRIANGLE"
  elsif result[1] > result[2] 
    return "SQUARE"
  elsif result[2] > result[0] && result[2] > result[1]    
    return "CROSS"
  else
    return "UNKNOWN"	  
  end
end

def mouse_dragged
  points << Vec2D.new(mouse_x, mouse_y)
end

def mouse_released
  points.clear
end

def key_pressed 
  case key  
  when 'e', 'E' # load pixels and evaluate shape
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
  when 'c', 'C'
  	background 255
  end
end
