#
# Edge Detection
# 
# Change the default shader to apply a simple, custom edge detection filter.
# 
# Press the mouse to switch between the custom and default shader.
#
attr_reader :edges, :img , :enabled


def setup
  size(640, 360, P2D)
  @enabled = true
  @img = load_image("leaves.jpg");      
  @edges = load_shader("edges.glsl")
end

def draw
  if (enabled == true)
    shader(edges)
  end
  image(img, 0, 0)
end

def mousePressed
  @enabled = !enabled
  if (!enabled == true)
    resetShader
  end
end
