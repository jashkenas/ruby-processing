# After Gravity by Christian Hahn

attr_reader :particles, :grabbed

def setup
  @particles  = []
  @grabbed    = nil
  
  size 600, 500
  background 0
  smooth
  stroke_weight 4
  ellipse_mode CENTER_DIAMETER
  color_mode RGB, 255
end

def draw
  no_stroke
  fill 0, 60
  rect 0, 0, width, height
  @particles.each {|p| p.collect_force; p.move; p.render }
end

def mouse_pressed
  return if mouse_x == 0 || mouse_y == 0
  return if particle_grab
  @particles << Particle.new(mouse_x, mouse_y, rand * 8 + 0.1)
end

def mouse_released
  @grabbed = nil
end

def particle_grab
  @grabbed = @particles.detect {|p| dist(mouse_x, mouse_y, p.x1, p.y1) < p.radius }
end


class Particle
  
  GRAVITY = 1.0
  
  attr_reader :x0, :y0, :x1, :y1, :radius, :mass_amount
  
  def initialize(x, y, mass)
    @x0, @y0, @x1, @y1  = x, y, x, y
    @x_speed, @y_speed  = 0, 0
    @x_accel, @y_accel  = 0, 0
    @mass_amount        = mass
    @diameter           = Math.sqrt(@mass_amount) * 20
    @radius             = @diameter / 2.0
  end
  
  def collect_force
    @x_accel, @y_accel = 0, 0
    @min_dist = 1000
    $app.particles.each do |p|
      next if p == self
      g_dist  = dist(@x0, @y0, p.x0, p.y0)
      g_theta = -(angleOf(@x0, @y0, p.x0, p.y0)).radians
      @min_dist = g_dist if g_dist < @min_dist
      force = (GRAVITY * @mass_amount * p.mass_amount) / g_dist
      if g_dist.abs > @diameter
        @x_accel += force / @mass_amount * Math.cos(g_theta)
        @y_accel += force / @mass_amount * Math.sin(g_theta)
      end
    end
  end
  
  def move
    @x_speed, @y_speed = 0, 0 if grabbed?
    @x_speed += @x_accel
    @y_speed += @y_accel
    @x1, @y1 = @x0 + @x_speed, @y0 + @y_speed
  end
  
  def grabbed?
    $app.grabbed == self
  end
  
  def render
    no_stroke
    grabbed? ? render_grabbed : render_free
  end
  
  def render_free
    charge_col  = 1000.0 / @min_dist / 50.0
    tot_col_1   = 100 + charge_col * 6
    tot_col_2   = 150 + charge_col*charge_col
    tot_col_3   = @diameter + 8 + charge_col
    fill(tot_col_1, tot_col_1, 255, charge_col * 150 + 3)
    ellipse(@x1, @y1, tot_col_3, tot_col_3)
    fill 0, 255
    stroke tot_col_2, tot_col_2, 255, charge_col * 255 + 3
    ellipse @x1, @y1, @diameter, @diameter
    @x0, @y0 = @x1, @y1
  end
  
  def render_grabbed
    fill 150, 150, 255, 100
    ellipse mouse_x, mouse_y, @diameter + 8, @diameter + 8
    fill 0, 255
    stroke 150, 150, 255, 255
    ellipse mouse_x, mouse_y, @diameter, @diameter
    @x0, @y0 = mouse_x, mouse_y
  end
  
  def angleOf(x1, y1, x2, y2)
    xd, yd = x1 - x2, y1 - y2
    180 + (-(180 * Math.atan2(yd, xd)) / PI)
  end
  
end
