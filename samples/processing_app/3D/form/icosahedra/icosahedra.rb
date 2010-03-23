# I Like Icosahedra
# by Ira Greenberg.
# 
# This example plots icosahedra. The Icosahdron is a regular
# polyhedron composed of twenty equalateral triangles.

# fjenett, 2010-03-11:
# This is by far not an exact translation of Iras code. I removed
# the unneeded Dimension3D class, simplyfied Shape3D and improved
# the Icosahedron class. That and the rubyfication ...
  

class Icosahedra < Processing::App

  def setup
    
    size 640, 360, P3D
    
    @ico1 = Icosahedron.new 75
    @ico2 = Icosahedron.new 75
    @ico3 = Icosahedron.new 75
    
  end
  
  def draw
  
  	background 0
  	lights
  	
  	translate width/2, height/2
  	
  	push_matrix
  	
  		translate -width/3.5, 0
  		rotate_x frame_count * PI / 185
  		rotate_y frame_count * PI / -200
  		
  		stroke 170, 0, 0
  		no_fill
  		
  		@ico1.draw
  	
  	pop_matrix
  	
  	push_matrix
  	
  		rotate_x frame_count * PI / 200
  		rotate_y frame_count * PI / 300
  		
  		stroke 170, 0, 180
  		fill 170, 170, 0
  		
  		@ico2.draw
  	
  	pop_matrix
  	
  	push_matrix
  	
  		translate width/3.5, 0
  		rotate_x frame_count * PI / -200
  		rotate_y frame_count * PI / 200
  		
  		no_stroke
  		fill 0, 0, 185
  		
  		@ico3.draw
  	
  	pop_matrix
  
  end
  
  require 'icosahedron' # load icosahedron.rb
  
end

Icosahedra.new :title => "Icosahedra"