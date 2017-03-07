$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fink/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fink"
  s.version     = Fink::VERSION
  s.authors     = ["guillaume barillot"]
  s.email       = ["gbarillot@gmail.com"]
  s.homepage    = "https://github.com/misterbnb/fink"
  s.summary     = "Report broken images"
  s.description = "Report broken images, make sure they are really broken (server side), then records it"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "httparty"
  s.add_dependency "jquery-rails"

end
