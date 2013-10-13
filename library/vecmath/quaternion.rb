class Quaternion
  EPSILON = 9.999999747378752e-05     # a value used by processing.org
  
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


