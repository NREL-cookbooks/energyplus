#
# Cookbook Name:: energyplus
# Recipe:: default
#
# Copyright 2013-2014, NREL

# this should get moved to a resource


# TODO: use Chef version method instead of semantic gem
chef_gem 'semantic'
require 'semantic'
require 'semantic/core_ext'

if platform_family?("debian") || platform_family?("rhel")
  # determine how to install energyplus based on the version
  energyplus node[:energyplus][:long_version]
else
  Chef::Log.warn("Installing from a #{node['platform_family']} installer is not yet not supported by this cookbook")
end
