#
# Esfera
# by David Pena.  
# Somewhat re-factored for ruby-processing
# by Martin Prout
# Distribucion aleatoria uniforme sobre la superficie de una esfera. 
#
require 'forwardable'

load_library :vecmath

QUANTITY = 16000 

attr_reader :orb, :phi, :radius, :rx, :ry


def setup
  size(800, 600, P3D)
  ArcBall.init(self)
  @rx = 0
  @ry =0
  no_smooth
  @radius = height/3.5
  @orb = HairyOrb.new(radius)
  QUANTITY.times do
    orb << HairFactory.create_hair(radius) 
  end
  noise_detail(3)
end

def draw
  background(0)
  rxp = ((mouse_x - (width/2))*0.005)
  ryp = ((mouse_y - (height/2))*0.005)
  @rx = (rx*0.9)+(rxp*0.1)
  @ry = (ry*0.9)+(ryp*0.1)
  orb.render
  if (frame_count % 10 == 0)
    puts(frame_rate)
  end
end

class HairyOrb
  extend Forwardable
  def_delegators(:@hairs, :<<, :each, :map)  
  attr_reader :radius
  
  def initialize radius
    @radius = radius
    @hairs = []    
  end
  

  def render
    fill 0
    no_stroke
    sphere(radius)
    self.map{ |hair|
      off = (noise(millis() * 0.0005, sin(hair.phi)) - 0.5) * 0.3
      offb = (noise(millis() * 0.0007, sin(hair.z) * 0.01) - 0.5) * 0.3
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
      stroke_weight(1)
      begin_shape(LINES)
      stroke(0)
      vertex(x, y, za)
      stroke(200, 150)
      vertex(xb, yb, zb)
      end_shape()
    } 
  end
end

module HairFactory 
  def self.create_hair radius
    z = rand(-radius .. radius)
    phi = rand(0 .. Math::PI * 2) 
    len = rand(1.15 .. 1.2)
    theta = Math.asin(z / radius)
    Hair.new(z, phi, len, theta)
  end 
end

Hair = Struct.new(:z, :phi, :len, :theta)

