$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'caddie/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'caddie'
  s.version     = Caddie::VERSION
  s.authors     = ['Zuger Cédric']
  s.email       = ['zuger.cedric@gmail.com']
  s.homepage    = 'https://github.com/czuger/caddie'
  s.summary     = 'Crest mArket DownloaD engInE'
  s.description = 'A rails engine that allow to download CREST market data (designed to be plugged into a custom application)'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_runtime_dependency 'rails', '~> 5.2'
  s.add_runtime_dependency 'pg', '~> 0.21'
end
