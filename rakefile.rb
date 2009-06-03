require "rubygems"
require "rake"
require "spec/rake/spectask"

ROOT = File.expand_path(File.dirname(__FILE__))

desc "Run all specs"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts << '--options' << ROOT + '/spec/spec.opts'
  t.spec_files = Dir.glob('spec/**/*_spec.rb').map { |f| f.to_s }
end  
