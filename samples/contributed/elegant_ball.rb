# elegant_ball.rb
# After a vanilla processing sketch by
# Ben Notorianni aka lazydog
#

load_library :vecmath

def setup
  size(800, 800, P3D)
  color_mode(RGB, 1)
end

def draw
  #background(0.25)
  background(0)
  # Move the origin so that the scene is centered on the screen.
  translate(width/2, height/2, 0.0)
  # Set up the lighting.
  setup_lights
  # Rotate the local coordinate system.
  smooth_rotation(5.0, 6.7, 7.3)
  # Draw the inner object.
  no_stroke
  fill(smooth_colour(10.0, 12.0, 7.0))
  draw_icosahedron(5, 60.0, false)
  # Rotate the local coordinate system again.
  smooth_rotation(4.5, 3.7, 7.3)
  # Draw the outer object.
  stroke(0.2)
  fill(smooth_colour(6.0, 9.2, 0.7))
  draw_icosahedron(5, 200.0, true)
end

def setup_lights
  ambient_light(0.025, 0.025, 0.025)
  directional_light(0.2, 0.2, 0.2, -1, -1, -1)
  spot_light(1.0, 1.0, 1.0, -200, 0, 300, 1, 0, -1, Math::PI/4, 20)
end

##
# Generate a vector whose components change smoothly over time in the range [ 0, 1 ].
# Each component uses a Math.sin function to map the current time in milliseconds somewhere
# in the range [ 0, 1 ].A 'speed' factor is specified for each component.
#
def smooth_vector(s1, s2, s3)
  mills = millis * 0.00003
  x = 0.5 * Math.sin(mills * s1) + 0.5
  y = 0.5 * Math.sin(mills * s2) + 0.5
  z = 0.5 * Math.sin(mills * s3) + 0.5
  Vec3D.new(x, y, z)
end

##
# Generate a colour which smoothly changes over time.
# The speed of each component is controlled by the parameters s1, s2 and s3.
#
def smooth_colour(s1, s2, s3)
  v = smooth_vector(s1, s2, s3)
  color(v.x, v.y, v.z)
end

##
# Rotate the current coordinate system.
# Uses smooth_vector to smoothly animate the rotation.
#
def smooth_rotation(s1, s2, s3)
  r1 = smooth_vector(s1, s2, s3)
  rotate_x(2.0 * Math::PI * r1.x)
  rotate_y(2.0 * Math::PI * r1.y)
  rotate_x(2.0 * Math::PI * r1.z)
end

##
# Draw an icosahedron defined by a radius r and recursive depth d.
# Geometry data will be saved into dst. If spherical is true then the icosahedron
# is projected onto the sphere with radius r.
#
def draw_icosahedron(depth, r, spherical)
  # Calculate the vertex data for an icosahedron inscribed by a sphere radius 'r'.
  # Use 4 Golden Ratio rectangles as the basis.
  gr = (1.0 + Math.sqrt(5.0)) / 2.0
  h = r / Math.sqrt(1.0 + gr * gr)
  v =
    [
  Vec3D.new(0, -h, h*gr), Vec3D.new(0, -h, -h*gr), Vec3D.new(0, h, -h*gr), Vec3D.new(0, h, h*gr),
  Vec3D.new(h, -h*gr, 0), Vec3D.new(h, h*gr, 0), Vec3D.new(-h, h*gr, 0), Vec3D.new(-h, -h*gr, 0),
  Vec3D.new(-h*gr, 0, h), Vec3D.new(-h*gr, 0, -h), Vec3D.new(h*gr, 0, -h), Vec3D.new(h*gr, 0, h)
  ]
  
  # Draw the 20 triangular faces of the icosahedron.
  unless spherical then
    r = 0.0
  end
  
  begin_shape(TRIANGLES)
    
  draw_triangle(depth, r, v[0], v[7],v[4])
  draw_triangle(depth, r, v[0], v[4], v[11])
  draw_triangle(depth, r, v[0], v[11], v[3])
  draw_triangle(depth, r, v[0], v[3], v[8])
  draw_triangle(depth, r, v[0], v[8], v[7])
  
  draw_triangle(depth, r, v[1], v[4], v[7])
  draw_triangle(depth, r, v[1], v[10], v[4])
  draw_triangle(depth, r, v[10], v[11], v[4])
  draw_triangle(depth, r, v[11], v[5], v[10])
  draw_triangle(depth, r, v[5], v[3], v[11])
  draw_triangle(depth, r, v[3], v[6], v[5])
  draw_triangle(depth, r, v[6], v[8], v[3])
  draw_triangle(depth, r, v[8], v[9], v[6])
  draw_triangle(depth, r, v[9], v[7], v[8])
  draw_triangle(depth, r, v[7], v[1], v[9])
  
  draw_triangle(depth, r, v[2], v[1], v[9])
  draw_triangle(depth, r, v[2], v[10], v[1])
  draw_triangle(depth, r, v[2], v[5], v[10])
  draw_triangle(depth, r, v[2], v[6], v[5])
  draw_triangle(depth, r, v[2], v[9], v[6])
  
  end_shape
end

##
# Draw a triangle either immediately or subdivide it first.
# If depth is 1 then draw the triangle otherwise subdivide first.
#
def draw_triangle(depth, r, p1, p2, p3)
  
  if (depth == 1) then
    vertex(p1.x, p1.y, p1.z)
    vertex(p2.x, p2.y, p2.z)
    vertex(p3.x, p3.y, p3.z)
  else
    # Calculate the mid points of this triangle.
    v1 = (p1 + p2) * 0.5
    v2 = (p2 + p3) * 0.5
    v3 = (p3 + p1) * 0.5
    unless (r == 0.0) then
      # Project the verticies out onto the sphere with radius r.
      v1.normalize!
      v1 *= r
      v2.normalize!
      v2 *= r
      v3.normalize!
      v3 *= r
    end
    ## Generate the next level of detail
    depth -= 1
    draw_triangle(depth, r, p1, v1, v3)
    draw_triangle(depth, r, v1, p2, v2)
    draw_triangle(depth, r, v2, p3, v3)
    # Uncomment out the next line to include the central part of the triangle.
    # draw_triangle(depth, r, v1, v2, v3)
  end
  
end




