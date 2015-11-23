#
# Cookbook Name:: couchbase
# Recipe:: setup_server
#
# Copyright 2012, getaroom
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

version =  node['couchbase']['server']['version'].split('.').first.to_i

if version > 3
  couchbase_services 'self' do
    services node['couchbase']['server']['services']
    retry_delay 30
    retries 4
    username node['couchbase']['server']['username']
    password node['couchbase']['server']['password']
  end
end

couchbase_settings 'web' do
  settings('username' => node['couchbase']['server']['username'],
           'password' => node['couchbase']['server']['password'],
           'port' => 8091)

  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end

couchbase_cluster 'default' do
  memory_quota_mb node['couchbase']['server']['memory_quota_mb']

  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end

couchbase_pool 'default' do
  memory_quota_mb node['couchbase']['server']['memory_quota_mb']

  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end
