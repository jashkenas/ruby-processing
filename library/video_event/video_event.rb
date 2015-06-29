require 'rpextras'

class Processing::App
  include Java::ProcessingCore::VideoInterface
  def captureEvent(c)
    # satisfy implement abstract class
  end
  
  def movieEvent(m)
    # satisfy implement abstract class
  end  
end
