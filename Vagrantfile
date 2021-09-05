Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"

  config.vm.provider :virtualbox do |v|
    v.gui = true
    v.memory = 2048
    v.customize ["modifyvm", :id, "--vram", "128"]
    v.customize ["modifyvm", :id, "--graphicscontroller","vmsvga"]
  end

  # https://gist.github.com/niw/bed28f823b4ebd2c504285ff99c1b2c2
  # Currently "ubuntu/bionic64" on VirtualBox requires `type: "virtualbox"`
  # to make synced folder works.
#   config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  # Prevent SharedFoldersEnableSymlinksCreate errors
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provision :shell,inline: 'apt-get update'
  config.vm.provision :shell,inline: 'apt-get upgrade -y'
end
