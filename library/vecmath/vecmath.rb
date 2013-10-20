EPSILON = 9.999999747378752e-05     # a value used by processing.org

class Vec 
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

  def to_a
    [x, y, z]
  end
  
  def self.dist_squared(vec_a, vec_b)
    (vec_a.x - vec_b.x)**2 + (vec_a.y - vec_b.y)**2 + (vec_a.z - vec_b.z)**2
  end
 
  def self.dist(vec_a, vec_b)
    Math.sqrt((vec_a.x - vec_b.x)**2 + (vec_a.y - vec_b.y)**2 + (vec_a.z - vec_b.z)**2)
  end

  def to_s
    "#{self.class}(Use Vec2D, Vec3D or make your own subclass)"  
  end

  def inspect
    self.to_s
  end
end


class Vec2D < Vec

  def to_a
    [x, y]
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
  
  def normalize!
    magnitude = Math.hypot(x, y)	  
    @x, @y = x / magnitude, y / magnitude
    return self
  end
  
  def set_mag(scalar)
    magnitude = Math.hypot(x, y)	  
    @x, @y = (x * scalar) / magnitude, (y * scalar) / magnitude
    return self    
  end
  
  def to_s
    "#{self.class}(x=#{x}, y=#{y})"  
  end
  
  alias :mag :modulus 

end

class Vec3D < Vec

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

  alias :mag :modulus 

end


class Quaternion
    
  attr_reader :w, :x, :y, :z

  def initialize(w = 1.0,  x = 0,  y = 0,  z = 0)
    @w, @x, @y, @z = w,  x,  y,  z
  end

  def ==(quat)
    (w - quat.w).abs < EPSILON && (x - quat.x).abs < EPSILON && (y - quat.y).abs < EPSILON && (z - quat.z).abs < EPSILON
  end


  def reset
    @w = 1.0
    @x = 0.0
    @y = 0.0
    @z = 0.0
  end

  def set(w, v)
    @w, @x, @y, @z = w, v.x, v.y, v.z 
  end

  def copy(q)
     @w, @x, @y, @z = q.w, q.x, q.y, q.z
  end

  def self.mult(q1, q2)      # class method   
    x0 = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y
    y0 = q1.w * q2.y + q1.y * q2.w + q1.z * q2.x - q1.x * q2.z
    z0 = q1.w * q2.z + q1.z * q2.w + q1.x * q2.y - q1.y * q2.x
    w0 = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z
    Quaternion.new(w0,  x0,  y0,  z0)
  end
  
  def * (q1)                 # instance method   
    x0 = w * q1.x + x * q1.w + y * q1.z - z * q1.y
    y0 = w * q1.y + y * q1.w + z * q1.x - x * q1.z
    z0 = w * q1.z + z * q1.w + x * q1.y - y * q1.x
    w0 = w * q1.w - x * q1.x - y * q1.y - z * q1.z
    Quaternion.new(w0,  x0,  y0,  z0)
  end

  def get_value
    sa = Math.sqrt(1.0 - w * w)
    sa = 1.0 unless (sa >= EPSILON)
    [Math.acos(w) * 2, x / sa, y / sa, z / sa]
  end
  
  def to_s
    "#{self.class}(w=#{w}, x=#{x}, y=#{y}, z=#{z})"  
  end

  def inspect
    self.to_s
  end
end

class ArcBall
  attr_reader :center_x, :center_y, :v_down, :v_drag, :q_now, :q_drag, :q_down, :axis, :axis_set, :radius

  def initialize(cx, cy, radius)
    @center_x = cx
    @center_y = cy
    @radius = radius
    @v_down = Vec3D.new
    @v_drag = Vec3D.new
    @q_now = Quaternion.new
    @q_down = Quaternion.new
    @q_drag = Quaternion.new
    @axis_set = [Vec3D.new(1.0, 0.0, 0.0), Vec3D.new(0.0, 1.0, 0.0), Vec3D.new(0.0, 0.0, 1.0)]
    @axis = -1
  end

  def select_axis(axis)
    @axis = axis
  end

  def mouse2sphere(x, y)
    v = Vec3D.new((x - center_x) / radius, (y - center_y) / radius, 0)
    mag = v.mag
    if (mag > 1.0)
      v.normalize!
    else
      v.z = Math.sqrt(1.0 - mag)
    end
    v = constrain(v, axis_set[axis]) unless (axis == -1)
    return v
  end

  def mouse_pressed(x, y)
    @v_down = mouse2sphere(x, y)
    @q_down.copy(q_now)
    @q_drag.reset
  end

  def mouse_dragged(x, y)
    @v_drag = mouse2sphere(x, y)
    @q_drag.set(v_down.dot(v_drag), v_down.cross(v_drag))
  end


  def constrain(vector, axis)
    res = vector - (axis * axis.dot(vector))
    res.normalize!
  end

  def update
    @q_now = q_drag * q_down
    quat2matrix(q_now)
  end

  def quat2matrix(q)
    q.get_value
  end
end



