Gem::Specification.new do |s|
  s.name        = "guttapercha"
  s.version     = '0.1.3'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Frantisek Havluj"]
  s.email       = ["haf@ujv.cz"]
  s.homepage    = "http://orf.ujv.cz"
  s.summary     = "Guttapercha"
  s.description = "LaTeX document helpers"

  s.files        = Dir.glob("{lib}/**/*") # + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)
  s.require_path = 'lib'
end
