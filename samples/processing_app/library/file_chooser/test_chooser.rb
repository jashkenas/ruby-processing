load_library :file_chooser
attr_reader :choose, :my_file, :img

###########
# example file chooser (in this case image file chooser) you could
# of course encapsulate image loading and resising in the block
###########

def setup
  size 600, 600 
  file_chooser do |fc|
    fc.look_feel "Nimbus" 
    fc.set_filter "Image Files",  [".png", ".jpg"]
    @my_file = fc.display
  end
  @img = load_image(my_file.to_s)
  img.resize(width, height)
end

def draw
  image img, 0, 0
end
