#
# Author:: Nicholas Long (<nicholas.long@nrel.gov>)
# Cookbook Name:: energyplus
# Provider:: energyplus
#
# Copyright 2013-2014, NREL

def initialize(*args)
  super
  @resource_name = :energyplus
  @allowed_actions.push(:install)
  @action = :install
end

default_action :install
attribute :version_long, kind_of: String, name_attribute: true

attr_accessor :exists
