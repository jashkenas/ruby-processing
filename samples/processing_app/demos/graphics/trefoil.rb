# Trefoil, by Andres Colubri
# A parametric surface is textured procedurally
# by drawing on an offscreen PGraphics surface.
#
# Features (Vec3D).to_normal(renderer) and (Vec3D).to_vertex_uv(renderer, u, v)
# see line 62 for inititialization of renderer where obj is an instance of PShape
# renderer = ShapeRender.new(obj)

load_library :vecmath

attr_reader :pg, :trefoil

def setup
  size(1024, 768, P3D)
  
  texture_mode(NORMAL)
  no_stroke

  # Creating offscreen surface for 3D rendering.
  @pg = create_graphics(32, 512, P3D)
  pg.begin_draw
  pg.background(0, 0)
  pg.noStroke
  pg.fill(255, 0, 0, 200)
  pg.end_draw 

  # Saving trefoil surface into a PShape3D object
  @trefoil = create_trefoil(350, 60, 15, pg)
end

def draw
  background(0)
  
  pg.begin_draw    
  pg.ellipse(rand(0.0..pg.width), rand(0.0..pg.height), 4, 4)
  pg.end_draw 

  ambient(250, 250, 250)
  pointLight(255, 255, 255, 0, 0, 200)
     
  push_matrix
  translate(width/2, height/2, -200)
  rotate_x(frame_count * PI / 500)
  rotate_y(frame_count * PI / 500)      
  shape(trefoil)
  pop_matrix
end

# Code to draw a trefoil knot surface, with normals and texture 
# coordinates. Makes of the Vec3D Render interface (uses ShapeRender here).
# Adapted from the parametric equations example by Philip Rideout:
# http://iphone-3d-programming.labs.oreilly.com/ch03.html

# This function draws a trefoil knot surface as a triangle mesh derived
# from its parametric equation.
def create_trefoil(s, ny, nx, tex)
 
  obj = create_shape()
  
  obj.begin_shape(TRIANGLES)
  obj.texture(tex)
  renderer = ShapeRender.new(obj)
  (0 ... nx).each do |j|
    u0 = j.to_f / nx
    u1 = (j + 1).to_f / nx 
    (0 ... ny).each do |i|
      v0 = i.to_f / ny
      v1 = (i + 1).to_f / ny
      
      p0 = eval_point(u0, v0)
      n0 = eval_normal(u0, v0)
      
      p1 = eval_point(u0, v1)
      n1 = eval_normal(u0, v1)
      
      p2 = eval_point(u1, v1)
      n2 = eval_normal(u1, v1)

      # Triangle p0-p1-p2      
      n0.to_normal(renderer)
      (p0 * s).to_vertex_uv(renderer, u0, v0)     
      n1.to_normal(renderer)
      (p1 * s).to_vertex_uv(renderer, u0, v1)
      n2.to_normal(renderer)
      (p2 * s).to_vertex_uv(renderer, u1, v1)

      p1 = eval_point(u1, v0)
      n1 = eval_normal(u1, v0)

      # Triangle p0-p2-p1      
      n0.to_normal(renderer)
      (p0 * s).to_vertex_uv(renderer, u0, v0) 
      n2.to_normal(renderer)
      (p2 * s).to_vertex_uv(renderer, u1, v1) 
      n1.to_normal(renderer)
      (p1 * s).to_vertex_uv(renderer, u1, v0)       
    end
  end
  obj.end_shape
  return obj
end

# Evaluates the surface normal corresponding to normalized 
# parameters (u, v)
def eval_normal(u, v)
  # Compute the tangents and their cross product.
  p = eval_point(u, v)
  tangU = eval_point(u + 0.01, v)
  tangV = eval_point(u, v + 0.01)
  tangU -= p
  tangV -= p
  tangV.cross(tangU).normalize! # it is easy to chain Vec3D operations
end

# Evaluates the surface point corresponding to normalized 
# parameters (u, v)
def eval_point(u, v)
  a = 0.5
  b = 0.3
  c = 0.5
  d = 0.1
  s = TAU * u
  t = (TAU * (1 - v)) * 2  
        
  sint = sin(t)
  cost = cos(t)
  sint15 = sin(1.5 * t)
  cost15 = cos(1.5 * t)

  r = a + b * cost15
  x = r * cost
  y = r * sint
  z = c * sint15

  dv = Vec3D.new(
  -1.5 * b * sint15 * cost - y,
  -1.5 * b * sint15 * sint + x,
  1.5 * c * cost15)

  q = dv.normalize     # regular normalize creates a new Vec3D for us
  qvn = Vec3D.new(q.y, -q.x, 0).normalize!  # chained Vec3D operations

  ww = q.cross(qvn)

  coss = cos(s)
  sins = sin(s)

  Vec3D.new(
  x + d * (qvn.x * coss + ww.x * sins),
  y + d * (qvn.y * coss + ww.y * sins),
  z + d * ww.z * sins)
end
