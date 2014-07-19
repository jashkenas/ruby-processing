NORM_LEN = 225.0

class Plane
  include Processing::Proxy
  
  attr_reader :vecs, :c, :n


  def initialize(vecs)
    @vecs = vecs
    init
  end
  
  def init    
    v1 = vecs[1] - vecs[0] 
    v2 = vecs[2] - vecs[0]  
    
    @c = Vec3D.new(
      (vecs[0].x+vecs[1].x+vecs[2].x) / 3, 
      (vecs[0].y+vecs[1].y+vecs[2].y) / 3, 
      (vecs[0].z+vecs[1].z+vecs[2].z) / 3
      )
    
    @n = v1.cross(v2)
    n.normalize!
  end
  
  def display(renderer)
    begin_shape(TRIANGLES)
    vecs.each do |vec|
      vec.to_vertex(renderer)
    end
    end_shape
    
    #normal
    stroke(200, 160, 30)
    begin_shape(LINES)
    c.to_vertex(renderer)
    (c + n * NORM_LEN).to_vertex(renderer)
    end_shape
    
    #binormal
    stroke(160, 200, 30)
    begin_shape(LINES)
    c.to_vertex(renderer)
    # tangent
    v = vecs[1].copy
    #v.set(vecs[1])
    v -= vecs[0]
    v.normalize!
    (c + v * NORM_LEN).to_vertex(renderer)
    end_shape
    
    stroke(30, 200, 160)
    begin_shape(LINES)
    c.to_vertex(renderer)
    b = v.cross(n)
    (c + b * NORM_LEN).to_vertex(renderer)
    end_shape
    stroke(0, 75)
  end
end
  

