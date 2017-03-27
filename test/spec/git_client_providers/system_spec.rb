#
# Copyright 2017, Noah Kantrowitz
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

require 'spec_helper'

describe PoiseGit::GitClientProviders::System do
  let(:git_client_resource) { chef_run.poise_git_client('git') }
  step_into(:poise_git_client)
  recipe do
    poise_git_client 'git' do
      provider :system
    end
  end

  shared_examples_for 'system provider' do |pkg='git'|
    it { expect(git_client_resource.provider_for_action(:install)).to be_a described_class }
    it { is_expected.to install_poise_languages_system(pkg).with(dev_package: false) }
  end

  context 'on Ubuntu' do
    let(:chefspec_options) { {platform: 'ubuntu', version: '16.04'} }
    it_behaves_like 'system provider'
  end # /context on Ubuntu

  context 'on CentOS' do
    let(:chefspec_options) { {platform: 'centos', version: '7.0'} }
    it_behaves_like 'system provider'
  end # /context on CentOS

  context 'on OmniOS' do
    let(:chefspec_options) { {platform: 'omnios', version: '151018'} }
    it_behaves_like 'system provider', 'developer/versioning/git'
  end # /context on OmniOS

  context 'on SmartOS' do
    let(:chefspec_options) { {platform: 'smartos', version: '5.11'} }
    it_behaves_like 'system provider', 'scmgit'
  end # /context on SmartOS

  context 'action :uninstall' do
    recipe do
      poise_git_client 'git' do
        action :uninstall
        provider :system
      end
    end

    it { expect(git_client_resource.provider_for_action(:uninstall)).to be_a described_class }
    it { is_expected.to uninstall_poise_languages_system('git').with(dev_package: false) }
  end # /context action :uninstall
end
