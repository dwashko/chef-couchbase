#
# Cookbook Name:: couchbase
# Resource:: manage_xdcr
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

actions :create, :delete, :replicate

attribute :remote_cluster_name, :kind_of => String, :name_attribute => true
attribute :username, :kind_of => String
attribute :password, :kind_of => String
attribute :install_path, :kind_of => String, :default => '/opt/couchbase'
attribute :master_ip, :kind_of => String, :default => '127.0.0.1'
attribute :replica_ip, :kind_of => String
attribute :replica_username, :kind_of => String
attribute :replica_password, :kind_of => String
attribute :demand_encryption, :kind_of => [TrueClass, FalseClass], :default => false
attribute :certificate, :kind_of => String

def initialize(*args)
  super
  @action = :create
end
