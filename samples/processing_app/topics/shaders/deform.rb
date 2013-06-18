#
# Deform. 
# 
# A GLSL version of the oldschool 2D deformation effect, by Inigo Quilez.
# Ported from the webGL version available in ShaderToy:
# http://www.iquilezles.org/apps/shadertoy/
# (Look for Deform under the Plane Deformations Presets)
# 
#
 
attr_reader :tex, :deform

def setup
  size(640, 360, P2D)
  
  textureWrap(REPEAT)
  @tex = loadImage("tex1.jpg")
 
  @deform = loadShader("deform.glsl")
  deform.set("resolution", width.to_f, height.to_f)
end

def draw
  deform.set("time", millis / 1000.0)
  deform.set("mouse", mouse_x.to_f, mouse_y.to_f)
  shader(deform)
  image(tex, 0, 0, width, height)
end
