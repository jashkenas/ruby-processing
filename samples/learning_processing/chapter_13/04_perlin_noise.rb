require 'ruby-processing'

class PerlinNoiseSketch < Processing::App
  def setup
    smooth
    @time = 0.0
    @increment = 0.01
  end
  
  def draw
    background 255

    n = $app.noise(@time) * $app.width
    @time += @increment
    $app.fill 0
    $app.ellipse $app.width/2, $app.height/2, n, n
  end

end


PerlinNoiseSketch.new :title => "Perlin Noise", :width => 400, :height => 400
