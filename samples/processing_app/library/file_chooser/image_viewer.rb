load_library :file_chooser
attr_reader :img

###########
# Example file chooser (in this case an image file chooser).
# We delay setting size of sketch until we know image size, probably
# would not work vanilla processing. Note we can wrap much code in the
# file_chooser block, no need for reflection. As with selectInput vanilla
# processing.
###########

def setup
  file_chooser do |fc|
    fc.set_filter "Image Files",  [".png", ".jpg"] # easily customizable chooser
    @img = load_image(fc.display)                  # fc.display returns a path String
    size(img.width, img.height)
  end
end

def draw
  background img                                  # img must be same size as sketch
end

