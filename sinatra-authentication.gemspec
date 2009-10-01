# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sinatra-authentication}
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Max Justus Spransy"]
  s.date = %q{2009-10-01}
  s.description = %q{Simple authentication plugin for sinatra.}
  s.email = %q{maxjustus@gmail.com}
  s.extra_rdoc_files = ["TODO", "lib/models/abstract_user.rb", "lib/models/datamapper_user.rb", "lib/models/dm_adapter.rb", "lib/models/rufus_tokyo_user.rb", "lib/models/tc_adapter.rb", "lib/sinatra-authentication.rb", "lib/views/edit.haml", "lib/views/index.haml", "lib/views/login.haml", "lib/views/show.haml", "lib/views/signup.haml"]
  s.files = ["History.txt", "Manifest", "Rakefile", "TODO", "lib/models/abstract_user.rb", "lib/models/datamapper_user.rb", "lib/models/dm_adapter.rb", "lib/models/rufus_tokyo_user.rb", "lib/models/tc_adapter.rb", "lib/sinatra-authentication.rb", "lib/views/edit.haml", "lib/views/index.haml", "lib/views/login.haml", "lib/views/show.haml", "lib/views/signup.haml", "readme.markdown", "test/datamapper_test.rb", "test/lib/dm_app.rb", "test/lib/helper.rb", "test/lib/tc_app.rb", "test/lib/test.db", "test/lib/users.tct", "test/route_tests.rb", "test/rufus_tokyo_test.rb", "sinatra-authentication.gemspec"]
  s.homepage = %q{http://github.com/maxjustus/sinatra-authentication}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Sinatra-authentication", "--main", "readme.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{sinatra-authentication}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Simple authentication plugin for sinatra.}
  s.test_files = ["test/datamapper_test.rb", "test/rufus_tokyo_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<sinatra>, [">= 0"])
      s.add_development_dependency(%q<dm-core>, [">= 0"])
      s.add_development_dependency(%q<dm-timestamps>, [">= 0"])
      s.add_development_dependency(%q<dm-validations>, [">= 0"])
      s.add_development_dependency(%q<rufus-tokyo>, [">= 0"])
    else
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<dm-core>, [">= 0"])
      s.add_dependency(%q<dm-timestamps>, [">= 0"])
      s.add_dependency(%q<dm-validations>, [">= 0"])
      s.add_dependency(%q<rufus-tokyo>, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<dm-core>, [">= 0"])
    s.add_dependency(%q<dm-timestamps>, [">= 0"])
    s.add_dependency(%q<dm-validations>, [">= 0"])
    s.add_dependency(%q<rufus-tokyo>, [">= 0"])
  end
end
