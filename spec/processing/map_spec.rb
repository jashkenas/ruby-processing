# require_relative '../../lib/rpextras'
require_relative '../../lib/ruby-processing/helper_methods'

# Java::Monkstone::MathToolLibrary.new.load(JRuby.runtime, false)

include Processing::HelperMethods
include Processing::MathTool

EPSILON ||= 1.0e-04

describe 'map1d' do
  it 'should return map1d(x, range1, range2)' do
    x = 5
    range1 = (0..10)
    range2 = (100..1)
    expect(map1d(x, range1, range2)).to eq 50.5
  end
end 

describe 'map1d' do
  it 'should return map1d(x, range1, range2)' do
    x = 50
    range1 = (0..100)
    range2 = (0..1.0)
    expect(map1d(x, range1, range2)).to eq 0.5
  end
end

describe 'map1d' do
  it 'should return map1d(x, range1, range2)' do
    x = 7.5
    range1 = (0..10)
    range2 = (5..105)
    expect(map1d(x, range1, range2)).to eq 80.0
  end
end 

describe 'map1d' do
  it 'should return map1d(x, range1, range2)' do
    x = 0.7
    range1 = (0..1.0)
    range2 = (0..200)
    expect(map1d(x, range1, range2)).to eq 140
  end
end  

describe 'constrained_map included' do
  it 'should return constrained_map(x, range1, range2)' do
    x = 0
    range1 = (0..10)
    range2 = (100..1)
    expect(constrained_map(x, range1, range2)).to eq 100
  end
end

describe 'constrained_map reverse' do
  it 'should return constrained_map(x, range1, range2)' do
    x0 = 10.1
    x1 =  -2
    range1 = (0..10)
    range2 = (100..1)
    expect(constrained_map(x0, range1, range2)).to eq 1
    expect(constrained_map(x1, range1, range2)).to eq 100
  end
end

describe 'constrained_map forward' do
  it 'should return constrained_map(x, range1, range2)' do
    x0 = 10.1
    x1 =  -2
    range1 = (0..10)
    range2 = (1..100)
    expect(constrained_map(x0, range1, range2)).to eq 100
    expect(constrained_map(x1, range1, range2)).to eq 1
  end
end

describe 'p5map' do
  it 'should return p5map(x, start1, last1, start2, last2)' do
    x = 5
    start1, last1, start2, last2 = 0, 10, 100, 1
    expect(p5map(x, start1, last1, start2, last2)).to eq 50.5
  end
end

describe 'map' do
  it 'should return map(x, start1, last1, start2, last2)' do
    x = 50
    start1, last1, start2, last2 = 0, 100, 0, 1.0
    expect(p5map(x, start1, last1, start2, last2)).to eq 0.5
  end
end 

describe 'p5map' do
  it 'should return p5map(x, start1, last1, start2, last2)' do
    x = 50
    start1, last1, start2, last2 = 0, 100, 0, 1.0
    expect(p5map(x, start1, last1, start2, last2)).to eq 0.5
  end
end

describe 'p5map' do
  it 'should return p5map(x, start1, last1, start2, last2)' do
    x = 50
    start1, last1, start2, last2 = 0, 100, 0, 1.0
    expect(p5map(x, start1, last1, start2, last2)).to eq 0.5
  end
end

describe 'p5map' do
  it 'should return p5map(x, start1, last1, start2, last2)' do
    x = 7.5
    start1, last1, start2, last2 = 0, 10, 5, 105
    expect(p5map(x, start1, last1, start2, last2)).to eq 80.0
  end
end 

describe 'norm' do
  it 'should return norm(x, start1, last1)' do
    x = 140
    start1, last1 = 0, 200
    expect(norm(x, start1, last1)).to eq 0.7
  end
end 

describe 'norm' do
  it 'should return norm(x, start1, last1)' do
    x = 210
    start1, last1 = 0, 200
    expect(norm(x, start1, last1)).to eq 1.05
  end
end

describe 'norm' do
  it 'should return norm(x, start1, last1)' do
    x = 10
    start1, last1 = 30, 200
    expect(norm(x, start1, last1)).to eq -0.11764705882352941
  end
end

describe 'norm_strict' do
  it 'should convert input to a normalized value' do
    x = 10
    start1, last1 = 30, 200
    expect(norm_strict(x, start1, last1)).to eq 0
  end
end  


describe 'lerp' do
  it 'should return lerp(start1, last1, x)' do
    x = 0.8
    start1, last1 = 0, 200
    expect(lerp(start1, last1, x)).to eq 160
  end
end 

describe 'lerp' do
  it 'should return lerp(start1, last1, x)' do
    x = 2.0
    start1, last1 = 0, 200
    expect(lerp(start1, last1, x)).to eq 200
  end
end

describe 'lerp' do
  it 'should return lerp(start1, last1, x)' do
    x = 0.5
    start1, last1 = 300, 200
    expect(lerp(start1, last1, x)).to eq 250
  end
end
