#
# Esfera
# by David Pena.  
# Somewhat re-factored for ruby-processing
# by Martin Prout
# Distribucion aleatoria uniforme sobre la superficie de una esfera. 
#
load_library :vecmath


QUANTITY = 16000 

attr_reader :orb, :phi, :radius, :rx, :ry

# signature-specific aliases for overloaded methods
java_alias :background_int, :background, [Java::int]
java_alias :fill_int, :fill, [Java::int]
java_alias :stroke_int, :stroke, [Java::int]
java_alias :stroke_float_float, :stroke, [Java::float, Java::float]

def setup
  size(800, 600, P3D)
  ArcBall.init(self, width / 2.0, height / 2.0)
  @rx = 0
  @ry =0
  no_smooth
  @radius = height/3.5
  @orb = HairyOrb.new(self, radius)
  QUANTITY.times do
    orb << HairFactory.create_hair(radius) 
  end
  noise_detail(3)
end

def draw
  background_int(0)
#  translate(width/2,height/2)
#  rxp = ((mouse_x - (width/2))*0.005)
#  ryp = ((mouse_y - (height/2))*0.005)
#  @rx = (rx*0.9)+(rxp*0.1)
#  @ry = (ry*0.9)+(ryp*0.1)
#  rotate_y(rx)
#  rotate_x(ry)
  fill_int 0
  no_stroke
  sphere(radius)
  orb.render
  if (frame_count % 10 == 0)
    puts(frame_rate)
  end
end

class HairyOrb 
  extend Enumerable
  attr_reader :app, :hairs, :radius
  
  def initialize app, radius
    @app, @radius = app, radius
    @hairs = []    
  end
  
  def << item
    hairs << item
  end      
  
  def render   
    hairs.each do |hair|
      off = (app.noise(app.millis() * 0.0005, sin(hair.phi)) - 0.5) * 0.3
      offb = (app.noise(app.millis() * 0.0007, sin(hair.z) * 0.01) - 0.5) * 0.3
      thetaff = hair.theta + off
      costhetaff = cos(thetaff)
      coshairtheta = cos(hair.theta)
      phff = hair.phi + offb
      x = radius * coshairtheta * cos(hair.phi)
      y = radius * coshairtheta * sin(hair.phi)
      za = radius * sin(hair.theta)
      xo = radius * costhetaff * cos(phff)
      yo = radius * costhetaff * sin(phff)
      zo = radius * sin(thetaff)
      xb, yb, zb = xo * hair.len, yo * hair.len, zo * hair.len
      app.stroke_weight(1)
      app.begin_shape(LINES)
      app.stroke_int(0)
      app.vertex(x, y, za)
      app.stroke_float_float(200, 150)
      app.vertex(xb, yb, zb)
      app.end_shape()
    end 
  end
end

class HairFactory 
  def self.create_hair radius
    z = rand(-radius .. radius)
    phi = rand(0 .. TAU)
    len = rand(1.15 .. 1.2)
    theta = Math.asin(z / radius) 
    return Hair.new(z, phi, len, theta)
  end 
end

class Hair
  attr_reader :z, :phi, :len, :theta  
  def initialize z, phi, len, theta 
    @z, @phi, @len, @theta = z, phi, len, theta 
  end
end
