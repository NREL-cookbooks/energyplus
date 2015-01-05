#
# Author:: Nicholas Long (<nicholas.long@nrel.gov>)
# Cookbook Name:: energyplus
# Provider:: energyplus
#
# Copyright 2013-2014, NREL

use_inline_resources

action :install do
  Chef::Log.info "Installing EnergyPlus resource of #{new_resource.name}"

  if Chef::VersionConstraint.new('>= 8.2.0').include?(new_resource.name)
    # Install via github files which are different than extracting the tarballs
    # Example URL is
    #     https://github.com/NREL/EnergyPlus/releases/download/v8.2.0-Update-1.2/EnergyPlus-8.2.0-8397c2e30b-Linux-x86_64.sh

    filename = ['EnergyPlus', node[:energyplus][:long_version], node[:energyplus][:sha], node[:energyplus][:platform]].join('-')
    filename += '.sh'
    file_path = "#{Chef::Config[:file_cache_path]}/#{filename}"
    src_path = "#{node[:energyplus][:download_url]}/#{node[:energyplus][:git_tag]}/#{filename}"
    # extracted_dir_name = "SetEPlusV#{node[:energyplus][:version]}-#{node[:energyplus][:platform]}".gsub('.', '-')
    # install_dir_name = "EnergyPlus-#{node[:energyplus][:long_version].gsub(".", "-")}"
    converge_by("Downloading #{ @new_resource.name }") do
      download_energyplus(file_path, src_path)
      install_energyplus_sh(filename)
    end
  elsif Chef::VersionConstraint.new('>= 8.1.0').include?(new_resource.name)
    filename = "SetEPlusV#{node[:energyplus][:version]}-#{node[:energyplus][:platform]}.tar.gz"
    file_path = "#{Chef::Config[:file_cache_path]}/#{filename}"
    src_path = "#{node[:energyplus][:download_url]}/#{filename}"
    extracted_dir_name = "SetEPlusV#{node[:energyplus][:version]}-#{node[:energyplus][:platform]}".gsub('.', '-')
    install_dir_name = "EnergyPlus-#{node[:energyplus][:long_version].gsub('.', '-')}"
    converge_by("Downloading #{ @new_resource.name }") do
      download_energyplus(file_path, src_path)
      install_energyplus(filename, extracted_dir_name, install_dir_name, true)
    end
  elsif Chef::VersionConstraint.new('>= 7.2.0').include?(new_resource.name)
    filename = "EPlusV#{node[:energyplus][:version]}-#{node[:energyplus][:platform]}.tar.gz"
    file_path = "#{Chef::Config[:file_cache_path]}/#{filename}"
    src_path = "#{node[:energyplus][:download_url]}/#{filename}"
    extracted_dir_name = "EnergyPlus-#{node[:energyplus][:long_version].gsub('.', '-')}"
    install_dir_name = "EnergyPlus-#{node[:energyplus][:long_version].gsub('.', '-')}"
    converge_by("Downloading #{ @new_resource.name }") do
      download_energyplus(file_path, src_path)
      install_energyplus(filename, extracted_dir_name, install_dir_name)
    end
  else
    Chef::Log.error "Version #{node[:energyplus][:long_version]} of EnergyPlus is not installable via this Chef script"
  end
end

def download_energyplus(file_path, src_path)
  remote_file file_path do
    source src_path
    # checksum chk_sum
    mode 00755

    action :create_if_missing
  end
end

def install_energyplus(filename, extracted_dir_name, install_dir_name, extract_to_known_dir = false)
  tar_command = "tar xzf #{filename}"
  if extract_to_known_dir
    tar_command = "mkdir #{extracted_dir_name}; " + tar_command + " -C #{extracted_dir_name}"
  end
  Chef::Log.info "Installing EnergyPlus #{filename} from #{Chef::Config[:file_cache_path]}/#{extracted_dir_name}"
  Chef::Log.info "tar command is #{tar_command}"

  bash 'install_energyplus' do
    cwd Chef::Config[:file_cache_path]

    code <<-EOH
      #{tar_command}
      mv #{extracted_dir_name} /usr/local/#{install_dir_name}

      cd /usr/local/bin
      find ../#{install_dir_name}/EnergyPlus -type f -perm -o+rx -exec ln -s {} \\;
      find ../#{install_dir_name}/ExpandObjects -type f -perm -o+rx -exec ln -s {} \\;
      find ../#{install_dir_name}/EPMacro -type f -perm -o+rx -exec ln -s {} \\;

      # in some versions the file is downcased and in the bin
      #find ../#{install_dir_name}/bin/energyplus -type f -perm -o+rx -exec ln -s {} \\;
    EOH

    not_if { ::File.exist?('/usr/local/bin/EnergyPlus') }
  end
end

def install_energyplus_sh(filename)
  bash 'install_energyplus' do
    cwd Chef::Config[:file_cache_path]

    code <<-EOH
      echo 'y' | ./#{filename}
    EOH

    not_if { ::File.exist?('/usr/local/bin/EnergyPlus') }
  end
end
