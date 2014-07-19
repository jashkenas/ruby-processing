# The Flock (a list of Boid objects)
require 'forwardable'

class Flock 
  extend Forwardable
  def_delegators(:@boids, :each, :<<, :reject)
  include Enumerable
  
  def initialize(size, position)
    @boids = (0 .. size).map{Boid.new(position)}	  
  end

  def run
    self.each do |bird|
      bird.run(self)  # Passing the entire list of boids to each boid individually
    end
  end
  
end

# The Boid class

class Boid
  include Processing::Proxy
  import 'vecmath'
  attr_reader :location, :velocity, :acceleration, :r, :maxforce, :maxspeed
  attr_reader :width, :height
  def initialize(loc)
    @acceleration = Vec2D.new
    @velocity = Vec2D.new(rand(-1.0 .. 1), rand(-1.0 .. 1))
    @location = loc
    @r = 2.0
    @maxspeed = 2
    @maxforce = 0.03
    @width = $app.width    
    @height = $app.height
  end
  
  def run(boids)
    flock(boids)
    update
    borders
    render
  end
  
  def apply_force(force)
    # We could add mass here if we want A = F / M
    @acceleration += force
  end
  
  # We accumulate a new acceleration each time based on three rules
  def flock boids
    sep = separate(boids)   # Separation
    ali = align(boids)      # Alignment
    coh = cohesion(boids)   # Cohesion
    # Arbitrarily weight these forces
    sep *= 1.5
    ali *= 1.0
    coh *= 1.0
    # Add the force vectors to acceleration
    apply_force(sep)
    apply_force(ali)
    apply_force(coh)
  end
  
  # Method to update location
  def update
    # Update velocity
    @velocity += acceleration
    # Limit speed   
    velocity.set_mag(maxspeed) {velocity.mag > maxspeed}
    @location += velocity
    # Reset accelertion to 0 each cycle
    @acceleration *= 0
  end
  
  # A method that calculates and applies a steering force towards a target
  # STEER = DESIRED MINUS VELOCITY
  def seek(target)
    desired = target - location  # A vector pointing from the location to the target
    # Normalize desired and scale to maximum speed
    desired.normalize!
    desired *= maxspeed
    # Steering = Desired minus Velocity
    steer = desired - velocity
    # Limit to maximum steering force
    steer.set_mag(maxforce) {steer.mag > maxforce}   
    return steer
  end

  def render
    # Draw a triangle rotated in the direction of velocity
    theta = velocity.heading + Math::PI/2.0
    fill(200,100)
    stroke(255)
    push_matrix
    translate(location.x,location.y)
    rotate(theta)
    begin_shape(TRIANGLES)
    vertex(0, -r*2)
    vertex(-r, r*2)
    vertex(r, r*2)
    end_shape
    pop_matrix
  end

  # Wraparound
  def borders
    if (location.x < -r) 
      location.x = width + r
    end
    if (location.y < -r) 
      location.y = height + r
    end
    if (location.x > width + r)
      location.x = -r
    end
    if (location.y > height + r)
      location.y = -r
    end
  end
          
  # Separation
  # Method checks for nearby boids and steers away
  def separate boids
    desiredseparation = 25.0
    steer = Vec2D.new
    count = 0
    # For every other bird in the system, check if it's too close
    boids.reject{|bd| bd.equal? self}.each do |other|
      d = location.dist(other.location)
      # If the distance is greater than 0 and less than an arbitrary amount 
      if ((d > 0) && (d < desiredseparation))
        # Calculate vector pointing away from neighbor
        diff = location - other.location
        diff.normalize!
        diff /= d        # Weight by distance
        steer += diff
        count += 1            # Keep track of how many
      end
    end
    # Average -- divide by how many
    if (count > 0)
      steer /= count.to_f
    end
    
    # As long as the vector is greater than 0
    if (steer.mag > 0)
      # Implement Reynolds: Steering = Desired - Velocity
      steer.normalize!
      steer *= maxspeed
      steer -= velocity      
      steer.set_mag(maxforce){steer.mag > maxforce} 
    end
    return steer
  end
    
  # Alignment
  # For every other nearby boid in the system, calculate the average velocity
  def align boids
    neighbordist = 50
    sum = Vec2D.new
    steer = Vec2D.new
    count = 0
    boids.reject{|bd| bd.equal? self}.each do |other|
      d = location.dist(other.location)
      if ((d > 0) && (d < neighbordist))
        sum += other.velocity
        count += 1
      end
    end
    if (count > 0)
      sum /= count.to_f
      sum.normalize!
      sum *= maxspeed
      steer = sum - velocity
      steer.set_mag(maxforce){steer.mag > maxforce} 
    end
    return steer
  end
    
  # Cohesion
  # For the average location (i.e. center) of all other nearby boids, calculate steering vector towards that location
  def cohesion boids
    neighbordist = 50
    sum = Vec2D.new   # Start with empty vector to accumulate all locations
    count = 0
    boids.reject{|bd| bd.equal? self}.each do |other|
      d = location.dist(other.location)
      if ((d > 0) && (d < neighbordist))
        sum += other.location # Add location
        count += 1
      end
    end
    sum /= count unless (count == 0)        # avoid div by zero
    return (count > 0)? seek(sum) : Vec2D.new 
  end
end



