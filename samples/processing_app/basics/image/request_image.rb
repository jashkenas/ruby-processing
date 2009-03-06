require 'ruby-processing'

# Request Image
# by Ira Greenberg. 
# From Processing for Flash Developers, Friends of ED, 2009. 
# 
# Shows how to use the request_image() function with preloader animation. 
# The request_image() function loads images on a separate thread so that 
# the sketch does not freeze while they load. It's very useful when you are
# loading large images, as this example demonstrates. 
# 
# To work, this example requires 10 images named dublin0.jpg ... dublin9.jpg 
# in the sketch data directory. To save space, these images are not included 
# with the example.

class RequestImage < Processing::App

  def setup
	  smooth
	  
	  @imgs = Array.new 10
	  @load_states = Array.new( @imgs.length, false )
	  @loader_x, @loader_y, @theta = 0.0, 0.0, 0.0
	
	  # Load images asynchronously
	  @imgs.length.times do |i|
		  @imgs[i] = request_image "dublin" + i.to_s + ".jpg"
	  end
  end
  
  def draw
  	background 0
  	
  	run_loader_animation
  	
	  # Check if individual images are fully loaded
	  @imgs.each_with_index do |img, i|
	  	# As images are loaded set true in boolean array
	  	@load_states[i] = (img.width != 0) && (img.width != -1)
	  end
	
	  # When all images are loaded draw them to the screen
	  if all_loaded?
	  	@img.each_with_index do |img, i|
	  		image( img, width/@imgs.length*i, 0, width/@imgs.length, height )
	  	end
	  end
  end
  
  # Loading animation
  def run_loader_animation
  	# Only run when images are loading
  	if all_loaded?
  		ellipse loader_x, loader_y, 10, 10
		loader_x += 2
		loader_y = height/2 + sin(theta) * (height/2.5)
		theta += PI/22
		
		# Reposition ellipse if it goes off the screen
		loader_x = -5 if loader_x > (width + 5)
  	end
  end
  
  # Return true when all images are loaded - no false values left in array
  def all_loaded?
  	@load_states.each { |state| return false unless state }
  	true
  end
end

RequestImage.new :title => "Request Image", :width => 800, :height => 60