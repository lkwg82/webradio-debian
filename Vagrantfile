Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"
  config.vm.provider :virtualbox do |v|
    v.gui = true
    v.memory = 2048
  end

  # https://gist.github.com/niw/bed28f823b4ebd2c504285ff99c1b2c2
  # Currently "ubuntu/bionic64" on VirtualBox requires `type: "virtualbox"`
  # to make synced folder works.
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  $script = <<-SCRIPT
  echo I am provisioning...
  dpkg -i /vagrant/webradio.deb || apt-get install -f -y
  dpkg -i /vagrant/webradio.deb
  shutdown -r now
  SCRIPT
  config.vm.provision :shell,inline: $script
end