#
# Regular Expression example
# by Martin Prout.  
# 
# This uses ruby scan
#
# Here we'll load the raw HTML from a URL and search for web-links
#

attr_reader :links, :url

def setup
  size(360, 480)
  @url = "http://processing.org"
  # Load the links
  @links = load_links(url)
  links.uniq! # get rid of the duplicates
  text_font(create_font("Georgia", 16))
end

def draw
  background(0)
  # Display the bare links
  fill(0, 255, 255)
  links.each_with_index do |link, i|
    text(link, 10, 20 + i * 20)
  end
end

def load_links(s)
  # Load the raw HTML
  lines = load_strings(s)
  # Put it in one big string
  all_txt = lines.join('\n')
  all_txt.scan(/
        https?:\/\/
        \w+
        (?: [.-]\w+ )*
        (?:
            \/
            [0-9]{1,5}
            \?
            [\w=]*
        )?
    /ix)
end

