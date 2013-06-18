#
#  Joints#
#  by Ricard Marxer#
#  This example shows how to access all the joints of a given body.
#
# converted to ruby-processing by Martin Prout
#

load_library :fisica
module Fis
  java_import 'fisica.Fisica'
  java_import 'fisica.FWorld'
  java_import 'fisica.FCircle'
  java_import 'fisica.FDistanceJoint'
  java_import 'fisica.FJoint'
end

SPIDER_COUNT = 10
MAIN_SIZE = 40
LEG_COUNT = 10
LEG_SIZE = 100

attr_reader :world, :mains, :body_color, :hover_color

def setup
  size(400, 400)
  @body_color = color('#6E0595')
  @hover_color = color('#F5B502')
  smooth
  @mains = []
  Fis::Fisica.init(self)  
  @world = Fis::FWorld.new
  world.set_edges
  world.set_gravity(0, 0)
  
  SPIDER_COUNT.times do 
    create_spider
  end
end

def draw
  background(255)
  world.step
  world.draw
end

def mouse_moved
  hovered = world.get_body(mouse_x, mouse_y)  
  mains.each do |other|    
    if (hovered == other)
      set_joints_drawable(other, true)
      set_joints_color(other, hover_color)      
    else
      set_joints_drawable(other, false)
      set_joints_color(other, body_color)
    end
  end
end

def key_pressed  
  save_frame("screenshot.png")  
end

def create_spider
  pos_x = rand(MAIN_SIZE/2 .. width-MAIN_SIZE/2)
  pos_y = rand(MAIN_SIZE/2 .. height-MAIN_SIZE/2)  
  main = Fis::FCircle.new(MAIN_SIZE)
  main.set_position(pos_x, pos_y)
  main.set_velocity(rand(-20 .. 20), rand(-20 .. 20))
  main.set_fill_color(body_color)
  main.set_no_stroke
  main.set_group_index(2)
  world.add(main)  
  mains << main
  
  (0 ... LEG_COUNT).each do |i|
    x = LEG_SIZE * cos(i * TAU/3) + pos_x
    y = LEG_SIZE * sin(i * TAU/3) + pos_y    
    leg = Fis::FCircle.new(MAIN_SIZE/2)
    leg.set_position(pos_x, pos_y)
    leg.set_velocity(rand(-20 .. 20), rand(-20 ..20))
    leg.set_fill_color(body_color)
    leg.set_no_stroke
    world.add(leg)    
    j = Fis::FDistanceJoint.new(main, leg)
    j.set_length(LEG_SIZE)
    j.set_no_stroke
    j.set_stroke(0)
    j.set_fill(0)
    j.set_drawable(false)
    j.set_frequency(0.1)
    world.add(j)
  end
end

def set_joints_color(b, c)
  l = b.get_joints  
  l.each do |j|
    j.set_stroke_color(c)
    j.set_fill_color(c)
    j.get_body1.set_fill_color(c)
    j.get_body2.set_fill_color(c)
  end
end

def set_joints_drawable(b, c)
  l = b.get_joints  
  l.each do |j|
    j.set_drawable(c)
  end
end

