require 'ruby-processing'

class ObjectOrientedTimer < Processing::App

  def setup
    background 0
    @timer = Timer.new(5000)
    @timer.start
  end
  
  def draw
    if @timer.is_finished?
      background rand(255)
      @timer.start
    end
  end
  
end


class Timer
  def initialize(total_time)
    @saved_time = nil         # When it started
    @total_time = total_time  # How long it should last
  end
  
  # When the timer starts it stores the current time in milliseconds
  def start
    @saved_time = $app.millis
  end
  
  # The method is_finished? returns true if 5 seconds have passed.
  # Most of the work of the timer is farmed out to this method.
  def is_finished?
    passed_time = $app.millis - @saved_time
    passed_time > @total_time
  end
  
  
end

ObjectOrientedTimer.new :title => "Object Oriented Timer", :width => 200, :height => 200