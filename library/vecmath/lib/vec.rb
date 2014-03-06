class Vec2D
  EPSILON = 9.999999747378752e-05     # a value used by processing.org
  attr_accessor :x, :y, :z  
  
  def initialize(x = 0 ,y = 0, z = 0)
    @x, @y, @z = x, y, z
    post_initialize
  end
  
  def post_initialize
    nil
  end  

  def ==(vec)
    (x - vec.x).abs < EPSILON && (y - vec.y).abs < EPSILON && (z - vec.z).abs < EPSILON
  end
 
  def self.dist_squared(vec_a, vec_b)
    (vec_a.x - vec_b.x)**2 + (vec_a.y - vec_b.y)**2 + (vec_a.z - vec_b.z)**2
  end
 
  def self.dist(vec_a, vec_b)
    Math.sqrt((vec_a.x - vec_b.x)**2 + (vec_a.y - vec_b.y)**2 + (vec_a.z - vec_b.z)**2)
  end

  def inspect
    self.to_s
  end

   
  def self.from_angle scalar
    Vec2D.new(Math.cos(scalar), Math.sin(scalar))
  end
  
  def modulus
    Math.hypot(x, y)	  
  end
  
  def mag_squared
    x**2 + y**2	  
  end

  # vanilla processing PVector returns a Vector, rather than Scalar (defaults to 3D result with z = 0)
  def cross(vec)
    x * vec.y - y * vec.x
  end
  
  # Scalar product, also known as inner product or dot product
  def dot(vec)
    x * vec.x + y * vec.y
  end
  
  def collinear_with?(vec)
    cross(vec).abs < EPSILON
  end
  
  def +(vec)
    Vec2D.new(x + vec.x, y + vec.y)
  end
  
  def -(vec)
    Vec2D.new(x - vec.x, y - vec.y)
  end
  
  def *(scalar)      
    Vec2D.new(x * scalar, y * scalar)
  end

  def / (scalar)      
    Vec2D.new(x / scalar, y / scalar) unless scalar == 0
  end

  # @param [Vec2D] vec
  #   The target vector
  # @param [Float] scalar 
  # @return [Vec2D]
  #   A new Vec2D on the way to the target (all the way if scalar not in 0 .. 1.0)
  
  def lerp(vec, scalar)
    if (0 .. 1.0).include? scalar
      x0, y0 = x * scalar + vec.x * (1 - scalar), y * scalar + vec.y * (1 - scalar)
    else
      x0, y0 = vec.x, vec.y # you will get there rather quicker than you hoped
    end
    Vec2D.new(x0, y0)
  end

  # Change the values of current Vec2D toward a target
  # @param [Vec2D] vec
  #   The target vector
  # @param [Float] scalar 
  # @return [Vec2D]
  #   self Vec2D on the way to the target (unchanged if scalar not in 0 .. 1.0)

  
  def lerp!(vec, scalar)     
    @x, @y = x * scalar + vec.x * (1 - scalar), y * scalar + vec.y * (1 - scalar) if (0 .. 1.0).include? scalar
    return self
  end
  
  def heading
    Math.atan2(-y, x) * -1.0
  end
  
  def normalize
    magnitude = Math.hypot(x, y)	  
    Vec2D.new( x / magnitude, y / magnitude)
  end
  
  def normalize!
    magnitude = Math.hypot(x, y)	  
    @x, @y = x / magnitude, y / magnitude
    return self
  end

  # The &block option means we can conditionally set_mag to
  # a limit value for example, when given &block returns true.

  def set_mag(scalar, &block)
    if block_given? && yield == false
      return self
    end      
    magnitude = Math.hypot(x, y)	  
    @x, @y = (x * scalar) / magnitude, (y * scalar) / magnitude
    return self    
  end

  def to_a
    [x, y]
  end

  def to_s
    "#{self.class}(x=#{x}, y=#{y})"  
  end
  
  alias :mag :modulus 

end

class Vec2DR < Vec2D
  
  def rotate(rot)
    Vec2D.new((x * Math.cos(rot)) - y * Math.sin(rot),
	    (x * Math.sin(rot)) + (y * Math.cos(rot)))
  end

  # this behaves like PVector rotate (ie changes self, except returns self rather than "void")
  def rotate!(rot)
    @x, @y = (x * Math.cos(rot) - y * Math.sin(rot)), (x * Math.sin(rot) + y * Math.cos(rot))
    return self
  end 
end

class Vec3D < Vec2D

  def modulus
    Math.sqrt(x**2 + y**2 + z**2)
  end

  def cross(vec)
    xc = y * vec.z - z * vec.y
    yc = z * vec.x - x * vec.z
    zc = x * vec.y - y * vec.x
    Vec3D.new(xc, yc, zc)
  end
  
  # Scalar product, also known as inner product or dot product
  def dot(vec)
    x * vec.x + y * vec.y + z * vec.z
  end
  
  def collinear_with?(vec)
    cross(vec) == Vec3D.new
  end

  def to_a
    [x, y, z]
  end
  
  def +(vec)
    Vec3D.new(x + vec.x, y + vec.y, z + vec.z)
  end 
  
  def -(vec)
    Vec3D.new(x - vec.x, y - vec.y, z - vec.z)
  end
  
  def * (scalar)       
    Vec3D.new(x * scalar, y * scalar, z * scalar)
  end

  def / (scalar)      
    Vec3D.new(x / scalar, y / scalar, z / scalar) unless scalar.abs < EPSILON
  end
  
  def normalize   	  
    magnitude = Math.sqrt(x**2 + y**2 + z**2)
    Vec3D.new( x / magnitude, y / magnitude, z / magnitude)
  end
  
  def normalize!    	  
    magnitude = Math.sqrt(x**2 + y**2 + z**2)
    @x, @y, @z = x / magnitude, y / magnitude, z / magnitude
    return self
  end
  
  def set_mag(scalar)
    magnitude = Math.sqrt(x**2 + y**2 + z**2)
    @x, @y, @z = (x * scalar) / magnitude, (y * scalar) / magnitude, (z * scalar) / magnitude
    return self    
  end
  
  def to_s
    "#{self.class}(x=#{x}, y=#{y}, z=#{z})"  
  end

end





