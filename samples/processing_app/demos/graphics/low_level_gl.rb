include_package 'java.nio'
java_import 'processing.opengl.PGL'  


attr_reader :sh, :vert_loc, :color_loc, :vert_data, :color_data

def setup
  size(640, 360, P3D)
  
  # Loads a shader to render geometry w/out
  # textures and lights.
  @sh = loadShader("frag.glsl", "vert.glsl")  
  @vert_data = allocate_direct_float_buffer(12)  
  @color_data = allocate_direct_float_buffer(12)
end

def draw
  background(0)
  
  # The geometric transformations will be automatically passed 
  # to the shader.
  rotate(frame_count * 0.01, width, height, 0)
  
  update_geometry
  
  pgl = beginPGL
  sh.bind
  
  @vert_loc = pgl.getAttribLocation(sh.glProgram, "vertex")
  @color_loc = pgl.getAttribLocation(sh.glProgram, "color")
  
  pgl.enableVertexAttribArray(vert_loc)
  pgl.enableVertexAttribArray(color_loc)

  pgl.vertexAttribPointer(vert_loc, 4, PGL.FLOAT, false, 0, vert_data)
  pgl.vertexAttribPointer(color_loc, 4, PGL.FLOAT, false, 0, color_data)
  
  pgl.drawArrays(PGL.TRIANGLES, 0, 3)
  
  pgl.disableVertexAttribArray(vert_loc)
  pgl.disableVertexAttribArray(color_loc)
  
  sh.unbind  
  
  endPGL
end

def update_geometry
  # Vertex 1
  vertices = [0, 0, 0, 1]
  colors = [1, 0, 0, 1]
  
  # Corner 2
  vertices += [width/2, height, 0, 1]
  colors += [0, 1, 0, 1]
  
  # Corner 3
  vertices += [width, 0, 0, 1]
  colors += [0, 0, 1, 1]
  
  vert_data.rewind
  vert_data.put(vertices.to_java :float)
  vert_data.position(0)
  
  color_data.rewind
  color_data.put(colors.to_java :float)
  color_data.position(0)  
end

def allocate_direct_float_buffer(n)
  ByteBuffer.allocateDirect(n * java.lang.Float::SIZE/8).order(ByteOrder.nativeOrder).asFloatBuffer
end
