class Range #:nodoc:
  def clip(n)
    if cover?(n)
      n
    elsif n < min
      min
    else
      max
    end
  end
end
