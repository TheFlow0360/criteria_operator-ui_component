# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "criteria_operator/ui_component/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "criteria_operator-ui_component"
  spec.version     = CriteriaOperator::UiComponent::VERSION
  spec.authors     = ["Florian Koch"]
  spec.email       = ["floriankochde@arcor.de"]

  spec.summary       = "UI component Extension for the criteria_operator gem."
  spec.description   = "This gem provides ui components for Rails Applicaitons based on Cells, " \
                       "that can be used to edit the criteria_operator expression trees."
  spec.homepage      = "https://github.com/TheFlow0360/criteria_operator-ui_component.git"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org/"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.1"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "sqlite3"

  spec.add_dependency "rails", "~> 5.1"
  spec.add_dependency "cells", "~> 4.1"
  spec.add_dependency "cells-rails", "~> 0.0"
  spec.add_dependency "cells-erb", "~> 0.1"
  spec.add_dependency "jquery-rails", "~> 4.3"
  spec.add_dependency "criteria_operator", "~> 0.3"

  # let yard run on install
  spec.metadata["yard.run"] = "yri"
end
