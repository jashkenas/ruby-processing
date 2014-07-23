class Cylinder
  include Processing::Proxy
  attr_accessor :vecs
  attr_reader :detail, :dim  
  
  def initialize(dim, detail)
    @dim = dim
    @detail = detail
    init
  end
  
  def init
    #    created around x-axis
    #    y = Math.cos
    #    z = Math.sin
    veca = []
    vecb = []
    (0 ... 360).step(360 / detail) do |theta|
      cost = DegLut.cos(theta)
      sint = DegLut.sin(theta)
      veca << Vec3D.new(0, cost * dim.y, sint * dim.z)
      vecb << Vec3D.new(dim.x, cost * dim.y, sint * dim.z)
    end
    @vecs = veca.concat(vecb)
  end
  
  def display(renderer)
    begin_shape(QUADS)
    detail.times do |i|
      if i < (detail - 1)
        vecs[i].to_vertex(renderer)
        vecs[i + 1].to_vertex(renderer)
        vecs[detail + i + 1].to_vertex(renderer)
        vecs[detail + i].to_vertex(renderer)
      else
        vecs[i].to_vertex(renderer)
        vecs[0].to_vertex(renderer)
        vecs[detail].to_vertex(renderer)
        vecs[detail + i].to_vertex(renderer)
      end
    end
    end_shape
  end
end
