#
# Esfera
# by David Pena.  
# Somewhat re-factored for ruby-processing
# by Martin Prout
# Distribucion aleatoria uniforme sobre la superficie de una esfera. 
#


QUANTITY = 16000 

attr_reader :orb, :phi, :radius, :rx, :ry

def setup
  size(800, 600, P3D)
  @rx = 0
  @ry =0
  no_smooth
  @radius = height/3.5
  @orb = HairyOrb.new
  QUANTITY.times do
    orb << HairFactory.create_hair(radius)
  end
end

def draw
  background(0)
  translate(width/2,height/2)
  rxp = ((mouse_x - (width/2))*0.005)
  ryp = ((mouse_y - (height/2))*0.005)
  @rx = (rx*0.9)+(rxp*0.1)
  @ry = (ry*0.9)+(ryp*0.1)
  rotate_y(rx)
  rotate_x(ry)
  fill(0)
  no_stroke
  sphere(radius)
  orb.render self, radius
  if (frame_count % 10 == 0)
    puts(frame_rate)
  end
end

class HairyOrb < Array
	include Processing::Proxy
	
	def render app, radius
		@app = app
		each do |hair|
			off = (app.noise(app.millis() * 0.0005, sin(hair.phi)) - 0.5) * 0.3
			offb = (app.noise(app.millis() * 0.0007, sin(hair.z) * 0.01) - 0.5) * 0.3
			thetaff = hair.theta + off
			phff = hair.phi + offb
			x = radius * cos(hair.theta) * cos(hair.phi)
			y = radius * cos(hair.theta) * sin(hair.phi)
			za = radius * sin(hair.theta)
			xo = radius * cos(thetaff) * cos(phff)
			yo = radius * cos(thetaff) * sin(phff)
			zo = radius * sin(thetaff)
			xb = xo * hair.len
			yb = yo * hair.len
			zb = zo * hair.len
			app.stroke_weight(1)
			app.begin_shape(LINES)
			app.stroke(0)
			app.vertex(x, y, za)
			app.stroke(200, 150)
			app.vertex(xb, yb, zb)
			app.end_shape()
		end	
	end
end

class HairFactory	
	def self.create_hair radius
		z = rand(-radius .. radius)
		phi = rand * TWO_PI
		len = rand(1.15 .. 1.2)
		theta = Math.asin(z / radius)
		return Hair.new(z, phi, len, theta)
	end	
end

class Hair
	attr_reader :z, :phi, :len, :theta	
	def initialize z, phi, len, theta	
		@z, @phi, @len, @theta	 = z, phi, len, theta	
	end
end
