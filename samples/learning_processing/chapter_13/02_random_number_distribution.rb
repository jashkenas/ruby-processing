require 'ruby-processing'

class RandomNumberDistributionSketch < Processing::App
  def setup
    @random_counts = Array.new(20, 0)
  end

  def draw
    @random_counts[rand(@random_counts.size)] += 1
    background 255
    stroke 0
    fill 175
    @random_counts.each_with_index do |count, i|
      rect i * width/@random_counts.size, 0, (width/@random_counts.size)-1, count  
    end
  end

end

RandomNumberDistributionSketch.new :title => "Random Number Distribution", :width => 400, :height => 400
