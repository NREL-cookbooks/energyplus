default[:energyplus][:version] = "800008"
default[:energyplus][:long_version] = "8.0.0"

default[:energyplus][:download_url] = "http://developer.nrel.gov/downloads/buildings/energyplus/builds"

if platform_family?("rhel")
	default[:energyplus][:platform] = "lin-64-RHEL5"
else 
	default[:energyplus][:platform] = "lin-64"
end
