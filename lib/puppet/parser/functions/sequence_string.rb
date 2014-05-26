module Puppet::Parser::Functions
  newfunction(:sequence_string, :type => :rvalue, :doc => <<-EOS
Takes a string and returns the sequence substr1,substr1substr2,substr1substr2substr3,...

*Example*

    sequence_string("/this/is/a/test","/")

Would result in:

    ["/","/this/","/this/is/","/this/is/a/","/this/is/a/test"]
    EOS
  ) do |arguments|
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
