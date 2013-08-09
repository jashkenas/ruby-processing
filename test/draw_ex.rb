def setup
  size(300, 300)  
end

def draw
  begin
    unknown_method()
  rescue NoMethodError => e
    puts e
    exit
  end
end
