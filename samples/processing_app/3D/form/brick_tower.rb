# Original by Ira Greenberg

# 3D castle tower constructed out of individual bricks.
# Uses the PVecor and Cube classes.

def setup
  @bricks_per_layer = 16
  @brick_layers = 18
  @brick_width, @brick_height, @brick_depth = 60, 25, 25
  @radius = 175.0
  @angle = 0
  size 640, 360, P3D
  @brick = Cubeish.new(@brick_width, @brick_height, @brick_depth)
end

def draw
  background 0
  @temp_x, @temp_y, @temp_z = 0, 0, 0
  fill 182, 62, 29
  no_stroke
  lights
  translate(width/2.0, height*1.2, -380)                  # move viewpoint into position
  rotate_x(radians(-45))                                  # tip tower to see inside
  rotate_y(frame_count * PI/600)                          # slowly rotate tower
  @brick_layers.times {|i| draw_layer(i) }
end

def draw_layer(layer_num)
  @layer_num = layer_num
  @temp_y -= @brick_height                                # increment rows
  @angle = 360.0 / @bricks_per_layer * @layer_num / 2.0   # alternate brick seams
  @bricks_per_layer.times {|i| draw_bricks(i) }
end

def draw_bricks(brick_num)
  @brick_num = brick_num
  @temp_z = cos(radians(@angle)) * @radius
  @temp_x = sin(radians(@angle)) * @radius
  push_matrix
  translate @temp_x, @temp_y, @temp_z
  rotate_y(radians(@angle))
  top_layer = @layer_num == @brick_layers - 1
  even_brick = @brick_num % 2 == 0
  @brick.create unless top_layer                          # main tower
  @brick.create if top_layer && even_brick                # add crenelation
  pop_matrix
  @angle += 360.0 / @bricks_per_layer
end


# The Cubeish class works a little different than the cube in the
# Processing example. SIDES tells you where the negative numbers go.
# We dynamically create each of the PVectors by passing in the
# appropriate signs.
class Cubeish
  SIDES = {:front  => ['-- ', ' - ', '   ', '-  '],
           :left   => ['-- ', '---', '- -', '-  '],
           :right  => [' - ', ' --', '  -', '   '],
           :back   => ['---', ' --', '  -', '- -'],
           :top    => ['-- ', '---', ' --', ' - '],
           :bottom => ['-  ', '- -', '  -', '   ']}

  SIGNS = {'-' => -1,
           ' ' =>  1}

  def initialize(width, height, depth)
    @vertices = {}
    @w, @h, @d = width, height, depth

    SIDES.each do |side, signs|
      @vertices[side] = signs.map do |s|
        s = s.split('').map {|el| SIGNS[el] }
        App::PVector.new(s[0]*@w/2, s[1]*@h/2, s[2]*@d/2)
      end
    end
  end

  def create
    @vertices.each do |name, vectors|
      begin_shape App::QUADS
      vectors.each {|v| vertex(v.x, v.y, v.z) }
      end_shape
    end
  end

end