# Explode 
# by Daniel Shiffman. 
# 
# Mouse horizontal location controls breaking apart of image and 
# Maps pixels from a 2D image into 3D space. Pixel brightness controls 
# translation along z axis. 
CELL_SIZE = 2

def setup    
  size 640, 360, P3D    
  @img = load_image "eames.jpg"
  @columns = @img.width / CELL_SIZE
  @rows = @img.height / CELL_SIZE    
end

def draw    
  background 0    
  (0...@columns).each { |i|        
    (0...@rows).each { |j|            
      x = i * CELL_SIZE + CELL_SIZE / 2
      y = j * CELL_SIZE + CELL_SIZE / 2            
      loc = x + y * @img.width            
      c = @img.pixels[loc]            
      z = (mouse_x / width.to_f) * brightness( @img.pixels[loc] ) - 20            
      push_matrix            
      translate x + 200, y + 100, z            
      fill c, 204
      no_stroke
      rect_mode CENTER            
      rect 0, 0, CELL_SIZE, CELL_SIZE            
      pop_matrix
    }
  }
  
end
