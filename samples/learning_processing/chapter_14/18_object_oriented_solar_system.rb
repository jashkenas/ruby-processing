require 'ruby-processing'

include Math

class Planet

  # Each planet object keeps track of its own angle of rotation.
  # @theta      Rotation around sun
  # @diameter   Size of planet
  # @distance   Distance from sun
  # @orbitspeed Orbit speed
  def initialize(distance_, diameter_)
    @distance = distance_
    @diameter = diameter_
    @theta = 0
    @orbitspeed = rand * 0.02 + 0.01
  end

  def update
    # Increment the angle to rotate
    @theta += @orbitspeed
  end

  def display
    # Before rotation and translation, the state of the matrix is saved with push_matrix.
    $app.push_matrix 
    # Rotate orbit
    $app.rotate @theta 
    # translate out @distance
    $app.translate @distance, 0 
    $app.stroke 0
    $app.fill 175
    $app.ellipse 0, 0, @diameter, @diameter
    # Once the planet is drawn, the matrix is restored with pop_matrix so that the next planet is not affected.
    $app.pop_matrix 
  end

end

class ObjectOrientedSolarSystemSketch < Processing::App

  def setup
    smooth
    @planets = Array.new(8) { |i| Planet.new(20 + i * 10, i + 8) }
  end

  def draw
    background 255

    # Drawing the Sun
    push_matrix
    # Translate to center of window
    translate width/2, height/2
    stroke 0
    fill 255
    ellipse 0, 0, 20, 20

    # Drawing all Planets
    @planets.each do |p|
      p.update
      p.display
    end

    pop_matrix
  end

end

  ObjectOrientedSolarSystemSketch.new :title => "Object Oriented Solar System", :width => 200, :height => 200

