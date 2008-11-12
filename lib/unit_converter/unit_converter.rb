# ConversionRule represents a single unit on which you can perform conversion, for example km/h.
class ConversionRule
  attr_reader :target_unit, :calc_type, :ratio

  def initialize(target_unit, calc_type, ratio)
    @target_unit = target_unit
    @calc_type = calc_type
    @ratio = ratio
  end
end

# ConversionType represents a group of units which you can performs conversion between
# For example, "Speed", containing conversion rules such as km/h and mph/h.
# TODO: Refactoring needed, needs some method to return ALL rules for a specific type, so you don't have to check
# both master_unit and conversion_rules when searching for a specific unit. Should be possible to remove attr_reader
# :master_unit and :conversion_rules after that. Will also need a way to indicate which unit that is the master unit
# for this type then.
class ConversionType
  attr_reader :name, :master_unit, :conversion_rules
  
  def initialize(name, master_unit)
    @name = name
    @master_unit = master_unit
    @conversion_rules = Hash.new
  end
  
  def add_rule(cr)
    @conversion_rules[cr.target_unit] = cr
  end
end

class UnitConverter  
  # Creates a new UnitConverter with conversion rules based on the input file
  # Defaults to "rules.txt" if no file is specified
  def initialize(file = File.dirname(__FILE__) + "/rules.txt")
    @conversion_types = nil
    build_conversion_rules(file)
  end
  
  # Regex patterns
  # FIXME: Should these be changed to constants? Or kept as class variables? Or something else?
	@@BLANK_LINE = /^\s*$/
	@@COMMENT = /^\s*#+.*/
	@@TYPE = /^TYPE (\S+.*) MASTER (\S+.*)/
	@@RULE = /^TO (\S+.*) (MULTIPLY|DIVIDE) ((?:\d|\.)+)$/
  
  # Performs a conversion between two known units
  # If to_unit isn't specified, returns a hash with other compatible units as key
  # and conversion result as value
  # TODO: Result should probably be rounded off to 3 decimals or so before being returned
  def perform_conversion(value, from_unit, to_unit = nil)
    type = nil
        
    # Find out what type from_unit is
    raise(ArgumentError, "Conversion Unit not found in any type") unless type = get_type(from_unit)
        
    # If to_unit isn't specified, build a hash of results and return that instead of a single value
    if to_unit.nil?
      # Need to perform a conversion for each of the units available for this type
      units = []
      # Get all units for this type
      type.conversion_rules.each_key { |unit| units << unit unless unit == from_unit }
      # Don't forget to add the master_unit
      units << type.master_unit unless type.master_unit == from_unit
      
      # Perform a conversion for each unit in the array, 
      # add the result to a hash with unit name as key and conversion result as value
      results = {}
      units.each { |unit| results[unit] = perform_conversion(value, from_unit, unit) }
      return results
    end
        
    # Make sure the to_unit is of the same type as the from unit
    raise(ArgumentError, "To unit is not of same type as From unit") unless (type.master_unit == to_unit || type.conversion_rules.has_key?(to_unit))
    
    # Make sure both units are valid before trying to perform a conversion
    raise(ArgumentError, "Invalid from Unit") unless type.conversion_rules.has_key?(from_unit) || type.master_unit == from_unit
    raise(ArgumentError, "Invalid to Unit") unless type.conversion_rules.has_key?(to_unit) || type.master_unit == to_unit
    
    # Make sure the value is a valid float before trying to perform a conversion
    # FIXME: Interesting note: the raise parameter here actually doesn't raise this error,
    # instead it's the actual Float conversion that raises the exception. Float(value) would
    # raise an exception even if no raise was specified here. To fix this: wrap the test in a
    # begin... rescue block!
    raise(ArgumentError, "Value is not a valid float") unless value = Float(value)

    if (from_unit != type.master_unit || to_unit == type.master_unit)
      # Since the from_unit isn't the master_unit for this type
      # need to perform a backwards conversion to the master unit 
      # before converting to the requested unit
      value = apply_conversion(type, from_unit, value, true)
    end

    # The value is now in the master_unit for this type
    # proceed with conversion if needed (target is other than master_unit)
    if to_unit != type.master_unit
      value = apply_conversion(type, to_unit, value)
    end
    value
  end
  
  # Returns the type that the passed in unit belongs to, nil if unit not found
  def get_type(unit)
    @conversion_types.each_value do |ct|
      if (ct.master_unit == unit || ct.conversion_rules.has_key?(unit))
        return ct
      end
    end
    return nil    
  end
  
  
  # Return a hash with the types as key, array of rules as value
  def get_types
    type_names = {}
    @conversion_types.each_value do |type|
      rules = []
      rules << type.master_unit
      type.conversion_rules.each_value { |cr| rules << cr.target_unit }
      rules.sort!
      type_names[type.name] = rules
    end
    type_names
  end
  
  # Returns an array containing all conversion units
  def get_units
    units = []
    @conversion_types.each_value do |type|
      units << type.master_unit
      type.conversion_rules.each_value { |cr| units << cr.target_unit }
    end
    units.sort!
  end
  
  
  private
  
  # Reads a conversion rules file and stores the information in the @conversion_types hash.
  def build_conversion_rules(file)
    active_type = nil
    @conversion_types = Hash.new
    
    # Make sure the file exists before trying to open it
    raise(IOError, "File does not exist") unless File.exists?(file)
    
    IO.foreach(file) do |line|
      if md = @@BLANK_LINE.match(line) # Blank line match, do nothing
        
      elsif md = @@COMMENT.match(line) # Comment, do nothing
        
      elsif md = @@TYPE.match(line) # A TYPE row is matched, set the active type
        # If there's a currently active type, add it to the array before proceeding
        @conversion_types[active_type.name] = active_type unless active_type.nil?
        active_type = ConversionType.new(md[1], md[2])
      
      elsif md = @@RULE.match(line) # A RULE row is matched
        # Make sure there's an active type set before adding any rules
        if active_type == nil
          raise "Syntax Error, No valid type set before rule"
        end
        
        # Type is ok, create a new rule and add it to the rules array
        active_type.add_rule(ConversionRule.new(md[1], md[2], md[3].to_f))
      
      else
        raise(SyntaxError, "line doesn't match any valid pattern")
      end        
    end
    @conversion_types[active_type.name] = active_type unless active_type.nil?
  end
  
  # Applies a conversion a unit, can apply a reverse transformation, returns result value  
  def apply_conversion(type, unit, value, reverse = false)
    cr = type.conversion_rules[unit.to_s]
        
    if cr.calc_type == "MULTIPLY"
      if reverse
        return value / cr.ratio
      else
        return value * cr.ratio
      end
    elsif
      cr.calc_type == "DIVIDE" then
      if reverse
        return value * cr.ratio
      else
        return value / cr.ratio
      end
    end
  end
  
end