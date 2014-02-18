# Drawolver: draw 2D & revolve 3D

# This example demonstrates the use of the `vecmath` library (a ruby-processing 
# replacement for PVector). Also demonstrated is how to extend an instance of a
# here an instance of a core ruby class. In this case the ruby Array class,  
# is extended to yield one_of_each pair of pts (see ExtendedArray module). This
# examples also includes a possibly rare use of the each_cons Enumerable method?
# For simpler illustrations of `vecmath` usage see the library examples.
# 2010-03-22 - fjenett (last revised by monkstone 2014-02-18)

load_library :vecmath

attr_reader :drawing_mode, :points, :rot_x, :rot_y, :vertices

module ExtendedArray
  # send one item from each array, expects array to be 2D:
  # array [[1,2,3], [a,b,c]] sends
  # [1,a] , [2,b] , [3,c]
  def one_of_each( &block )
    i = 0
    one = self[0]
    two = self[1]
    mi = one.length > two.length ? two.length : one.length
    while i < mi do
      yield( one[i], two[i] )
      i += 1
    end
  end
end

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
      ext_array = [r1,r2].extend ExtendedArray # extend an instance of Array
      ext_array.one_of_each do |v1, v2|          
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
    b *= dot   
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

