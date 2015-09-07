require_relative '../../lib/ruby-processing'
require "#{RP5_ROOT}/lib/rpextras"

Java::MonkstoneArcball::ArcballLibrary.load(JRuby.runtime)
Java::MonkstoneVecmathVec2::Vec2Library.load(JRuby.runtime)
Java::MonkstoneVecmathVec3::Vec3Library.load(JRuby.runtime)

AppRender ||= Java::MonkstoneVecmath::AppRender
ShapeRender ||= Java::MonkstoneVecmath::ShapeRender
