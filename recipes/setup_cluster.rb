#
# Cookbook Name:: couchbase
# Recipe:: setup_cluster
#

cluster_name = node['couchbase']['server']['cluster_name']
#cluster_name = "west_cluster"
prefix = "ns_1@"
separator=","

selfipaddress = "" #node["ipaddress"]
known_nodes = "" #prefix+selfipaddress
rebal = false
joinnodehash = {} 
pick=""

if node["ipaddress"] != selfipaddress
  Chef::Log.info( "if - node ipaddress is '#{node["ipaddress"]}' before selfipaddress is set" )
  selfipaddress = node["ipaddress"]
  Chef::Log.info( "if - node ipaddress is '#{node["ipaddress"]}' while selfipaddress is '#{selfipaddress}' after selfipaddress is set" )
  known_nodes = prefix+selfipaddress
  Chef::Log.info( "if - known nodes are '#{known_nodes}'" )
else
  Chef::Log.info( "else - if statement is false  node ipaddress is '#{node["ipaddress"]}' while selfipaddress is '#{selfipaddress}'" )
end

existing_cmd = Mixlib::ShellOut.new('/opt/couchbase/bin/couchbase-cli server-list -c ' + \
               node['ipaddress']  + ':8091' \
               ' -u ' + node['couchbase']['server']['username'] + \
               ' -p ' + node['couchbase']['server']['password'])

Chef::Log.info("EXISTING NODES IS " )
existing_cmd.run_command
puts existing_cmd.stdout

cluster = search(:node, "couchbase:#{cluster_name}")
joinnode = ""
jvalu=""
clear=true
notclustered = true
i=0
hostcheck= selfipaddress +":8091"
while i < 3 do
    cluster.each do |node|
        uri = URI("http://#{node['ipaddress']}:8091/pools/default")
        check = Net::HTTP::Get.new(uri) 
        check.basic_auth "#{node['couchbase']['server']['username']}", "#{node['couchbase']['server']['password']}"
        begin
            res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(check) }
            Chef::Log.info("response is #{res.code}")
            if res.code == "200" then
                Chef::Log.info("got a 200")

                jvalu= JSON.parse(res.body)
                Chef::Log.info ("making a check to #{node['ipaddress']} to see what the response is")
                
                Chef::Log.info ("#{uri}")

                if jvalu['nodes'].length > 1 then
                    jvalu['nodes'].each do |ncheck|
                        Chef::Log.info("host name is #{ncheck['hostname']}")

                        if ncheck['hostname'] == hostcheck then 
                            Chef::Log.info("node is already in a cluster")
                            known_nodes = ""
                            notclustered = false
                            break
                        else 
                            known_nodes = known_nodes + separator + prefix + ncheck['hostname'].sub(/:8091/, '')
                            Chef::Log.info("know nodes at this iteration is #{known_nodes}")
                        end
                    end
                    Chef::Log.info("nodes greater than one break out and add");
                    if notclustered then
                        Chef::Log.info("not clustered so we are ready to join #{node['ipaddress']}")
                        joinnode = node['ipaddress']
                    end
                    break
                end

                jvalu['nodes'].each do |cnode| 
                   ts=Time.now.to_i
                   Chef::Log.info("node ip is #{cnode['hostname']} and uptime is #{cnode['uptime']}") 
                   Chef::Log.info("number of nodes is #{jvalu['nodes'].length}")
                   timestamp  = ts - cnode['uptime'].to_i
                   if cnode['hostname'] != hostcheck then
                       joinnodehash[cnode['hostname']] = timestamp
                   end
               end
           else
               Chef::Log.info("Did not get a 200")
               clear=false
           end
        rescue SystemCallError
            clear=false
        end
    end
    i = i+1
    if clear == true then
        break
    end
end

Chef::Log.info("are we going to join the domain? Only if not clustered")
if joinnodehash.empty? then 
    Chef::Log.info("joinnodehash is #{joinnodehash}")
end
if notclustered then 
    if !joinnode.empty? then
        pick = joinnode
        Chef::Log.info("going to join #{pick}")
    else 
        if joinnodehash.empty? then
            Chef::Log.info("joinnode hash is empty")
        else
            Chef::Log.info("do we have a joinnodehash")
            pick = joinnodehash.sort.reverse.pop
            pick = pick[0].sub(/:8091/, '')
            known_nodes = known_nodes + separator + prefix + pick
            Chef::Log.info("have to parse #{joinnodehash}")
            Chef::Log.info("joinnode is not empty going to join #{pick}")
        end
        Chef::Log.info("going to add server #{node['ipaddress']} to #{cluster_name} on #{pick}")
    end
    if !pick.empty? then
        add_node "#{cluster_name}" do 
            clusterip pick
            hostname node['ipaddress'] 
            username node['couchbase']['server']['username']
            password node['couchbase']['server']['password']
        end
    end
    if !pick.empty? then
        Chef::Log.info("okay pick should not be empty so set rebal to true")
        rebal = true
    end
end

Chef::Log.info("going to run against #{known_nodes}")
ejected_nodes = ""
if rebal == true then
    cluster_rebal "Rebalance-In Nodes to form a cluster  " do
            ejectedNodes ejected_nodes
            Chef::Log.info( "Ejected nodes are '#{ejectedNodes}'" )
            knownNodes known_nodes
            Chef::Log.info( "cluster_rebal known nodes are '#{knownNodes}'" )
            username node['couchbase']['server']['username']
            password node['couchbase']['server']['password']
            clusterip pick
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

