########################
# stochastic_grammar.rb
# unweighted rules accepted
# with default weight = 1
# complex stochastic rule
########################
class StochasticGrammar
  PROB = 1
  attr_accessor :axiom, :srules

  def initialize axiom
    @axiom = axiom
    @srules = {}   # rules dictionary (a hash of hashes)
  end

  ######################################################
  # randomly selects a rule (with a weighted probability)
  #####################################################

  def stochastic_rule(rules)
    total = rules.inject(0) do |total, rule_and_weight|
      total += rule_and_weight[PROB]
    end
    srand
    chance = rand * total
    rules.each do |item, weight|
      return item unless chance > weight
      chance -= weight
    end
    return rule
  end

  def has_rule?(pre)
    @srules.has_key?(pre)
  end

  def add_rule(pre, rule, weight = 1.0)  # default weighting 1 (can handle non-stochastic rules)
    if (has_rule?(pre))                  # add to existing hash
      srules[pre][rule] = weight
    else
      srules[pre] = {rule => weight}     # store new hash with pre key
    end
  end

  def new_production(prod)  # note the use of gsub!, we are changing prod as we go
    prod.gsub!(/./) do |ch|
      (has_rule?(ch)) ? stochastic_rule(srules[ch]) : ch
    end
  end

  def generate(repeat = 0)
    prod = axiom
    repeat.times do
      prod = new_production(prod)
    end
    return prod
  end
end
