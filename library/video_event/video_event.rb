require_relative '../../lib/ruby-processing'
require "#{RP5_ROOT}/lib/rpextras"

class Processing::App
  include Java::MonkstoneVideoevent::VideoInterface
  def captureEvent(c)
    # satisfy implement abstract class
  end
  
  def movieEvent(m)
    # satisfy implement abstract class
  end  
end
