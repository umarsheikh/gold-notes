# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "patron"
  s.version = "0.4.18"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2.0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Phillip Toland"]
  s.date = "2012-03-05"
  s.description = "Ruby HTTP client library based on libcurl"
  s.email = ["phil.toland@gmail.com"]
  s.extensions = ["ext/patron/extconf.rb"]
  s.files = ["ext/patron/extconf.rb"]
  s.homepage = "https://github.com/toland/patron"
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = "patron"
  s.rubygems_version = "1.8.10"
  s.summary = "Patron HTTP Client"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<rake-compiler>, [">= 0.7.5"])
      s.add_development_dependency(%q<rspec>, [">= 2.3.0"])
      s.add_development_dependency(%q<rcov>, [">= 0.9.9"])
    else
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<rake-compiler>, [">= 0.7.5"])
      s.add_dependency(%q<rspec>, [">= 2.3.0"])
      s.add_dependency(%q<rcov>, [">= 0.9.9"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<rake-compiler>, [">= 0.7.5"])
    s.add_dependency(%q<rspec>, [">= 2.3.0"])
    s.add_dependency(%q<rcov>, [">= 0.9.9"])
  end
end
