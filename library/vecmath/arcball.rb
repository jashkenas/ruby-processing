# An example of a pure ruby library
# by Martin Prout, based on the original by Ken Shoemake 
# and Ariel Malka version for processing.
#
class ArcBall
  attr_reader :center_x, :center_y, :v_down, :v_drag, :q_now, :q_drag, :q_down, :axis, :axis_set, :radius

  def initialize(cx, cy, radius)
    @center_x = cx
    @center_y = cy
    @radius = radius
    @v_down = AVector.new
    @v_drag = AVector.new
    @q_now = Quaternion.new
    @q_down = Quaternion.new
    @q_drag = Quaternion.new
    @axis_set = [AVector.new(1.0, 0.0, 0.0), AVector.new(0.0, 1.0, 0.0), AVector.new(0.0, 0.0, 1.0)]
    @axis = -1
  end

  def select_axis(axis)
    @axis = axis
  end

  def mouse2sphere(x, y)
    v = AVector.new((x - center_x) / radius, (y - center_y) / radius, 0)
    mag = v.x * v.x + v.y * v.y
    if (mag > 1.0)
      v.normalize
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
    @q_drag.set(AVector.dot(v_down, v_drag), v_down.cross(v_drag))
  end


  def constrain(vector, axis)
    res = AVector.sub(vector, AVector.mult(axis, AVector.dot(axis, vector)))
    res.normalize
  end

  def update
    @q_now = q_drag * q_down
    quat2matrix(q_now)
  end

  def quat2matrix(q)
    q.get_value
  end
end

class Quaternion
  attr_reader :w, :x, :y, :z

  def initialize(w = 1.0,  x = 0,  y = 0,  z = 0)
    @w, @x, @y, @z = w,  x,  y,  z
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
    Quaternion.mult(self, q1)
  end

  def get_value
    sa = Math.sqrt(1.0 - w * w)
    sa = 1.0 unless (sa >= Java::processing::core::PConstants::EPSILON)
    [Math.acos(w) * 2, x / sa, y / sa, z / sa]
  end
end

class AVector

  attr_accessor :x, :y, :z

  def initialize(x = 0, y = 0, z = 0)
    @x, @y, @z = x, y, z
  end

  def add(vector)
    AVector.new(vector.x + x, vector.y + y, vector.z + z)
  end

  def normalize
    orig_dist = Math.sqrt(x * x + y * y + z * z)
    @x /= orig_dist
    @y /= orig_dist
    @z /= orig_dist
    self
  end

  def self.dot(v1, v2)
    v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
  end

  def self.mult(v, scalar)
    AVector.new(v.x * scalar, v.y * scalar, v.z * scalar)
  end

  def self.sub(v1, v2)
    AVector.new(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
  end

  def cross(v)
    AVector.new(y * v.z - v.y * z,  z * v.x - v.z * x, x * v.y - v.x * y)
  end

end
