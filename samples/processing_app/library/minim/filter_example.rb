# filterExample
# is an example of using the different filters
# in continuous sound.
# 
# author: Damien Di Fede, Anderson Mills
# Anderson Mills's work was supported by numediart (www.numediart.org)

load_library 'minim'
include_package 'ddf.minim'
include_package 'ddf.minim.ugens'
# the effects package is needed because the filters are there for now.
include_package 'ddf.minim.effects'

attr_reader :minim, :out, :filt, :osc, :cut_osc, :cutoff

def setup
  size(300, 200, P2D)  
  @minim = Minim.new(self)
  
  # use the getLineOut method of the Minim object to get an AudioOutput object
  @out = minim.get_line_out
  
  # initialize the oscillator 
  # (a sawtooth wave has energy across the spectrum)
  @osc = Oscil.new(500, 0.2, Waves::SAW)
  # uncoment one of the filters to hear it's effect
  # @filt = LowPassSP.new(400, out.sample_rate)
  # @filt = LowPassFS.new(400, out.sample_rate)
  @filt = BandPass.new(400, 100, out.sample_rate)
  # @filt = HighPassSP.new(400, out.sample_rate)
  # @filt = NotchFilter.new(400, 100, out.sample_rate)
  
  # create an Oscil we will use to modulate 
  # the cutoff frequency of the filter.
  # by using an amplitude of 800 and an
  # offset of 1000, the cutoff frequency 
  # will sweep between 200 and 1800 Hertz.
  @cut_osc = Oscil.new(1, 800, Waves::SINE)
  # offset the center value of the Oscil by 1000
  cut_osc.offset.set_last_value( 1000 )

  # patch the oscil to the cutoff frequency of the filter
  cut_osc.patch(filt.cutoff)
  
  # patch the sawtooth oscil through the filter and then to the output
  osc.patch(filt).patch(out)
end

def draw
  background(0)
  stroke(255)  
  # draw the waveforms
  (0 ... out.buffer_size - 1).step do |i|
    # find the x position of each buffer value  
    x1  =  map( i, 0, out.buffer_size, 0, width )
    x2  =  map( i+1, 0, out.buffer_size, 0, width )
    # draw a line from one buffer position to the next for both channels
    line( x1, 50 + out.left.get(i)*50, x2, 50 + out.left.get(i+1)*50)
    line( x1, 150 + out.right.get(i)*50, x2, 150 + out.right.get(i+1)*50)
  end
end




