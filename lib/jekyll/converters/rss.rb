module Jekyll

  require 'rexml/document'
  require 'time'
  require "YAML"

  module RSS
    #Reads posts from an RSS feed.
    #It creates a post file for each entry in the RSS.
    def self.process(source = "rss.xml")
      #FileUtils.mkdir_p "_posts"
      content = ""
      open(source, "r") { |f| content << f.read }
      doc = REXML::Document.new(content)
      posts = 0
      doc.elements.each("rss/channel/item") do |item|
        link = item.elements["link"].text

        # Use the URL after the last slash as the post's name
        name = link.split("/")[-1]
        
        # Remove html extension
        name = $1 if name =~ /(.*)\.html/

        # Remove the leading digits and dash that Serendipity adds
        name = $1 if name =~ /\d+\-(.*)/

        title = item.elements["title"].text

        content_element = (item.elements["content:encoded"] or item.elements["description"])
        unless content_element
          puts "No content in RSS item '#{name}'\n"
          next
        end
        content = content_element.text
        timestamp = Time.parse(item.elements["pubDate"].text)
        filename = "_posts/#{timestamp.strftime("%Y-%m-%d")}-#{name}.html"
        puts "#{link} -> #{filename}"
        File.open(filename, "w") do |f|
          YAML.dump(
            {
              "layout" => "post",
              "name" => name,
              "title" => title,
              "time" => timestamp,
            },
            f
          )
          f.puts "---\n#{content}"
        end
        posts += 1
      end
      puts "Created #{posts} posts!"
    end
  end
end
