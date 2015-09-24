gem 'minitest'      # don't use bundled minitest
require 'java'
require 'minitest/autorun'

require_relative '../lib/ruby-processing/helper_methods'
require_relative '../lib/core'

include Processing::HelperMethods

EPSILON ||= 1.0e-04

Java::Monkstone::MathToolLibrary.new.load(JRuby.runtime, false)

include Processing::HelperMethods
include Processing::MathTool

EPSILON ||= 1.0e-04

Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

Dir.chdir(File.dirname(__FILE__))

class HelperMethodsTest < Minitest::Test
 def test_hex_color
   col_double = 0.5
    hexcolor = 0xFFCC6600
    dodgy_hexstring = '*56666'
    hexstring = '#CC6600'
    assert hex_color(col_double) == 0.5, 'double as a color'
    assert hex_color(hexcolor) == -3381760, 'hexadecimal fixnum color'
    assert hex_color(hexstring) == -3381760, 'hexadecimal string color'
    assert_raises(StandardError, 'Dodgy Hexstring') do
      hex_color(dodgy_hexstring)
    end  
  end 
  
  def test_dist
    ax, ay, bx, by = 0, 0, 1.0, 1.0
    assert dist(ax, ay, bx, by) == Math.sqrt(2), '2D distance'
    by = 0.0
    assert dist(ax, ay, bx, by) == 1.0, 'when y dimension is zero'
    ax, ay, bx, by = 0, 0, 0.0, 0.0
    assert dist(ax, ay, bx, by) == 0.0, 'when x and y dimension are zero' 
    ax, ay, bx, by = 1, 1, -2.0, -3.0
    assert dist(ax, ay, bx, by) == 5, 'classic triangle dimensions'
    ax, ay, bx, by, cx, cy = -1, -1, 100, 2.0, 3.0, 100
    assert dist(ax, ay, bx, by, cx, cy) == 5, 'classic triangle dimensions'
    ax, ay, bx, by, cx, cy = 0, 0, -1.0, -1.0, 0, 0
    assert dist(ax, ay, bx, by, cx, cy) == Math.sqrt(2)
    ax, ay, bx, by, cx, cy = 0, 0, 0.0, 0.0, 0, 0
    assert dist(ax, ay, bx, by, cx, cy) == 0.0
    ax, ay, bx, by, cx, cy = 0, 0, 1.0, 0.0, 0, 0
    assert dist(ax, ay, bx, by, cx, cy) == 1.0, 'when x and z dimension are zero'
  end
end
