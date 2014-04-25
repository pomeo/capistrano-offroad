# -*- mode: ruby; encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'capistrano-offroad/version'

Gem::Specification.new do |s|
  s.name = "capistrano-offroad"
  s.version = CapistranoOffroad::VERSION::STRING
  s.summary = "Capistrano add-ons and recipes for non-rails projects"
  s.description = <<EOF
Capistrano-offroad is a support package for using Capistrano with
non-rails projects.  It contains basic reset of Rails-specific tasks,
a handful of utility functions, and modules with recipes.
EOF

  s.authors = ["Maciej Pasternacki"]
  s.email = "maciej@pasternacki.net"
  s.homepage = "http://github.com/mpasternacki/capistrano-offroad"
  s.licenses = ['BSD']

  s.add_dependency "capistrano", "= 2.15.5"

  s.required_rubygems_version = ">= 1.3.6"
  s.files = Dir.glob("lib/**/*.rb") + %w(README LICENSE)
  s.require_paths = ["lib"]
end
