# encoding: utf-8
require 'chefspec'
require 'spec_helper'
require 'fauxhai'

describe 'couchbase::server' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      stub_command("grep '{error_logger_mf_dir, \"/opt/couchbase/var/lib/couchbase/logs\"}.' /opt/couchbase/etc/couchbase/static_config").and_return(0)
    end.converge(described_recipe)
  end

  it 'enables and starts couchbase-server' do
    expect(chef_run).to enable_service('couchbase-server')
    expect(chef_run).to start_service('couchbase-server')
  end

  it "creates directory /opt/couchbase//var/lib/couchbase/logs" do
    expect(chef_run).to create_directory('/opt/couchbase/var/lib/couchbase/logs').with(user: 'couchbase')
  end

  it 'creates directory /opt/couchbase/var/lib/couchbase/data' do
    expect(chef_run).to create_directory('/opt/couchbase/var/lib/couchbase/data').with(user: 'couchbase')
  end

  it 'downloads /var/chef/cache/couchbase-server-community-4.0.0-centos6.x86_64.rpm' do
    expect(chef_run).to create_remote_file_if_missing('/var/chef/cache/couchbase-server-community-4.0.0-centos6.x86_64.rpm') 
  end

  it 'installs rpm /var/chef/cache/couchbase-server-community-4.0.0-centos6.x86_64.rpm' do
    expect(chef_run).to install_rpm_package('/var/chef/cache/couchbase-server-community-4.0.0-centos6.x86_64.rpm')
  end

  it 'rewrites couchbase log_dir config' do
    expect(chef_run).to_not run_ruby_block('rewrite_couchbase_log_dir_config')
  end

end
