# Extend Range class to include clip (used to implement processing constrain)
class Range #:nodoc:
  def clip(n)
    return n if cover?(n)
    (n < min) ? min : max
  end
end
