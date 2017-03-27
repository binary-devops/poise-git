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

require 'spec_helper'

describe 'poise-git::default' do
  recipe { include_recipe 'poise-git' }

  context 'with defaults' do
    it { is_expected.to install_poise_git_client('git').with(version: '') }
  end # /context with defaults

  context 'with attributes' do
    before do
      override_attributes['poise-git'] = {}
      override_attributes['poise-git']['recipe'] = {}
      override_attributes['poise-git']['recipe']['version'] = '1.2.3'
    end

    it { is_expected.to install_poise_git_client('git').with(version: '1.2.3') }
  end # /context with attributes
end
