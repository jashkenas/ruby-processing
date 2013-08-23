load_library :file_chooser
attr_reader :img

###########
# example file chooser (in this case image file chooser) 
# note image loading and resizing encapsulated in the block.
# borrows heavily off control_panel. 
###########

def setup
  size 600, 600 
  file_chooser do |fc|
    fc.look_feel "Nimbus" 
    fc.set_filter "Image Files",  [".png", ".jpg"]
    my_file = fc.display
    @img = load_image(my_file)
    img.resize(width, height)
    fc.dispose
  end
end

def draw
  image img, 0, 0
end
