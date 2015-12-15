#
# Cookbook Name:: couchbase
# Provider:: manage_xdcr
#
# Copyright 2015, GannettDigital
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

use_inline_resources

def xdcr_setup_command(command, host, options)
  "#{new_resource.install_path}/bin/couchbase-cli xdcr-setup --#{command} -c #{host}:8091 #{options}"
end

def xdcr_replicate_command(command, host, options)
  "#{new_resource.install_path}/bin/couchbase-cli xdcr-replicate --#{command} -c #{host}:8091 #{options}"
end

action :create do
  return unless check_replication(new_resource.username, new_resource.password, new_resource.master_ip, new_resource.remote_cluster_name) == false

  options = "-u #{new_resource.username} \
             -p #{new_resource.password} \
             --xdcr-hostname=#{new_resource.replica_ip}:8091 \
             --xdcr-cluster-name=#{new_resource.remote_cluster_name} \
             --xdcr-username=#{new_resource.replica_username} \
             --xdcr-password=#{new_resource.replica_password}"
  if new_resource.demand_encryption == true
    options = "#{options} \
               --xdcr-demand-encryption=1 \
               --xdcr-certificate=#{new_resource.certificate}"
  end

  cmd = xdcr_setup_command('create', new_resource.master_ip, options)

  execute 'creaet xdcr replication' do
    sensitive false
    command cmd
  end
end

action :delete do
end

action :replicate do
  options = "-u #{new_resource.username} \
             -p #{new_resource.password} \
             --xdcr-cluster-name=#{new_resource.remote_cluster_name} \
             --xdcr-from-bucket=#{new_resource.from_bucket} \
             --xdcr-to-bucket=#{new_resource.to_bucket}"

  cmd = xdcr_replicate_command('create', new_resource.master_ip, options)

  begin
    execute 'replicate buckets' do
      sensitive false
      command cmd
    end
  rescue # => e
    return
  end
end
