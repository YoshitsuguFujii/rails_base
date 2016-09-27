$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_base/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_base"
  s.version     = RailsBase::VERSION
  s.authors     = ["y.fujii"]
  s.email       = ["ishikurasakura@gmail.com"]
  s.homepage    = "https://github.com/YoshitsuguFujii/rails_base"
  s.summary     = "rails共通処理"
  s.description = "rails共通処理"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.1"
  s.add_dependency "gon"
  s.add_dependency "simple_form"
  s.add_dependency "compass-rails"
  s.add_dependency "kaminari"
  s.add_dependency "slim"
  s.add_dependency "zip_code_jp"
end
