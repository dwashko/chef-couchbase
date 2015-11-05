require_relative 'spec_helper'

describe service('couchbase-server') do
  it { should be_enabled }
  it { should be_running }
end

describe port(8091) do
  it { should be_listening }
end
