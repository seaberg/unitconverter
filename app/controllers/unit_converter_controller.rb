# TODO: Perhaps it is possible to use automatic loading instead, if the unit_converter conforms to the
# standard naming convention using modules, UnitConverter::UnitConverter or similar.
# This error will disappear when the unit_converter library is converted to a proper ruby gem
require File.expand_path(File.dirname(__FILE__) + "/../../lib/unit_converter/unit_converter.rb")

class UnitConverterController < ApplicationController
  # Display the unit_converter, perform conversion if posting a conversion request
  def index
    uc = UnitConverter.new
    @types = uc.get_types
    
    if request.post?
      perform_conversion(params[:input])
    end
  end

  def perform_conversion()
    uc = UnitConverter.new
    @results = nil
    
    begin
      input = parse_input(params[:input])
      @unit = input[:unit]
      @value = input[:value]
      @results = uc.perform_conversion(input[:value], input[:unit])
    rescue ArgumentError
      # Not a valid conversion
      return
    end
  end    
  
  def autocomplete_conversion_input
    re = Regexp.new("^#{params[:conversion][:input]}", "i")    
    uc = UnitConverter.new
    units = uc.get_units
    @matched_units = []
    units.each do |u|
      @matched_units << u if re.match(u)
    end
  end
  
  private
    
  # Parse input into a hash containing :value => and :unit => unit
  # TODO: characters in middle of a conversion value does not produce an error, for example: 1223qwee2 Pound
  # TODO: Should be possible to begin a value with a decimal sign, for example: .72 Pound should be a valid conversion
  def parse_input(input)
    value_unit_r = /(\d+(?:\.\d+)?)\s+([a-z\/]+(?: [a-z\/]+)*)/i
    unit_value_r = /([a-z\/]+(?: [a-z\/]+)*)\s+(\d+(?:\.\d+)?)/i
        
    value = ""
    unit = ""
    
    if md = value_unit_r.match(input)
      value = md[1]
      unit = md[2]
    elsif md = unit_value_r.match(input)
      unit = md[1]
      value = md[2]
    else
      raise ArgumentError, "Invalid Input"
    end
    result = {:value => value, :unit => unit}    
  end
  
end