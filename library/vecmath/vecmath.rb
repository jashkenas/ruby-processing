# vecmath.rb
# The vecmath library provides Vec2D and Vec3D classes which can be
# use in place of processing PVector, and provide a more rubylike interface.
# Also included in the vecmath library is the ArcBall utility 
# ==== Example Arcball usage see vecmath library in samples
#   def setup 
#      .....
#      camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), 0, 0, 0, 0, 1, 0)
#      @arcball = ArcBall.new(0, 0, min(width - 20, height - 20) * 0.8)
#      .....
#    end
#
#    def update
#      theta, x, y, z = arcball.update
#      rotate(theta, x, y, z)
#    end
#    
#    def mouse_pressed
#      arcball.mouse_pressed(mouse_x, mouse_y)
#    end
#    
#    def mouse_dragged
#      arcball.mouse_dragged(mouse_x, mouse_y)
#    end




require_relative 'lib/vec'
require_relative 'lib/quaternion'
require_relative 'lib/arcball'
