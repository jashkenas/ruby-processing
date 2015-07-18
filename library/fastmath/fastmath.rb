require_relative '../../lib/ruby-processing'
require "#{RP5_ROOT}/lib/rpextras"

Java::ProcessingFastmath::DeglutLibrary.new.load(JRuby.runtime, false)
