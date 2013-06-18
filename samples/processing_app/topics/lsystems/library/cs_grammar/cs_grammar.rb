######################################
# cs_grammar.rb a context sensitive
# 1-L lsystem grammar for 
# ruby/ruby-processing
# by Martin Prout (January 2013)
######################################



##################################
# The grammar class stores rules
# in two Hashes, one for cs rules,
# one for context free rules. Rules
# are filtered on input, and context
# is checked using get_rule in production
##################################

class Grammar

  attr_reader :axiom, :context, :no_context, :idx, :ignore
  def initialize(axiom, rules, ignore = '')
    @axiom = axiom
    @no_context = {}
    @context = {}
    @ignore = ignore
    rules.each_pair do |pair|
      add_rule pair[0], pair[1]
    end
  end
  
  def add_rule(pre, rule)
    if pre.length == 3
      if pre[1] == '<'
        @context[pre[2]] = pre
      elsif pre[1] == '>'
        @context[pre[0]] = pre 
      end
      @no_context[pre] = rule # key length == 3
    elsif pre.length == 1
      @no_context[pre] = rule # key length == 1
    else 
      print "unrecognized grammar '#{pre}'"  
    end
  end
  
  def generate(repeat = 0) # repeat iteration grammar rules
    prod = axiom
    repeat.times do
      prod = new_production(prod)
    end
    return prod
  end 
  
  
  def new_production prod  # single iteration grammar rules
    @idx = -1
    prod.gsub!(/./) do |ch|
      get_rule(prod, ch) 
    end
  end
  
  def get_rule prod, ch
    rule = ch # default is return original character as rule (no change)
    @idx += 1 # increment the index of axiom/production as a side effect
    if (context.has_key?(ch))
      if context[ch][1] == '<'
        cs_char = context[ch][0]
        rule = no_context[context[ch]] if cs_char == get_context(prod, idx, -1) # use context sensitive rule
      elsif context[ch][1] == '>'
        cs_char = context[ch][2]
        rule = no_context[context[ch]] if cs_char == get_context(prod, idx, 1) # use context sensitive rule
      end
    else
      rule = no_context[ch] if no_context.has_key?(ch) # context free rule if it exists
    end
    return rule
  end
  
  def get_context prod, idx, inc
    index = idx + inc
    while (ignore.include? prod[index])
      index += inc
    end
    return prod[index]
  end
end


