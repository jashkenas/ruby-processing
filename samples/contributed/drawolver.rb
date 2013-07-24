# Drawolver: draw 2D & revolve 3D

# Example to show how to extend Ruby classes in a useful way and how to
# use PVector and the Array is extended to yield one_of_each 
# pair of pts. See the drawolver library. Also features the use each_cons, 
# possibly a rare use for this ruby Enumerable method?
# 2010-03-22 - fjenett (revised monkstone 2013-07-22)

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
      i = i + 1
    end
  end
end


def setup 
  size 640, 360, P3D
  frame_rate 30 
  reset_scene
end

def draw  
  background 255    
  if (!drawing_mode)      
    translate(width/2, height/2)
    rotate_x rot_x
    rotate_y rot_y
    @rot_x += 0.01
    @rot_y += 0.02
    translate(-width/2, -height/2)
  end 
  no_fill
  stroke 0  
  points.each_cons(2) { |ps, pe| line ps.x, ps.y, pe.x, pe.y}

  if (!drawing_mode)    
    no_stroke
    fill 120
    lights    
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
  points << RPVector.new(mouse_x, mouse_y)
end

def mouse_dragged
  points << RPVector.new(mouse_x, mouse_y)
end

def mouse_released
  points << RPVector.new(mouse_x, mouse_y)
  recalculate_shape
end

def recalculate_shape  
  @vertices = []
  points.each_cons(2) do |ps, pe|   
    b = points.last - points.first
    len = b.mag
    b.normalize   
    a = ps - points.first   
    dot = a.dot b   
    b = b * dot   
    normal = points.first + b    
    c = ps - normal
    nlen = c.mag    
    vertices << []    
    (0..360).step(12) do |deg|     
      ang = radians deg
      e = normal + c * cos(ang)
      e.z = c.mag * sin(ang)      
      vertices.last << e
    end
  end
  @drawing_mode = false
end

# a wrapper around PVector that implements operators methods for +, -, *, /
#
class RPVector < Java::ProcessingCore::PVector

  def + ( other )
    v = RPVector.add( self, other )
    RPVector.new v.x, v.y, v.z
  end

  def - ( other )
    v = RPVector.sub( self, other )
    RPVector.new v.x, v.y, v.z
  end

  def * ( other )
    v = RPVector.mult( self, other )
    RPVector.new v.x, v.y, v.z
  end

  def / ( other )
    v = RPVector.div( self, other )
    RPVector.new v.x, v.y, v.z
  end

end



