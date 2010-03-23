# A Bezier playground. Click to shape the curve. Drag to move it.
# Arrows toggle between curves, delete removes them.
# You can print out the parametric equations for t = 0..1

module Math
  
  def self.overlaps(x, y, point_x, point_y)
    Math.sqrt((x-point_x)**2 + (y-point_y)**2) < Bezier::RADIUS 
  end
  
end


class Curve
  
  attr_accessor :x1, :y1, :c1x, :c1y, :c2x, :c2y, :x2, :y2
  
  def initialize
    @x1, @y1, @x2, @y2 = Bezier::X1, Bezier::Y1, Bezier::X2, Bezier::Y2
    set_control_points(  Bezier::X1+30, Bezier::Y1, Bezier::X2-30, Bezier::Y2)
  end
  
  
  def contains(x, y)
    return :one if Math.overlaps(@x1, @y1, x, y)
    return :two if Math.overlaps(@x2, @y2, x, y)
  end
  
  
  def all_points
    return x1, y1, c1x, c1y, c2x, c2y, x2, y2
  end
  
  
  def control_points
    return c1x, c1y, c2x, c2y
  end
  
  
  def set_control_points(*points)
    @c1x, @c1y, @c2x, @c2y = *points
  end
  
  
  def draw
    $app.bezier *all_points
    $app.oval @x1, @y1, 3, 3
    $app.oval @x2, @y2, 3, 3
  end
  
  
  def print_equation
    p = all_points.map {|p| p.to_i }
    puts ""
    puts "*** line ##{$app.curves.index(self) + 1} ***"
    puts "x = (1-t)^3 #{p[0]} + 3(1-t)^2 t#{p[2]} + 3(1-t)t^2 #{p[4]} + t^3 #{p[6]}"
    puts "y = -1 * ((1-t)^3 #{p[1]} + 3(1-t)^2 t#{p[3]} + 3(1-t)t^2 #{p[5]} + t^3 #{p[7]})"
    puts ""
  end
  
end


class Bezier < Processing::App
  
  attr_accessor :curves, :c1x, :c1y, :c2x, :c2y
  
  X1, Y1, X2, Y2 = 50.0, 50.0, 250.0, 250.0
  REDDISH = [250, 100, 100]
  RADIUS = 7
  
  load_library :control_panel

  def setup
    size 700, 700
    smooth
    @curves = []
    
    control_panel do |c|
      c.button :new_curve
      c.button :print_equations
    end
    
    generate_curve
  end
  
  
  def print_equations
    @curves.each {|c| c.print_equation }
  end
  
  
  def control_points
    return c1x, c1y, c2x, c2y
  end
  
  
  def set_control_points(*points)
    @c1x, @c1y, @c2x, @c2y = points.any? ? points : [X1, Y1, X2, Y2]
  end
  
  
  def generate_curve
    @curves << @current_curve = Curve.new
    @current = @curves.length - 1
    set_control_points(*current_curve.control_points)
  end
  
  
  def current_curve
    @curves[@current]
  end
  
  
  def new_curve
    current_curve.set_control_points(c1x, c1y, c2x, c2y)
    generate_curve
  end
  
  
  def clicked_control_point?
    x, y = mouse_x, mouse_y
    return :one if Math.overlaps(@c1x, @c1y, x, y)
    return :two if Math.overlaps(@c2x, @c2y, x, y)
  end
  
  
  def key_pressed
    case keyCode
    when 8 # Delete the current line
      return if @curves.length <= 1
      @curves.delete(current_curve) 
      @current = @curves.length - 1
    when LEFT # Flip forward
      @current = (@current + 1) % @curves.length
    when RIGHT # Flip back
      @current = (@current - 1) % @curves.length
    end
    set_control_points(*current_curve.control_points)
  end
  
  
  def mouse_pressed
    switch_curve_if_endpoint_clicked
    @control = clicked_control_point?
    return if @control
    curve = @curves.detect {|c| c.contains(mouse_x, mouse_y) }
    @end_point = curve.contains(mouse_x, mouse_y) if curve
  end
  
  
  def mouse_released
    @control, @end_point = nil, nil
  end
  
  
  def mouse_dragged
    offs = compute_offsets
    return if offs.map {|o| o.abs }.max > 100
    return move_control_point(*offs) if @control
    return move_end_point(*offs) && move_control_point(*offs) if @end_point
    move_current_curve(*offs)
  end
  
  
  def switch_curve_if_endpoint_clicked
    become = @curves.detect {|c| c.contains(mouse_x, mouse_y) }
    return unless become && become != current_curve
    current_curve.set_control_points(*control_points)
    self.set_control_points(*become.control_points)
    @current = @curves.index(become)
  end
  
  
  def move_current_curve(x_off, y_off)
    @c1x += x_off; @c2x += x_off
    @c1y += y_off; @c2y += y_off
    current_curve.set_control_points(*control_points)
    current_curve.x1 += x_off; current_curve.x2 += x_off
    current_curve.y1 += y_off; current_curve.y2 += y_off
  end
  
  
  def move_control_point(x_off, y_off)
    case @control || @end_point
    when :one : @c1x += x_off and @c1y += y_off
    when :two : @c2x += x_off and @c2y += y_off
    end
    current_curve.set_control_points(*control_points)
  end
  
  
  def move_end_point(x_off, y_off)
    c = current_curve
    case @end_point
    when :one : c.x1 += x_off and c.y1 += y_off
    when :two : c.x2 += x_off and c.y2 += y_off
    end
  end
  
  
  def compute_offsets
    return mouse_x - pmouse_x, mouse_y - pmouse_y
  end
  
  
  def draw_curves
    stroke 255
    no_fill
    stroke_width 2
    @curves.each {|curve| curve.draw }
  end
  
  
  def draw_current_control_points
    fill *REDDISH
    no_stroke
    oval @c1x, @c1y, 5, 5
    oval @c2x, @c2y, 5, 5
  end
  
  
  def draw_control_tangent_lines
    c = current_curve
    stroke *REDDISH
    stroke_width 1
    line @c1x, @c1y, c.x1, c.y1
    line @c2x, @c2y, c.x2, c.y2
  end
    
  
  def draw
    background 50
    draw_control_tangent_lines
    draw_curves
    draw_current_control_points
  end
  
end

Bezier.new