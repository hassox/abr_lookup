# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "abr_lookup/version"

Gem::Specification.new do |s|
  s.name        = "abr_lookup"
  s.version     = AbrLookup::VERSION
  s.authors     = ["Daniel Neighman"]
  s.email       = ["has.sox@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A simple ABN / ACN lookup utility}
  s.description = %q{An ABN / ACN lookup utility that includes middleware}

  s.rubyforge_project = "abr_lookup"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:

  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "activemodel"
  s.add_runtime_dependency 'rack'
end
