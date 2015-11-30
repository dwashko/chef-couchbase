if defined?(ChefSpec)
  def write_couchbase_services(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:couchbase_services, :set_services, resource)
  end

  def modify_couchbase_node(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:couchbase_node, :modify, resource)
  end

  def modify_couchbase_web_settings(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:couchbase_settings, :modify, resource)
  end

  def create_couchbase_cluster(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:couchbase_cluster, :create_if_missing, resource)
  end

  def modify_couchbase_pool(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:couchbase_pool, :modify_if_existing, resource)
  end

  def couchbase_node_directories(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:couchbase_node_directories, :add, resource)
  end

  def couchbase_cluster_init(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:couchbase_cluster_init, :init, resource)
  end
end
