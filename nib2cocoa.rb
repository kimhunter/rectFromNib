

##### !/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'json'

def frame_to_nsmakerect frame
  params = frame.gsub(/[\{\} ]+/, '').strip
  
  "NSMakeRect(#{params})" unless params == ''
end
def find_top_superview b
  sviews = b.xpath("//object[reference[@key='NSSuperview']]")
  ids = []
  sviews.each do |x|
    ref = x.xpath("reference[@key='NSSuperview']")
    ids << x.attribute('id') if ref.attribute('ref').nil?
  end
  ids.first
end

def print_view b
    indent = ""
    cur_id = ''
    top_super_view = find_top_superview b
    
    b.each do |ui|
      frame = ui.xpath("string[@key='NSFrame']").inner_text
      puts indent + ui.attribute('class').value
      puts indent + "#{frame_to_nsmakerect(frame)}"
      puts indent + ""
      begin
        indent = '    ' if ui.xpath("reference[@key='NSSuperview']").attribute('ref').value == top_super_view
      rescue 
        indent += "    "
      end
    end
end


nib = Nokogiri::XML(open("test_nibs/test_simple.xib"))
nib.remove_namespaces!
# puts nib
base = nib.xpath("//object[reference[@key='NSSuperview']]")
# puts base
print_view base



# puts nib.xpath("//object[@class='IBUILabel']")
# 
# kml.xpath('//LineString/coordinates').each do |coord|
#   current_points = []
#   # coord is a pile of CSV and each is normally separated by newlines or spaces 
#   coord.text.split(/[\n ]/).each do |str|
#     next if str.nil? || str.strip == ""
#     long, lat = str.split(',')
#     current_points << PolygonPoint.new(long, lat)
#   end
#   
# 
