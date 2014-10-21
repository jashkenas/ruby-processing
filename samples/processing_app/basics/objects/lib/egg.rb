class Egg
  attr_reader :angle, :app, :x, :y, :tilt, :scalar

  def initialize(app, x, y, t, s)
    @app, @x, @y, @tilt, @scalar = app, x, y, t, s / 100.0
    @angle = 0
  end

  def wobble
    @tilt = Math.cos(angle) / 8
    @angle += 0.1
  end

  def display
    app.no_stroke
    app.fill 255
    app.push_matrix
    app.translate(x, y)
    app.rotate(tilt)
    app.scale(scalar)
    app.begin_shape
    app.vertex(0, -100)
    app.bezier_vertex(25, -100, 40, -65, 40, -40)
    app.bezier_vertex(40, -15, 25, 0, 0, 0)
    app.bezier_vertex(-25, 0, -40, -15, -40, -40)
    app.bezier_vertex(-40, -65, -25, -100, 0, -100) 
    app.end_shape
    app.pop_matrix
  end
end
