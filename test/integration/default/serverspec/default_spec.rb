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

require 'serverspec'
set :backend, :exec

describe file('/test1/README.md') do
  it { is_expected.to be_a_file }
  its(:content) { is_expected.to include('repo=test_repo') }
  its(:content) { is_expected.to include('branch=master') }
end

describe file('/test2/README.md') do
  it { is_expected.to be_a_file }
  its(:content) { is_expected.to include('repo=test_repo') }
  its(:content) { is_expected.to include('branch=release') }
end

describe file('/test3/README.md') do
  it { is_expected.to be_a_file }
  its(:content) { is_expected.to include('repo=private_test_repo') }
  its(:content) { is_expected.to include('branch=master') }
end

describe file('/test4/README.md') do
  it { is_expected.to be_a_file }
  its(:content) { is_expected.to include('repo=private_test_repo') }
  its(:content) { is_expected.to include('branch=release') }
end
