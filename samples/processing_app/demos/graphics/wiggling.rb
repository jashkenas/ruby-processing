# Press 'w' to start wiggling, space to restore
# original positions.

load_library :fastmath

attr_reader :cube, :wiggling
CUBE_SIZE = 320.0
CIRCLE_RAD = 100.0
CIRCLE_RES = 36
NOISE_MAG = 1.0

# signature-specific alias for overloaded method 
java_alias :background_int, :background, [Java::int]

 
def setup
  size(1024, 768, P3D);    
  wiggling = false
  @cube = create_cube
end

def draw
  background_int(0)
  
  translate(width/2, height/2)
  rotate_x(frame_count * 0.01)
  rotate_y(frame_count * 0.01)
  
  shape(cube)
  
  if (wiggling)
    (0 ... cube.get_child_count).each do |i|
      face = cube.get_child(i)
      face.get_vertex_count.times do |j|
      x, y, z = face.get_vertex_x(j), face.get_vertex_y(j), face.get_vertex_z(j)
      x += rand(-NOISE_MAG/2 .. NOISE_MAG/2)
      y += rand(-NOISE_MAG/2 .. NOISE_MAG/2)
      z += rand(-NOISE_MAG/2 .. NOISE_MAG/2)
      face.set_vertex(j, x, y, z)
    end
  end
end

end

def key_pressed
  case key
  when 'w'
    @wiggling = !wiggling
  when ' '
    restore_cube
  when '1'
    cube.set_stroke_weight(1)
  when '2'
    cube.set_stroke_weight(5)
  when '3'
    cube.set_stroke_weight(10)
  end
end

