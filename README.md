DESCRIPTION
===========

Installs and configures Couchbase. Also has optional LWRP for setting up a cluster, buckets, and xcdr. Tested with couchbase version 4.

REQUIREMENTS
============

Chef 0.12 and Ohai 0.6.12 are required due to the use of platform_family.

Platforms
---------

* Debian family (Debian, Ubuntu etc)
* Red Hat family (Redhat, CentOS, Oracle etc)
* Microsoft Windows

Note that Couchbase Server does not support Windows 8 or Server 2012: see http://www.couchbase.com/issues/browse/MB-6395. This is targeted to be fixed in Couchbase 2.0.2.

ATTRIBUTES
==========

couchbase-server
----------------

* `node['couchbase']['server']['edition']`          - The edition of couchbase-server to install, "community" or "enterprise"
* `node['couchbase']['server']['version']`          - The version of couchbase-server to install
* `node['couchbase']['server']['database_path']`    - The directory Couchbase should persist data to
* `node['couchbase']['server']['index_path']`       - The directory Couchbase should persist index to
* `node['couchbase']['server']['log_dir']`          - The directory Couchbase should log to
* `node['couchbase']['server']['memory_quota_mb']`  - The per server RAM quota for data in megabytes
* `node['couchbase']['server']['index_memory_quota_mb']` - The per server RAM quota for the index in megabytes
* `node['couchbase']['server']['services']`         - Couchbase 4.0 and up. Services the node should run - data, query, and index 
                                                      Enterprise can do individual servies, all community nodes must include data
* `node['couchbase']['server']['username']`         - The cluster's username for the REST API and Admin UI
* `node['couchbase']['server']['password']`         - The cluster's password for the REST API and Admin UI
* `node['couchbase']['server']['run_cluster_init']` - Boolean whether to initialize the node as a stand alone server.
                                                      Default is true. Setting go false will require node to be joined to a cluster
                                                      before it is usable.

moxi
----

* `node['couchbase']['moxi']['version']`            - The version of moxi to install
* `node['couchbase']['moxi']['package_file']`       - The package file to download
* `node['couchbase']['moxi']['package_base_url']`   - The base URL where the packages are located 
* `node['couchbase']['moxi']['package_full_url']`   - The full URL to the moxi package
* `node['couchbase']['moxi']['cluster_server']`     - The bootstrap server for moxi to contact for the node list
* `node['couchbase']['moxi']['cluster_rest_url']`   - The bootstrap server's full REST URL for retrieving the initial node list

RECIPES
=======

client_clibrary
------

Installs the libcouchbase2 and devel packages for the clibrary.

server
------

Installs the couchbase-server package and starts the couchbase-server service. If run_cluster_init is true (default) will initialize the server.

moxi
----

Installs the moxi-server package and starts the moxi-server service.

test_join_cluster
-----------------

Example recipe to join nodes into a cluster.

test_leave_cluster
------------------

Example recipe to remove a node from a cluster.

test_bucket_create
------------------

Example recipe to add a bucket to the cluster.

test_xdcr_create
----------------

Example recipe to establish xdcr between two cluster and replicate a bucket.

test_xdcr_delete
----------------

Example recipe to delete bucket replication and xdcr between two clusters.

RESOURCES/PROVIDERS
===================

couchbase_node
--------------

### Actions

* `:modify` - **Default** Modify the configuration of the node

### Attribute Parameters

* `id` - The id of the Couchbase node, typically "self", defaults to the resource name
* `database_path` - The directory the Couchbase node should persist data to
* `username` - The username to use to authenticate with Couchbase
* `password` - The password to use to authenticate with Couchbase

### Examples

```ruby
couchbase_node "self" do
  database_path "/mnt/couchbase-server/data"

  username "Administrator"
  password "password"
end
```

couchbase_cluster
-----------------

### Actions

* `:create_if_missing` - **Default** Create a cluster/pool only if it doesn't exist yet

### Attribute Parameters

* `cluster` - The id of the Couchbase cluster, typically "default", defaults to the resource name
* `memory_quota_mb` - The per server RAM quota for the entire cluster in megabytes
* `username` - The username to use to authenticate with Couchbase
* `password` - The password to use to authenticate with Couchbase

### Examples

```ruby
couchbase_cluster "default" do
  memory_quota_mb 256

  username "Administrator"
  password "password"
end
```

couchbase_settings
------------------

### Actions

* `:modify` - **Default** Modify the collection of settings

### Attribute Parameters

* `group` - Which group of settings to modify, defaults to the resource name
* `settings` - The hash of settings to modify
* `username` - The username to use to authenticate with Couchbase
* `password` - The password to use to authenticate with Couchbase

### Examples

```ruby
couchbase_settings "autoFailover" do
  settings({
    "enabled" => true,
    "timeout" => 30,
  })

  username "Administrator"
  password "password"
end
```

couchbase_bucket
----------------

### Actions

* `:create` - **Default** Create a Couchbase bucket

### Attribute Parameters

* `bucket` - The name to use for the Couchbase bucket, defaults to the resource name
* `cluster` - The name of the cluster the bucket belongs to, defaults to "default"
* `memory_quota_mb` - The bucket's per server RAM quota for the entire cluster in megabytes
* `memory_quota_percent` The bucket's RAM quota as a percent (0.0-1.0) of the cluster's quota
* `replicas` - Number of replica (backup) copies, defaults to 1. Set to false to disable
* `username` - The username to use to authenticate with Couchbase
* `password` - The password to use to authenticate with Couchbase

### Examples

```ruby
couchbase_bucket "default" do
  memory_quota_mb 128
  replicas 2

  username "Administrator"
  password "password"
end

couchbase_bucket "pillowfight" do
  memory_quota_percent 0.5
  replicas false

  username "Administrator"
  password "password"
end
```

LICENSE AND AUTHOR
==================

Author:: Chris Griego (<cgriego@getaroom.com>)
Author:: Morgan Nelson (<mnelson@getaroom.com>)
Author:: Julian Dunn (<jdunn@aquezada.com>)

Copyright 2012, getaroom

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
