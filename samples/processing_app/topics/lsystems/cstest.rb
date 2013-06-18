###########################
# cstest.rb (use rp5 run ..
# test of cs_grammar library
###########################
load_library 'cs_grammar'

def setup
  (0 .. 7).each do |i|
    grammar = Grammar.new(
      "baaaaaa",
      {
        "b<a" => "b",   # context sensitive rule replace a when preceded by b
        "b"   =>"a"
      }
      )    
    puts grammar.generate(i)
  end
end


