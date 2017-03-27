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

describe PoiseGit::Resources::PoiseGit do
  step_into(:poise_git)
  before do
    override_attributes['poise-git'] ||= {}
    override_attributes['poise-git']['provider'] = 'dummy'
  end

  before do
    # Don't actually run the real thing
    allow_any_instance_of(described_class::Provider).to receive(:action_sync).and_return(nil)
  end

  def cache_path(path)
    "#{Chef::Config[:file_cache_path]}/#{path}"
  end

  context 'with defaults' do
    recipe do
      poise_git_client 'git'
      poise_git '/test' do
        repository 'https://example.com/test.git'
        revision 'd44ec06d0b2a87732e91c005ed2048c824fd63ed'
      end
    end

    it { is_expected.to_not render_file(cache_path('poise_git_deploy_2089348824')) }
    it { is_expected.to_not render_file(cache_path('poise_git_wrapper_2089348824')) }
  end # /context with defaults

  context 'with in-line deploy key' do
    recipe do
      poise_git_client 'git'
      poise_git '/test' do
        repository 'https://example.com/test.git'
        revision 'd44ec06d0b2a87732e91c005ed2048c824fd63ed'
        deploy_key 'secretkey'
      end
    end

    it { is_expected.to render_file(cache_path('poise_git_deploy_2089348824')).with_content('secretkey') }
    it { is_expected.to render_file(cache_path('poise_git_wrapper_2089348824')).with_content(%Q{#!/bin/sh\n/usr/bin/env ssh -o "StrictHostKeyChecking=no" -i "#{cache_path('poise_git_deploy_2089348824')}" $@\n}) }
    it { expect(chef_run.poise_git('/test').to_text).to include 'deploy_key "suppressed sensitive value"' }
  end # /context with in-line deploy key

  context 'with in-line deploy key with embedded newlines' do
    # Reversion test for a weird bug that only triggers on SSH keys that have a
    # line starting with /.
    recipe do
      poise_git_client 'git'
      poise_git '/test' do
        repository 'https://example.com/test.git'
        revision 'd44ec06d0b2a87732e91c005ed2048c824fd63ed'
        deploy_key "secretkey\n/foo"
      end
    end

    it { is_expected.to render_file(cache_path('poise_git_deploy_2089348824')).with_content("secretkey\n/foo") }
    it { is_expected.to render_file(cache_path('poise_git_wrapper_2089348824')).with_content(%Q{#!/bin/sh\n/usr/bin/env ssh -o "StrictHostKeyChecking=no" -i "#{cache_path('poise_git_deploy_2089348824')}" $@\n}) }
    it { expect(chef_run.poise_git('/test').to_text).to include 'deploy_key "suppressed sensitive value"' }
  end # /context with in-line deploy key with embedded newlines

  context 'with path deploy key' do
    recipe do
      poise_git_client 'git'
      poise_git '/test' do
        repository 'https://example.com/test.git'
        revision 'd44ec06d0b2a87732e91c005ed2048c824fd63ed'
        deploy_key '/mykey'
      end
    end

    it { is_expected.to_not render_file(cache_path('poise_git_deploy_2089348824')) }
    it { is_expected.to render_file(cache_path('poise_git_wrapper_2089348824')).with_content(%Q{#!/bin/sh\n/usr/bin/env ssh -o "StrictHostKeyChecking=no" -i "/mykey" $@\n}) }
    it { expect(chef_run.poise_git('/test').to_text).to include 'deploy_key "/mykey"' }
  end # /context with path deploy key

  context 'with path deploy key on Windows' do
    recipe do
      poise_git_client 'git'
      poise_git '/test' do
        repository 'https://example.com/test.git'
        revision 'd44ec06d0b2a87732e91c005ed2048c824fd63ed'
        deploy_key 'C:\\mykey'
      end
    end

    it { is_expected.to_not render_file(cache_path('poise_git_deploy_2089348824')) }
    it { is_expected.to render_file(cache_path('poise_git_wrapper_2089348824')).with_content(%Q{#!/bin/sh\n/usr/bin/env ssh -o "StrictHostKeyChecking=no" -i "C:\\mykey" $@\n}) }
    it { expect(chef_run.poise_git('/test').to_text).to include 'deploy_key "C:\\\\mykey"' }
  end # /context with path deploy key on Windows

  context 'with no parent' do
    recipe do
      poise_git '/test' do
        repository 'https://example.com/test.git'
        revision 'd44ec06d0b2a87732e91c005ed2048c824fd63ed'
      end
    end

    it { is_expected.to install_poise_git_client('git') }
  end # /context with no parent

  context 'without an explicit revision' do
    # This test confirms the execution plumbing is working because
    # load_current_resource will try to ls-remote.
    recipe do
      poise_git_client 'git'
      poise_git '/test' do
        repository 'https://example.com/test.git'
      end
    end

    it do
      fake_cmd = double(error!: nil, stdout: "d44ec06d0b2a87732e91c005ed2048c824fd63ed\tHEAD\n")
      expect_any_instance_of(described_class::Provider).to receive(:poise_shell_out).with(%w{/git ls-remote https://example.com/test.git HEAD}, log_tag: 'poise_git[/test]', timeout: 900, environment: {}).and_return(fake_cmd)
      run_chef
    end
  end # /context without an explicit revision
end
