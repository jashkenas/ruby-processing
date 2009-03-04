class String #:nodoc:
  
  def titleize
    self.underscore.humanize.gsub(/\b([a-z])/) { $1.capitalize }
  end
  
  def humanize()
    self.gsub(/_id$/, "").gsub(/_/, " ").capitalize
  end
  
  def camelize(first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      self.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
    else
      self.first + self.camelize[1..-1]
    end
  end
  
  def underscore
    self.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end
  
  # String.ord is Ruby 1.9, so this is a little fix for R 1.8 
  # to make it forward compatible and readable
  unless String.method_defined? :ord
  	def ord
  		self[0]
  	end
  end  
  
end