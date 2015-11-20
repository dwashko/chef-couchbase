require 'chef/resource'
require File.join(File.dirname(__FILE__), 'credentials_attributes')

class Chef
  class Resource
    # Provices Class CouchbaseNode < Resource
    class CouchbaseServices< Resource
      include Couchbase::CredentialsAttributes

      def id(arg = nil)
        set_or_return(:id, arg, :kind_of => String, :name_attribute => true)
      end

      def services(arg = nil)
        set_or_return(:services, arg, :kind_of => String, :default => 'data,query,index')
      end

      def initialize(*)
        super
        @action = :set_services
        @allowed_actions.push(:set_services)
        @resource_name = :couchbase_services
      end
    end
  end
end