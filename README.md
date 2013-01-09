Linux port of  https://github.com/cal/vagrant-ubuntu-precise-64. Tested on Ubuntu 12.10.

It's not as generic as the original, but it works and I like shorter code better. :)

The last line you will get looks like this:

    [ubuntu-12.04.1-server-amd64-vagrant] Compressing package to: <some-path>/ubuntu-12.04.1-server-amd64-vagrant.box

Let Vagrant know about the box:

    vagrant box add ubuntu-12.04.1-server-amd64 ~/ubuntu-12.04.1-server-amd64-vagrant/ubuntu-12.04.1-server-amd64-vagrant.box

And try it:

    mkdir -p ~/my_ubuntu_server
    cd ~/my_ubuntu_server
    vagrant init ubuntu-12.04.1-server-amd64
    vagrant up
    vagrant ssh

