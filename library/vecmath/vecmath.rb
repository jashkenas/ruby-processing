require_relative '../../lib/ruby-processing'
require "#{RP5_ROOT}/lib/rpextras"

Java::ProcessingVecmathArcball::ArcballLibrary.new.load(JRuby.runtime, false)
Java::ProcessingVecmathVec2::Vec2Library.new.load(JRuby.runtime, false)
Java::ProcessingVecmathVec3::Vec3Library.new.load(JRuby.runtime, false)

AppRender = Java::ProcessingVecmath::AppRender
ShapeRender = Java::ProcessingVecmath::ShapeRender
