###########################
# cstest.rb (use rp5 run ..
# test of cs_grammar library
###########################
load_library 'cs_grammar'

def setup
  size 150, 250
  background 0
  fill(200, 200, 0)
  f = create_font("Arial", 16, true)
  text_font(f)
  (0 .. 7).each do |i|
    grammar = Grammar.new(
      "baaaaaa",
      {
        "b<a" => "b",   # context sensitive rule replace a when preceded by b
        "b"   =>"a"
      }
      )    
    text grammar.generate(i), 30, i * 25
  end
end


