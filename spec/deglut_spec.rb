require_relative '../lib/rpextras'

Java::ProcessingFastmath::DeglutLibrary.new.load(JRuby.runtime, false)

EPSILON = 1.0e-04
TO_RADIAN = Math::PI / 180

describe '#DegLut.sin(-720 .. 720) test' do
  (-720 .. 720).step(1) do |deg|
    it "should work #{deg}" do
      sine = DegLut.sin(deg)
      expect(sine).to be_within(EPSILON).of(Math.sin(deg * TO_RADIAN))
    end
  end
end


describe '#DegLut.cos(-720 .. 720) test' do
  (-720 .. 720).step(1) do |deg|
    it "should work #{deg}" do
      cosine = DegLut.cos(deg)
      expect(cosine).to be_within(EPSILON).of(Math.cos(deg * TO_RADIAN))
    end
  end
end
