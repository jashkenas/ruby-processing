require 'forwardable'

# Avoid the monkey patching of String for camelize
class CamelString
  extend Forwardable
  def_delegators(:@string, *String.public_instance_methods(false))
  def initialize(str = 'no_name')
    @string = (str.length > 60) ? 'long_name' : str
  end

  def camelize(first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      @string.gsub(%r{\/(.?)}) { '::' + Regexp.last_match[1].upcase }
        .gsub(/(^|_)(.)/) { Regexp.last_match[2].upcase }
    else
      @string[0] + camelize[1..-1]
    end
  end
end
