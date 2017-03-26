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

describe PoiseGit::Resources::PoiseGit do
  recipe do
    poise_git_client 'git'
    poise_git '/test' do
      user 'root'
      repository 'https://example.com/test.git'
      revision 'd44ec06d0b2a87732e91c005ed2048c824fd63ed'
      deploy_key 'secretkey'
    end
  end

  before do
    # Don't actually run the real thing
    allow_any_instance_of(described_class::Provider).to receive(:action_sync).and_return(nil)
  end

  it { run_chef }
end
