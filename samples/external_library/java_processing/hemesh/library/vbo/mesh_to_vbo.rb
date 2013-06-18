# mesh_to_vbo.rb, with java_imports becomes a specialist class
module MS  
  java_import 'wblut.hemesh.HEC_IsoSurface'
  java_import 'wblut.hemesh.HE_Mesh'
  java_import 'wblut.hemesh.HEM_Smooth'
  
  class MeshToVBO 
    
    attr_reader :parent
    
    def initialize(parent)
      @parent = parent
    end
    
    def meshToVBO(mesh, col = nil)
      tri_mesh = mesh.get
      tri_mesh.triangulate
      retained = parent.create_shape
      retained.begin_shape(TRIANGLES)
      if col
        retained.fill(col)
      else # we will have a light grey color, created by bit shifting
        fcol = (255 >> 24) & 0xFF|(211 >> 16) & 0xFF|(211 >> 8) & 0xFF|211
        retained.fill(fcol)
      end
      retained.ambient(50)
      retained.specular(50)
      mesh.fItr.each do |face|  # call each on the hemesh mesh iterator
        he = face.getHalfedge
        begin      # this block is the ruby equivalent of do while
          vx = he.getVertex
          vn = vx.getVertexNormal
          retained.normal(vn.xf, vn.yf, vn.zf)
          retained.vertex(vx.xf, vx.yf, vx.zf)
          he = he.getNextInFace
        end while (he != face.getHalfedge)
      end
      retained.end_shape
      return retained
    end
  end
end

