module UnitConverterHelper
  
  # Renders a hash containing conversion types and values
  def render_units(hash)
    units = ""
    left = true
    hash.each_key do |type|
      # Alternate between types_left and types_right
      # TODO: Probably better to separate columns using tables instead
      if left
        units += "<div id=\"types_left\">"
      else
        units += "<div id=\"types_right\">"
      end
      left = !left
        
      units += "<table>"
      units += "<tr>"
      units += "<td>#{type}</td>"
      units += "</tr>"
      hash[type].each { |unit| units += "<tr><td>#{unit}</td></tr>" }
      units += "</table>"
      
      units += "</div>"
    end
    units
  end
  
  # Renders a UnitConverter results hash
  def render_results_hash(results)
    return "<p>Not a valid conversion</p>" if results.nil?
    text = "<p>"
    results.each_key do |r|
      text += "#{r}: #{results[r]}<br />"
    end
    text += "</p>"
  end
  
  
end
