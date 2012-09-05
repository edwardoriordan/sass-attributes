require "sass"
require "json"

module Sass::Script::Functions
  
  @@variable = ""
  @@variable = {}
	@@objects = []

  @@prefix = "sass_styles_"

  def add_selector(selector, values)

    # unquote: Remove quotes from a string if the string is quoted
    values = unquote(values)
  	selector = unquote(selector)

		newValues = {
    	selector => Hash[*values.value.split(',')]
		}
		
		@@objects << newValues

		Sass::Script::String.new(values)
  end

  def add_variable(name, value)
    #@@variable << {unquote(name) => unquote(value)}
    #@@variable += make_js_variable(unquote(name),unquote(value))
    @@variable = @@variable.merge({unquote(name) => unquote(value)})
    Sass::Script::String.new(value)
  end

  # Directly output a sass variables to js
  def make_js_variable_direct(name, value)
    if type_of(value).to_s == "number" && value.unitless?
      "var " + @@prefix + name.to_s + " = " + value.to_s + ";\n"   
    else
      "var " + @@prefix + name.to_s + " = '" + value.to_s + "';\n"
    end
  end

  def make_js_variable(name, value)
    "var " + @@prefix + name.to_s + " = " + value + ";\n"    
  end

  def write_json

    #output = make_js_variable("selectors", JSON.pretty_generate(@@objects))
    #output = "// VARIABLES\n" + @@variable;
    output = make_js_variable('variables', JSON.pretty_generate(@@variable))

  	File.open("style.js","w") do |f|
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
  
end