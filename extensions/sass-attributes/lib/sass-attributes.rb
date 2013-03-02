require 'compass'
require 'json'

Compass::Frameworks.register("sass-attributes", :path => "#{File.dirname(__FILE__)}/..")

module Sassatributes
  VERSION = "0.1"
  DATE = "2013-03-02"
end

module Sass::Script::Functions
  
  #collections
  @@variables = {}
  @@selector_attributes = {}

  #prefix added to outputed sass variables
  @@prefix = "sassStyles"

  # in future versions of sass we should be able to get access to the 
  # selector and not have to pass it in
  def add_selector_attributes(selector, values, mq)
    assert_type mq, :String

    # unquote: Remove quotes from a string if the string is quoted
    selector = unquote(selector.value)
    values = unquote(values)
    mq = unquote(mq)

    data_attr = Hash[*values.value.split(',').map(&:strip)]

    # if selector has already been added
    # add the values to the selector
    # otherwise create a new selector
    if @@selector_attributes.has_key?(selector)
      @@selector_attributes[selector]['data_attributes'] = @@selector_attributes[selector]['data_attributes'].merge(data_attr)
    else
      selector_object = { 
        selector => {
          'data_attributes' => data_attr,
          'mq' => mq
        }
      }
      @@selector_attributes = @@selector_attributes.merge(selector_object)  
    end
    
    
    Sass::Script::String.new(values)
  end

  def add_variable(name, value)
    @@variables = @@variables.merge({unquote(name) => unquote(value)})
    Sass::Script::String.new(value)
  end

  def make_js_variable(name, value)
    "var " + @@prefix + name.to_s + " = " + value + ";\n"    
  end

  # write json to style file
  def write_json
    output = make_js_variable("Selectors", JSON.pretty_generate(@@selector_attributes))
    output += make_js_variable('Variables', JSON.pretty_generate(@@variables))

    File.open(Compass.configuration.javascripts_dir + "/style.sass.js", "w") do |f|
      f.write(output)
    end

    @@variable = ''

    Sass::Script::String.new('')
  end
  
end