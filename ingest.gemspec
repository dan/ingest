$:.push File.expand_path("../lib", __FILE__)

require "ingest/version"

Gem::Specification.new do |s|
  s.name        = "ingest"
  s.version     = Ingest::VERSION
  s.authors     = ["Dan Benjamin"]
  s.email       = ["dan@hivelogic.com"]
  s.homepage    = "http://hivelogic.com"
  s.summary     = "A podcast RSS feed fetcher and parser."
  s.description = "A library designed to help fetch and parse podcast RSS feeds."
  s.license     = 'MIT'

  s.files       = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files  = Dir["test/**/*"]

  s.require_paths = ['lib']
end
