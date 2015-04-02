# encoding: utf-8
require 'chefspec'
require 'spec_helper'
require 'fauxhai'

describe 'couchbase::client' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
    end.converge(described_recipe)
  end
  it 'add yum_repository couchbase' do
    expect(chef_run).to add_yum_repository('couchbase')
  end

end
