class Word
  # A helper to keep track of word frequency.
  attr_accessor :word
  attr_reader :count
  def initialize word
    @word = word
    @count = 1
  end

  def increment
    @count += 1
  end
end

################################
# This sketch is translated from a vanilla processing sketch by Daniel Schiffman
# that was designed to demonstrate the use IntHash class in vanilla processing.
# Similar results can easily be obtained using more idiomatic ruby. Here IntHash 
# has been replaced by a String => Word hash (as used in a Schiffman prototype). 
# Read about concordance here:-
# http://en.wikipedia.org/wiki/Concordance_(publishing)
################################

attr_reader :concordance, :lines, :tokens, :counter

def setup
  size 640, 360
  @counter = 0
  @concordance = {}
  # Open a file, read its contents, and 'scan' for words using a regex.
  # Include words with apostrophe eg Harker's 
  @tokens = File.read(data_path("dracula.txt")).scan(/[\w'-]+/)
  text_font(create_font("Georgia", 24))
end

def draw
  background 51
  fill 255
  s = (tokens[counter] == "I")? tokens[counter] : tokens[counter].downcase
  @counter = (counter + 1) % tokens.length
  if (concordance.has_key?(s))
    # Get the word object and increase the count
    # We access objects from a Hash via its key, the String
    w = concordance[s]
    w.increment    # increment word count
  else
    # Otherwise make a new Word instance and add it to 
    # the Hash using the word String as the key
    concordance[s] = Word.new(s)
  end

  # x and y will be used to locate each word
  x = 0
  y = height - 10

  # Look at each word
  concordance.values.each do |w|
    # Only display words that appear 3 times
    if (w.count > 3)  # access word count
      # The size is the count
      fsize = constrain(w.count, 0, 100)
      text_size(fsize)
      text(w.word, x, y)
      # Move along the x-axis
      x += text_width(w.word) + 1
    end

    # If x gets to the end, move y
    # If y == 0 we are done
    if (y == 0)
      no_loop
    else
      if (x > width)
        x = 0
        y = (y < 0)? 0 : y - 100
      end
    end
  end
end
