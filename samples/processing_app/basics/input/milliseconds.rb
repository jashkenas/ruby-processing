require 'ruby-processing'

# A millisecond is 1/1000 of a second. 
# Processing keeps track of the number of milliseconds a program has run.
# By modifying this number with the modulo(%) operator, 
# different patterns in time are created.  

class Milliseconds < Processing::App

  def setup
    no_stroke
    @scale = width/10
  end
  
  def draw
  	@scale.times do |i|
  		color_mode RGB, (i+1) * @scale * 10
  		fill millis % ((i+1) * @scale * 10)
  		rect i*@scale, 0, @scale, height
  	end
  end
  
end

Milliseconds.new :title => "Milliseconds", :width => 200, :height => 200