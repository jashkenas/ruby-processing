class Slider < javax.swing.JSlider
  attr_accessor :name, :label
  
  def initialize(*args)
    super(*args)
  end
  
  def update_label(value)
    value = value.to_s
    value << "0" if value.length < 4
    label.set_text "<html><br>#{@name.to_s}: #{value}</html>"
  end


  module ClassMethods
    def slider_frame; @slider_frame; end
    
    # Creates a slider, in a new window, to control an instance variable.
    # Sliders take a name and a range (optionally), returning an integer.
    def create_slider(name, range=0..100)
      attr_accessor name
      return if Object.const_defined?(:JRUBY_APPLET)
      min, max = range.begin * 100, range.end * 100
      initialize_slider_frame unless @slider_frame
      slider = Slider.new(min, max)
      slider.add_change_listener do
        val = slider.get_value / 100.0
        slider.update_label(val)
        Processing::App.current.send(name.to_s + "=", val)
      end
      slider.set_minor_tick_spacing((max - min).abs / 10) 
      slider.set_paint_ticks true
      slider.paint_labels = true
      label = javax.swing.JLabel.new("<html><br>" + name.to_s + "</html>")
      slider.label = label
      slider.name = name
      @slider_frame.sliders << slider
      @slider_frame.panel.add label
      @slider_frame.panel.add slider
    end
    
    
    def initialize_slider_frame
      @slider_frame ||= javax.swing.JFrame.new
      class << @slider_frame
        attr_accessor :sliders, :panel
      end
      @slider_frame.sliders ||= []
      slider_panel ||= javax.swing.JPanel.new(java.awt.FlowLayout.new(1, 0, 0))
      @slider_frame.panel = slider_panel
    end
    
    
    def remove_slider_frame
      if @slider_frame
        @slider_frame.remove_all
        @slider_frame.dispose
        @slider_frame = nil
      end
    end
  end
  
  module InstanceMethods
    def display_slider_frame
      f = self.class.slider_frame
      f.add f.panel
      f.set_size 200, 32 + (71 * f.sliders.size)
      f.setDefaultCloseOperation(javax.swing.JFrame::DISPOSE_ON_CLOSE)
      f.set_resizable false
      f.set_location(@width + 10, 0)
      f.show
    end
  end
  
end