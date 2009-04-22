# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sinatra-authentication}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Max Justus Spransy"]
  s.date = %q{2009-04-22}
  s.description = %q{Simple authentication plugin for sinatra.}
  s.email = %q{maxjustus@gmail.com}
  s.extra_rdoc_files = ["lib/models/user.rb", "lib/views/signup.haml", "lib/views/edit.haml", "lib/views/login.haml", "lib/views/index.haml", "lib/views/show.haml", "lib/sinatra-authentication.rb", "TODO"]
  s.files = ["lib/models/user.rb", "lib/views/signup.haml", "lib/views/edit.haml", "lib/views/login.haml", "lib/views/index.haml", "lib/views/show.haml", "lib/sinatra-authentication.rb", "History.txt", "Rakefile", "readme.rdoc", "TODO", "Manifest", "sinatra-authentication.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/maxjustus/sinatra-authentication}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Sinatra-authentication", "--main", "readme.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{sinatra-authentication}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple authentication plugin for sinatra.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<sinatra>, [">= 0"])
      s.add_development_dependency(%q<dm-core>, [">= 0"])
      s.add_development_dependency(%q<dm-timestamps>, [">= 0"])
      s.add_development_dependency(%q<dm-validations>, [">= 0"])
    else
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<dm-core>, [">= 0"])
      s.add_dependency(%q<dm-timestamps>, [">= 0"])
      s.add_dependency(%q<dm-validations>, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<dm-core>, [">= 0"])
    s.add_dependency(%q<dm-timestamps>, [">= 0"])
    s.add_dependency(%q<dm-validations>, [">= 0"])
  end
end
