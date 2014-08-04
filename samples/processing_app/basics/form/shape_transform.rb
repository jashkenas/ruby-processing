# Shape Transform
# by Ira Greenberg.  
# 
# Illustrates the geometric relationship 
# between Cube, Pyramid, Cone and 
# Cylinder 3D primitives.
# 
# Instructions:
# Up Arrow - increases points
# Down Arrow - decreases points
# 'p' key toggles between cube/pyramid

load_library :vecmath
attr_reader :renderer


def setup  
  size 640, 360, P3D
  @renderer = AppRender.new(self)  
  no_stroke  
  @angle_inc = PI / 300  
  @pts = 4
  @angle = 0
  @radius = 99
  @cylinder_length = 95  
  @is_pyramid = false  
end

def draw  
  background 170, 95, 95
  lights
  fill 255, 200, 200  
  translate width / 2, height / 2
  rotate_x frame_count * @angle_inc
  rotate_y frame_count * @angle_inc
  rotate_z frame_count * @angle_inc
  
  vertices = []
  
  (0...2).each { |i|
    @angle = 0
    vertices[i] = []
    0.upto(@pts) { |j|
      pvec = Vec3D.new 0, 0
      (
        pvec.x = cos(@angle.radians) * @radius
        pvec.y = sin(@angle.radians) * @radius
        
        ) unless ( @is_pyramid && i == 1 )
        
        pvec.z = @cylinder_length
        vertices[i][j] = pvec
        
        @angle += 360.0/@pts
    }
    @cylinder_length *= -1
  }
  
  begin_shape QUAD_STRIP
    0.upto(@pts) { |j|
      vertices[0][j].to_vertex(renderer)
      vertices[1][j].to_vertex(renderer)
    }
    end_shape
    
    [0,1].each { |i|
      begin_shape
        0.upto(@pts) { |j|
          vertices[i][j].to_vertex(renderer)
        }
        end_shape CLOSE
    }
    
  end
  
  def key_pressed    
    if key == CODED
      @pts += 1 if keyCode == UP && @pts < 90
      @pts -= 1 if keyCode == DOWN && @pts > 4
    end    
    @is_pyramid = !@is_pyramid if key.eql? "p"    
  end
  
