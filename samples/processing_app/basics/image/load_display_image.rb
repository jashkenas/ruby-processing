# Images can be loaded and displayed to the screen at their actual size
# or any other size. 


def setup
  size 640, 360
  # The file "jelly.jpg" must be in the data folder
  # of the current sketch to load successfully
  @a = load_image "jelly.jpg"    
  no_loop # Makes draw only run once
end

def draw
  # Displays the image at its actual size at point (0,0)
  image @a, 0, 0
  # Displays the image at point (@a.width, 0) at half of its size
  image @a, @a.width, 0, @a.width/2, @a.height/2
end
