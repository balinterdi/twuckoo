# require 'scrubyt'
require "rubygems"
require 'open-uri'
require "hpricot"

number = ARGV.first
doc = Hpricot(open("http://www.rtqe.net/ObliqueStrategies/Ed#{number}.html"))
advices = doc.search("p").map { |para| para.inner_html.gsub("\n", " ").strip }.select { |para| para =~ /^[^<>]+$/m }
open("oblique_strategies_#{number}.txt", "w") do |f|
  advices.each { |advice| f.write(advice + "\n") }
end

# Daily_Oblique/ZenKoan77
