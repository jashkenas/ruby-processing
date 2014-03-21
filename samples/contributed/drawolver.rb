# Drawolver: draw 2D & revolve 3D

# Example to show how to use the VecMath library.
# ruby replacement for PVector. Also features 
# the use each_cons, possibly a rare use for this 
# ruby Enumerable method?
# 2010-03-22 - fjenett (last revised by monkstone 2014-03-21)
# now uses 'zip' and 'each', in place of a custom Array object
# with a 'one_of_each' method

load_library :vecmath
import 'vecmath'
attr_reader :drawing_mode, :points, :rot_x, :rot_y, :vertices

def setup 
  size 1024, 768, P3D
  frame_rate 30 
  reset_scene
end

def draw  
  background 0    
  if (!drawing_mode)      
    translate(width/2, height/2)
    rotate_x rot_x
    rotate_y rot_y
    @rot_x += 0.01
    @rot_y += 0.02
    translate(-width/2, -height/2)
  end 
  no_fill
  stroke 255
  points.each_cons(2) { |ps, pe| line ps.x, ps.y, pe.x, pe.y}

  if (!drawing_mode)    
    stroke 125
    fill 120
    lights 
    ambient_light 120, 120, 120
    vertices.each_cons(2) do |r1, r2|
      begin_shape(TRIANGLE_STRIP)
      r1.zip(r2).each do |v1, v2|
        vertex v1.x, v1.y, v1.z
        vertex v2.x, v2.y, v2.z
      end
      end_shape 
    end
  end 
end

def reset_scene 
  @drawing_mode = true
  @points = []
  @rot_x = 0.0
  @rot_y = 0.0
end

def mouse_pressed
  reset_scene
  points << Vec3D.new(mouse_x, mouse_y)
end

def mouse_dragged
  points << Vec3D.new(mouse_x, mouse_y)
end

def mouse_released
  points << Vec3D.new(mouse_x, mouse_y)
  recalculate_shape
end

def recalculate_shape  
  @vertices = []
  points.each_cons(2) do |ps, pe|   
    b = points.last - points.first
    # len = b.mag
    b.normalize!   
    a = ps - points.first   
    dot = a.dot b   
    b = b * dot   
    normal = points.first + b    
    c = ps - normal
    # nlen = c.mag    
    vertices << []    
    (0..TAU).step(PI/15) do |ang|     
      e = normal + c * cos(ang)
      e.z = c.mag * sin(ang)      
      vertices.last << e
    end
  end
  @drawing_mode = false
end




