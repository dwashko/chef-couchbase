require_relative 'spec_helper'

describe user('couchbase') do
  it { should exist }
end

describe group('couchbase') do
  it { should exist }
end

describe service('couchbase-server') do
  it { should be_enabled }
end

describe command('/opt/couchbase/bin/couchbase-cli server-info -c 127.0.0.1:8091 -u Administrator -p password |grep status') do
  its(:stdout) { should match(/  "status": "healthy",/) }
end

describe port(8091) do
  it { should be_listening }
end

bucket_output = [
  %r{/test/},
  %r{/ bucketType: membase/},
  %r{/ authType: sasl/},
  %r{/ numReplicas: 0/},
  %r{/ ramQuota: 130023424/},
  %r{/ ramUsed: 38267248/}
]
describe command('/opt/couchbase/bin/couchbase-cli bucket-list -c 127.0.0.1:8091 -u Administrator -p password') do
  bucket_output.each do |b|
    its(:stdout) { should match(b) }
  end
end
