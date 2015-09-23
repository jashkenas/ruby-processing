gem 'minitest'      # don't use bundled minitest
require 'minitest/autorun'

Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

Dir.chdir(File.dirname(__FILE__))

class Rp5Test < Minitest::Test

  def test_normal
    out, _err_ = capture_io do
      open('|../bin/rp5 app pdf.rb', 'r') do |io|
        while l = io.gets
          puts(l.chop)
        end
      end
    end
    assert_match(/ok/, out, 'Failed PDF sketch')
 end

 def test_p3d
    out, _err_ = capture_io do
      open('|../bin/rp5 app p3d.rb', 'r') do |io|
        while l = io.gets
          puts(l.chop)
        end
      end
    end
    assert_match(/ok/, out, 'Failed P3D sketch')
  end
 end