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

describe PoiseGit::Resources::PoiseGitClient do
  before do
    override_attributes['poise-git'] ||= {}
    override_attributes['poise-git']['provider'] = 'dummy'
  end

  context 'with an empty name' do
    recipe do
      poise_git_client ''
    end

    it { is_expected.to install_poise_git_client('').with(version: '') }
  end # /context with an empty name

  context 'with name git' do
    recipe do
      poise_git_client 'git'
    end

    it { is_expected.to install_poise_git_client('git').with(version: '') }
  end # /context with name git

  context 'with name 1.2.3' do
    recipe do
      poise_git_client '1.2.3'
    end

    it { is_expected.to install_poise_git_client('1.2.3').with(version: '1.2.3') }
  end # /context with name 1.2.3

  context 'with name git-1.2.3' do
    recipe do
      poise_git_client 'git-1.2.3'
    end

    it { is_expected.to install_poise_git_client('git-1.2.3').with(version: '1.2.3') }
  end # /context with name git-1.2.3

  context 'with name git1.2.3' do
    recipe do
      poise_git_client 'git1.2.3'
    end

    it { is_expected.to install_poise_git_client('git1.2.3').with(version: '1.2.3') }
  end # /context with name git1.2.3
end
