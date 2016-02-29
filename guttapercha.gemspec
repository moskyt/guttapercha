Gem::Specification.new do |s|
  s.name        = "guttapercha"
  s.version     = '1.0.2'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Frantisek Havluj"]
  s.email       = ["haf@ujv.cz"]
  s.homepage    = "http://orf.ujv.cz"
  s.summary     = "Guttapercha"
  s.description = "LaTeX document helpers"

  s.files        = Dir.glob("{lib}/**/*") # + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)
  s.require_path = 'lib'
  
  s.add_development_dependency "rake"
  s.add_development_dependency "minitest", "~> 5.0"
  s.add_development_dependency "ci_reporter_minitest", "~> 1.0"
  
end
