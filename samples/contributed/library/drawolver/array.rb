 # this is a custom extension of the default Array class allowing for
# more readable code above. Seems to need to live in separate file,
# when updated to run as a bare sketch for processing-2.0
# This file belongs to drawolver.rb
#
class Array
  
  # send one item from each array, expects array to be 2D:
  # array [[1,2,3], [a,b,c]] sends
  # [1,a] , [2,b] , [3,c]
  def one_of_each( &block )    
    i = 0
    one = self[0]
    two = self[1]
    mi = one.length > two.length ? two.length : one.length
    while i < mi do
      yield( one[i], two[i] )
      i = i + 1
    end   
  end 
end

# a wrapper around PVector that implements operators methods for +, -, *, /
#
class RPVector < Java::ProcessingCore::PVector
  
  def + ( other )
    v = RPVector.add( self, other )
    RPVector.new v.x, v.y, v.z
  end
  
  def - ( other )
    v = RPVector.sub( self, other )
    RPVector.new v.x, v.y, v.z
  end
  
  def * ( other )
    v = RPVector.mult( self, other )
    RPVector.new v.x, v.y, v.z
  end
  
  def / ( other )
    v = RPVector.div( self, other )
    RPVector.new v.x, v.y, v.z
  end
  
end


