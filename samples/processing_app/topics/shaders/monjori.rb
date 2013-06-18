##
 # Monjori. 
 # 
 # GLSL version of the 1k intro Monjori from the demoscene 
 # (http://www.pouet.net/prod.php?which=52761)
 # Ported from the webGL version available in ShaderToy:
 # http://www.iquilezles.org/apps/shadertoy/
 # (Look for Monjori under the Plane Deformations Presets) 
##
 
attr_reader :monjori

def setup
  size(640, 360, P2D)
  no_stroke 
  @monjori = loadShader("monjori.glsl")
  monjori.set("resolution", width.to_f, height.to_f)   
end

def draw
  monjori.set("time", millis() / 1000.0)  
  shader(monjori)
  # This kind of effects are entirely implemented in the
  # fragment shader, they only need a quad covering the  
  # entire view area so every pixel is pushed through the 
  # shader.   
  rect(0, 0, width, height)  
end
