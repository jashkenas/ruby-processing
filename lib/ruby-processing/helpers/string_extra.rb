require 'forwardable'

# Avoid the monkey patching of String for underscore/titleize/humanize
class StringExtra
  extend Forwardable
  def_delegators(:@string, *String.public_instance_methods(false))
  def initialize(str = 'no_name')
    @string = (str.length > 60) ? 'long_name' : str
  end

  def titleize
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
      .gsub(/_id$/, '')
      .gsub(/_/, ' ').capitalize
      .gsub(/\b([a-z])/) { $1.capitalize }
  end

  def humanize
    gsub(/_id$/, '').gsub(/_/, ' ').capitalize
  end

  def underscore
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
  end
end
