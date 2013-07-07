

# Wave Gradient 
# by Ira Greenberg.  
# 
# Generate a gradient along a sin() wave.


def setup
  size 640, 360
  background 200  	
  angle     = 0.0
  px, py    = 0.0, 0.0
  amplitude = 30.0
  frequency = 0.0
  fill_gap  = 2.5
  
  (-75 ... height + 75).each do |i|
    angle = 0.0
    frequency += 0.002  		
    (width + 75).times do |j|
      py = i + sin( angle.radians ) * amplitude
      angle += frequency  			
      c = color((py-i).abs * 255 / amplitude,
        255 - (py-i).abs * 255 / amplitude,
        j * (255.0 / (width+50)))  			
      fill_gap.ceil.times do |filler|
        set j-filler, py.to_i-filler, c
        set j, py.to_i, c
        set j+filler, py.to_i+filler, c
      end
    end
  end  	
end
