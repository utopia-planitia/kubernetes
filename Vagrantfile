
$num_instances = 4
if ENV["NUM_INSTANCES"].to_i > 0 && ENV["NUM_INSTANCES"]
  $num_instances = ENV["NUM_INSTANCES"].to_i
end

$box_url = case ENV["VAGRANT_OS"]
    when "coreos-alpha"
        $box = "coreos-alpha"
        $box_url = "https://alpha.release.core-os.net/amd64-usr/current/coreos_production_vagrant_virtualbox.json"
    when "coreos-beta"
        $box = "coreos-beta"
        $box_url = "https://beta.release.core-os.net/amd64-usr/current/coreos_production_vagrant_virtualbox.json"
    when "coreos-stable"
        $box = "coreos-stable"
        $box_url = "https://stable.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json"
    when "ubuntu-16.04"
        $box = "ubuntu/xenial64"
    when "bento-16.04"
        $box = "bento/ubuntu-16.04"
end

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.box_check_update = false
  config.vm.box = $box
  config.vm.box_url = $box_url

  config.vm.provider :virtualbox do |v|
    v.check_guest_additions = false
    v.functional_vboxsf     = false
  end

  (1..$num_instances).each do |i|
    config.vm.define vm_name = "%s%d" % ["node", i] do |config|

      config.vm.hostname = vm_name
      config.vm.synced_folder '.', '/vagrant', disabled: true
      config.vm.network :private_network, ip: "172.17.8.#{i+100}"

      config.vm.provider :virtualbox do |vb|
        vb.memory = 4096
        vb.cpus = 2
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", "85"]
        vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
        vb.customize ["modifyvm", :id, "--uartmode1", "disconnected" ]
      end

    end    
  end

end