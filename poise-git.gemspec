#
# Copyright 2015-2017, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poise_git/version'

Gem::Specification.new do |spec|
  spec.name = 'poise-git'
  spec.version = PoiseGit::VERSION
  spec.authors = ['Noah Kantrowitz']
  spec.email = %w{noah@coderanger.net}
  spec.description = 'A Chef cookbook for installing and using Git.'
  spec.summary = spec.description
  spec.homepage = 'https://github.com/poise/poise-git'
  spec.license = 'Apache-2.0'
  spec.metadata['platforms'] = 'amazon arch centos debian fedora gentoo omnios opensuse raspbian redhat smartos suse ubuntu'

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w{lib}

  spec.add_dependency 'chef', '>= 12.1', '< 14'
  spec.add_dependency 'halite', '~> 1.1'
  spec.add_dependency 'poise', '~> 2.6'
  spec.add_dependency 'poise-languages', '~> 2.1'

  spec.add_development_dependency 'poise-boiler', '~> 1.6'
end
