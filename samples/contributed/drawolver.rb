# Drawolver: draw 2D & revolve 3D

# Example to show how to extend Ruby classes in a useful way and how to
# use PVector and the Array is extended to yield one_of_each 
# pair of pts. See the drawolver library. Also features the use each_cons, 
# possibly a rare use for this ruby Enumerable method?
# 2010-03-22 - fjenett

load_library 'drawolver'
attr_reader :drawing_mode, :points, :rot_x, :rot_y, :vertices

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
  points.each_cons(2) { |ps, pe|   
    line ps.x, ps.y, pe.x, pe.y
  } 
  if (!drawing_mode)    
    no_stroke
    fill 120
    lights    
    vertices.each_cons(2) { |r1, r2|     
      begin_shape(TRIANGLE_STRIP)       
        [r1,r2].one_of_each { |v1, v2|          
          vertex v1.x, v1.y, v1.z
          vertex v2.x, v2.y, v2.z
        }
        end_shape
    }
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
  points.push(RPVector.new(mouse_x, mouse_y))
end

def mouse_dragged
  points.push(RPVector.new(mouse_x, mouse_y))
end

def mouse_released
  points.push(RPVector.new(mouse_x, mouse_y))
  recalculate_shape
end

def recalculate_shape  
  @vertices = []
  points.each_cons(2) { |ps, pe|   
    b = points.last - points.first
    len = b.mag
    b.normalize   
    a = ps - points.first   
    dot = a.dot b   
    b = b * dot   
    normal = points.first + b    
    c = ps - normal
    nlen = c.mag    
    vertices.push []    
    (0..360).step( 12 ) { |deg|     
      ang = radians deg
      e = normal + c * cos(ang)
      e.z = c.mag * sin(ang)      
      vertices.last.push e
    }
  }
  @drawing_mode = false
end


