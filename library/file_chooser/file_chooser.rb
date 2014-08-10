# Here's a little library for using swing JFileChooser.
# in ruby-processing, borrows heavily from control_panel

module FileChooser
  ##
  # FileFilter is abstract, requires accept and getDescription
  ##

  require 'pathname'
  JXChooser = Java::javax::swing::JFileChooser
  JFile = Java::java::io::File
  System = Java::JavaLang::System

  class Filter < Java::javax::swing::filechooser::FileFilter
    attr_reader :description, :extensions
    def define(description, extensions)
      @description, @extensions = description, extensions
    end

    def accept(fobj)
      return true if extensions.include? File.extname(fobj.to_s).downcase
      return true if fobj.isDirectory
    end

    def getDescription
      description
    end
  end

  class RXChooser
    java_import javax.swing.UIManager
    require 'rbconfig'
    HOST = 'host_os'
    UHOME = 'user.home'
    UDIR = 'user.dir'
    OS = :unix
    case RbConfig::CONFIG[HOST]
    when /darwin/      then OS = :mac
    when /mswin|mingw/ then OS = :windows
    end

    def initialize
      javax.swing.UIManager.setLookAndFeel(
        javax.swing.UIManager.getSystemLookAndFeelClassName)
      @chooser = JXChooser.new
    end

    def set_filter(description, extensions)
      filter = FileChooser::Filter.new
      filter.define(description, extensions)
      @chooser.setFileFilter(filter)
    end

    def display
      if :windows == OS
        @chooser.setCurrentDirectory(JFile.new(System.getProperty(UDIR)))
      else
        @chooser.setCurrentDirectory(JFile.new(System.getProperty(UHOME)))
      end
      success = @chooser.show_open_dialog($app)
      if success == JXChooser::APPROVE_OPTION
        return Pathname.new(@chooser.get_selected_file.get_absolute_path).to_s
      else
        nil
      end
    end

    def dispose
      @chooser = nil
    end
  end

  module InstanceMethods
    def file_chooser
      @chooser = RXChooser.new
      return @chooser unless block_given?
      yield(@chooser)
    end
  end
end

Processing::App.send :include, FileChooser::InstanceMethods
