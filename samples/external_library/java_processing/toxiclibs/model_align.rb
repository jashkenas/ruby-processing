# This example demonstrates how to rotate a number of meshes
# so that each points towards a common & user controlled focal point.
#
# Requires toxiclibs-0020 or newer
#
# (c) 2012 Karsten Schmidt / LGPL2 licensed
#
load_libraries :toxiclibscore, :toxiclibs_p5, :colorutils, :vecmath

module Toxi
  include_package 'toxi.geom'
  include_package 'toxi.geom.mesh'
  include_package 'toxi.processing'
end

# container for mesh positions

attr_reader :gfx, :positions

def setup
  size(640,480,P3D)
  ArcBall.init(self)
  @gfx = Toxi::ToxiclibsSupport.new(self)
  # compute mesh positions on circle in XZ plane
  @positions = (Toxi::Circle.new(200).toPolygon2D(8)).map{ |p| p.to3DXZ}
end

def draw
  background(51)
  lights
  no_stroke
  # create manual focal point in XY plane
  focus = Toxi::Vec3D.new((mouse_x - width/2), (mouse_y - height/2), 0)
  # create mesh prototype to draw at all generated positions
  # the mesh is a simple box placed at the world origin
  m = Toxi::AABB.new(25).to_mesh
  # draw focus
  gfx.box(Toxi::AABB.new(focus, 5))
  # align the positive z-axis of mesh to point at focus
  # mesh needs to be located at world origin for it to work correctly
  # only once rotated, move it to actual position
  positions.map {|p| gfx.mesh(m.copy.pointTowards(focus.sub(p), Toxi::Vec3D::Z_AXIS).translate(p))}
  
  # draw connections from mesh centers to focal point
  stroke(0,255,255)
  positions.map {|p| gfx.line(p, focus)}
end

