
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'subs/version'

Gem::Specification.new do |spec|
  spec.name          = 'subs'
  spec.version       = Subs::VERSION
  spec.authors       = ['ForeverZer0']
  spec.email         = ['efreed09@gmail.com']

  spec.summary       = %q{Simple and intuitive command-line program to automatically and accurately search and  download subtitles for all of your favorite movies and television shows.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = 'https://github.com/ForeverZer0/subs'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split('x0').reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'xmlrpc',  '~> 0.3'
  spec.add_runtime_dependency 'thor',    '~> 0.20'

  spec.add_development_dependency 'bundler',  '~> 2.0'
  spec.add_development_dependency 'rake',     '~> 10.0'
end
