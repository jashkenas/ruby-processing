

# The beginShape() function begins recording vertices 
# for a shape and endShape() stops recording. 
# A vertex is a location in space specified by X, Y, 
# and sometimes Z coordinates. After calling the beginShape() function, 
# a series of vertex() functions must follow.  
# To stop drawing the shape, call the endShape() functions.


def setup
  size 200, 200
  background 10, 10, 50
  no_fill
  stroke_weight 3
  stroke 102
  begin_shape  
  curve_vertex 168, 182 
  curve_vertex 168, 182 
  curve_vertex 136, 38 
  curve_vertex 42, 34 
  curve_vertex 64, 200 
  curve_vertex 64, 200 
  end_shape  
  
  stroke 51 
  begin_shape LINES 
  vertex 60, 40 
  vertex 160, 10 
  vertex 170, 150 
  vertex 60, 150 
  end_shape  
  
  stroke 126 
  begin_shape  
  vertex 60, 40 
  bezier_vertex 160, 10, 170, 150, 60, 150 
  end_shape  
  
  stroke 255 
  begin_shape POINTS 
  vertex 60, 40 
  vertex 160, 10 
  vertex 170, 150 
  vertex 60, 150 
  end_shape  
end
