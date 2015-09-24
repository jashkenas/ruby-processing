gem 'minitest'      # don't use bundled minitest
require 'java'
require 'minitest/autorun'
require 'minitest/spec'

require_relative '../lib/rpextras'

Java::MonkstoneFastmath::DeglutLibrary.new.load(JRuby.runtime, false)

EPSILON ||= 1.0e-04
TO_RADIAN = Math::PI / 180


Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

Dir.chdir(File.dirname(__FILE__))

class DeglutTest < Minitest::Test
  def test_cos_sin
    (-720..720).step(1) do |deg|
      sine = DegLut.sin(deg)
      deg_sin = Math.sin(deg * TO_RADIAN)
      assert_in_delta(sine, deg_sin, EPSILON)
      cosine = DegLut.cos(deg)
      deg_cos = Math.cos(deg * TO_RADIAN)
      assert_in_delta(cosine, deg_cos, EPSILON)
    end
  end
end


