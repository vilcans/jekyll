module Jekyll

  module Filters
    def textilize(input)
      RedCloth.new(input).to_html
    end

    def date_to_string(date)
      date.strftime("%d %b %Y")
    end

    def date_to_long_string(date)
      date.strftime("%d %B %Y")
    end

    def date_to_xmlschema(date)
      date.xmlschema
    end

    def xml_escape(input)
      CGI.escapeHTML(input)
    end

    def cgi_escape(input)
      CGI::escape(input)
    end

    # Escape quote chars and backslash in a string
    # so it can be used in a Javascript string literal.
    def string_escape(input)
      return input.gsub(/(["'\\])/, '\\\\\1')
    end

    # Create a valid HTML id attribute from a string.
    #
    # According to the HTML4 spec (http://www.w3.org/TR/html4/types.html#h-6.2):
    # "ID and NAME tokens must begin with a letter ([A-Za-z]) and may be followed
    # by any number of letters, digits ([0-9]), hyphens ("-"), underscores ("_"),
    # colons (":"), and periods (".")."
    #
    # Also, colons are not allowed in XML, so we consider them invalid too.
    #
    # This filter "escapes" invalid character as hexadecimal codes.
    # It is not a proper escaping since it's not safely reversible.
    #
    # NOTE: We do not ensure that the first character of the string
    # is a letter. You can make sure that the string begins with a letter
    # by adding a prefix, e.g.:
    #
    #     <a id="tag-{{ t | html_id }}">...
    def to_id(input)
      input \
        .gsub(/[\s\/]/, '-') \
        .gsub(/([^a-zA-Z0-9_.\-]+)/n) do
        '_' + $1.unpack('H2' * $1.size).join('').upcase
      end
    end

    def number_of_words(input)
      input.split.length
    end

    def array_to_sentence_string(array)
      connector = "and"
      case array.length
      when 0
        ""
      when 1
        array[0].to_s
      when 2
        "#{array[0]} #{connector} #{array[1]}"
      else
        "#{array[0...-1].join(', ')}, #{connector} #{array[-1]}"
      end
    end

  end
end
