# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----

# ---- original file header ----
#
# @summary
#   Takes a string and returns the sequence substr1,substr1substr2,substr1substr2substr3,...
#
#*Example*
#
#    sequence_string("/this/is/a/test","/")
#
#Would result in:
#
#    ["/","/this/","/this/is/","/this/is/a/","/this/is/a/test"]
#
#
Puppet::Functions.create_function(:'testguide::sequence_string') do
  # @param arguments
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :arguments
  end


  def default_impl(*arguments)
    
    str = arguments[0]
    separator = arguments[1] ? arguments[1] : '/'
    sequence = [arguments[2]]
    str.each_line(separator) do |part|
      sequence << "#{sequence[-1]}#{part}"
    end
    if arguments[2]
      sequence.shift
    end
    return sequence.compact
  
  end
end