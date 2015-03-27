# encoding: utf-8
require 'chefspec'
require 'spec_helper'
require 'fauxhai'

describe 'couch_support::prerequisites' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['couchbase']['server']['log_dir'] = '/tmp'
      node.set['couchbase']['logrotate']['frequency'] = 'minute'
      node.set['couchbase']['logrotate']['rotate'] = 'stuff'
      stub_command("cat /etc/rc.local | grep 'never > /sys/kernel/mm/transparent_hugepage/enabled'").and_return('0')
    end.converge(described_recipe)
  end

  it 'includes the aws recipe' do
    expect(chef_run).to_not include_recipe('aws')
  end

end