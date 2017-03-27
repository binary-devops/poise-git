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

describe PoiseGit::GitClientProviders::Dummy do
  let(:git_client_resource) { chef_run.poise_git_client('test') }
  step_into(:poise_git_client)
  recipe do
    poise_git_client 'test' do
      provider :dummy
    end
  end

  describe '#git_binary' do
    subject { git_client_resource.git_binary }

    it { is_expected.to eq '/git' }

    context 'with an option override' do
      before do
        override_attributes['poise-git'] ||= {}
        override_attributes['poise-git']['test'] ||= {}
        override_attributes['poise-git']['test']['git_binary'] = '/other'
      end

      it { is_expected.to eq '/other' }
    end # /context with an option override
  end # /describe #git_binary

  describe '#git_environment' do
    subject { git_client_resource.git_environment }

    it { is_expected.to eq({}) }

    context 'with an option override' do
      before do
        override_attributes['poise-git'] ||= {}
        override_attributes['poise-git']['test'] ||= {}
        override_attributes['poise-git']['test']['git_environment'] = {'FOO' => 'BAR'}
      end

      it { is_expected.to eq({'FOO' => 'BAR'}) }
    end # /context with an option override
  end # /describe #git_environment

  describe 'action :install' do
    # Just make sure it doesn't error.
    it { run_chef }
  end # /describe action :install

  describe 'action :uninstall' do
    recipe do
      poise_git_client 'test' do
        action :uninstall
        provider :dummy
      end
    end

    # Just make sure it doesn't error.
    it { run_chef }
  end # /describe action :uninstall
end
