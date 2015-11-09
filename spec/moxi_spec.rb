# encoding: utf-8
require 'chefspec'
require 'spec_helper'
require 'fauxhai'

describe 'couchbase::moxi' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
    end.converge(described_recipe)
  end

  it 'enables a service moxi-server' do
    expect(chef_run).to enable_service('moxi-server')
    expect(chef_run).to_not enable_service('not_moxi-server')
  end

  it 'creates a template moxi-cluster.cfg.erb with attributes' do
    expect(chef_run).to create_template('/opt/moxi/etc/moxi-cluster.cfg').with(
      owner:   'moxi',
      group:  'moxi',
    )
    expect(chef_run).to_not create_template('/opt/moxi/etc/moxi-cluster.cfg').with(
      owner:   'not_moxi',
      group:  'not_moxi',
    )
  end
  it 'starts a service moxi-server' do
    expect(chef_run).to start_service('moxi-server')
    expect(chef_run).to_not start_service('not_moxi-server')
  end
end
