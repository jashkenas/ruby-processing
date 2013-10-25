# Trefoil, by Andres Colubri
# A parametric surface is textured procedurally
# by drawing on an offscreen PGraphics surface.

attr_reader :pg, :trefoil

def setup
  size(1024, 768, P3D)
  
  texture_mode(NORMAL)
  noStroke

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
  pg.ellipse(rand * pg.width, rand * pg.height, 4, 4)
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
# coordinates.
# Adapted from the parametric equations example by Philip Rideout:
# http:#iphone-3d-programming.labs.oreilly.com/ch03.html

# This function draws a trefoil knot surface as a triangle mesh derived
# from its parametric equation.
def create_trefoil(s, ny, nx, tex)
 
  obj = create_shape()
  obj.begin_shape(TRIANGLES)
  obj.texture(tex)
    
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
      obj.normal(n0.x, n0.y, n0.z)
      obj.vertex(s * p0.x, s * p0.y, s * p0.z, u0, v0)      
      obj.normal(n1.x, n1.y, n1.z)
      obj.vertex(s * p1.x, s * p1.y, s * p1.z, u0, v1)
      obj.normal(n2.x, n2.y, n2.z)
      obj.vertex(s * p2.x, s * p2.y, s * p2.z, u1, v1)

      p1 = eval_point(u1, v0)
      n1 = eval_normal(u1, v0)

      # Triangle p0-p2-p1      
      obj.normal(n0.x, n0.y, n0.z)
      obj.vertex(s * p0.x, s * p0.y, s * p0.z, u0, v0)      
      obj.normal(n2.x, n2.y, n2.z)
      obj.vertex(s * p2.x, s * p2.y, s * p2.z, u1, v1)
      obj.normal(n1.x, n1.y, n1.z)
      obj.vertex(s * p1.x, s * p1.y, s * p1.z, u1, v0)      
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
  tangU.sub(p)
  tangV.sub(p)
  
  normUV = tangV.cross(tangU)
  normUV.normalize
  return normUV
end

# Evaluates the surface point corresponding to normalized 
# parameters (u, v)
def eval_point(u, v)
  a = 0.5
  b = 0.3
  c = 0.5
  d = 0.1
  s = TWO_PI * u
  t = (TWO_PI * (1 - v)) * 2  
        
  r = a + b * cos(1.5 * t)
  x = r * cos(t)
  y = r * sin(t)
  z = c * sin(1.5 * t)
        
  dv = PVector.new
  dv.x = -1.5 * b * sin(1.5 * t) * cos(t) - (a + b * cos(1.5 * t)) * sin(t)
  dv.y = -1.5 * b * sin(1.5 * t) * sin(t) + (a + b * cos(1.5 * t)) * cos(t)
  dv.z = 1.5 * c * cos(1.5 * t)
        
  q = dv      
  q.normalize
  qvn = PVector.new(q.y, -q.x, 0)
  qvn.normalize
  ww = q.cross(qvn)
        
  pt = PVector.new
  pt.x = x + d * (qvn.x * cos(s) + ww.x * sin(s))
  pt.y = y + d * (qvn.y * cos(s) + ww.y * sin(s))
  pt.z = z + d * ww.z * sin(s)
  return pt
end
