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

    # Create a valid NCName from a string.
    # NCNames are used in the id attribute in HTML and XML.
    # Invalid characters are converted to hexadecimal codes.
    # It is not a proper escaping since it's not safely reversible.
    #
    # NCNames may only contain the following characters:
    #
    # Letter | "_" | "-" | "." | [0-9] | #xB7 | [#x0300-#x036F] | [#x203F-#x2040]
    #
    # and the first character must be a letter or underscore.
    #
    # To be safe, this filter also removes non-ascii characters even
    # though any letter is allowed in the standard.
    def ncname(input)
      input \
        .sub(/^([^a-zA-Z_])/, '_\1') \
        .sub(/\s/, '-') \
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
