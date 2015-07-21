require_relative '../../lib/ruby-processing'
require "#{RP5_ROOT}/lib/rpextras"

Java::MonkstoneArcball::ArcballLibrary.new.load(JRuby.runtime, false)
Java::MonkstoneVecmathVec2::Vec2Library.new.load(JRuby.runtime, false)
Java::MonkstoneVecmathVec3::Vec3Library.new.load(JRuby.runtime, false)

AppRender ||= Java::MonkstoneVecmath::AppRender
ShapeRender ||= Java::MonkstoneVecmath::ShapeRender
