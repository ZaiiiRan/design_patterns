module Deep_dup
  def deep_dup(element)
    if element.is_a?(Array)
      element.map { |sub_element| deep_dup(sub_element) }
    else 
      begin
        element.dup
      rescue
        element
      end
    end
  end
end