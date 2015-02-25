require "chef/resource"
require File.join(File.dirname(__FILE__), "credentials_attributes")

class Chef
  class Resource
    class ClusterInfo < Resource
      include Couchbase::CredentialsAttributes

      def username(arg=nil)
        set_or_return(:username, arg, :kind_of => String, :name_attribute => true)
      end

      def password(arg=nil)
        set_or_return(:password, arg, :kind_of => String, :name_attribute => true)
      end      

      def clusterip(arg=nil)
        set_or_return(:clusterip, arg, :kind_of => String, :name_attribute => true)
      end

      def jsonresponse(arg=nil)
        set_or_return(:jsonreponse, arg, :kind_of => String, :name_attribute => true)
      end

      def initialize(*)
        super
        @action = :getclusterinfo
        @allowed_actions.push :getclusterinfo
        @resource_name = :cluster_info
      end
    end
  end
end
