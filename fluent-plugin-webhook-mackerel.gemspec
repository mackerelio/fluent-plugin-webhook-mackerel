lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-webhook-mackerel"
  spec.version       = File.read(File.expand_path('../VERSION', __FILE__))
  spec.authors       = ["mackerelio"]
  spec.email         = ["mackerel-developers@mackerel.io"]
  spec.summary       = %q{fluentd input plugin for receiving Mackerel webhook}
  spec.description   = %q{fluentd input plugin for receiving Mackerel webhook}
  spec.homepage      = "https://github.com/mackerelio/fluent-plugin-webhook-mackerel"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.7.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "fluentd", ">= 0.14.0"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
end
