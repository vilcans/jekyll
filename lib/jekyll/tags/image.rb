module Jekyll

  require 'rubygems'
  require 'RMagick'

  ATTRIBUTES = %w(max_width max_height)

  class ImageTag < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      super

      args = markup.strip.split /\s+/
      @file = args.shift
      
      # Handle key=value arguments.
      # TODO: is there a standard way to implement keyword arguments in tags?
      args.each do |arg|
        key, value = arg.split('=', 2)
        unless ATTRIBUTES.include? key
          raise SyntaxError.new("Syntax Error in 'image' - Valid syntax: image <file> [max_width=x max_height=y]")
        end
        instance_variable_set "@#{key}", value.to_i
      end
    end

    def render(context)
      src_base = context.registers[:site].source
      path = File.join(src_base, @file)
      if not File.exist?(path)
        return "<strong>File #{path} not found</strong>"
      end

      image = Magick::ImageList.new(path).first

      width, height = image.columns, image.rows
      if ((@max_width and width > @max_width) or
        (@max_height and height > @max_height))
        #puts "needs to scale"
        scaled = image.resize_to_fit(@max_width || width, @max_height || height)
        extension = File.extname(@file)
        width, height = scaled.columns, scaled.rows
        scaled_name = "#{@file[0...-extension.length]}_#{width}x#{height}#{extension}"
        file_to_write = File.join(context.registers[:site].dest, scaled_name)
        FileUtils.mkdir_p File.dirname(file_to_write)
        scaled.write file_to_write
        src_name = scaled_name
      else
        src_name = @file
      end
      return %Q(<img src="/#{src_name}" width="#{width}" height="#{height}" />)
    end
  end

end

Liquid::Template.register_tag('image', Jekyll::ImageTag)

