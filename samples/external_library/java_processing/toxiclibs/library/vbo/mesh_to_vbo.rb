############################################
# mesh_to_vbo.rb
# a ruby library to convert toxi.mesh object
# to vbo (PShape) written by Martin Prout
# make use of Processing::Proxy mixin
############################################
class MeshToVBO
  include Processing::Proxy
  
  attr_reader :parent
  
  def initialize(parent)
    @parent = parent   
  end
  
  def meshToVBO(mesh, smth)
    retained = parent.createShape()
    retained.begin_shape(PShape::TRIANGLES)
    if (smth)
      mesh.computeVertexNormals()
      mesh.getFaces.each do |f|
        retained.normal(f.a.normal.x, f.a.normal.y, f.a.normal.z)
        retained.vertex(f.a.x, f.a.y, f.a.z)
        retained.normal(f.b.normal.x, f.b.normal.y, f.b.normal.z)
        retained.vertex(f.b.x, f.b.y, f.b.z)
        retained.normal(f.c.normal.x, f.c.normal.y, f.c.normal.z)
        retained.vertex(f.c.x, f.c.y, f.c.z)
      end
    else
      mesh.getFaces.each do |f|
        retained.normal(f.normal.x, f.normal.y, f.normal.z)
        retained.vertex(f.a.x, f.a.y, f.a.z)
        retained.vertex(f.b.x, f.b.y, f.b.z)
        retained.vertex(f.c.x, f.c.y, f.c.z)
      end
    end
    retained.end_shape()
    return retained
  end
  
  # variant
  # input array of meshes, output an array of shapes
  def meshToRetained(mesh, smth)
    rshapes = []
    (0 ... mesh.length).each do |i|
      rshapes.push(meshToVBO(mesh[i], smth))
    end
    return rshapes
  end
end


