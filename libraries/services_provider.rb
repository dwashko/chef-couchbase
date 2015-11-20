require 'chef/provider'
require 'net/http'
require File.join(File.dirname(__FILE__), 'client')

class Chef
  class Provider
    # Provides Class CouchbaesServices < Provider
    class CouchbaseServices < Provider
      provides :couchbase_services
      include Couchbase::Client

      def load_current_resource
        @current_resource = Chef::Resource::CouchbaseServices.new @new_resource.name
        @current_resource.id @new_resource.id
        @current_resource.services @new_resource.services
      end

      def action_set_services
        Chef::Log.warn("setting servicesto ")
        Chef::Log.warn(@new_resource.services)
        post "/node/controller/setupServices", 'services' => @new_resource.services
        @new_resource.updated_by_last_action true
        Chef::Log.info "#{@new_resource} modified"
      end

      private

      def node_data
        @node_data ||= begin
          response = get "/nodes/#{@new_resource.id}"
          Chef::Log.error response.body unless response.is_a?(Net::HTTPSuccess) || response.body.empty?
          response.value
          JSONCompat.from_json response.body
        end
      end
    end
  end
end
