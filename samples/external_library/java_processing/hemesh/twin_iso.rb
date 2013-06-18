load_libraries :hemesh, :vbo

include MS # module MS imports necessary java classes and contains ruby MeshToVBO class

RES = 20

attr_reader :mesh_ret, :inv_mesh_ret, :render

def setup
  size(800, 800, P3D)
  smooth(8)
  values = []               # build a multi-dimensional array in ruby
  (0 .. RES).each do |i|    # the inclusive range is intentional here
    valu = []
    (0 .. RES).each do |j|
      val = []
      (0 .. RES).each do |k|
        val << 2.1 * noise(0.35 * i, 0.35 * j, 0.35 * k)
      end
      valu << val
    end
    values << valu
  end
  
  creator = HEC_IsoSurface.new
  creator.set_resolution(RES,RES, RES) # number of cells in x,y,z direction
  creator.set_size(400.0/RES, 400.0/RES, 400.0/RES) # cell size
  
  # JRuby requires a bit of help to determine correct 'java args', particulary with 
  # overloaded arrays args as seen below. Note we are saying we have an 'array' of  
  # 'float array' here, where the values can also be double[][][].
  java_values = values.to_java(Java::float[][]) # pre-coerce values to java
  creator.set_values(java_values)               # the grid points
  
  creator.set_isolevel(1)   # isolevel to mesh
  creator.set_invert(false) # invert mesh
  creator.set_boundary(100) # value of isoFunction outside grid
  # use creator.clear_boundary to set boundary values to "no value".
  # A boundary value of "no value" results in an open mesh
  
  mesh = HE_Mesh.new(creator)
  # mesh.modify(HEM_Smooth.new.set_iterations(10).setAutoRescale(true))
  creator.set_invert(true)
  
  inv_mesh = HE_Mesh.new(creator)
  inv_mesh.modify(HEM_Smooth.new.set_iterations(10).set_auto_rescale(true))
  @render = MeshToVBO.new(self)
  no_stroke
  # no color args produces a default light grey fill
  @mesh_ret = render.meshToVBO(mesh, color(200, 0, 0))
  @inv_mesh_ret = render.meshToVBO(inv_mesh, color(0, 0, 200))
end

def draw
  background(120)
  lights
  define_lights
  translate(400, 400)
  rotate_y(mouse_x.to_f / width * TWO_PI)  # use TWO_PI until processing-2.0b9
  rotate_x(mouse_y.to_f / height * TWO_PI) # then we can use TAU
  shape(inv_mesh_ret)
  shape(mesh_ret)
end

def define_lights
  ambient(20, 20, 20)
  ambient_light(60, 60, 60)
  point_light(30, 30, 30, 0, 0, 0)
  directional_light(40, 40, 50, 1, 0, 0)
  spot_light(30, 30, 30, 0, 40, 200, 0, -0.5, 0.5, PI / 2, 2)
end
