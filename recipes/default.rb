#
# Cookbook Name:: energyplus
# Recipe:: default
#
# Copyright 2013, NREL

# handle the differing platforms
if platform_family?("debian")
  filename = "EPlusV#{node[:energyplus][:version]}-#{node[:energyplus][:platform]}.tar.gz"
  file_path = "#{Chef::Config[:file_cache_path]}/#{filename}"
  src_path = "#{node[:energyplus][:download_url]}/#{filename}"

  remote_file file_path do
    source src_path
    #checksum chk_sum
    mode 00755

    action :create_if_missing
  end

  # only works for 64 bit machines right now because it has to move lib directories:  x86_64-linux
  bash "install_energyplus" do
    cwd Chef::Config[:file_cache_path]

    #use the version that is in the vagrant directory for now
    code <<-EOH
      tar xzf EnergyPlus-#{node[:energyplus][:version]}-#{node[:energyplus][:platform]}.tar.gz
      mv EnergyPlus-#{node[:energyplus][:version].gsub(".","-")} /usr/local/

      cd /usr/local/bin
      find ../EnergyPlus-#{node[:energyplus][:version].gsub(".","-")}/bin/ -type f -perm -o+rx -exec ln -s {} \\;
    EOH

    not_if { ::File.exists?("/usr/local/bin/energyplus") }
  end
end

