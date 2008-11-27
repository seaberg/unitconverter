require 'test/unit'
require 'unit_converter'

class TestUnitConverter < Test::Unit::TestCase
  
  def setup
    @uc = UnitConverter.new    
    @types = @uc.get_types
  end  
    
  def test_conversion_rule
    cr = ConversionRule.new("m/s", "MULTIPLY", 666)
    
    assert_equal("m/s", cr.target_unit)
    assert_equal("MULTIPLY", cr.calc_type)
    assert_equal(666, cr.ratio)
  end
  
  def test_conversion_type
    ct = ConversionType.new("Speed", "km/h")
    
    assert_equal("Speed", ct.name)
    assert_equal("km/h", ct.master_unit)
    
    cr = ConversionRule.new("m/s", "MULTIPLY", 666)
    ct.add_rule(cr)
    assert_equal(1, ct.conversion_rules.size)
    assert_equal(cr, ct.conversion_rules["m/s"])
  end
  
  def test_types_size
    assert_equal(4, @types.size)    
  end
  
  def test_length_rules
    assert(contains(@types["Length"], "Meters"), "Typelist does not contain Length -> Meters")    
    assert(contains(@types["Length"], "Kilometers"), "Typelist does not contain Length -> Kilometers")
    assert(contains(@types["Length"], "Miles"), "Typelist does not contain Length -> Miles")    
    assert(contains(@types["Length"], "Yards"), "Typelist does not contain Length -> Yards")    
    assert(contains(@types["Length"], "Feet"), "Typelist does not contain Length -> Feet")    
    assert(contains(@types["Length"], "Inches"), "Typelist does not contain Length -> Inches")    
    assert(contains(@types["Length"], "Centimeters"), "Typelist does not contain Length -> Centimeters")    
    assert(contains(@types["Length"], "Millimeters"), "Typelist does not contain Length -> Millimeters")    
    assert(contains(@types["Length"], "Nautical Miles"), "Typelist does not contain Length -> Nautical Miles")        
  end
  
  def test_speed_rules
    assert(contains(@types["Speed"], "Kilometers / Hour"), "Typelist does not contain Speed -> Kilometers / Hour")
    assert(contains(@types["Speed"], "Kilometers / Minute"), "Typelist does not contain Speed -> Kilometers / Minute")
    assert(contains(@types["Speed"], "Miles / Hour"), "Typelist does not contain Speed -> Miles / Hour")
    assert(contains(@types["Speed"], "Meters / Second"), "Typelist does not contain Speed -> Meters / Second")
    assert(contains(@types["Speed"], "Knots"), "Typelist does not contain Speed -> Knots")    
  end
  
  def test_weight_rules
    assert(contains(@types["Weight"], "Grams"), "Typelist does not contain Weight -> Grams")
    assert(contains(@types["Weight"], "Pounds"), "Typelist does not contain Weight -> Pounds")
    assert(contains(@types["Weight"], "Ounces"), "Typelist does not contain Weight -> Ounces")
    assert(contains(@types["Weight"], "Kilograms"), "Typelist does not contain Weight -> Kilograms")
    assert(contains(@types["Weight"], "Metric Tons"), "Typelist does not contain Weight -> Metric Tons")
    assert(contains(@types["Weight"], "Micrograms"), "Typelist does not contain Weight -> Micrograms")
    assert(contains(@types["Weight"], "Milligrams"), "Typelist does not contain Weight -> Milligrams")    
  end
  
  def test_volume_rules
    assert(contains(@types["Volume"], "Liters"), "Typelist does not contain Volume -> Liters")
    assert(contains(@types["Volume"], "US Gallons"), "Typelist does not contain Volume -> US Gallons")
    assert(contains(@types["Volume"], "US Pints"), "Typelist does not contain Volume -> US Pints")
    assert(contains(@types["Volume"], "UK Pints"), "Typelist does not contain Volume -> UK Pints")
    assert(contains(@types["Volume"], "US Tablespoons"), "Typelist does not contain Volume -> US Tablespoons")
    assert(contains(@types["Volume"], "US Teaspoons"), "Typelist does not contain Volume -> US Teaspoons")
    assert(contains(@types["Volume"], "Cubic Meters"), "Typelist does not contain Volume -> Cubic Meters")
    assert(contains(@types["Volume"], "Deciliters"), "Typelist does not contain Volume -> Deciliters")
    assert(contains(@types["Volume"], "Centiliters"), "Typelist does not contain Volume -> Centiliters")
    assert(contains(@types["Volume"], "Milliliters"), "Typelist does not contain Volume -> Milliliters")
    assert(contains(@types["Volume"], "Microliters"), "Typelist does not contain Volume -> Microliters")    
  end
  
  def test_length_conversion
    assert_in_delta(1069.055, @uc.perform_conversion(27.154, "Meters", "Inches"), 0.01)
    assert_in_delta(98.812095, @uc.perform_conversion(183, "Kilometers", "Nautical Miles"), 0.01)
    assert_in_delta(1498745.6, @uc.perform_conversion(851.56, "Miles", "Yards"), 0.01)    
    assert_in_delta(17.0688, @uc.perform_conversion(0.56, "Feet", "Centimeters"), 0.01)
    assert_in_delta(2413, @uc.perform_conversion(95, "Inches", "Millimeters"), 0.01)    
  end
  
  def test_speed_conversion
    assert_in_delta(5.8333333, @uc.perform_conversion(21, "Kilometers / Hour", "Meters / Second"), 0.01)
    assert_in_delta(184.18048, @uc.perform_conversion(412, "Miles / Hour", "Meters / Second"), 0.01)
    assert_in_delta(2397.6, @uc.perform_conversion(666, "Meters / Second", "Kilometers / Hour"), 0.01)    
    assert_in_delta(0.67906667, @uc.perform_conversion(22, "Knots", "Kilometers / Minute"), 0.01)    
  end
  
  def test_weight_conversion
    assert_in_delta(2.9189204, @uc.perform_conversion(1324, "Grams", "Pounds"), 0.01)
    assert_in_delta(14.514956, @uc.perform_conversion(512, "Ounces", "Kilograms"), 0.01)
    assert_in_delta(456700000, @uc.perform_conversion(0.0004567, "Metric Tons", "Micrograms"), 0.01)
    assert_in_delta(0.01686, @uc.perform_conversion(478, "Milligrams", "Ounces"), 0.01)        
  end
  
  def test_volume_conversion
    assert_in_delta(63.698, @uc.perform_conversion(241.123, "Liters", "US Gallons"), 0.01)
    assert_in_delta(926.766, @uc.perform_conversion(1113, "US Pints", "UK Pints"), 0.01)
    assert_in_delta(4542, @uc.perform_conversion(1514, "US Tablespoons", "US Teaspoons"), 0.01)
    assert_in_delta(75624515, @uc.perform_conversion(7562.4515, "Cubic Meters", "Deciliters"), 0.01)
    assert_in_delta(12340, @uc.perform_conversion(1234, "Centiliters", "Milliliters"), 0.01)
    assert_in_delta(28474458.909, @uc.perform_conversion(1925.672, "US Tablespoons", "Microliters"), 0.01)    
  end
  
  def test_argumenterror
    # Make sure passing invalid type, units and value to perform_conversion raises ArgumentError
    assert_raise(ArgumentError) { @uc.perform_conversion(123, "INVALID_FROM_UNIT", "Grams") }
    assert_raise(ArgumentError) { @uc.perform_conversion(123, "Grams", "INVALID_TO_UNIT") }
    assert_raise(ArgumentError) { @uc.perform_conversion("INVALID_VALUE", "Grams", "Micrograms") }    
  end
  
  def test_invalid_rules
    assert_raise(SyntaxError) { UnitConverter.new("invalid_rules.txt") }
  end
  
  def test_invalid_file
    assert_raise(IOError) { UnitConverter.new("invalid_file.txt") }
  end
  
  def test_get_units
    units = @uc.get_units
    assert_equal(32, units.size)
    assert(contains(units, "Knots"), "Units array does not contain Knots")
    assert(contains(units, "Grams"), "Units array does not contain Gram")
    assert(contains(units, "UK Pints"), "Units array does not contain UK Pint")
    assert(contains(units, "Inches"), "Units array does not contain Inch")    
  end  
  
  private
  
  # Returns true if array contains value, else false
  def contains(array, value)
    array.each do |type|
      if type == value
        return true
      end
    end
    return false
  end
  
end