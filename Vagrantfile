
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

CONFIG = File.join(File.dirname(__FILE__), "config.rb")
if File.exist?(CONFIG)
  require CONFIG
else
  puts "config.rb is missing"
  exit
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = $vm_box
  config.vm.box_url = $vm_box
  config.vm.hostname = $hostname

  $vm_ips.each do |ip|
    puts "Private network ip: %s" % ip
    config.vm.network :private_network, ip: ip
  end
  config.vm.network :forwarded_port, guest: 22, host: $vm_ssh_port, auto_correct: false,  id: "ssh"
  
  if $shared_folders
    $shared_folders.each_with_index do |(host_folder, guest_folder), index|
      config.vm.synced_folder host_folder.to_s, guest_folder.to_s, id: "vagrant-share%02d" % index
    end
  end
  
  INSTALLER = File.join(File.dirname(__FILE__), "scripts/installer.sh")
  if File.exist?(INSTALLER)
    config.vm.provision :shell do |s|
        s.privileged = false
        s.path = "scripts/installer.sh"
        s.args = [$hostname]
    end
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", $vm_memory]
    vb.customize ["modifyvm", :id, "--name", $vm_name]
    
    # Disable USB 2.0 support since it cause error
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["modifyvm", :id, "--usbehci", "off"]
    
    # For debugging
    if $gui
        vb.gui = true
    end
  end
  
  config.ssh.forward_agent = true
end
