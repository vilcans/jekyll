module Jekyll

  require 'rubygems'
  require 'RMagick'

  ATTRIBUTES = %w(max_width max_height css_class)

  class ImageTag < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      super

      args = markup.strip.split /\s+/
      file = args.shift
      if file =~ /^\/+(.*)/
        # Absolute image path; remove leading slashes
        @file = $1
      else
        # TODO: make path relative to post
        @file = file
      end

      # Handle key=value arguments.
      # TODO: is there a standard way to implement keyword arguments in tags?
      args.each do |arg|
        key, value = arg.split('=', 2)
        unless ATTRIBUTES.include? key
          raise SyntaxError.new("Syntax Error in 'image' - Valid syntax: image <file> [max_width=x max_height=y css_class=zzz]")
        end
        instance_variable_set "@#{key}", value
      end
      @max_width = @max_width && @max_width.to_i
      @max_height = @max_height && @max_height.to_i
    end

    def render(context)
      site = context.registers[:site]
      src_base = site.source
      path = File.join(src_base, @file)
      if not File.exist?(path)
        return "<strong>File #{path} not found</strong>"
      end

      image = Magick::ImageList.new(path).first

      max_width = @max_width || site.config['image_max_width']
      max_height = @max_height || site.config['image_max_height']

      original_width, original_height = image.columns, image.rows
      width, height = original_width, original_height
      if ((max_width and width > max_width) or
        (max_height and height > max_height))
        scaled = image.resize_to_fit(max_width || width, max_height || height)
        extension = File.extname(@file)
        width, height = scaled.columns, scaled.rows
        scaled_name = "#{@file[0...-extension.length]}_#{width}x#{height}#{extension}"
        file_to_write = File.join(context.registers[:site].dest, scaled_name)
        FileUtils.mkdir_p File.dirname(file_to_write)
        scaled.write file_to_write
        src_name = '/' + scaled_name
      else
        src_name = '/' + @file
      end

      if site.config.has_key?('image_include')
        # TODO: Secure this. Do not allow reading files outside _includes 
        source = File.read(File.join(context.registers[:site].source, '_includes', site.config['image_include']))
        partial = Liquid::Template.parse(source)
        context.stack do
          context['css_class'] = @css_class
          context['image'] = {
            'name' => src_name, 'width' => width, 'height' => height
          }
          context['original'] = {
            'name' => '/' + @file, 'width' => original_width, 'height' => original_height
          }
          partial.render(context)
        end
      elsif @css_class
        %Q(<img src="#{src_name}" width="#{width}" height="#{height}" class="#{@css_class}"/>)
      else
        %Q(<img src="#{src_name}" width="#{width}" height="#{height}"/>)
      end
    end
  end

end

Liquid::Template.register_tag('image', Jekyll::ImageTag)

