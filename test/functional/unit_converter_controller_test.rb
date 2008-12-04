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

  def test_length_conversion
    post :perform_conversion, :input => "27.154 Meters"
    results = assigns["results"]
    assert_not_nil results, "Conversion with input: \"27.154 Meters\" failed"
    assert_in_delta(0.027154, results["Kilometers"], 0.01)
    assert_in_delta(0.016872713, results["Miles"], 0.01)
    assert_in_delta(29.695975, results["Yards"], 0.01)
    assert_in_delta(89.087927, results["Feet"], 0.01)
    assert_in_delta(1069.055, results["Inches"], 0.01)
    assert_in_delta(2715.4, results["Centimeters"], 0.01)
    assert_in_delta(27154, results["Millimeters"], 0.01)
    assert_in_delta(0.014661987, results["Nautical Miles"], 0.01)
  end

  def test_volume_conversion
    post :perform_conversion, :input => "US Pints 65"
    results = assigns["results"]
    assert_not_nil results, "Conversion with input: \"US Pints 65\" failed"    
    assert_in_delta(30.756471, results["Liters"], 0.01)
    assert_in_delta(8.125, results["US Gallons"], 0.01)
    assert_in_delta(0.030756471, results["Cubic Meters"], 0.01)    
  end

  def test_speed_conversion
    post :perform_conversion, :input => "268 Kilometers / Hour"
    results = assigns["results"]
    assert_not_nil results, "Conversion with input: \"268 Kilometers / Hour\" failed"
    assert_in_delta(144.70842, results["Knots"], 0.01)
    assert_in_delta(74.444444, results["Meters / Second"], 0.01)
    assert_in_delta(166.52748, results["Miles / Hour"], 0.01)
    assert_in_delta(4.4666667, results["Kilometers / Minute"], 0.01)  
  end


  def test_invalid_input
    post :perform_conversion, :input => "dsgdgasagd223asz"
    assert_match(/Not a valid conversion/, @response.body)
  end

end