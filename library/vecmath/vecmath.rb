require 'rpextras'

# HACK: required for exported applications, comment out or replace first line
# with next line (create a lib folder here and move rpextras.jar there.
# require_relative 'lib/rpextras'

Java::ProcessingVecmathArcball::ArcballLibrary.new.load(JRuby.runtime, false)
Java::ProcessingVecmathVec2::Vec2Library.new.load(JRuby.runtime, false)
Java::ProcessingVecmathVec3::Vec3Library.new.load(JRuby.runtime, false)

AppRender = Java::ProcessingVecmath::AppRender
ShapeRender = Java::ProcessingVecmath::ShapeRender
