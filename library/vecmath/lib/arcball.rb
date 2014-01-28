require_relative 'vec'
require_relative 'quaternion'

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



