require File.dirname(__FILE__) + '/../test_helper'
require 'unit_converter_controller'

# Re-raise errors caught by the controller.
class UnitConverterController; def rescue_action(e) raise e end; end

class UnitConverterControllerTest < Test::Unit::TestCase
  def setup
    @controller = UnitConverterController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns["types"]
  end
  
  def test_perform_conversion
    # Test length conversion
    post :perform_conversion, :input => "27.154 m"
    results = assigns["results"]
    assert_not_nil results, "Conversion with input: \"27.154 m\" failed"
    assert_in_delta(0.027154, results["Km"], 0.01)
    assert_in_delta(0.016872713, results["Mile"], 0.01)
    assert_in_delta(29.695975, results["Yard"], 0.01)
    assert_in_delta(89.087927, results["Foot"], 0.01)
    assert_in_delta(1069.055, results["Inch"], 0.01)
    assert_in_delta(2715.4, results["Centimeter"], 0.01)
    assert_in_delta(27154, results["Millimeter"], 0.01)
    assert_in_delta(0.014661987, results["Nautical Mile"], 0.01)
    
    # Test volume conversion
    post :perform_conversion, :input => "US Pint 65"
    results = assigns["results"]
    assert_not_nil results, "Conversion with input: \"US Pint 65\" failed"    
    assert_in_delta(30.756471, results["Liter"], 0.01)
    assert_in_delta(8.125, results["US Gallon"], 0.01)
    assert_in_delta(0.030756471, results["Cubic Meter"], 0.01)
    
    # Test speed conversion
    post :perform_conversion, :input => "268 Kilometers/h"
    results = assigns["results"]
    assert_not_nil results, "Conversion with input: \"268 Kilometers/h\" failed"
    assert_in_delta(144.70842, results["Knots"], 0.01)
    assert_in_delta(74.444444, results["Meters/s"], 0.01)
    assert_in_delta(166.52748, results["Miles/h"], 0.01)
    assert_in_delta(4.4666667, results["Kilometers/minute"], 0.01)
  end
  
  def test_invalid_input
    post :perform_conversion, :input => "dsgdgasagd223asz"
    assert_match(/Not a valid conversion/, @response.body)
  end
  
end