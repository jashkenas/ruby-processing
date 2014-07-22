# uber simple Homogeneous 4 x 4 matrix

class Mat4
  attr_reader :mat

  def initialize(axisX, axisY, axisZ, trans)
    @mat = [
    [axisX.x, axisY.x, axisZ.x, trans.x],
    [axisX.y, axisY.y, axisZ.y, trans.y],
    [axisX.z, axisY.z, axisZ.z, trans.z],
    [0, 0, 0,  1]
    ]
  end 
  
  # The processing version changes the input 'array', here we return
  # a new array with transformed values (which we then assign to the input)
  # see line 89 Frame_of_Reference.rb

  def mult(array)
    array.map { |arr|
      xt = mat[0][0] * arr.x + mat[0][1] * arr.y + mat[0][2] * arr.z + mat[0][3] * 1
      yt = mat[1][0] * arr.x + mat[1][1] * arr.y + mat[1][2] * arr.z + mat[1][3] * 1
      zt = mat[2][0] * arr.x + mat[2][1] * arr.y + mat[2][2] * arr.z + mat[2][3] * 1
      Vec3D.new(xt, yt, zt)
    }
  end
 
end

