class Ring
  attr_reader :app, :width, :x, :y, :diameter
  attr_accessor :on
  def initialize(app)
    @app = app
    @width = app.width
  end

  def start(x, y)
    @x = x
    @y = y
    @on = true
    @diameter = 1
  end

  def grow
    return unless on
    @diameter += 0.5
    @diameter = 0 if diameter > width * 1.5
  end
  
  def display
    return unless on
    app.no_fill
    app.stroke_weight 4
    app.stroke 155, 153
    app.ellipse x, y, diameter, diameter
  end
end
