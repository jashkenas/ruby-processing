#
# Example 18-6: Analyzing King Lear
#
def setup
  size 200, 200

  # Load the font
  textFont loadFont("Georgia-Bold-16.vlw")

  # Where are we in the text (start later b/c Project Gutenberg has 
  # licensing info at beginning)
  @counter = 1509

  # Load King Lear into an array of strings
  url     = "http://www.gutenberg.org/dirs/etext97/1ws3310.txt"
  rawtext = load_strings(url)

  # Join the big array together as one long string
  everything = rawtext.join

  # All the lines in King Lear are first joined as one big String and 
  # then split up into an array of individual words. 
  # Note the use of splitTokens() since we are using spaces and 
  # punctuation marks all as delimiters.  
  delimiters = " ,.?!;:[]"
  @kinglear  = split_tokens(everything, delimiters)

  frameRate 5
end

def draw
  background 255

  # Pick one word from King Lear
  theword = @kinglear[@counter]

  # Count how many times that word appears in King Lear
  total = 0
  @kinglear.length.times do |i|
    total += 1 if theword == @kinglear[i]
  end

  # Display the text and total times the word appears
  fill 0
  text theword, 10, 90
  text "#{total}", 10, 110
  stroke 0
  fill 175
  rect 10, 50, total / 4, 20

  # Move onto the next word
  @counter = (@counter + 1) % @kinglear.length
end
