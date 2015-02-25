#
# Cookbook Name:: couchbase
# Recipe:: setup_cluster
#

#cluster_name = node["cluster_name"]
cluster_name = node['couchbase']['server']['cluster_name']
selfipaddress=""
#known_nodes=prefix+self.node["ipaddress"]

if node["ipaddress"] != selfipaddress
  Chef::Log.info( "if - node ipaddress is '#{node["ipaddress"]}' before selfipaddress is set" )
  selfipaddress = node["ipaddress"]
  Chef::Log.info( "if - node ipaddress is '#{node["ipaddress"]}' while selfipaddress is '#{selfipaddress}' after selfipaddress is set" )
else
  Chef::Log.info( "else - if statement is false  node ipaddress is '#{node["ipaddress"]}' while selfipaddress is '#{selfipaddress}'" )
end

cluster = search(:node, "role:#{cluster_name}")

target=node_to_join(cluster,selfipaddress,node['couchbase']['server']['username'],node['couchbase']['server']['password'])

if target then
    add_node "#{cluster_name}" do
        hostname node["ipaddress"]
        username node['couchbase']['server']['username']
        password node['couchbase']['server']['password']
        clusterip target['nodetojoin']
    end
    ejected_nodes = ""
    cluster_rebal "Rebalance-In Nodes to form a cluster  " do
            ejectedNodes ejected_nodes
            knownNodes target['knownnodes']
           username node['couchbase']['server']['username']
            password node['couchbase']['server']['password']
            clusterip target['nodetojoin']
    end
end

ruby_block "wait for rebalance completion " do
  block do
    sleep 5
  end
end

#couchbase_bucket "#{cluster_name}" do
#  memory_quota_mb 100

#  username node['couchbase']['server']['username']
#  password node['couchbase']['server']['password']
#end

