# Here's a little library for quickly hooking up controls to sketches.
# For messing with the parameters and such.
# These controls will set instance variables on the sketches.

# You can make sliders, checkboxes, buttons, and drop-down menus.
# (optionally) pass the range and default value.

module ControlPanel
  # class used to create slider elements for control_panel
  class Slider < javax.swing.JSlider
    def initialize(control_panel, name, range, initial_value, proc = nil)
      min = range.begin * 100
      max = (
        (range.exclude_end? && range.begin.respond_to?(:succ)) ?
          range.max : range.end) * 100
      super(min, max)
      set_minor_tick_spacing((max - min).abs / 10)
      set_paint_ticks true
      # paint_labels = true
      set_preferred_size(java.awt.Dimension.new(190, 30))
      label = control_panel.add_element(self, name)
      add_change_listener do
        update_label(label, name, value)
        $app.instance_variable_set("@#{name}", value) unless value.nil?
        proc.call(value) if proc
      end
      set_value(initial_value ? initial_value * 100 : min)
      fire_state_changed
    end

    def value
      get_value / 100.0
    end

    def update_label(label, name, value)
      value = value.to_s
      value << '0' if value.length < 4
      label.set_text "<html><br><b>#{name}: #{value}</b></html>"
    end
  end

  # class used to combo_box menu elements for control_panel
  class Menu < javax.swing.JComboBox
    def initialize(control_panel, name, elements, initial_value, proc = nil)
      super(elements.to_java(:String))
      set_preferred_size(java.awt.Dimension.new(190, 30))
      control_panel.add_element(self, name)
      add_action_listener do
        $app.instance_variable_set("@#{name}", value) unless value.nil?
        proc.call(value) if proc
      end
      set_selected_index(initial_value ? elements.index(initial_value) : 0)
    end

    def value
      get_selected_item
    end
  end

  # Creates check-box elements for control_panel
  class Checkbox < javax.swing.JCheckBox
    def initialize(control_panel, name, proc = nil)
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

  # Creates button elements for control_panel
  class Button < javax.swing.JButton
    def initialize(control_panel, name, proc = nil)
      super(name.to_s)
      set_preferred_size(java.awt.Dimension.new(170, 64))
      control_panel.add_element(self, name, false, true)
      add_action_listener do
        $app.send(name.to_s)
        proc.call(value) if proc
      end
    end
  end

  # class used to contain control_panel elements
  class Panel < javax.swing.JFrame
    java_import javax.swing.UIManager

    attr_accessor :elements, :panel

    def initialize
      super()
      @elements = []
      @panel = javax.swing.JPanel.new(java.awt.FlowLayout.new(1, 0, 0))
      set_feel
    end

    def display
      add panel
      set_size 200, 30 + (64 * elements.size)
      set_default_close_operation javax.swing.JFrame::HIDE_ON_CLOSE
      set_resizable false
      set_location($app.width + 10, 0) unless $app.width + 10 > $app.displayWidth
      panel.visible = true
    end

    def add_element(element, name, has_label = true, _button_ = false)
      if has_label
        label = javax.swing.JLabel.new("<html><br><b>#{name}</b></html>")
        panel.add label
      end
      elements << element
      panel.add element
      has_label ? label : nil
    end

    def remove
      remove_all
      dispose
    end

    def slider(name, range = 0..100, initial_value = nil, &block)
      Slider.new(self, name, range, initial_value, block || nil)
    end

    def menu(name, elements, initial_value = nil, &block)
      Menu.new(self, name, elements, initial_value, block || nil)
    end

    def checkbox(name, initial_value = nil, &block)
      checkbox = Checkbox.new(self, name, block || nil)
      checkbox.do_click if initial_value == true
    end

    def button(name, &block)
      Button.new(self, name, block || nil)
    end

    def look_feel(lf)
      set_feel(lf)
    end
    
    private
    
    def set_feel(lf = 'metal')
      lafinfo = javax.swing.UIManager.getInstalledLookAndFeels
      laf = lafinfo.select do |info|
        info.getName.eql? lf.capitalize
      end
      javax.swing.UIManager.setLookAndFeel(laf[0].getClassName)
    end
  end

  # instance methods module
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
