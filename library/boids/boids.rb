# Boids -- after Tom de Smedt.
# See his Python version: http://nodebox.net/code/index.php/Boids
# This is an example of how a pure-Ruby library can work.
# -- omygawshkenas

class Boid
  attr_accessor :boids, :x, :y, :z, :vx, :vy, :vz, :is_perching, :perch_time
  
  def initialize(boids, x, y, z)
    @boids, @flock = boids, boids
    @x, @y, @z = x, y, z
    @vx, @vy, @vz = 0.0, 0.0, 0.0
    @is_perching = false
    @perch_time = 0.0
  end
  
  def cohesion(d = 100.0)
    # Boids gravitate towards the center of the flock,
    # Which is the averaged position of the rest of the boids.
    vx = vy = vz = 0.0
    @boids.each do |boid|
      vx, vy, vz = vx+boid.x, vy+boid.y, vz+boid.z unless boid.equal? self
    end
    count = @boids.length - 1.0
    vx, vy, vz = vx/count, vy/count, vz/count
    return (vx - @x) / d, (vy - @y) / d, (vz - @z) / d
  end
  
  def separation(radius = 10.0)
    # Boids don't like to cuddle.
    vx = vy = vz = 0.0
    @boids.each do |boid|
      unless boid.equal? self
        dvx, dvy, dvz = @x - boid.x, @y - boid.y, @z - boid.z
        vx += dvx if dvx.abs < radius
        vy += dvy if dvy.abs < radius
        vz += dvz if dvz.abs < radius
      end
    end
    return vx, vy, vz
  end
  
  def alignment(d = 5.0)
    # Boids like to fly at the speed of traffic.
    vx = vy = vz = 0.0
    @boids.each do |boid|
      unless boid.equal? self
        vx, vy, vz = vx+boid.vx, vy+boid.vy, vz+boid.vz
      end
    end
    count = @boids.length - 1.0
    vx, vy, vz = vx / count, vy / count, vz / count
    return (vx - @vx) / d, (vy - @vy) / d, (vz - @vz) / d
  end
  
  def limit(max=30.0)
    # Tweet, Tweet! The boid police will bust you for breaking the speed limit.
    most = [@vx.abs, @vy.abs, @vz.abs].max
    return if most < max
    scale = max / most.to_f
    @vx *= scale
    @vy *= scale
    @vz *= scale
  end
  
  def angle
    a = (Math.atan(@vy / @vx) * (180.0 / Math::PI)) + 360.0
    a += 180.0 if @vx < 0.0
    return a
  end
  
  def goal(x, y, z, d = 50.0)
    # Them boids is hungry.
    return (x - @x) / d, (y - @y) / d, (z - @z) / d
  end
end



class Boids < Array  
  attr_accessor :boids, :x, :y, :w, :h, 
                :scattered, :has_goal, :flee
                
  attr_reader :scatter, :scatter_time, :scatter_i,
              :perch, :perch_y, :perch_t,
              :goal_x, :goal_y, :goal_z
              
  def self.flock(n, x, y, w, h)
    return Boids.new.setup(n, x, y, w, h)
  end
  
  def setup(n, x, y, w, h)
    n.times do |i|
      dx, dy = rand(w), rand(h)
      z = rand(200.0)
      self << Boid.new(self, x + dx, y + dy, z)
    end
    @x, @y, @w, @h = x, y, w, h
    @scattered = false
    @scatter = 0.005
    @scatter_time = 50.0
    @scatter_i = 0.0
    @perch = 1.0 # Lower this number to divebomb.
    @perch_y = @h
    @perch_time = -> {rand(25.0 .. 75.0)}
    @has_goal = false
    @flee = false
    @goal_x = @goal_y = @goal_z = 0.0
    return self
  end
  
  def scatter(chance = 0.005, frames = 50.0)
    @scatter = chance
    @scatter_time = frames
  end
  
  def no_scatter
    @scatter = 0.0
  end
  
  def perch(ground = nil, chance = 1.0, frames = nil)
    frames ||= -> {rand(25.0 .. 75.0)}
    ground ||= @h
    @perch, @perch_y, @perch_time = chance, ground, frames
  end
  
  def no_perch
    @perch = 0.0
  end
  
  def goal(x, y, z, flee = false)
    @has_goal = true
    @flee = flee
    @goal_x, @goal_y, @goal_z = x, y, z
  end
  
  def no_goal
    @has_goal = false
  end
  
  def constrain
    # Put them boids in a cage.
    dx, dy = @w * 0.1, @h * 0.1
    self.each do |b|
      b.vx += rand(dx) if b.x < @x - dx
      b.vx += rand(dy) if b.y < @y - dy
      b.vx -= rand(dx) if b.x > @x + @w + dx
      b.vy -= rand(dy) if b.y > @y + @h + dy
      b.vz += 10.0 if b.z < 0.0
      b.vz -= 10.0 if b.z > 100.0
      
      if b.y > @perch_y && rand < @perch
        b.y = @perch_y
        b.vy = -(b.vy.abs) * 0.2
        b.is_perching = true
        @perch_time.respond_to?(:call) ? b.perch_time = @perch_time.call : b.perch_time = @perch_time
      end
    end
  end
  
  def shuffle
    self.sort! { rand }
  end
  
  def update(opts={})
    # Just flutter, little boids ... just flutter away.
    # Shuffling keeps things flowing smooth.
    options = {shuffled: true, 
               cohesion: 100.0, 
               separation: 10.0, 
               alignment: 5.0, 
               goal: 20.0, 
               limit: 30.0}
    options.merge! opts
    
    self.shuffle if options[:shuffled]
    m1 = 1.0 # cohesion
    m2 = 1.0 # separation
    m3 = 1.0 # alignment
    m4 = 1.0 # goal
    
    @scattered = true if !(@scattered) && rand < @scatter
    if @scattered
      m1 = -m1
      m3 *= 0.25
      @scatter_i += 1.0
    end
    if @scatter_i >= @scatter_time
      @scattered = false
      @scatter_i = 0.0
    end
    
    m4 = 0.0 unless @has_goal
    m4 = -m4 if @flee
    
    self.each do |b|
      if b.is_perching
        if b.perch_time > 0.0
          b.perch_time -= 1.0
          next
        else
          b.is_perching = false
        end
      end
      
      vx1, vy1, vz1 = b.cohesion(options[:cohesion])
      vx2, vy2, vz2 = b.separation(options[:separation])
      vx3, vy3, vz3 = b.alignment(options[:alignment])
      vx4, vy4, vz4 = b.goal(@goal_x, @goal_y, @goal_z, options[:goal])
      
      b.vx += m1*vx1 + m2*vx2 + m3*vx3 + m4*vx4
      b.vy += m1*vy1 + m2*vy2 + m3*vy3 + m4*vy4
      b.vz += m1*vz1 + m2*vz2 + m3*vz3 + m4*vz4
      
      b.limit(options[:limit])
  
      b.x += b.vx
      b.y += b.vy
      b.z += b.vz
    end
    self.constrain
  end
end
  
  