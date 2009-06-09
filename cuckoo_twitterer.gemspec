# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cuckoo_twitterer}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["B\303\241lint \303\211rdi"]
  s.date = %q{2009-06-09}
  s.default_executable = %q{cuckoo_twitterer.rb}
  s.description = %q{A simple yet elegant solution to tweet a message regularly from a file (and in the future: from a webpage, a database, etc.)}
  s.email = %q{balint.erdi@bucionrails.com}
  s.executables = ["cuckoo_twitterer.rb"]
  s.extra_rdoc_files = ["bin/cuckoo_twitterer.rb", "lib/cuckoo_twitterer.rb", "lib/environments.rb", "lib/modules/one_line_from_file.rb", "tasks/spec.rake"]
  s.files = ["bin/cuckoo_twitterer.rb", "config/bot.yml", "lib/cuckoo_twitterer.rb", "lib/environments.rb", "lib/modules/one_line_from_file.rb", "Manifest", "Rakefile", "spec/cuckoo_twitterer_spec.rb", "spec/one_line_from_file_spec.rb", "spec/spec.opts", "tasks/spec.rake", "cuckoo_twitterer.gemspec"]
  s.homepage = %q{http://github.com/balinterdi/cuckoo_twitterer}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Cuckoo_twitterer"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{cuckoo_twitterer}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{A simple yet elegant solution to tweet a message regularly from a file (and in the future: from a webpage, a database, etc.)}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
