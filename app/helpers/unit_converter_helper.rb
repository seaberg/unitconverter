module UnitConverterHelper
  
  # Renders a hash containing conversion types and values
  def render_units(hash)
    units = ""
    left = true
    hash.each_key do |type|
      # Alternate between types_left and types_right
      if left
        units += "<div id=\"types_left\">"
      else
        units += "<div id=\"types_right\">"
      end
      left = !left
        
      units += "<table>"
      units += "<tr>"
      units += "<td id=\"type-header\">#{type}</td>"
      units += "</tr>"
      hash[type].each { |unit| units += "<tr><td>#{unit}</td></tr>" }
      units += "</table>"
      
      units += "</div>"
    end
    units
  end
  
  # Renders a UnitConverter results hash
  def render_results_hash(unit, value, results)		
    text = ""
    
    return "<p>Not a valid conversion</p>" if results.nil?
    
    text += "<div id=\"results-header\">#{value} #{unit}<br /></div>"
    
    text += "<table>"
    results.each_key do |r|
      text += "<tr><td id=\"results-unit\">#{r}</td><td>#{results[r]}</td></tr>"
    end
    text += "</table>"
  end
  
end
