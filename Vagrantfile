# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.hostname = 'energyplus-berkshelf'

  # Don't use 11.14.2 because of https://github.com/opscode/chef/issues/1739 (duplicate error)
  config.omnibus.chef_version = 'latest'

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = 'ubuntu/trusty64'

  # Use berkshelf.  Make sure to install ChefDK if you are using Windows.
  config.berkshelf.enabled = true

  config.vm.network :private_network, type: 'dhcp'
  config.vm.provider :virtualbox do |p|
    nc = 1
    p.customize ['modifyvm', :id, '--memory', nc * 1024, '--cpus', nc]
  end

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      energyplus: {
        version: '820000',
        long_version: '8.2.0',
        git_tag: 'v8.2.0-Update-1.2',
        sha: '8397c2e30b'
      }
      # energyplus: {
      #   version: '810009',
      #   long_version: '8.1.0'
      # }
    }

    chef.run_list = [
      'recipe[energyplus::default]'
    ]
  end
end
