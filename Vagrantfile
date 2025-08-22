# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.box_version = "202502.21.0"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  config.vm.network "forwarded_port", guest: 9090, host: 9090, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 3000, host: 3000, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 80, host: 8000, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  #config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Disable the default share of the current code directory. Doing this
  # provides improved isolation between the vagrant box and your host
  # by making sure your Vagrantfile isn't accessible to the vagrant box.
  # If you use this you may want to enable additional shared subfolders as
  # shown above.
  # config.vm.synced_folder ".", "/vagrant", disabled: true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
     vb.memory = "4096"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      sudo apt-get install apt-transport-https golang \
          software-properties-common openjdk-21-jdk git -y
      #Install Maven
      cd /tmp
      wget -q https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.tar.gz
      tar xzf apache-maven-3.9.11-bin.tar.gz -C /opt/
      sudo ln -s /opt/apache-maven-3.9.11 /opt/maven
      cp /vagrant/maven.sh /etc/profile.d/
      sudo chmod +x /etc/profile.d/maven.sh
      # Grafana
      sudo mkdir -p /etc/apt/keyrings/
      wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
      echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
      # Updates the list of available packages
      sudo apt-get update
      # Installs the latest OSS release:
      sudo apt-get install grafana -y --force-yes
      sudo update-rc.d grafana-server defaults 95 10
      sudo service grafana-server start
      #Install Datadog agent
      sudo DD_API_KEY=aa5696fb6493fee1501faf4738233ef4 DD_SITE="us3.datadoghq.com" DD_APM_INSTRUMENTATION_ENABLED=host DD_ENV=dev DD_APM_INSTRUMENTATION_LIBRARIES=java:1,python:3,js:5,php:1,dotnet:3,ruby:2 bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)"
      #Run java app
      mkdir /opt/simple-api
      cd /opt/simple-api
      git clone https://github.com/felipe-guerra-oliveira/simple-springboot-api.git .
      cp /vagrant/run-java.sh .
      sudo chmod +x ./run-java.sh
      ./run-java.sh
      mkdir /opt/prometheus && cd /opt/prometheus
      wget -q https://github.com/prometheus/prometheus/releases/download/v3.5.0/prometheus-3.5.0.linux-amd64.tar.gz
      tar xvfz prometheus-*.tar.gz
      cd ./prometheus-3.5.0.linux-amd64
      cp -f /vagrant/prometheus.yml .
      sudo ./prometheus --config.file=prometheus.yml &
  SHELL
end
