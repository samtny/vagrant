# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise64"
  config.ssh.forward_agent = true

  config.vm.define "photos" do |photos|
    photos.vm.hostname = "photos"

    photos.vm.network "private_network", ip: "192.168.35.10"
    photos.vm.network "forwarded_port", guest: 443, host: 4430
 
    photos.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end

    photos.vm.provision "shell", path: "scripts/bootstrap.sh"

    photos.vm.provision "ansible" do |ansible|
      ansible.groups = {
        "mongo" => [ "photos" ],
        "photos_api" => [ "photos" ],
        "photos_process" => [ "photos" ],
        "photos_web" => [ "photos" ],
      }

      ansible.playbook = "ansible/site.yml"

      ansible.extra_vars = { ansible_ssh_user: "vagrant" }
      ansible.sudo = true;
    end
  end
end
