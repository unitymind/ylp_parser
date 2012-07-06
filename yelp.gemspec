$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "yelp/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "yelp"
  s.version     = Yelp::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of YlpParser."
  s.description = "TODO: Description of YlpParser."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.6"
  s.add_dependency "httparty", "~> 0.8.3"
  s.add_dependency "nokogiri", "~> 1.5.5"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
