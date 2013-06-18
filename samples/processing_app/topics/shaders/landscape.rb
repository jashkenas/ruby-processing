#
# Elevated
# https://www.shadertoy.com/view/MdX3Rr by inigo quilez
# Created by inigo quilez - iq/2013
# License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
# Processing port by Raphaël de Courville.
#
 
attr_reader :landscape

def setup
  size(640, 360, P2D)
  no_stroke
   
  # The code of this shader shows how to integrate shaders from shadertoy
  # into Processing with minimal changes.
  @landscape = load_shader("landscape.glsl")
  landscape.set("resolution", width.to_f, height.to_f)  
end

def draw
  background(0)
    
  landscape.set("time", (millis/1000.0).to_f)
  shader(landscape) 
  rect(0, 0, width, height)

  frame.set_title "frame: #{frame_count} - fps: #{frame_rate}"     
end

