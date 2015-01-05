# Version is no longer matters after 8.2
default[:energyplus][:version] = "820000"
default[:energyplus][:long_version] = "8.2.0"

# Starting in version 8.2 you may need to append another version and include the sha
default[:energyplus][:append_version] = ""
default[:energyplus][:sha] = ""

if Chef::VersionConstraint.new(">= 8.2.0").include?(node[:energyplus][:long_version])
	default[:energyplus][:download_url] =  "https://github.com/NREL/EnergyPlus/releases/download"
	default[:energyplus][:git_tag] = "v8.2.0-Update-1.2"
	default[:energyplus][:sha] = "8397c2e30b"
	if platform_family?("rhel")
		Chef::Log.error 'Cannot install EnergyPlus > 8.2 on RHEL'
	else
		default[:energyplus][:platform] = "Linux-x86_64"
	end

else
	default[:energyplus][:download_url] =  "http://developer.nrel.gov/downloads/buildings/energyplus/builds"
	if platform_family?("rhel")
		default[:energyplus][:platform] = "lin-64-RHEL5"
	else
		default[:energyplus][:platform] = "lin-64"
	end

end

