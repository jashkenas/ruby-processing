# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com

# XOR Multi-Layered Neural Network Example
# Neural network code is all in the "code" folder
load_library :nn

require_relative './landscape'
include_package 'nn'

ITERATIONS_PER_FRAME = 5

attr_reader :inputs, :nn, :count, :land, :theta, :f, :result, :known


def setup
  
  size(400, 400, P3D)
  @theta = 0.0
  # Create a landscape object
  @land = Landscape.new(20, 300, 300)
  @f = create_font("Courier", 12, true)
  
  @nn = Network.new(2, 4)
  @count = 0
  # Create a list of 4 training inputs
  @inputs = []
  inputs << [1.0, 0]
  inputs << [0, 1.0] 
  inputs << [1.0, 1.0] 
  inputs << [0, 0.0]
end

def draw  
  lights  
  ITERATIONS_PER_FRAME.times do |i|
    inp = inputs.sample
    # Compute XOR    
    @known = ((inp[0] > 0.0 && inp[1] > 0.0) || (inp[0] < 1.0 && inp[1] < 1.0))? 0 : 1.0 
    
    # Train that sucker!
    @result = nn.train(inp, known)
    @count += 1
  end 
  
  # Ok, visualize the solution space
  background(175)
  push_matrix
  translate(width / 2, height / 2 + 20, -160)
  rotate_x(Math::PI / 3)
  rotate_z(theta)
  
  # Put a little BOX on screen
  push_matrix
 
  stroke(50)
  no_fill
  translate(-10, -10, 0)
  box(280)
  land.calculate(nn)
  land.render
  # Draw the landscape
  pop_matrix
   
  @theta += 0.0025
  pop_matrix
  
  # Display overal neural net stats
  network_status  
end  

def network_status
  mse = 0.0  
  text_font(f)
  fill(0)
  text("Your friendly neighborhood neural network solving XOR.", 10, 20)
  text("Total iterations: #{count}", 10, 40)
  mse += (result - known) * (result - known)    
  rmse = Math::sqrt(mse / 4.0)
  out = "Root mean squared error: #{format("%.5f", rmse)}"
  hint DISABLE_DEPTH_SORT
  text(out, 10, 60) 
  hint ENABLE_DEPTH_SORT
end



