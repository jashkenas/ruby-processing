gem 'minitest'      # don't use bundled minitest
require 'java'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/rpextras'

Java::MonkstoneVecmathVec2::Vec2Library.load(JRuby.runtime)
Java::MonkstoneVecmathVec3::Vec3Library.load(JRuby.runtime)

EPSILON = 1.0e-04

Dir.chdir(File.dirname(__FILE__))

class VecmathTest < Minitest::Test
  def test_equals
    x, y = 1.0000001, 1.01
    a = Vec2D.new(x, y)
    assert_equal(a.to_a, [x, y], 'Failed to return Vec2D as and Array')
  end

  def test_not_equals
    a = Vec2D.new(3, 5)
    b = Vec2D.new(6, 7)
    refute_equal(a, b, 'Failed equals false')
  end

  def test_copy_equals
    x, y = 1.0000001, 1.01
    a = Vec2D.new(x, y)
    b = a.copy
    assert_equal(a.to_a, b.to_a, 'Failed deep copy')
  end

  def test_copy_not_equals
    x, y = 1.0000001, 1.01
    a = Vec2D.new(x, y)
    b = a.copy
    b *= 0
    refute_equal(a.to_a, b.to_a, 'Failed deep copy')
  end

  def test_equals_when_close
    a = Vec2D.new(3.0000000, 5.00000)
    b = Vec2D.new(3.0000000, 5.000001)
    assert_equal(a, b, 'Failed to return equal when v. close')
  end

  def test_sum
    a = Vec2D.new(3, 5)
    b = Vec2D.new(6, 7)
    c = Vec2D.new(9, 12)
    assert_equal(a + b, c, 'Failed to sum vectors')
  end

  def test_subtract
    a = Vec2D.new(3, 5)
    b = Vec2D.new(6, 7)
    c = Vec2D.new(-3, -2)
    assert_equal(a - b, c, 'Failed to subtract vectors')
  end

  def test_multiply
    a = Vec2D.new(3, 5)
    b = 2
    c = a * b
    d = Vec2D.new(6, 10)
    assert_equal(c, d, 'Failed to multiply vector by scalar')
  end

  def test_divide
    a = Vec2D.new(3, 5)
    b = 2
    c = Vec2D.new(1.5, 2.5)
    d = a / b
    assert_equal(c, d, 'Failed to divide vector by scalar')
  end

  def test_from_angle
    a = Vec2D.from_angle(Math::PI * 0.75)
    assert_equal(a, Vec2D.new(-1 * Math.sqrt(0.5), Math.sqrt(0.5)), 'Failed to create vector from angle')
  end

  def test_random
    a = Vec2D.random
    assert a.kind_of? Vec2D
    assert_in_delta(a.mag, 1.0, EPSILON)
  end

  def test_assign_value
    a = Vec2D.new(3, 5)
    a.x=23
    assert_equal(a.x, 23, 'Failed to assign x value')
  end

  def test_mag
    a = Vec2D.new(-3, -4)
    assert_equal(a.mag, 5, 'Failed to return magnitude of vector')
  end

  def test_mag_variant
    a = Vec2D.new(3.0, 2)
    b = Math.sqrt(3.0**2 + 2**2)
    assert_in_delta(a.mag, b, EPSILON, 'Failed to return magnitude of vector')
  end

  def test_mag_zero_one
    a = Vec2D.new(-1, 0)
    assert_equal(a.mag, 1, 'Failed to return magnitude of vector')
  end

  def test_dist
    a = Vec2D.new(3, 5)
    b = Vec2D.new(6, 7)
    assert_equal(a.dist(b), Math.sqrt(3.0**2 + 2**2), 'Failed to return distance between two vectors')
  end

  def test_lerp
    a = Vec2D.new(1, 1)
    b = Vec2D.new(3, 3)
    assert_equal(a.lerp(b, 0.5), Vec2D.new(2, 2), 'Failed to return lerp between two vectors')
  end

  def test_lerp_unclamped
    a = Vec2D.new(1, 1)
    b = Vec2D.new(3, 3)
    assert_equal(a.lerp(b, 5), Vec2D.new(11, 11), 'Failed to return lerp between two vectors')
  end

    def test_lerp!
    a = Vec2D.new(1, 1)
    b = Vec2D.new(3, 3)
    a.lerp!(b, 0.5)
    assert_equal(a, Vec2D.new(2, 2), 'Failed to return lerp! between two vectors')
  end

  def test_lerp_unclamped!
    a = Vec2D.new(1, 1)
    b = Vec2D.new(3, 3)
    a.lerp!(b, 5)
    assert_equal(a, Vec2D.new(11, 11), 'Failed to return lerp! between two vectors')
  end

  def test_set_mag
    a = Vec2D.new(1, 1)
    assert_equal(a.set_mag(Math.sqrt(32)), Vec2D.new(4, 4), 'Failed to set_mag vector')
  end

  def test_set_mag_block
    a = Vec2D.new(1, 1)
    assert_equal(a.set_mag(Math.sqrt(32)) { true }, Vec2D.new(4, 4), 'Failed to set_mag_block true vector')
  end

  def test_set_mag_block_false
    a = Vec2D.new(1, 1)
    assert_equal(a.set_mag(Math.sqrt(32)) { false }, Vec2D.new(1, 1), 'Failed to set_mag_block true vector')
  end

  def test_plus_assign
    a = Vec2D.new(3, 5)
    b = Vec2D.new(6, 7)
    a += b
    assert_equal(a, Vec2D.new(9, 12), 'Failed to += assign')
  end

  def test_normalize
    a = Vec2D.new(3, 5)
    b = a.normalize
    assert_in_delta(b.mag, 1, EPSILON, 'Failed to return a normalized vector')
  end

  def test_normalize!
    a = Vec2D.new(3, 5)
    a.normalize!
    assert_in_delta(a.mag, 1, EPSILON, 'Failed to return a normalized! vector')
  end

  def test_heading
    a = Vec2D.new(1, 1)
    assert_in_delta(a.heading, Math::PI / 4.0, EPSILON, 'Failed to return heading in radians')
  end

  def test_rotate
    x, y = 20, 10
    b = Vec2D.new(x, y)
    a = b.rotate(Math::PI / 2)
    assert_equal(a, Vec2D.new(-10, 20), 'Failed to rotate vector by scalar radians')
  end


  def test_inspect
    a = Vec2D.new(3, 2.000000000000001)
    assert_equal(a.inspect, 'Vec2D(x = 3.0000, y = 2.0000)')
  end

  def test_array_reduce
    array = [Vec2D.new(1, 2), Vec2D.new(10, 2), Vec2D.new(1, 2)]
    sum = array.reduce(Vec2D.new) { |c, d| c + d }
    assert_equal(sum, Vec2D.new(12, 6))
  end

  def test_array_zip
    one = [Vec2D.new(1, 2), Vec2D.new(10, 2), Vec2D.new(1, 2)]
    two = [Vec2D.new(1, 2), Vec2D.new(10, 2), Vec2D.new(1, 2)]
    zipped = one.zip(two).flatten
    expected = [Vec2D.new(1, 2), Vec2D.new(1, 2), Vec2D.new(10, 2), Vec2D.new(10, 2), Vec2D.new(1, 2), Vec2D.new(1, 2)]
    assert_equal(zipped, expected)
  end

  def test_equals
    x, y, z = 1.0000001, 1.01, 0.0
    a = Vec3D.new(x, y)
    assert_equal(a.to_a, [x, y, z], 'Failed to return Vec3D as and Array')
  end

  def test_not_equals
    a = Vec3D.new(3, 5, 1)
    b = Vec3D.new(6, 7, 1)
    refute_equal(a, b, 'Failed equals false')
  end

  def test_copy_equals
    x, y, z = 1.0000001, 1.01, 1
    a = Vec3D.new(x, y, z)
    b = a.copy
    assert_equal(a.to_a, b.to_a, 'Failed deep copy')
  end

  def test_copy_not_equals
    x, y, z = 1.0000001, 1.01, 6.0
    a = Vec3D.new(x, y, z)
    b = a.copy
    b *= 0
    refute_equal(a.to_a, b.to_a, 'Failed deep copy')
  end

  def test_equals_when_close
    a = Vec3D.new(3.0000000, 5.00000, 2)
    b = Vec3D.new(3.0000000, 5.000001, 2)
    assert_equal(a, b, 'Failed to return equal when v. close')
  end

  def test_sum
    a = Vec3D.new(3, 5, 1)
    b = Vec3D.new(6, 7, 1)
    c = Vec3D.new(9, 12, 2)
    assert_equal(a + b, c, 'Failed to sum vectors')
  end

  def test_subtract
    a = Vec3D.new(3, 5, 0)
    b = Vec3D.new(6, 7, 1)
    c = Vec3D.new(-3, -2, -1)
    assert_equal(a - b, c, 'Failed to subtract vectors')
  end

  def test_multiply
    a = Vec3D.new(3, 5, 1)
    b = 2
    c = a * b
    d = Vec3D.new(6, 10, 2)
    assert_equal(c, d, 'Failed to multiply vector by scalar')
  end

  def test_divide
    a = Vec3D.new(3, 5, 4)
    b = 2
    c = Vec3D.new(1.5, 2.5, 2)
    d = a / b
    assert_equal(c, d, 'Failed to divide vector by scalar')
  end

  def test_random
    a = Vec3D.random
    assert a.kind_of? Vec3D
    assert_in_delta(a.mag, 1.0, EPSILON)
  end

  def test_assign_value
    a = Vec3D.new(3, 5)
    a.x=23
    assert_equal(a.x, 23, 'Failed to assign x value')
  end

  def test_mag
    a = Vec3D.new(-3, -4)
    assert_equal(a.mag, 5, 'Failed to return magnitude of vector')
  end

  def test_mag_variant
    a = Vec3D.new(3.0, 2)
    b = Math.sqrt(3.0**2 + 2**2)
    assert_in_delta(a.mag, b, EPSILON, 'Failed to return magnitude of vector')
  end

  def test_mag_zero_one
    a = Vec3D.new(-1, 0)
    assert_equal(a.mag, 1, 'Failed to return magnitude of vector')
  end

  def test_dist
    a = Vec3D.new(3, 5)
    b = Vec3D.new(6, 7)
    assert_equal(a.dist(b), Math.sqrt(3.0**2 + 2**2), 'Failed to return distance between two vectors')
  end



  def test_set_mag
    a = Vec3D.new(1, 1)
    assert_equal(a.set_mag(Math.sqrt(32)), Vec3D.new(4, 4), 'Failed to set_mag vector')
  end

  def test_set_mag_block
    a = Vec3D.new(1, 1)
    assert_equal(a.set_mag(Math.sqrt(32)) { true }, Vec3D.new(4, 4), 'Failed to set_mag_block true vector')
  end

  def test_set_mag_block_false
    a = Vec3D.new(1, 1)
    assert_equal(a.set_mag(Math.sqrt(32)) { false }, Vec3D.new(1, 1), 'Failed to set_mag_block true vector')
  end

  def test_plus_assign
    a = Vec3D.new(3, 5)
    b = Vec3D.new(6, 7)
    a += b
    assert_equal(a, Vec3D.new(9, 12), 'Failed to += assign')
  end

  def test_normalize
    a = Vec3D.new(3, 5)
    b = a.normalize
    assert_in_delta(b.mag, 1, EPSILON, 'Failed to return a normalized vector')
  end

  def test_normalize!
    a = Vec3D.new(3, 5)
    a.normalize!
    assert_in_delta(a.mag, 1, EPSILON, 'Failed to return a normalized! vector')
  end

  def test_inspect
    a = Vec3D.new(3, 2.000000000000001, 1)
    assert_equal(a.inspect, 'Vec3D(x = 3.0000, y = 2.0000, z = 1.0000)')
  end

  def test_array_reduce
    array = [Vec3D.new(1, 2), Vec3D.new(10, 2), Vec3D.new(1, 2)]
    sum = array.reduce(Vec3D.new) { |c, d| c + d }
    assert_equal(sum, Vec3D.new(12, 6))
  end

  def test_array_zip
    one = [Vec3D.new(1, 2), Vec3D.new(10, 2), Vec3D.new(1, 2)]
    two = [Vec3D.new(1, 2), Vec3D.new(10, 2), Vec3D.new(1, 2)]
    zipped = one.zip(two).flatten
    expected = [Vec3D.new(1, 2), Vec3D.new(1, 2), Vec3D.new(10, 2), Vec3D.new(10, 2), Vec3D.new(1, 2), Vec3D.new(1, 2)]
    assert_equal(zipped, expected)
  end
  
  def test_eql?
    a = Vec3D.new(3.0, 5.0, 0)
    b = Vec3D.new(3.0, 5.0, 0)
    assert(a.eql?(b))
  end
  
  def test_not_eql?
    a = Vec3D.new(3.0, 5.0, 0)
    b = Vec3D.new(3.0, 5.000001, 0)
    refute(a.eql?(b))
  end
  
  def test_equal?
    a = Vec3D.new(3.0, 5.0, 0)
    assert(a.equal?(a))
  end
  
  def test_not_equal?
    a = Vec3D.new(3.0, 5.0, 0)
    b = Vec3D.new(3.0, 5.0, 0)
    refute(a.equal?(b))
  end
end
