require_relative '../lib/ruby-processing/helper_methods'
require_relative '../lib/ruby-processing/helpers/range.rb'

include Processing::HelperMethods

EPSILON = 1.0e-04


describe '2D#dist' do
  it 'should return dist(ax, ay, ab, ay)' do
    ax, ay, bx, by = 0, 0, 1.0, 1.0
    expect(dist(ax, ay, bx, by)).to eq Math.sqrt(2)
  end
end

describe '2D#dist' do
  it 'should return dist(ax, ay, ab, ay)' do
    ax, ay, bx, by = 0, 0, 1.0, 0.0
    expect(dist(ax, ay, bx, by)).to eq 1.0
  end
end

describe '2D#dist' do
  it 'should return dist(ax, ay, ab, ay)' do
    ax, ay, bx, by = 0, 0, 0.0, 0.0
    expect(dist(ax, ay, bx, by)).to eq 0.0
  end
end

describe '2D#dist' do
  it 'should return dist(ax, ay, ab, ay)' do
    ax, ay, bx, by = 1, 1, -2.0, -3.0
    expect(dist(ax, ay, bx, by)).to eq 5
  end
end

describe '3D#dist' do
  it 'should return dist(ax, ay, ab, ay)' do
    ax, ay, bx, by, cx, cy = -1, -1, 100, 2.0, 3.0, 100
    expect(dist(ax, ay, bx, by, cx, cy)).to eq 5
  end
end

describe '3D#dist' do
  it 'should return dist(ax, ay, az, bx, by, bz)' do
    ax, ay, bx, by, cx, cy = 0, 0, -1.0, -1.0, 0, 0
    expect(dist(ax, ay, bx, by, cx, cy)).to eq Math.sqrt(2)
  end
end

describe '3D#dist' do
  it 'should return dist(ax, ay, az, bx, by, bz)' do
    ax, ay, bx, by, cx, cy = -1, -1, 0.0, 2.0, 3.0, 0
    expect(dist(ax, ay, bx, by, cx, cy)).to eq 5
  end
end

describe '3D#dist' do
  it 'should return dist(ax, ay, az, bx, by, bz)' do
    ax, ay, bx, by, cx, cy = 0, 0, 0.0, 0.0, 0, 0
    expect(dist(ax, ay, bx, by, cx, cy)).to eq 0.0
  end
end

describe '3D#dist' do
  it 'should return dist(ax, ay, az, bx, by, bz)' do
    ax, ay, bx, by, cx, cy = 0, 0, 1.0, 0.0, 0, 0
    expect(dist(ax, ay, bx, by, cx, cy)).to eq 1.0
  end
end

describe '3D#dist' do
  it 'should return dist(ax, ay, az, bx, by, bz)' do
    ax, ay, bx, by, cx, cy = 0, 0, 1.0, 1.0, 0, 0
    expect(dist(ax, ay, bx, by, cx, cy)).to eq Math.sqrt(2)
  end
end

describe 'Range#clip_lo' do
  it 'should return (a..b).clip(x)' do
    a, b, x0 = 0, 100, -10
    expect((a..b).clip(x0)).to eq a  
  end
end

describe 'Range#clip_hi' do
  it 'should return (a..b).clip(x1)' do
    a, b, x1 = 0, 100, 200
    expect((a..b).clip(x1)).to eq b
  end
end

describe 'Range#clip_val' do
  it 'should return (a..b).clip(x2)' do
    a, b, x2 = 0, 100, 50
    expect((a..b).clip(x2)).to eq x2
  end
end

describe 'constrained_map#lo' do
  it 'should return constrained_map' do
    r1, r2, x0 = (0..100), (20..200), -10
    expect(constrained_map(x0, r1, r2)).to eq 20  
  end
end

describe 'constrained_map#hi' do
  it 'should return constrained_map' do
    r1, r2, x1 = (0..100), (200..20), 200
    expect(constrained_map(x1, r1, r2)).to eq 20 
  end
end

describe 'constrained_map#val' do
  it 'should return constrained_map' do
    r1, r2, x1 = (0..100), (20..200), 50
    expect(constrained_map(x1, r1, r2)).to eq 110.0
  end
end
