name             "couchbase"
maintainer       "Julian C. Dunn"
maintainer_email "jdunn@chef.io"
license          "MIT"
description      "Installs and configures Couchbase Server."
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "1.5.0"
issues_url       "https://github.com/disney/couchbase/issues"
source_url       "https://github.com/disney/couchbase"

%w{debian ubuntu centos redhat oracle amazon scientific}.each do |os|
  supports os
end

%w{apt openssl yum}.each do |d|
  depends d
end

recipe "couchbase::server", "Installs couchbase-server"
recipe "couchbase::client", "Installs libcouchbase"
