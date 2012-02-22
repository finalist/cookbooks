include_attribute "jetty"

expand!

default[:solr][:version]   = "3.5.0"
default[:solr][:link]      = "http://apache.favoritelinks.net/lucene/solr/#{solr.version}/apache-solr-#{solr.version}.tgz"
default[:solr][:directory] = "/usr/local/src"
default[:solr][:download]  = "#{solr.directory}/apache-solr-#{solr.version}.tgz"
default[:solr][:extracted] = "#{solr.directory}/apache-solr-#{solr.version}"
default[:solr][:war]       = "#{solr.extracted}/dist/apache-solr-#{solr.version}.war"

default[:solr][:context_path] = 'solr'
default[:solr][:home]         = "#{node.jetty.home}/webapps/#{node.solr.context_path}"
default[:solr][:data]         = "#{node.jetty.home}/webapps/#{node.solr.context_path}/data"
