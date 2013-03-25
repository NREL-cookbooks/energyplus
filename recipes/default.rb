#
# Cookbook Name:: energyplus
# Recipe:: default
#
# Copyright 2013, NREL

# handle the differing platforms
if platform_family?("debian")
  remote_file "#{Chef::Config[:file_cache_path]}/EnergyPlus-#{node[:energyplus][:version]}-Linux-64.tar.gz" do
    source "http://developer.nrel.gov/downloads/buildings/EnergyPlus-#{node[:energyplus][:version]}-Linux-64.tar.gz"
    mode 00755
    #checksum node[:energyplus][:checksum]
  end

  # only works for 64 bit machines right now because it has to move lib directories:  x86_64-linux
  bash "install_energyplus" do
    #password = ftxeDhpZ2
    cwd Chef::Config[:file_cache_path]

    #use the version that is in the vagrant directory for now
    code <<-EOH
      tar xzf EnergyPlus-#{node[:energyplus][:version]}-Linux-64.tar.gz
      mv EnergyPlus-7-1-0 /usr/local/

      cd /usr/local/bin
      find ../EnergyPlus-7-1-0/bin/ -type f -perm -o+rx -exec ln -s {} \\;
    EOH

    not_if { ::File.exists?("/usr/local/bin/energyplus") }
  end
end

