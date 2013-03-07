#
# Cookbook Name:: energyplus
# Recipe:: default
#
# Copyright 2013, NREL

# handle the differing platforms
#remote_file "#{Chef::Config[:file_cache_path]}/SetEPlusV#{node[:energyplus][:version]}-lin-64.sh" do
#  source "http://zerodev-128488.nrel.gov/energyplus/SetEPlusV#{node[:energyplus][:version]}-lin-64.sh"
#  mode 00755
#  checksum node[:energyplus][:checksum]
#end

# only works for 64 bit machines right now because it has to move lib directories:  x86_64-linux
bash "install_energyplus" do
  #password = ftxeDhpZ2
  cwd Chef::Config[:file_cache_path]

  #use the version that is in the vagrant directory for now
  code <<-EOH
    cd /vagrant
    tar xzf energyplus_linux_64.tar.gz
    mv EnergyPlus-7-1-0 /usr/local/

    cd /usr/local/bin
    find ../EnergyPlus-7-1-0/bin/ -type f -perm -o+rx -exec ln -s {} \;
  EOH

  not_if { ::File.exists?("/usr/local/bin/energyplus") }
end

