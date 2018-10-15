#
# Cookbook Name:: couchbase
# Attributes:: server
#
# Author:: Julian C. Dunn (<jdunn@opscode.com>)
# Copyright (C) 2012, SecondMarket Labs, LLC.
# Copyright (C) 2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['couchbase']['server']['edition'] = "enterprise"
default['couchbase']['server']['version'] = "5.0.1"
default['couchbase']['server']['community_edition_guid'] = "9E3DC4AA-46D9-4B30-9643-2A97169F02A7"
default['couchbase']['server']['enterprise_edition_guid'] = "DD309984-2414-FDF4-11AA-85A733064291"

case node['platform']
when "debian"
  package_machine = node['kernel']['machine'] == "x86_64" ? "amd64" : "x86"
  if node['couchbase']['server']['version'] < "3.0.0"
    Chef::Log.error("Couchbase Server does not have a Debian release for #{node['couchbase']['server']['version']}")
  else
    default['couchbase']['server']['package_file'] = "couchbase-server-#{node['couchbase']['server']['edition']}_#{node['couchbase']['server']['version']}-debian7_#{package_machine}.deb"
  end
when "oracle", "centos", "redhat", "scientific", "enterpriseenterprise", "amazon", "xenserver", "cloudlinux", "ibm_powerkvm", "parallels", "nexus_centos"
  package_machine = node['kernel']['machine'] == "x86_64" ? "x86_64" : "x86"
  if node['couchbase']['server']['version'] < "3.0.0"
    default['couchbase']['server']['package_file'] = "couchbase-server-#{node['couchbase']['server']['edition']}_#{node['couchbase']['server']['version']}_#{package_machine}.rpm"
  else
    default['couchbase']['server']['package_file'] = "couchbase-server-#{node['couchbase']['server']['edition']}-#{node['couchbase']['server']['version']}-centos6.#{package_machine}.rpm"
  end
when "ubuntu"
  package_machine = node['kernel']['machine'] == "x86_64" ? "amd64" : "x86"
  if node['couchbase']['server']['version'] < "3.0.0"
    default['couchbase']['server']['package_file'] = "couchbase-server-#{node['couchbase']['server']['edition']}_#{node['couchbase']['server']['version']}_#{package_machine}.deb"
  elsif [14,16].include?(node['lsb']['release'].to_i)
    default['couchbase']['server']['package_file'] = "couchbase-server-#{node['couchbase']['server']['edition']}_#{node['couchbase']['server']['version']}-ubuntu#{node['lsb']['release'].to_i}.04_#{package_machine}.deb"
  else
    default['couchbase']['server']['package_file'] = "couchbase-server-#{node['couchbase']['server']['edition']}_#{node['couchbase']['server']['version']}-ubuntu14.04_#{package_machine}.deb"
  end
else
  Chef::Log.error("Couchbase Server is not supported on #{node['platform_family']}")
end

default['couchbase']['server']['package_base_url'] = "http://packages.couchbase.com/releases/#{node['couchbase']['server']['version']}"
default['couchbase']['server']['package_full_url'] = "#{node['couchbase']['server']['package_base_url']}/#{node['couchbase']['server']['package_file']}"

default['couchbase']['server']['service_name'] = "couchbase-server"
default['couchbase']['server']['install_dir'] = "/opt/couchbase"

default['couchbase']['server']['database_path'] = File.join(node['couchbase']['server']['install_dir'],"var","lib","couchbase","data")
default['couchbase']['server']['index_path'] = File.join(node['couchbase']['server']['install_dir'],"var","lib","couchbase","data")
default['couchbase']['server']['log_dir'] = File.join(node['couchbase']['server']['install_dir'],"var","lib","couchbase","logs")

default['couchbase']['server']['username'] = "Administrator"
default['couchbase']['server']['password'] = "password"

default['couchbase']['server']['memory_quota_mb'] = Couchbase::Utils.from_node(node).in_megabytes

default['couchbase']['server']['port'] = 8091

default['couchbase']['server']['allow_unsigned_packages'] = true

default['couchbase']['server']['services'] = "index,n1ql,kv,fts"