def create_cube
  cube = create_shape(GROUP)   
  
  # Front face         
  face = create_shape
  face.begin_shape(POLYGON)
  face.stroke(255, 0, 0)
  face.fill(255)
  face.begin_contour
  face.vertex(-CUBE_SIZE / 2, -CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.vertex(CUBE_SIZE / 2, -CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.vertex(CUBE_SIZE / 2, CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.vertex(-CUBE_SIZE / 2, CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.end_contour
  face.begin_contour
  CIRCLE_RES.times do |i|
    angle = 360 * i / CIRCLE_RES
    x = CIRCLE_RAD * DegLut.sin(angle)
    y = CIRCLE_RAD * DegLut.cos(angle)
    z = CUBE_SIZE / 2
    face.vertex(x, y, z)
  end
  face.end_contour
  face.end_shape(CLOSE)
  cube.add_child(face)
  
  # Back face
  face = create_shape
  face.begin_shape(POLYGON)
  face.stroke(255, 0, 0)
  face.fill(255)
  face.begin_contour
  face.vertex(CUBE_SIZE / 2, -CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.vertex(-CUBE_SIZE / 2, -CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.vertex(-CUBE_SIZE / 2, CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.vertex(CUBE_SIZE / 2, CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.end_contour
  face.begin_contour
  CIRCLE_RES.times do |i|
    angle = 360 * i / CIRCLE_RES
    x = CIRCLE_RAD * DegLut.sin(angle)
    y = CIRCLE_RAD * DegLut.cos(angle)
    z = -CUBE_SIZE / 2
    face.vertex(x, y, z)
  end
  face.end_contour
  face.end_shape(CLOSE)
  cube.add_child(face)
  
  # Right face
  face = create_shape
  face.begin_shape(POLYGON)
  face.stroke(255, 0, 0)
  face.fill(255)
  face.begin_contour
  face.vertex(CUBE_SIZE / 2.0, -CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.vertex(CUBE_SIZE / 2.0, -CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.vertex(CUBE_SIZE / 2.0, CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.vertex(CUBE_SIZE / 2.0, CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.end_contour
  face.begin_contour
  CIRCLE_RES.times do |i|
    angle = 360 * i / CIRCLE_RES
    x = CUBE_SIZE / 2
    y = CIRCLE_RAD * DegLut.sin(angle)
    z = CIRCLE_RAD * DegLut.cos(angle)
    face.vertex(x, y, z)
  end
  face.end_contour
  face.end_shape(CLOSE)
  cube.add_child(face)
  
  # Left face
  face = create_shape
  face.begin_shape(POLYGON)
  face.stroke(255, 0, 0)
  face.fill(255)
  face.begin_contour
  face.vertex(-CUBE_SIZE / 2, -CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.vertex(-CUBE_SIZE / 2, -CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.vertex(-CUBE_SIZE / 2, CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.vertex(-CUBE_SIZE / 2, CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.end_contour
  face.begin_contour
  CIRCLE_RES.times do |i|
    angle = 360 * i / CIRCLE_RES
    x = -CUBE_SIZE / 2
    y = CIRCLE_RAD * DegLut.sin(angle)
    z = CIRCLE_RAD * DegLut.cos(angle)
    face.vertex(x, y, z)
  end
  face.end_contour
  face.end_shape(CLOSE)
  cube.add_child(face)
  
  # Top face
  face = create_shape
  face.begin_shape(POLYGON)
  face.stroke(255, 0, 0)
  face.fill(255)
  face.begin_contour
  face.vertex(-CUBE_SIZE / 2, CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.vertex(CUBE_SIZE / 2, CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.vertex(CUBE_SIZE / 2, CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.vertex(-CUBE_SIZE / 2, CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.end_contour
  face.begin_contour
  CIRCLE_RES.times do |i|
    angle = 360 * i / CIRCLE_RES
    x = CIRCLE_RAD * DegLut.sin(angle)
    y = CUBE_SIZE / 2
    z = CIRCLE_RAD * DegLut.cos(angle)
    face.vertex(x, y, z)
  end
  face.end_contour
  face.end_shape(CLOSE)
  cube.add_child(face);     
  
  # Bottom face
  face = create_shape
  face.begin_shape(POLYGON)
  face.stroke(255, 0, 0)
  face.fill(255)
  face.begin_contour
  face.vertex(CUBE_SIZE / 2, -CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.vertex(-CUBE_SIZE / 2, -CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.vertex(-CUBE_SIZE / 2, -CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.vertex(CUBE_SIZE / 2, -CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.end_contour
  face.begin_contour
  CIRCLE_RES.times do |i|
    angle = 360 * i / CIRCLE_RES
    x = CIRCLE_RAD * DegLut.sin(angle)
    y = -CUBE_SIZE / 2
    z = CIRCLE_RAD * DegLut.cos(angle)
    face.vertex(x, y, z)
  end
  face.end_contour
  face.end_shape(CLOSE)
  cube.add_child(face)
  return cube
end

def restore_cube
  
  
  # Front face
  face = cube.get_child(0)
  face.set_vertex(0, -CUBE_SIZE / 2, -CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.set_vertex(1, CUBE_SIZE / 2, -CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.set_vertex(2, CUBE_SIZE / 2, CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.set_vertex(3, -CUBE_SIZE / 2, CUBE_SIZE / 2, CUBE_SIZE / 2)
  CIRCLE_RES.times do |i|
    angle = 360 * i / CIRCLE_RES
    x = CIRCLE_RAD * DegLut.sin(angle)
    y = CIRCLE_RAD * DegLut.cos(angle)
    z = CUBE_SIZE / 2
    face.set_vertex(4 + i, x, y, z)
  end
  
  # Back face
  face = cube.get_child(1)
  face.set_vertex(0, CUBE_SIZE / 2, -CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.set_vertex(1, -CUBE_SIZE / 2, -CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.set_vertex(2, -CUBE_SIZE / 2, CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.set_vertex(3, CUBE_SIZE / 2, CUBE_SIZE / 2, -CUBE_SIZE / 2)
  CIRCLE_RES.times do |i|
    angle = 360 * i / CIRCLE_RES
    x = CIRCLE_RAD * sin(angle)
    y = CIRCLE_RAD * cos(angle)
    z = -CUBE_SIZE / 2
    face.set_vertex(4 + i, x, y, z)
  end
  
  # Right face
  face = cube.get_child(2)
  face.set_vertex(0, CUBE_SIZE / 2, -CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.set_vertex(1, CUBE_SIZE / 2, -CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.set_vertex(2, CUBE_SIZE / 2, CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.set_vertex(3, CUBE_SIZE / 2, CUBE_SIZE / 2, CUBE_SIZE / 2)
  CIRCLE_RES.times do |i|
    angle = 360 * i / CIRCLE_RES
    x = CUBE_SIZE / 2
    y = CIRCLE_RAD * DegLut.sin(angle)
    z = CIRCLE_RAD * DegLut.cos(angle)
    face.set_vertex(4 + i, x, y, z)
  end
  
  # Left face
  face = cube.get_child(3)
  face.set_vertex(0, -CUBE_SIZE / 2, -CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.set_vertex(1, -CUBE_SIZE / 2, -CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.set_vertex(2, -CUBE_SIZE / 2, CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.set_vertex(3, -CUBE_SIZE / 2, CUBE_SIZE / 2, -CUBE_SIZE / 2)
  CIRCLE_RES.times do |i|
    angle = 360 * i / CIRCLE_RES
    x = -CUBE_SIZE / 2
    y = CIRCLE_RAD * DegLut.sin(angle)
    z = CIRCLE_RAD * DegLut.cos(angle)
    face.set_vertex(4 + i, x, y, z)
  end    
  
  # Top face
  face = cube.get_child(4)
  face.set_vertex(0, -CUBE_SIZE / 2, CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.set_vertex(1, CUBE_SIZE / 2, CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.set_vertex(2, CUBE_SIZE / 2, CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.set_vertex(3, -CUBE_SIZE / 2, CUBE_SIZE / 2, -CUBE_SIZE / 2)
  CIRCLE_RES.times do |i|
    angle = 360 * i / CIRCLE_RES
    x = CIRCLE_RAD * DegLut.sin(angle)
    y = CUBE_SIZE / 2
    z = CIRCLE_RAD * DegLut.cos(angle)
    face.set_vertex(4 + i, x, y, z)
  end    
  
  # Bottom face
  face = cube.get_child(5)
  face.set_vertex(0, CUBE_SIZE / 2, -CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.set_vertex(1, -CUBE_SIZE / 2, -CUBE_SIZE / 2, CUBE_SIZE / 2)
  face.set_vertex(2, -CUBE_SIZE / 2, -CUBE_SIZE / 2, -CUBE_SIZE / 2)
  face.set_vertex(3, CUBE_SIZE / 2, -CUBE_SIZE / 2, -CUBE_SIZE / 2)
  CIRCLE_RES.times do |i|
    angle = 360 * i / CIRCLE_RES
    x = CIRCLE_RAD * DegLut.sin(angle)
    y = -CUBE_SIZE / 2
    z = CIRCLE_RAD * DegLut.cos(angle)
    face.set_vertex(4 + i, x, y, z)
  end
end

