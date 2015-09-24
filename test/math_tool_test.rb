gem 'minitest'      # don't use bundled minitest
require 'java'
require 'minitest/autorun'

require_relative '../lib/rpextras'
require_relative '../lib/ruby-processing/helper_methods'

Java::Monkstone::MathToolLibrary.new.load(JRuby.runtime, false)

include Processing::HelperMethods
include Processing::MathTool

EPSILON ||= 1.0e-04

Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

Dir.chdir(File.dirname(__FILE__))

class MathToolTest < Minitest::Test
 def test_map1d
    x = [0, 5, 7.5, 10]
    range1 = (0..10)
    range2 = (100..1)
    range3 = (0..10)
    range4 = (5..105)
    assert map1d(x[0], range1, range2) == 100, 'map to first'
    assert map1d(x[1], range1, range2) == 50.5, 'map to reversed intermediate'
    assert map1d(x[2], range3, range4) == 80.0, 'map to intermediate'
    assert map1d(x[3], range1, range2) == 1, 'map to last'
  end
  
  def test_p5map # as map1d except not using range input
    x = [0, 5, 7.5, 10]
    range1 = (0..10)
    range2 = (100..1)
    range3 = (0..10)
    range4 = (5..105)
    assert p5map(x[0], range1.first, range1.last, range2.first, range2.last) == 100
    assert p5map(x[1], range1.first, range1.last, range2.first, range2.last) == 50.5
    assert p5map(x[2], range3.first, range3.last, range4.first, range4.last) == 80.0
    assert p5map(x[3], range1.first, range1.last, range2.first, range2.last) == 1
  end
  
  def test_norm
    x = [10, 140, 210]
    start0, last0 = 30, 200
    start1, last1 = 0, 200
    assert norm(x[0], start0, last0) == -0.11764705882352941, 'unclamped map'
    assert norm(x[1], start1, last1) == 0.7, 'map to intermediate'
    assert norm(x[2], start1, last1) == 1.05, 'unclamped map'
  end
  
  def test_norm_strict
    x = [10, 140, 210]
    start0, last0 = 30, 200
    assert norm_strict(x[0], start0, last0) == 0, 'clamped map to 0..1.0'
  end
  
  def test_lerp # behaviour is deliberately different to processing which is unclamped
    x = [0.5, 0.8, 2.0]
    start0, last0 = 300, 200
    start1, last1 = 0, 200
    assert lerp(start0, last0, x[0]) == 250, 'produces a intermediate value of a reversed range'
    assert lerp(start1, last1, x[1]) == 160, 'lerps tp an intermediate value'
    assert lerp(start1, last1, x[2]) == 200, 'lerps to the last value of a range'
  end
  
  def test_constrain
    x = [15, 2_500, -2_500]
    start1, last1 = 0, 200
    assert constrain(x[0], start1, last1) == 15
    assert constrain(x[1], start1, last1) == 200
    assert constrain(x[2], start1, last1) == 0
  end
end
