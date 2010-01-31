############################
# Non-stochastic grammar
# with unique premise/rules 
############################
class Grammar
  attr_accessor :axiom, :rules
  
  def initialize axiom
    @axiom = axiom
    @rules = Hash.new
  end
  
  def add_rule premise, rule
    rules.store(premise, rule)
  end
  
  ##########################################
  # replace each pre char with a unique rule
  ##########################################
  def new_production production
    production.gsub!(/./) { |c| (r = @rules[c]) ? r : c }
  end
  
  ##########################################
  # control the number of iterations 
  # default 0, returns the axiom
  ##########################################
  def generate repeat = 0
    prod = axiom
    repeat.times do
      prod = new_production prod
    end
    return prod
  end  
end  

