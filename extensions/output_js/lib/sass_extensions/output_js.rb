require "sass"
require "json"

module Sass::Script::Functions
  
  @@variables = {}
	@@selector_attributes = {}
  @@data_attributes = {}

  @@prefix = "sass_styles_"

  # in future versions of sass we should be able to get access to the 
  # selector and not have to pass it in.
  def add_selector_attributes(selector, values, mq)
    assert_type mq, :String

    # unquote: Remove quotes from a string if the string is quoted
  	selector = unquote(selector)
    values = unquote(values)
    mq = unquote(mq)

    # create selector object from the list of values passed in
    # strip any trailing or leading whitespace
    selector_object = {
    	selector => Hash[*values.value.split(',').map(&:strip)]
		}
    selector_object[selector]['mq'] = mq
		
    @@selector_attributes = @@selector_attributes.merge(selector_object)

		Sass::Script::String.new(values)
  end

  # in future versions of sass we should be able to get access to the 
  # selector and not have to pass it in.
  # Not sure if best api is to have different types of functions
  # or one generic one?
  def add_data_attribute(selector, data_attribute, value, mq)
    assert_type value, :String
    assert_type mq, :String

    # unquote: Remove quotes from a string if the string is quoted
    selector = unquote(selector)
    data_attribute = unquote(data_attribute)
    value = unquote(value)
    mq = unquote(mq)

    newValues = {
      selector => [data_attribute, value, mq]
    }
    
    #@@objects << newValues
    @@data_attributes = @@data_attributes.merge(newValues)

    Sass::Script::String.new(value)
  end

  def add_variable(name, value)
    @@variables = @@variables.merge({unquote(name) => unquote(value)})
    Sass::Script::String.new(value)
  end

  def make_js_variable(name, value)
    "var " + @@prefix + name.to_s + " = " + value + ";\n"    
  end

  def write_json
    output = make_js_variable("selectors", JSON.pretty_generate(@@selector_attributes))
    #output += make_js_variable("data_attributes", JSON.pretty_generate(@@data_attributes))
    output += make_js_variable('variables', JSON.pretty_generate(@@variables))

  	File.open(Compass.configuration.javascripts_dir + "/style.sass.js","w") do |f|
  		f.write(output)
		end

    @@variable = ''

		Sass::Script::String.new('')
  end

  # def add_style_value_OLD(selector, value)
  # 	existingValues = JSON.parse(IO.read("style.json"))

  #   newValues = {
  #   	selector => value
		# }

		# @values = existingValues.merge(newValues)

		# File.open("style.json","w") do |f|
  # 		f.write(JSON.pretty_generate(values))
		# end

		# Sass::Script::String.new('OK')
  # end

  # Directly output a sass variables to js
  def make_js_variable_direct(name, value)
    if type_of(value).to_s == "number" && value.unitless?
      "var " + @@prefix + name.to_s + " = " + value.to_s + ";\n"   
    else
      "var " + @@prefix + name.to_s + " = '" + value.to_s + "';\n"
    end
  end
  
end