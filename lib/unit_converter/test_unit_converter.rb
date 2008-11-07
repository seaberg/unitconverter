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
    assert(contains(@types["Length"], "m"), "Typelist does not contain Length -> m")    
    assert(contains(@types["Length"], "Km"), "Typelist does not contain Length -> Km")
    assert(contains(@types["Length"], "Mile"), "Typelist does not contain Length -> Mile")    
    assert(contains(@types["Length"], "Yard"), "Typelist does not contain Length -> Yard")    
    assert(contains(@types["Length"], "Foot"), "Typelist does not contain Length -> Foot")    
    assert(contains(@types["Length"], "Inch"), "Typelist does not contain Length -> Inch")    
    assert(contains(@types["Length"], "Centimeter"), "Typelist does not contain Length -> Centimeter")    
    assert(contains(@types["Length"], "Millimeter"), "Typelist does not contain Length -> Millimeter")    
    assert(contains(@types["Length"], "Nautical Mile"), "Typelist does not contain Length -> Nautical Mile")        
  end
  
  def test_speed_rules
    assert(contains(@types["Speed"], "Kilometers/h"), "Typelist does not contain Speed -> Kilometers/h")
    assert(contains(@types["Speed"], "Kilometers/minute"), "Typelist does not contain Speed -> Kilometers/minute")
    assert(contains(@types["Speed"], "Miles/h"), "Typelist does not contain Speed -> Miles/h")
    assert(contains(@types["Speed"], "Meters/s"), "Typelist does not contain Speed -> Meters/s")
    assert(contains(@types["Speed"], "Knots"), "Typelist does not contain Speed -> Knots")    
  end
  
  def test_weight_rules
    assert(contains(@types["Weight"], "Gram"), "Typelist does not contain Weight -> Gram")
    assert(contains(@types["Weight"], "Pound"), "Typelist does not contain Weight -> Pound")
    assert(contains(@types["Weight"], "Ounce"), "Typelist does not contain Weight -> Ounce")
    assert(contains(@types["Weight"], "Kilogram"), "Typelist does not contain Weight -> Kilogram")
    assert(contains(@types["Weight"], "Metric Ton"), "Typelist does not contain Weight -> Metric Ton")
    assert(contains(@types["Weight"], "Microgram"), "Typelist does not contain Weight -> Microgram")
    assert(contains(@types["Weight"], "Milligram"), "Typelist does not contain Weight -> Milligram")    
  end
  
  def test_volume_rules
    assert(contains(@types["Volume"], "Liter"), "Typelist does not contain Volume -> Liter")
    assert(contains(@types["Volume"], "US Gallon"), "Typelist does not contain Volume -> US Gallon")
    assert(contains(@types["Volume"], "US Pint"), "Typelist does not contain Volume -> US Pint")
    assert(contains(@types["Volume"], "UK Pint"), "Typelist does not contain Volume -> UK Pint")
    assert(contains(@types["Volume"], "US Tablespoon"), "Typelist does not contain Volume -> US Tablespoon")
    assert(contains(@types["Volume"], "US Teaspoon"), "Typelist does not contain Volume -> US Teaspoon")
    assert(contains(@types["Volume"], "Cubic Meter"), "Typelist does not contain Volume -> Cubic Meter")
    assert(contains(@types["Volume"], "Deciliter"), "Typelist does not contain Volume -> Deciliter")
    assert(contains(@types["Volume"], "Centiliter"), "Typelist does not contain Volume -> Centiliter")
    assert(contains(@types["Volume"], "Milliliter"), "Typelist does not contain Volume -> Milliliter")
    assert(contains(@types["Volume"], "Microliter"), "Typelist does not contain Volume -> Microliter")    
  end
  
  def test_length_conversion
    assert_in_delta(1069.055, @uc.perform_conversion(27.154, "m", "Inch"), 0.01)
    assert_in_delta(98.812095, @uc.perform_conversion(183, "Km", "Nautical Mile"), 0.01)
    assert_in_delta(1498745.6, @uc.perform_conversion(851.56, "Mile", "Yard"), 0.01)    
    assert_in_delta(17.0688, @uc.perform_conversion(0.56, "Foot", "Centimeter"), 0.01)
    assert_in_delta(2413, @uc.perform_conversion(95, "Inch", "Millimeter"), 0.01)    
  end
  
  def test_speed_conversion
    assert_in_delta(5.8333333, @uc.perform_conversion(21, "Kilometers/h", "Meters/s"), 0.01)
    assert_in_delta(184.18048, @uc.perform_conversion(412, "Miles/h", "Meters/s"), 0.01)
    assert_in_delta(2397.6, @uc.perform_conversion(666, "Meters/s", "Kilometers/h"), 0.01)    
    assert_in_delta(0.67906667, @uc.perform_conversion(22, "Knots", "Kilometers/minute"), 0.01)    
  end
  
  def test_weight_conversion
    assert_in_delta(2.9189204, @uc.perform_conversion(1324, "Gram", "Pound"), 0.01)
    assert_in_delta(14.514956, @uc.perform_conversion(512, "Ounce", "Kilogram"), 0.01)
    assert_in_delta(456700000, @uc.perform_conversion(0.0004567, "Metric Ton", "Microgram"), 0.01)
    assert_in_delta(0.01686, @uc.perform_conversion(478, "Milligram", "Ounce"), 0.01)        
  end
  
  def test_volume_conversion
    assert_in_delta(63.698, @uc.perform_conversion(241.123, "Liter", "US Gallon"), 0.01)
    assert_in_delta(926.766, @uc.perform_conversion(1113, "US Pint", "UK Pint"), 0.01)
    assert_in_delta(4542, @uc.perform_conversion(1514, "US Tablespoon", "US Teaspoon"), 0.01)
    assert_in_delta(75624515, @uc.perform_conversion(7562.4515, "Cubic Meter", "Deciliter"), 0.01)
    assert_in_delta(12340, @uc.perform_conversion(1234, "Centiliter", "Milliliter"), 0.01)
    assert_in_delta(28474458.909, @uc.perform_conversion(1925.672, "US Tablespoon", "Microliter"), 0.01)    
  end
  
  def test_argumenterror
    # Make sure passing invalid type, units and value to perform_conversion raises ArgumentError
    assert_raise(ArgumentError) { @uc.perform_conversion(123, "INVALID_FROM_UNIT", "Gram") }
    assert_raise(ArgumentError) { @uc.perform_conversion(123, "Gram", "INVALID_TO_UNIT") }
    assert_raise(ArgumentError) { @uc.perform_conversion("INVALID_VALUE", "Gram", "Microgram") }    
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
    assert(contains(units, "Gram"), "Units array does not contain Gram")
    assert(contains(units, "UK Pint"), "Units array does not contain UK Pint")
    assert(contains(units, "Inch"), "Units array does not contain Inch")    
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