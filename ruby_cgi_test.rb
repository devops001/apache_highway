#!/usr/bin/ruby

require 'coderay'

def escape(line)
  line.gsub('<','&lt;').gsub('>','&gt;')
end

html = []

html << "Content-type: text/html\n\n"

html << "<!doctype 'html'><html><head><meta charset='utf-8'></head><body><h1>ruby works</h1>"

###############################################
## ENV variables:
###############################################

html << "<hr/><h3>ENV variables available:</h3><pre>"
ENV.keys.sort.each { |key| html << "#{key} = #{escape(ENV[key])}\n" }

###############################################
## this script:
###############################################

html << "<hr/><h3>This script:</h3>"
html << CodeRay.scan(File.read(__FILE__), :ruby).div

###############################################
## display html:
###############################################

html << "</body></html>"
puts html.join()

