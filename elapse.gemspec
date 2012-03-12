require File.expand_path("../lib/elapse/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "elapse"
  s.version = Elapse::VERSION
  s.authors = ["Alex Fortuna"]
  s.email = ["alex.r@askit.org"]
  s.homepage = "http://github.com/dadooda/elapse"

  # Copy these from class's description, adjust markup.
  s.summary = %q{Elapsed time measurement tool}
  s.description = %q{Elapsed time measurement tool}
  # end of s.description=

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map {|f| File.basename(f)}
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "yard"
end
