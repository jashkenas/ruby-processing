# Here's a little library for quickly hooking up controls to sketches.
# For messing with the parameters and such.
# These controls will set instance variables on the sketches.

# You can make sliders, checkboxes, buttons, and drop-down menus.

module ControlPanel

  class Slider < javax.swing.JSlider
    def initialize(name, range, control_panel, proc=nil)
      min, max = range.begin * 100, range.end * 100
      super(min, max)
      set_minor_tick_spacing((max - min).abs / 10)
      set_paint_ticks true
      paint_labels = true
      set_preferred_size(java.awt.Dimension.new(190, 30))
      label = control_panel.add_element(self, name)
      add_change_listener do
        update_label(label, name, value)
        $app.instance_variable_set("@#{name}", value) unless value.nil?
        proc.call(value) if proc
      end
    end
    
    def value
      get_value / 100.0
    end
    
    def update_label(label, name, value)
      value = value.to_s
      value << "0" if value.length < 4
      label.set_text "<html><br>#{name.to_s}: #{value}</html>"
    end
  end
  
  
  class Menu < javax.swing.JComboBox  
    def initialize(name, elements, control_panel, proc=nil)
      super(elements.to_java(:String))
      set_preferred_size(java.awt.Dimension.new(190, 30))
      control_panel.add_element(self, name)
      add_action_listener do
        $app.instance_variable_set("@#{name}", value) unless value.nil?
        proc.call(value) if proc
      end
    end
    
    def value
      get_selected_item
    end
  end
  
  
  class Checkbox < javax.swing.JCheckBox
    def initialize(name, control_panel, proc=nil)
      @control_panel = control_panel
      super(name.to_s)
      set_preferred_size(java.awt.Dimension.new(190, 64))
      set_horizontal_alignment javax.swing.SwingConstants::CENTER
      control_panel.add_element(self, name, false)
      add_action_listener do 
        $app.instance_variable_set("@#{name}", value) unless value.nil?
        proc.call(value) if proc
      end
    end
    
    def value
      is_selected
    end
  end
  
  
  class Button < javax.swing.JButton
    def initialize(name, control_panel, proc=nil)
      super(name.to_s)
      set_preferred_size(java.awt.Dimension.new(170, 64))
      control_panel.add_element(self, name, false, true)
      add_action_listener do
        $app.send(name.to_s)
        proc.call(value) if proc
      end
    end
  end
  
  
  class Panel < javax.swing.JFrame
    attr_accessor :elements
    
    def initialize
      super()
      @elements = []
      @panel = javax.swing.JPanel.new(java.awt.FlowLayout.new(1, 0, 0))
    end
    
    def display
      add @panel
      set_size 200, 30 + (64 * @elements.size)
      set_default_close_operation javax.swing.JFrame::DISPOSE_ON_CLOSE
      set_resizable false
      set_location($app.width + 10, 0)
      show
    end
    
    def add_element(element, name, has_label=true, button=false)
      if has_label
        label = javax.swing.JLabel.new("<html><br>#{name}</html>")
        @panel.add label
      end
      @elements << element
      @panel.add element
      return has_label ? label : nil
    end
    
    def remove
      remove_all
      dispose
    end
    
    def slider(name, range=0..100, &block)
      slider = Slider.new(name, range, self, block || nil)
    end

    def menu(name, *elements, &block)
      menu = Menu.new(name, elements, self, block || nil)
    end
    
    def checkbox(name, &block)
      checkbox = Checkbox.new(name, self, block || nil)
    end
    
    def button(name, &block)
      button = Button.new(name, self, block || nil)
    end
  end
  

  module InstanceMethods
    def control_panel
      @control_panel = ControlPanel::Panel.new unless @control_panel
      return @control_panel unless block_given?
      yield(@control_panel)
      @control_panel.display
    end
  end
end


Processing::App.send :include, ControlPanel::InstanceMethods