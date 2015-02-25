require "chef/provider"
require File.join(File.dirname(__FILE__), "client")
require File.join(File.dirname(__FILE__), "cluster_data")

class Chef
  class Provider
    class ClusterInfo < Provider
      include Couchbase::Client

      def load_current_resource
        @current_resource = Resource::ClusterInfo.new @new_resource.name
        @current_resource.username @new_resource.username
        @current_resource.password @new_resource.password
        @current_resource.clusterip @new_resource.clusterip

      end
     
      def action_getclusterinfo
      begin
        Chef::Log.info ("value of clusterip is " + new_resource.clusterip); 

          #get "/pools/default", info_params 
          response = get "/pools/default"
          #Chef::Log.info("Dann Response is #{response}")
          #Chef::Log.info("body is #{response.body.inspect}")
          @new_resource.jsonresponse  response.body
              @new_resource.updated_by_last_action true
              Chef::Log.info "#{@new_resource} modified"
          end        

          rescue SystemCallError
            Chef::Log "error adding node is " +$!
      end

      def info_params 
        {
          "user" => new_resource.username,
          "clusterip" => new_resource.clusterip,
          "password" => new_resource.password
        }
      end
 
    end
  end
end
