Vagrant.configure("2") do |config|

  config.vm.define "ubuntu22.04", primary: false do |ubuntu|
    ubuntu.vm.box = "bento/ubuntu-22.04"

    if Vagrant.has_plugin?("vagrant-vbguest")
      config.vbguest.auto_update = false
    end
    ubuntu.vm.synced_folder "./", "/vagrant", type: "virtualbox"

    ubuntu.vm.provider "virtualbox" do |vb|
      vb.memory = "8192"
      vb.cpus = "8"
    end

    ubuntu.vm.hostname = "ubuntu2204"
    ubuntu.vm.provision "shell", privileged: false, inline: <<-SHELL
      echo "Hej from $(lsb_release -ds)"
    SHELL
    ubuntu.vm.provision "shell", privileged: false, path: "provision.sh"
    ubuntu.vm.provision "shell", privileged: false, path: "collect_host_info.sh"
    ubuntu.vm.provision "shell", privileged: false, inline: <<-SHELL
      mv $HOME/$(hostname).host_info /vagrant/
    SHELL
    # ubuntu.vm.provision "shell", privileged: false, path: "build_tools.sh"
    # ubuntu.vm.provision "shell", privileged: false, path: "build_release.sh"

  end

  config.vm.define "ubuntu24.04", primary: false do |ubuntu|
    ubuntu.vm.box = "bento/ubuntu-24.04"

    if Vagrant.has_plugin?("vagrant-vbguest")
      config.vbguest.auto_update = false
    end
    ubuntu.vm.synced_folder "./", "/vagrant", type: "virtualbox"

    ubuntu.vm.provider "virtualbox" do |vb|
      vb.memory = "8192"
      vb.cpus = "8"
    end

    ubuntu.vm.hostname = "ubuntu2404"
    ubuntu.vm.provision "shell", privileged: false, inline: <<-SHELL
      echo "Hej from $(lsb_release -ds)"
    SHELL
  end

  config.vm.define "debian-13", primary: false do |debian|
    debian.vm.box = "bento/debian-13"
    debian.vm.box_version = "202510.26.0"

    if Vagrant.has_plugin?("vagrant-vbguest")
      config.vbguest.auto_update = false
    end
    debian.vm.synced_folder "./", "/vagrant", type: "virtualbox"

    debian.vm.provider "virtualbox" do |vb|
      vb.memory = "8192"
      vb.cpus = "8"
    end

    debian.vm.hostname = "debian13"
    debian.vm.provision "shell", privileged: false, inline: <<-SHELL
      echo "Hej from $(lsb_release -ds)"
    SHELL
  end

  config.vm.define "popos-22.04", primary: false do |popos|
    popos.vm.box = "operations/popos-22.04"
    popos.vm.box_version = "1.0.0"
    popos.vm.guest = "ubuntu"

    popos.vm.synced_folder "./", "/vagrant", type: "virtualbox"

    popos.vm.provider "virtualbox" do |vb|
      vb.memory = "8192"
      vb.cpus = "8"
    end

    popos.vm.hostname = "popos2204"
    popos.vm.provision "shell", privileged: false, path: "provision.sh"
  end

  config.vm.define "freebsd14", primary: false do |freebsd|
    freebsd.vm.box = "generic/freebsd14"

    if Vagrant.has_plugin?("vagrant-vbguest")
      config.vbguest.auto_update = false
    end

    config.vm.boot_timeout = 600

    # Private network is needed for synced folder to work, see https://www.vagrantup.com/docs/synced-folders/nfs#prerequisites
    freebsd.vm.network "private_network", ip: "192.168.20.6"
    # The two-way synced directories seem to be flaky with the FreeBSD guest.
    # On the first write lower level directories do not exist anymore/are unmounted.
    # Consequently, we fall back to rsync
    # freebsd.vm.synced_folder "./", "/vagrant", type: "virtualbox"
    freebsd.vm.synced_folder "./", "/vagrant", type: "rsync", rsync__exclude: [".git/", ]

    freebsd.vm.provider "virtualbox" do |vb|
      vb.memory = "8192"
      vb.cpus = "8"
    end

    freebsd.vm.hostname = "freebsd14"
    freebsd.vm.provision "shell", privileged: true, inline: <<-SHELL
      echo "Hej from $(lsb_release -ds)"

      echo "Setting up BASH as default shell..."
      pkg install -y bash
      chsh -s /usr/local/bin/bash vagrant

      cd /vagrant/netbsd-11-src
    SHELL
  end
end
