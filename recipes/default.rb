#
# Cookbook Name:: energyplus
# Recipe:: default
#
# Copyright 2013, NREL

# handle the differing platforms
remote_file "#{Chef::Config[:file_cache_path]}/SetEPlusV#{node[:energyplus][:version]}-lin-64.sh" do
  source "http://zerodev-128488.nrel.gov/energyplus/SetEPlusV#{node[:energyplus][:version]}-lin-64.sh"
  mode 00755
  checksum node[:energyplus][:checksum]
end

# only works for 64 bit machines right now because it has to move lib directories:  x86_64-linux
bash "install_energyplus" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    chmod +x SetEPlusV#{node[:energyplus][:version]}-lin-64.sh
  EOH

  #mv /opt/OpenStudio-#{node[:openstudio][:version]}-Linux/
  #rsync -a --delete-delay apache-solr-#{version}/dist/ #{node[:solr][:dist_dir]}
  #rsync -a --delete-delay apache-solr-#{version}/contrib/ #{node[:solr][:contrib_dir]}
end

