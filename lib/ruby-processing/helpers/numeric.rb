class Numeric #:nodoc
  
  def degrees
    self*180/Math::PI
  end
  
  def radians
    self*Math::PI/180
  end

end