
Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "snappy"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://dl.dropbox.com/u/7490647/talifun-ubuntu-11.04-server-amd64.box"

  # This allows me to access all ports on the VM at this address, instead of
  # using port forwarding.
  config.vm.network "33.33.33.10"

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  # config.vm.forward_port "http", 80, 8000

  # Enable provisioning with chef solo, specifying a cookbooks path (relative
  # to this Vagrantfile), and adding some recipes and/or roles.
  #
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ['cookbooks/opscode',
                           'cookbooks/slab',
                           'cookbooks/err']

    chef.add_recipe 'haskell'
    chef.add_recipe 'tmux'
    chef.add_recipe 'vim'

    chef.json.merge!({
      :haskell => {
        :cabal => %w{snap text}
      },
      :vim => {
        :extra_packages => %w{vim-scripts exuberant-ctags ack-grep}
      },
      :domain => [],
      :openldap => {}
    })
  end

end
