class Object
  def or_if_blank(alternative)
    if respond_to?(:blank?) 
      blank? ? alternative : self
    elsif nil? 
      alternative
    else
      if respond_to?(:empty?) && respond_to?(:strip)
        self.strip.empty? ? alternative : self
      elsif respond_to?(:empty?)
        self.empty? ? alternative : self
      else
        self
      end
    end
  end
end