########################################################
# A 3D Hilbert fractal implemented using a
# Lindenmayer System in ruby-processing by Martin Prout
#
# Use right mouse button drag or mousewheel for 
# zoom even then needs a customised forked peasycam to work
########################################################


load_libraries :hilbert, :peasycam
include_package 'peasy'
attr_reader :hilbert, :cam

def setup
  size displayWidth, displayHeight, P3D
  configure_peasycam
  @hilbert = Hilbert.new(height/10)
  hilbert.create_grammar 3
  no_stroke
end

def configure_peasycam
  @cam = PeasyCam.new self, height / 6.5
  cam.set_minimum_distance height / 10
  cam.set_maximum_distance height
end

def draw
  background 0
  lights
  hilbert.render
end


