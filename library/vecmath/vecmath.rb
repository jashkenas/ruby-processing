require_relative '../../lib/ruby-processing'
require "#{RP5_ROOT}/lib/rpextras"

Java::MonkstoneVecmathVec2::Vec2Library.new.load(JRuby.runtime, false)
Java::MonkstoneVecmathVec3::Vec3Library.new.load(JRuby.runtime, false)

AppRender = Java::MonkstoneVecmath::AppRender
ShapeRender = Java::MonkstoneVecmath::ShapeRender
# see runner.rb where rpextras gets loaded see ext for java classes
module Processing
  # Access the built in ArcBall funtionality
  class ArcBall
    def self.init app, center_x = nil, center_y = nil, radius = nil
      x = center_x.nil? ? app.width * 0.5 : center_x
      y = center_y.nil? ? app.height * 0.5 : center_y
      r = radius.nil? ? app.height * 0.5 : radius
      arcball = Java::MonkstoneArcball::Arcball.new(app.to_java, x.to_java(:float), y.to_java(:float), r.to_java(:float))
      arcball.set_active true
    end
  end
end
