def setup
  size(300, 300)
  begin
    unknown_method()
  rescue NoMethodError => e
    puts e
    exit
  end
end

def draw
end
