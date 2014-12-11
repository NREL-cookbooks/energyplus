# EnergyPlus cookbook

Install and configures [EnergyPlus](www.energyplus.gov).

# Requirements

* Chef 10 or greater
* CentOS / RedHat / Ubuntu

# Usage

This cookbook is not on http://supermarket.chef.io. The best method to add this repo is to add as a github source in your Berksfile.

`cookbook "energyplus", github: 'NREL-cookbooks/energyplus'`

The add recipe to your run list or as include_recipe.

`recipe['energyplus']`

or

`include_recipe['energyplus']`

# Attributes
default[:energyplus][:version] - Version of EnergyPlus as defined by the download. * Defaults: "800009" *
default[:energyplus][:long_version] - The long version of EnergyPlus (more semantic). * Default: "8.0.0" *

default[:energyplus][:download_url] - passwordless installer path. * Default "http://developer.nrel.gov/downloads/buildings/energyplus/builds" *
