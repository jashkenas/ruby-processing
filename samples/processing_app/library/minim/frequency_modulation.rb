
# frequencyModulation
# <p>
# A simple example for doing FM (frequency modulation) using two Oscils. 
# Use the mouse to control the speed and range of the frequency modulation.
# <p>  
# Author: Damien Di Fede 

load_library 'minim'
include_package 'ddf.minim'
include_package 'ddf.minim.ugens'

attr_reader :minim, :out, :fm, :wave

def setup
  size(512, 200, P3D)  
  @minim = Minim.new(self)
  
  # use the getLineOut method of the Minim object to get an AudioOutput object
  @out = minim.get_line_out()
  # make the Oscil we will hear.
  # arguments are frequency, amplitude, and waveform
  @wave = Oscil.new( 200, 0.8, Waves::TRIANGLE )
  
  # make the Oscil we will use to modulate the frequency of wave.
  # the frequency of this Oscil will determine how quickly the
  # frequency of wave changes and the amplitude determines how much.
  # since we are using the output of fm directly to set the frequency 
  # of wave, you can think of the amplitude as being expressed in Hz.
  @fm = Oscil.new( 10, 2, Waves::SINE )
  
  # set the offset of fm so that it generates values centered around 200 Hz
  fm.offset.set_last_value( 200 )
  # patch it to the frequency of wave so it controls it
  fm.patch( wave.frequency )
  # and patch wave to the output
  wave.patch( out )
  # patch the Oscil to the output
  wave.patch(out)
end

def draw
  background(0)
  stroke(255)  
  # draw the waveforms
  (0 ... out.buffer_size - 1).step do |i|
    # find the x position of each buffer value  
    x1  =  map( i, 0, out.buffer_size(), 0, width )
    x2  =  map( i+1, 0, out.buffer_size(), 0, width )
    # draw a line from one buffer position to the next for both channels
    line( x1, 50 + out.left.get(i)*50, x2, 50 + out.left.get(i+1)*50)
    line( x1, 150 + out.right.get(i)*50, x2, 150 + out.right.get(i+1)*50)
  end
end


# we can change the parameters of the frequency modulation Oscil
# in real-time using the mouse.
def mouse_moved
  modulate_amount = map( mouse_y, 0, height, 220, 1 )
  modulate_frequency = map( mouse_x, 0, width, 0.1, 100 )  
  fm.frequency.set_last_value( modulate_frequency )
  fm.amplitude.set_last_value( modulate_amount )
end
