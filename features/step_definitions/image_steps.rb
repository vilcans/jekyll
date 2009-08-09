require 'rubygems'
require 'RMagick'

Given /^I have an (\d+)x(\d+) image file "([^\"]*)"$/ do |width, height, name|
  image = Magick::Image.new(width.to_i, height.to_i)
  image.write(name)
end

