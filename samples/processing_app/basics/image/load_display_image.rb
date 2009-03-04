require 'ruby-processing'

# Images can be loaded and displayed to the screen at their actual size
# or any other size. 

class LoadDisplayImage < Processing::App

  def setup
    # The file "jelly.jpg" must be in the data folder
  	# of the current sketch to load successfully
    @a = load_image "jelly.jpg"
    
    no_loop # Makes draw only run once
  end
  
  def draw
  	# Displays the image at its actual size at point (0,0)
  	image @a, 0, 0
	  # Displays the image at point (100, 0) at half of its size
  	image @a, 100, 0, @a.width/2, @a.height/2
  end
  
end

LoadDisplayImage.new :title => "Load Display Image", :width => 200, :height => 200