# This sketch demonstrates how to create synthesized sound with Minim 
# using an AudioOutput and an Oscil. An Oscil is a UGen object, 
# one of many different types included with Minim. For many more examples 
# of UGens included with Minim, have a look in the Synthesis 
# folder of the Minim examples.
#

load_library 'minim'
include_package 'ddf.minim'
include_package 'ddf.minim.ugens'

attr_reader :minim, :out, :wave

def setup
  size(512, 200, P3D)  
  @minim = Minim.new(self)
  
  # use the getLineOut method of the Minim object to get an AudioOutput object
  @out = minim.get_line_out()
  
  # create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
  @wave = Oscil.new( 440, 0.5, Waves::SINE )
  # patch the Oscil to the output
  wave.patch(out)
end

def draw
  background(0)
  stroke(255)  
  # draw the waveforms
  (0 ... out.buffer_size - 1).step do |i|
    line( i, 50 + out.left.get(i)*50, i+1, 50 + out.left.get(i+1)*50 )
    line( i, 150 + out.right.get(i)*50, i+1, 150 + out.right.get(i+1)*50 )
  end
end
