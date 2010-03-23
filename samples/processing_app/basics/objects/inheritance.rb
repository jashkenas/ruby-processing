# Inheritance
# 
# A class can be defined using another class as a foundation. In object-oriented
# programming terminology, one class can inherit fields and methods from another. 
# An object that inherits from another is called a subclass, and the object it 
# inherits from is called a superclass. A subclass extends the superclass.

class Inheritance < Processing::App

  def setup
    
    size 200, 200
    smooth
    
    @arm = SpinArm.new width/2, height/2, 0.01
    @spots = SpinSpots.new width/2, height/2, -0.02, 33.0
  end
  
  def draw
  
  	background 204
  	
  	@arm.display
  	@spots.display
  end
  
  # vvv CLASS SPIN
  
  class Spin
  
  	attr_accessor :x, :y, :speed
  	attr_accessor :angle
  	
  	def initialize ( x, y, s )
  	
  		@x, @y = x, y
  		@speed = s
  		@angle = 0.0
  	end
  	
  	def update
  	
  		@angle += @speed
  	end
  
  end
  
  # ^^^ CLASS SPIN
  
  # vvv CLASS SPINARM
  
  class SpinArm < Spin # inherit from (or "extend") class Spin
  
  	def display
  		
  		stroke_weight 1
  		stroke 0
  		
  		push_matrix
  		
  			translate @x, @y
  			update
  			rotate @angle
  			line 0, 0, 66, 0
  		pop_matrix
  	end
  
  end
  
  # ^^^ CLASS SPINARM
  
  # vvv CLASS SPINSPOTS
  
  class SpinSpots < Spin
  
  	attr_accessor :dim
  	
  	def initialize ( x, y, s, d )
  	
  		super( x, y, s )
  		@dim = d
  	end
  	
  	def display
  	
  		no_stroke
  		
  		push_matrix
  			
  			translate @x, @y
  			update
  			rotate @angle
  			ellipse -@dim/2, 0, @dim, @dim
  			ellipse  @dim/2, 0, @dim, @dim
  		pop_matrix
  	end
  	
  end
  
  # ^^^ CLASS SPINSPOTS
  
end

Inheritance.new :title => "Inheritance"